* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RMCLSREP
* Function  Close Active Report
* Version   1.3
*
* Maintenance:
* uuu yy-mm-dd s(999999) ....
* mrs 93-01-19 s(999999) clean up
* mrs 94-11-08 s(211501) correct connect distribution of a reopened
*                        active report
* jvd 99-11-17 p(188923) recompile due to changed MONITNGL
* sju 04-12-06 NOM31     Add date and time (tenths of second) to trace
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* fhi     2014-03-03 NOMALL-1363 Get cat cate into trace messages
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* SU1     2017-09-26 NOMALL-1823 NOM 3.5: remove CONNECT
* SU2     2018-08-30 NOMALL-2130 sep.var.:GDA MONIT-GL -> PDA RMEXSEPA
* SU3     2018-10-18             LDA MONITNGL removed
* ----------------------------------------------------------------------
*
DEFINE DATA GLOBAL USING MONIT-GL
PARAMETER
1 RMEX-SPOOL-ATTRIBUTES   (A250) /*OPTIONAL /*SU2
************************************************************************
INDEPENDENT
1 +CMRDC       (A1)        /* NOMALL-2009 fhi in
*
/*SU3 LOCAL USING MONITNGL
LOCAL
1 #TRACING     (L)
1 #TRACE-MSG   (A250)
1 #CATDATE     (A19) /* NOMALL-1363 fhi in
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
FORMAT LS=100
*
************************************************************************
DEFINE SUBROUTINE CLOSE-REPORT
************************************************************************
IF G-TRACE GE *LEVEL
  #TRACING := TRUE
  PERFORM XXCATAL-GET-CATDATE #CATDATE
  COMPRESS 'Start' *PROGRAM 'cataloged at'  #CATDATE
    TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
INCLUDE CMRDC                  /* NOMALL-2009 fhi in
IF ##REPORT-IS-OPENED
  IF ##REC-COUNT = 0
    ESCAPE ROUTINE
  END-IF
  PERFORM HANDLE-CONTENTS-POINTERS
  RESET REPORT-CONTENTS ##C-CONTENTS ##AC-SEQNO
  IF ##CUR-RECORD > 0 AND ##IN-NRM AND ##CUR-RECORD > 0
    DECIDE FOR EVERY CONDITION
      WHEN ##IN-NRM PERFORM CREATE-IN-NRM
      WHEN NONE IGNORE
    END-DECIDE
  END-IF
  PERFORM DISTRIBUTE-VIA-NATREP
/*SU3  MONITNGL-G-NEW-VARIABLES := G-NEW-VARIABLES
*
  PERFORM UPDATE-ACTIVE-REPORT RMEX-SPOOL-ATTRIBUTES /*SU2
  RESET ##REPORT-IS-OPENED
END-IF
IF #TRACING
  COMPRESS 'Ended with: --->' G-NATRP-ERC-A G-NATRP-ERT TO #TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' #TRACE-MSG
  END TRANSACTION
END-IF
*
END-SUBROUTINE /* CLOSE-REPORT
*
END
