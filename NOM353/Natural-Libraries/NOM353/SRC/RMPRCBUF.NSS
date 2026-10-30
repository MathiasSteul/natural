* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RMPRCBUF
* Function  Flush Buffer to Container
* Version   1.3
*
* Maintenance:
* uuu yy-mm-dd s(999999) ....
* mrs 93-01-19           clean up
* sju 04-12-06 NOM31     Add date and time (tenths of second) to trace
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* fhi     2014-03-03 NOMALL-1363 Get cat cate into trace messages
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* SU1     2017-09-26 NOMALL-1823 NOM 3.5: remove CONNECT
* ----------------------------------------------------------------------
*
DEFINE DATA GLOBAL USING MONIT-GL
INDEPENDENT
1 +CMRDC    (A1)        /* NOMALL-2009 fhi in
* *****
LOCAL
1 #TRACING  (L)
1 #CATDATE  (A19) /* NOMALL-1363 fhi in
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
FORMAT LS=100
*
************************************************************************
DEFINE SUBROUTINE PROCESS-BUFFER
************************************************************************
IF G-TRACE GE *LEVEL
  #TRACING := TRUE
  PERFORM XXCATAL-GET-CATDATE #CATDATE
  COMPRESS 'Start' *PROGRAM 'cataloged at' #CATDATE TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
INCLUDE CMRDC                  /* NOMALL-2009 fhi in
*
IF ##CUR-RECORD > 0
  DECIDE FOR EVERY CONDITION
    WHEN ##IN-NRM     PERFORM CREATE-IN-NRM
    WHEN NONE         IGNORE
  END-DECIDE
END-IF
*
IF #TRACING
  COMPRESS 'Ended with: --->' G-NATRP-ERC-A G-NATRP-ERT TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
*
END-SUBROUTINE /* PROCESS-BUFFER
*
END
