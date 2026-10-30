* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RMCHJOB
* Function  Change Spool Class
* Version   3.4.1+
*
* Maintenance:
* SU      2013-11-20 NOMALL-82 created: new class: activate error
* fhi     2016-08-01 NOMALL-1748 Backout Report Formatting
* ----------------------------------------------------------------------
*
DEFINE DATA GLOBAL USING MONIT-GL
PARAMETER
1 #NEW-CLASS (A1) /*G-ERROR-CLASS
1 #TRACING   (L)  /*G-TRACE
* G-ORDER-ID GDA
************************************************************************
LOCAL USING RMSPL--L
LOCAL USING RMSR---E
LOCAL USING RLOG-L /*PL-PARMS with LG- vars
LOCAL
1 SOURCE VIEW OF NRM-SOURCE
  2 SR-ID
  2 SR-TYPE
  2 SR-CC-TYPE
  2 SR-MONITOR-ID
  2 SR-NUMBER-OF-LINES
  2 SR-RECORD-LENGTH
  2 SR-CONTROL-FLAG
* 2 SR-CONVERTED                           /* NOMALL-1748 fhi out
  2 SR-ATTRIBUTES-IDENT
  2 SR-SPOOL-ATTRIBUTES
* 2 SR-SPOOL-ATTRIBUTES-CONV               /* NOMALL-1748 fhi out
  2 SR-SPOOL-ATTR-EXTENDED (1:120)
1 SPOOL-UPDATE VIEW OF SPOOL-UPDATE
  2 ERROR-CODE
  2 ERROR-TEXT
  2 JOB-NAME
  2 JOB-NUMBER
  2 CLASS
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
FORMAT LS=100
************************************************************************
DEFINE SUBROUTINE CHANGE-SPOOL-CLASS
************************************************************************
IF G-ORDER-ID = 0 OR #NEW-CLASS = ' '
  ESCAPE ROUTINE
END-IF
FNDSR. FIND SOURCE WITH SR-ID = G-ORDER-ID
END-FIND
IF *NUMBER (FNDSR.) = 0
  ESCAPE ROUTINE /* CHANGE-SPOOL-CLASS-TO-ERROR
END-IF
#SPOOL-ATTRIBUTES := SOURCE.SR-SPOOL-ATTRIBUTES
IF NOT(#SPOOL-TYPE = JES2 OR=JES3) OR #SPOOL-JES-NODE = 0
    OR #SPOOL-JES-JOB-NAME = ' ' OR #SPOOL-JES-JOB-NUMBER = 0
  ESCAPE ROUTINE
END-IF
IF #TRACING
  IF #NEW-CLASS = G-ERROR-CLASS
    G-TRACE-MSG := 'error'
  ELSE
    G-TRACE-MSG := #NEW-CLASS
  END-IF
  COMPRESS 'Change spool class' #SPOOL-JES-JOB-NAME
    #SPOOL-JES-JOB-NUMBER 'to' G-TRACE-MSG TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
FIND SPOOL-UPDATE WITH NODE = #SPOOL-JES-NODE
    AND JOB-NAME   = #SPOOL-JES-JOB-NAME
    AND JOB-NUMBER = #SPOOL-JES-JOB-NUMBER
    AND CLASS      = #NEW-CLASS
    AND FUNCTION   = 'CHANGE'
*
  IF SPOOL-UPDATE.ERROR-CODE > 0
    COMPRESS #SPOOL-JES-JOB-NAME '/' #SPOOL-JES-JOB-NUMBER '/'
      TO LG-OBJECT-NAME LEAVING NO
    WRITE NOTITLE NOHDR *PROGRAM *TIMX (EM=YYYY'-'MM'-'DD' 'HH':'II)
      'Cannot change to Class' #NEW-CLASS
    WRITE NOTITLE NOHDR *PROGRAM *TIMX (EM=YYYY'-'MM'-'DD' 'HH':'II)
      SPOOL-UPDATE.ERROR-TEXT
    G-NATRP-ERC := 0005
    G-NATRP-ERT := SPOOL-UPDATE.ERROR-TEXT
    PERFORM WRITE-ERROR-LOG
  END-IF
END-FIND
*
************************************************************************
* End of main line (now subroutines):
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE WRITE-ERROR-LOG
************************************************************************
IF G-ORDER-ID NE 0
  LG-OBJECT-NAME := G-ORDER-ID
END-IF
IF G-NATRP-ERC = 0005
  LG-MSG := G-NATRP-ERT
ELSE
  COMPRESS G-NATRP-ERC G-NATRP-ERT TO LG-MSG
END-IF
LG-USERID := G-LG-USERID
LG-CODE   := 'MO'
CALLNAT 'RLOG' PL-PARMS
END OF TRANSACTION
IF #TRACING
  COMPRESS 'Error: --->' G-NATRP-ERC-A LG-MSG TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
*
END-SUBROUTINE /* WRITE-ERROR-LOG
*
END-SUBROUTINE /* CHANGE-SPOOL-CLASS
*
END
