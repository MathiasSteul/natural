* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RMOPENRP - Open Active Report
*
* Maintenance:
* uuu yy-mm-dd s(999999) ....
* mrs 93-01-19           clean up
* gw  94-04-28 s(200014) translate repname to upper case
* mrs 94-11-03 s(999999) since 93-01-12 ar-printers is filled which
*                        results in duplicate printout records when
*                        report is reopened (see RMSTOREP)
* mrs 94-11-04 s(212611) check for p-repname = blank
* mrs 94-11-08 s(211501) create/distribute connect doc error if
*                        active report is reopened
* mrs 95-06-28 s(227076) avoid problems during reopen if the report
*                        is stored in NOM and in Con-nect
* gw  95-12-21 s(236583) report description
* gw  96-09-18 s(999999) use NOMRNB-N to get RNB
* gw  98-09-17 p(174092) allow overwrite parms in case of reopen
* jvd 98-09-27 p(164220) NOM141ÖNAT23
* sju 99-01-07 p(179585 - 177782) honour P-ARCHIVE parm
* jvd 99-11-17 p(188923) Rcompiled program due to changed MONITNGL
*                       and remove comments pre 1997
* wcd 00-04-01 CE 7267  Increase to 20 printers
* xsiszha 2000-08-15 (CE7461) Extend Report and Bundle Names
* sju 04-12-06 NOM31     Add date and time (tenths of second) to trace
* xsetggr 2005-10-26 p(270950) Field G-ACTIVE-ISN must be P10, not P8
* xsetggr 2007-09-04 NOM3201   Support P11 format run numbers
* xsetggr 2008-03-13 p(302418) react to error code from NOMEX013
* xsetggr 2008-07-21 p(307127) check report processing defaults to set
*                              r-create-definition if not specified
* fhi     2009-12-10 N3460   Use non-opo active-reports view for NOM321
* xsetggr 2009-12-18 N3460   get NOM version with NOMVI-2N
* fhi     2010-02-24 N3460   Non-opo active-reports view only < NOM3300
*                            No tags entered for this change.
* fhi     2010-10-11 NOMALL-97 Do not call RMSTREP1 any more.
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* xsetggr 2010-09-23 NOMALL-879 if no value of 'Create Definition',use N
* fhi     2012-08-20 NOMALL-1004 Add report formatting parameters
* bli     2012-09-19 NOMALL-94 delete old version check
* SU1     2013-09-10 NOMALL-82 new class: activate error
* fhi     2014-03-03 NOMALL-1363 Get cat cate into trace messages
* SU2     2014-03-05 NOMALL-1281 show last update user+date in NOMRNB-N
* SU3     2014-12-19 NOMALL-1548 remove unused LDA
* fhi     2016-08-01 NOMALL-1748 Backout Report Formatting
* fhi     2016-11-15 NOMALL-1961 Use new task IDs
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* SU4     2018-01-29 NOMALL-1823 NOM 3.5: remove CONNECT
* fhi     2018-03-13 NOMALL-1918 Correct multinode behavior, no tags
* SU5     2018-03-15 NOMALL-2085 NOM35 printer:sep.pages
* fhi     2018-10-10 NOMALL-2130 Introduce PDA RMEXSEPA
* SU6     2018-10-18             LDA MONITNGL removed
* SU7     2019-07-24 NOMALL-2312 Allow sep. exit to override empty desc.
* SU8     2020-02-17 NOMALL-2379 avoid IDENT-FILES cutted to A26
* BLI     2020-03-09 NOMALL-2294 Reset +G-ACTIVE-ISN-P10 to prevent 3113
* SU9     2020-04-14 NOMALL-2403 use different DDM for NOMALL-2379
* SU10    2020-04-16 NOMALL-2349 error handling (NPR)
* SU11    2020-07-13 NOMALL-2404 NOM352:remove SU9
* SU12    2020-11-10 NOMALL-2440 split DDM -> NRM-MF-NODES
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING MONIT-GL
PARAMETER USING RMEXSEPA
************************************************************************
INDEPENDENT
1 +G-ACTIVE-ISN-P10          (P10)
1 +CMRDC                     (A1)  /* NOMALL-2009 fhi in
1 +NOD-CURRENT-ERROR-CLASS   (A1)
* *****
LOCAL USING VGRANT-L
LOCAL USING RLOG-L
LOCAL USING VDEFRP-L
* *****
LOCAL
/*SU11 1 RP-LONG VIEW OF NRM-REPORTS-NEW /*SU8 SU9
/*SU11 2 R-IDENT-FILES     (A50/1:5) /*in GDA MONIT-GL: A26 (old DDM)
*
1 REPORT-IN-MASTER         (L)
1 #ORDER-REPNAME           (A31)
1 REDEFINE #ORDER-REPNAME
  2 #ORDER                 (P10)
  2 #REPNAME               (A25)
1 #REPORT                  (A25/1:25)
1 NOMRNB-PARMS
  2 NOMRNB-RNB             (P11)
  2 NOMRNB-NAME            (A25)
  2 NOMRNB-TYPE            (A1)       /* 'R' - Report , 'B' - Bundle
1 #TRACING                 (L)
1 #CATDATE                 (A19) /* NOMALL-1363 fhi in
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
FORMAT LS=100
************************************************************************
DEFINE SUBROUTINE OPEN-NEW-REPORT
************************************************************************
IF G-TRACE GE *LEVEL AND G-TRACE-SET = SCAN ('CREATE')
  #TRACING := TRUE
  PERFORM XXCATAL-GET-CATDATE #CATDATE
  COMPRESS 'Start' *PROGRAM 'cataloged at'  #CATDATE TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
INCLUDE CMRDC                  /* NOMALL-2009 fhi in
IF P-REPNAME = ' '
  P-REPNAME := 'NONAME'
END-IF
*
SEPARATE P-REPNAME LEFT JUSTIFIED INTO #REPORT (*) WITH DELIMITER ' '
COMPRESS #REPORT (*) TO P-REPNAME LEAVING NO
*
EXAMINE P-REPNAME TRANSLATE INTO UPPER
*
RESET #TEXT-ARRAY(*) ##REC-COUNT ##CUR-RECORD ##IN-NRM REPORT-CONTENTS
  ##AC-SEQNO  ##C-CONTENTS ##NRM-SEQ ##START-LINE ##END-LINE
  +G-ACTIVE-ISN-P10  /* BLI NOMALL-2294
*
G-REPORT := P-REPNAME
#ORDER   := G-ORDER-ID
#REPNAME := G-REPORT
*
FINDACT. FIND ACTIVE-REPORTS WITH AR-ORDER-REPNAME = #ORDER-REPNAME
  IF #TRACING
    COMPRESS G-REPORT 'Order' G-ORDER-ID TO G-TRACE-MSG
    PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END-IF
  RESET G-PROCESSING-PARMS
  +G-ACTIVE-ISN-P10 := *ISN(FINDACT.)
  G-REPORT := AR-REPNAME
  G-REPRNB := AR-REPRNB
  ##REC-COUNT := AR-NUMBER-OF-LINES
  ADD 1 TO ##AC-SEQNO
*
  DECIDE ON FIRST VALUE OF AR-CURRENT-LOCATION
    VALUE 'D'
      ##IN-NRM := TRUE
    NONE VALUE IGNORE
  END-DECIDE
  G-STORE-NATRPT        := ACTIVE-REPORTS.AR-STORE-NATRPT
  G-NATRPT-DIST  (1:10) := ACTIVE-REPORTS.AR-NATRPT-DIST (1:10)
  G-NATRPT-DIST-NO      := ACTIVE-REPORTS.C*AR-NATRPT-DIST
  RESET G-JPRINTER-NO G-PRINTERS (1:20)
  G-KEYWORDS (1:6)      := ACTIVE-REPORTS.AR-KEYWORDS(1:6)
  G-HOLD                := ACTIVE-REPORTS.AR-HOLD-PRINT
  G-ARCHIVE             := ACTIVE-REPORTS.AR-ARCHIVE
  G-RETENTION-PERIOD    := ACTIVE-REPORTS.AR-RETENTION-PERIOD
  G-RETENTION-ACTION    := ACTIVE-REPORTS.AR-RETENTION-ACTION
  G-SEPMEM              := ACTIVE-REPORTS.AR-SEPMEM
  G-SEPNO               := ACTIVE-REPORTS.AR-SEPNO
/*SU6  MONITNGL-G-NEW-VARIABLES := G-NEW-VARIABLES
/*SU6  G-AR-REOPENED            := TRUE
/*SU6  G-NEW-VARIABLES          := MONITNGL-G-NEW-VARIABLES
  PERFORM OVERWRITE-PARMS
  ESCAPE ROUTINE
END-FIND
IF #TRACING
  COMPRESS G-REPORT 'Order' G-ORDER-ID TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
*
REPORT-IN-MASTER := TRUE
OPEN-MASTER. FIND REPORTS WITH R-REPNAME = P-REPNAME
  IF NO RECORDS FOUND
/*SU 2018-10-16 GET REPORTS +#MASTER-ISN
    GET REPORTS G-MASTER-DEFINITION-ISN /*copy master to new report def.
    REPORT-IN-MASTER         := FALSE
    G-REPORT                 := P-REPNAME
    REPORTS.R-REPNAME        := P-REPNAME
    REPORTS.R-MASTER-REPNAME := ##MASTER-REPNAME
    REPORTS.R-TYPE           := 'C'
*
    RESET REPORTS.R-IDENT-JOB-NAME REPORTS.R-JOB-FROM
      REPORTS.R-JOB-TO REPORTS.R-IDENT-FILES (*)
      REPORTS.R-EXITLIB REPORTS.R-ASM-EXIT REPORTS.R-E-EXIT-TYPE
      REPORTS.R-E-IDENT-LINE REPORTS.R-E-IDENT-STRING
      REPORTS.R-E-BREAK-STRING REPORTS.R-E-BREAK-LINE
      REPORTS.R-E-BREAK-START REPORTS.R-E-BREAK-END
      REPORTS.R-E-REP-PREFIX REPORTS.R-E-BUN-PREFIX REPORTS.R-UPARMS (*)
*
    DECIDE FOR EVERY CONDITION
      WHEN P-BUNDLE (*) NE ' '
        REPORTS.R-BUNDLE (1:5) := P-BUNDLE(*)
      WHEN P-PRINTERS (*) NE ' '
        REPORTS.R-PRINTER   (*) := P-PRINTERS  (*)
        REPORTS.R-COPIES    (*) := P-COPIES    (*)
        REPORTS.R-SEP-PAGES (*) := P-SEP-PAGES (*) /*SU5
      WHEN P-DISTRIBUTION (*) NE ' '
        REPORTS.R-NATRPT-DIST(*) := P-DISTRIBUTION(*)
      WHEN P-STORE-NRM NE ' '
        REPORTS.R-STORE-NATRPT := P-STORE-NRM
      WHEN P-REPORT-SEPSTART NE ' '
        REPORTS.R-SEPSTART := P-REPORT-SEPSTART
      WHEN P-REPORT-SEPEND NE ' '
        REPORTS.R-SEPEND := P-REPORT-SEPEND
      WHEN P-REPORT-SEPNO NE 0
        REPORTS.R-SEPNO := P-REPORT-SEPNO
      WHEN P-RETENTION-ACTION NE ' '
        REPORTS.R-RETENTION-ACTION := P-RETENTION-ACTION
      WHEN P-RETENTION-UNIT NE ' '
        REPORTS.R-RETENTION-UNIT := P-RETENTION-UNIT
      WHEN P-RETENTION-NUM NE 0
        REPORTS.R-RETENTION-NUM := P-RETENTION-NUM
      WHEN P-RETENTION-CALENDAR NE ' '
        REPORTS.R-RETENTION-CALENDAR := P-RETENTION-CALENDAR
      WHEN P-OWNER NE ' '
        REPORTS.R-USERID := P-OWNER
      WHEN P-REPORT-JOBCARDS (*) NE ' '
        REPORTS.R-PRINT-JOBCARD (1:3) := P-REPORT-JOBCARDS (1:3)
      WHEN P-HOLD NE ' '
        REPORTS.R-HOLD-PRINT := P-HOLD
      WHEN P-ARCHIVE NE ' '
        REPORTS.R-ARCHIVE := P-ARCHIVE
      WHEN NONE
        IGNORE
    END-DECIDE
  END-NOREC
  G-SEPMEM := REPORTS.R-SEPMEM
  G-REPORT := P-REPNAME
  REPORTS.R-REPNAME := P-REPNAME
  NOMRNB-NAME := G-REPORT
  NOMRNB-TYPE := 'R'
  CALLNAT 'NOMRNB-N' NOMRNB-RNB NOMRNB-NAME NOMRNB-TYPE G-USERID /*SU2
  G-REPRNB := NOMRNB-RNB
*
  REPORTS.R-LASTRNB := G-REPRNB
  IF NOT REPORT-IN-MASTER
    IF P-REPORT-DESCRIPTION NE ' '
      REPORTS.R-DESC := P-REPORT-DESCRIPTION
    ELSE
      IF R-EXITMEM = MASK ('STD')
        COMPRESS '(' R-EXITMEM ')' REPORTS.R-DESC TO REPORTS.R-DESC
      ELSE
        COMPRESS '(' ##EXITMEM ')' REPORTS.R-DESC TO REPORTS.R-DESC
      END-IF
    END-IF
    RESET REPORTS.R-EXITMEM
    IF REPORTS.R-CREATE-DEFINITION = ' '
      REPORT-DEFAULTS.M-MONITOR-ID := F#MONITOR-TASK-ID1 (<>)
      FIND REPORT-DEFAULTS WITH M-MONITOR-ID =
          REPORT-DEFAULTS.M-MONITOR-ID
        REPORTS.R-CREATE-DEFINITION :=
          REPORT-DEFAULTS.R-CREATE-DEFINITION
      END-FIND
    END-IF
    IF REPORTS.R-CREATE-DEFINITION = 'Y'
      STORE-MASTER. STORE REPORTS
      LG-CODE        := 'RM'
      LG-MSG         := REPORTS.R-DESC
      LG-USERID      := G-JOBUSERID
      LG-OBJECT-NAME := REPORTS.R-REPNAME
      CALLNAT 'RLOG' PL-PARMS
      GRANTS.GR-OBJECT-TYPE := 'R'
      GRANTS.GR-USERID      := G-JOBUSERID
      GRANTS.GR-OBJECT-NAME := P-REPNAME
      GRANTS.GR-OPTION(*)   := 'Y'
      STORE-GRANTS. STORE GRANTS
    END-IF
  ELSE
    /*Do not cut field R-IDENT-FILES to A26, remember long content in
    /*own view (next NOM version increase field length in GDA:
/*SU11 #LONG. GET RP-LONG *ISN (OPEN-MASTER.) /*remember long field SU8
    UPDATE (OPEN-MASTER.)
/*SU11  UPDATE (#LONG.) /*SU8
    IF REPORTS.R-DESC = ' ' /*SU7
      REPORTS.R-DESC := P-REPORT-DESCRIPTION
    END-IF
  END-IF
*
  PERFORM INIT-REPORT-PARMS
  PERFORM OVERWRITE-PARMS
  PERFORM STORE-OPEN-REPORT #RMEXSEPA
  IF G-NATRP-ERC > 0
    BACKOUT TRANSACTION
    RESET G-PROCESSING-PARMS ##REPORT-CONTROL-RECORD P-EXIT-PARMS
      +G-ACTIVE-ISN-P10  /* BLI NOMALL-2294
  ELSE
    END TRANSACTION
  END-IF
END-FIND
IF #TRACING
  COMPRESS 'Ended with: --->' G-NATRP-ERC-A G-NATRP-ERT TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END TRANSACTION
END-IF
*
************************************************************************
ON ERROR /*SU1 NOMALL-82
************************************************************************
  IF *ERROR-NR NE 3148
    PERFORM CHANGE-SPOOL-CLASS +NOD-CURRENT-ERROR-CLASS #TRACING
  END-IF
END-ERROR
*
END-SUBROUTINE
*
END
