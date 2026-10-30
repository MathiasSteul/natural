* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RMUPDREP - Update Active Report Parameters
*
* Maintenance:
* uuu yy-mm-dd s(999999) ....
* mrs 93-01-19 s(999999) clean up
* mrs 94-11-08 s(211501) correct connect distribution of a reopened
*                        active report
* jvd 98-11-24 s(284191) incorporate 'Archive Immediate' functionality
*                        from UKSJU. Thank you, Steve!
* sju 00-04-28 p(191368) monitor multitasking
* sju 02-04-26 NOM221    Archive type
* sju 02-10-08 NOM221    Stylesheet URL
* sju 02-10-31 NOM221    Long records (Jes2 only)
* sju 03-06-02 p(241125) not all lines of separated report printed
* xsetggr 2005-10-26 p(270950) Field G-ACTIVE-ISN must be P10, not P8
* xsetggr 2008-05-05 p(304350) get and store size of binary docs
* xsetggr 2008-11-26 P311559 use unix attr for size of unix binary files
* bli     2009-01-21 p307959 restow due to unix attr changes in rmspl--l
* fhi     2010-09-03 NOMALL-97 Extend message line
* xsetggr 2011-10-27 NOMALL-970 implement report flag 'print once'
* raya    2012-02-01 NOMALL-1096 error-text a250 in NOMWK--P stow only
* raya    2012-02-07 NOMALL-98 check existance of printer-exit and if
*                    not exist no printout
* raya    2012-08-20 NOMALL-78 disable  long records
* xsetggr 2012-10-17 ES-104    fill MA-CURRENT-LOCATION
* xsetggr 2013-01-22 NOMALL-970 implementation cancelled
* raya    2013-02-20 NOMALL-1233 log rc <> 0 from RBINSZ-N
* SU1     2013-01-31 unused      Deactivate unused data areas
* SU2     2014-07-22 NOMALL-1279 fill fields for Adabas Vista
* fhi     2014-10-21 NOMALL-79   Introduce long filenames
* SU3     2015-08-11 NOMALL-1690 XXHASH restructure
* SU4     2015-12-30 NOMALL-1722 support long path names
* SU5     2016-01-19 NOMALL-1802 do not update Adabas Vista fields
* SU6     2018-01-29 NOMALL-1823 NOM 3.5: remove CONNECT
* SU7     2018-08-30 NOMALL-2130 sep.var.:GDA MONIT-GL -> PDA RMEXSEPA
* SU8     2018-12-19             version check removed
* fhi     2019-08-07 NOMALL-2315 Avoid NAT3113 due to missing ISN
* ----------------------------------------------------------------------
*
DEFINE DATA GLOBAL USING MONIT-GL
PARAMETER
1 RMEX-SPOOL-ATTRIBUTES   (A250) /*OPTIONAL
************************************************************************
INDEPENDENT
1 +G-ACTIVE-ISN-P10  (P10)
1 +IN-SEPARATION     (L)
1 +WAKE-PRINTOUTS    (L)
* *****
LOCAL USING RMTASK-E
LOCAL USING NOMWK--P
LOCAL USING NOMFNC-E
LOCAL USING RMSPL--L
LOCAL USING RCCTYP-E
LOCAL USING RMSR---E
LOCAL USING XXHASH-P
* *****
LOCAL
1 #REC-NUMBER        (I4)
1 P-SIZE             (I4)
1 #ERC               (N4)
1 #ERT               (A250)
1 #PRINTOUTS-CREATED (L)
1 #TRACING           (L)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE UPDATE-ACTIVE-REPORT
************************************************************************
RESET #REC-NUMBER P-SIZE #ERC #ERT
*
PERFORM RMGTRACE-GET-SETTINGS #TRACING
IF +G-ACTIVE-ISN-P10 = 0 /* This can happen if NOMEX013 has returned
/*                          an error in RMSTOREP, so no update is
/*                          required in this case.
  ESCAPE ROUTINE
END-IF
*
GET-ACT. GET ACTIVE-REPORTS +G-ACTIVE-ISN-P10
*
ACTIVE-REPORTS.AR-NUMBER-OF-LINES := ##REC-COUNT
ACTIVE-REPORTS.AR-KEYWORDS (*)    := G-KEYWORDS (*)
*
IF G-JPRINTER-NO > 0
  PERFORM CREATE-PRINTOUTS RMEX-SPOOL-ATTRIBUTES /*RMCRTPRT
  IF G-NATRP-ERC NE 1078 AND G-NATRP-ERC NE 1079
    #PRINTOUTS-CREATED:= TRUE
  ELSE
    #PRINTOUTS-CREATED:=FALSE
    RESET G-NATRP-ERC G-NATRP-ERT /*ERR 1078/1079 ONCE
  END-IF
END-IF
*
DECIDE FOR EVERY CONDITION
  WHEN ##IN-NRM
    ACTIVE-REPORTS.AR-STORE-NATRPT := 'Y'
    ACTIVE-REPORTS.AR-CURRENT-LOCATION := 'D'
    RESET ACTIVE-REPORTS.AR-SOURCE-ID
  WHEN REPORTS.R-ARCHIVE = 'Y'
    ACTIVE-REPORTS.AR-ARCHIVE := 'A'
    RESET ACTIVE-REPORTS.AR-ACTIVE
  WHEN REPORTS.R-ARCHIVE = 'I'
    ACTIVE-REPORTS.AR-ARCHIVE := 'I'
    RESET ACTIVE-REPORTS.AR-ACTIVE
  WHEN ACTIVE-REPORTS.AR-ARCHIVE = ' '
    ACTIVE-REPORTS.AR-ACTIVE := 'X'
  WHEN NONE
    IGNORE
END-DECIDE
*
IF ACTIVE-REPORTS.AR-CURRENT-LOCATION = ' '
  ACTIVE-REPORTS.AR-CURRENT-LOCATION := 'S'
  ADD 1 TO G-SYSOUT-NEED-COUNT
END-IF
*
ACTIVE-REPORTS.AR-INSERTED   := G-INSERTED
ACTIVE-REPORTS.AR-HOLD-PRINT := G-HOLD
*
ACTIVE-REPORTS.AR-STATUS := 'B'
ACTIVE-REPORTS.AR-ARCHIVE-TYPE:= REPORTS.R-ARCHIVE-TYPE
ACTIVE-REPORTS.AR-STYLESHEET-URL:= REPORTS.R-STYLESHEET-URL
ACTIVE-REPORTS.AR-REP-FORMAT := REPORTS.R-REP-FORMAT
* ACTIVE-REPORTS.AR-LAST-SEQNO := ???????????????????? := ##AC-SEQNO
UPDATE (GET-ACT.)
*
END TRANSACTION
*
RESET G-NATRP-ERC
PERFORM SEND-TO-BUNDLE RMEX-SPOOL-ATTRIBUTES
END TRANSACTION
IF G-NATRP-ERC = 0
  GETACT2. GET ACTIVE-REPORTS +G-ACTIVE-ISN-P10
  IF ACTIVE-REPORTS.AR-CC-TYPE = BINARY
    #SPOOL-ATTRIBUTES := ACTIVE-REPORTS.AR-SPOOL-ATTRIBUTES
    CALLNAT 'RBINSZ-N' AR-REPNAME AR-REPRNB 'R' #REC-NUMBER P-SIZE
      #ERC #ERT
    DECIDE ON FIRST VALUE OF #SPOOL-TYPE
      VALUE SEQUENTIAL-FILE-UNIX
        IF #ERC EQ 0
          #SPOOL-UNIX-SIZE := P-SIZE
        ELSE
          RESET #SPOOL-UNIX-SIZE
        END-IF
      VALUE DIRECT-INPUT
        IF #ERC EQ 0
          #SPOOL-DI-SIZE := P-SIZE
        ELSE
          RESET #SPOOL-DI-SIZE
        END-IF
      NONE VALUE IGNORE
    END-DECIDE
*
    IF #TRACING AND #ERC NE 0
      COMPRESS 'RBINSZ-N ENDED WITH' #ERC #ERT INTO G-TRACE-MSG
      PERFORM XXRLOG-WRITE-LOG 'W' G-TRACE-MSG
    END-IF
*
    ACTIVE-REPORTS.AR-SPOOL-ATTRIBUTES := #SPOOL-ATTRIBUTES
  END-IF
  ACTIVE-REPORTS.AR-STATUS := 'P'
  UPDATE (GETACT2.)
  DECIDE ON EVERY VALUE OF #SPOOL-TYPE
    VALUE SEQUENTIAL-FILE-UNIX
      XXHASH-PARMS.P-SHORT-NAME := #SPOOL-UNIX-FILE-NAME
    VALUE DIRECT-INPUT
      XXHASH-PARMS.P-SHORT-NAME := #SPOOL-DI-PATH
      XXHASH-PARMS.P-FUNCTION   := 'U' /*update rep. data
      COMPRESS AR-REPNAME '/' AR-REPRNB TO XXHASH-PARMS.P-REPRNB
        LEAVING NO
      PERFORM XXHASH XXHASH-PARMS
      XXHASH-PARMS.P-SHORT-NAME := #SPOOL-DI-FILENAME
    ANY
      XXHASH-PARMS.P-FUNCTION := 'U' /*update record
      COMPRESS AR-REPNAME '/' AR-REPRNB TO XXHASH-PARMS.P-REPRNB
        LEAVING NO
      PERFORM XXHASH XXHASH-PARMS
    NONE IGNORE
  END-DECIDE
  END TRANSACTION
END-IF
CALLNAT 'RMUPDSTN' +G-ACTIVE-ISN-P10 #ERC
IF #ERC = 0
  END TRANSACTION
ELSE
  BACKOUT TRANSACTION
  RESET #ERC
END-IF
IF #PRINTOUTS-CREATED
  RESET #PRINTOUTS-CREATED
  IF +IN-SEPARATION
    +WAKE-PRINTOUTS:= TRUE
  ELSE
    NOMWK-TASK-TYPE:= EQU-MANAGE-PRINTOUTS
    CALLNAT NOM-WAKE-MONITOR NOMWK-NOMVERS NOMWK-PARMS (*)
  END-IF
END-IF
*
END-SUBROUTINE /* UPDATE-ACTIVE-REPORT
*
END
