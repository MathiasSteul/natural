* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXRLOG - Write string to log. Regards error numbers */
*  Writes a string to NOM logging into the SAT error file using
*  program RLOG. Called if only a string without additional parameters
*  is to be logged from within the monitor. If the string begins with
*  the error number, the error number is resolved.
*
*  Maintenance
*  User ID   yyyy-mm-dd Issue         Remark
* ---------------------------------------------------------------------
* fhi       2010-09-23 NOMALL-800    Created.
* fhi       2011-05-02 NOMALL-901    Pass User if defined
* xsetggr   2011-09-12 NOMALL-1058   Pass application if log from API
* xsetggr   2011-09-20 NOMALL-901    corrections
* fhi       2012-12-10 NOMALL-1214   Fill message field for online acc.
* fhi       2014-02-11 NOMALL-1318   Correct parameter handling for 'W'
* fhi       2014-04-11 NOMALL-1209   Create unique strings
* fhi       2014-08-15 NOMALL-1454   Check better for error number
* SU1       2014-12-19 NOMALL-1548 remove unused LDA
* fhi       2015-05-06 NOMALL-1585   Limit the trace to one member
*                                    Old tags deleted
* fhi       2016-04-15 NOMALL-1837 Introduce +DEVICE for testing
* fhi       2016-11-15 NOMALL-1961 Use new task IDs
* fhi       2017-03-28 NOMALL-2009 Improve RDC data collection
* fhi       2018-10-16 NOM 3.5     Add fct 'M':Generate msg only,No tags
* SU2       2018-10-30 backout NOMALL-1214: RLOG-L
* BLI       2019-08-08 NOMALL-2294 write log 'W' regardless of trace
* SU3     2020-06-24 NOMALL-2349 remove unused + lev -> I2
* SU4     2021-04-16 NOMALL-2454 recat RMTASK-P to avoid NAT1305
************************************** data ****************************
DEFINE DATA
PARAMETER
1 XXRLOG-FUNCTION  (A1)
/* 'W' Write to output, too.
/*SU2 NOÜ /* 'S' Stack Log.
/* 'T' Trace output
/* 'M' Generate message only and return resolved message in XXRLOG-MSG
1 XXRLOG-MSG       (A)  DYNAMIC BY VALUE RESULT
1 XXRLOG-USER      (A8) OPTIONAL
1 XXRLOG-APPL      (A8) OPTIONAL
1 XXRLOG-MSGTYPE   (A1) OPTIONAL          /* 'N'=Nat or 'U'/' '=User
/*                                        /* implemented for fct 'M'
************************************************************************
INDEPENDENT
1 +TRACE-PROG      (A8)
1 +DEVICE          (A8)
1 +G-TASK-NUMBER   (I1)
1 +CMRDC           (A1)
************************************************************************
LOCAL USING RLOG-L /*SU2 was RLOG-P
LOCAL USING RMTASK-P
LOCAL USING XXGMSG-A
LOCAL
1 #LASTPROG        (A8)
1 #XX-ERROR-CODE-A (A) DYNAMIC
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE XXRLOG-WRITE-LOG
************************************************************************
IF +CMRDC = 'S'
  CALL 'CMRDC' 'T' ' '                    /* Don't trace any events
END-IF
IF +TRACE-PROG = ' '
  CALLNAT 'RMGTRACN'
  IF +TRACE-PROG = ' '
    +TRACE-PROG := 'NOTRACEÜ' /* Avoid calling get-settings all the time
  END-IF
END-IF
IF XXRLOG-FUNCTION = 'T' AND +TRACE-PROG NE 'NOTRACEÜ' /*NOMALL-2294 BLI
  PERFORM XXLSLEVL-GET-LAST-LEVEL #LASTPROG
  IF #LASTPROG NE SCAN (+TRACE-PROG) /*SU3 moved inside IF
    ESCAPE ROUTINE /* trace only program entered in TRACE=... statement
  END-IF
END-IF
LG-CODE := 'MO'
DECIDE FOR EVERY CONDITION
  WHEN +DEVICE = 'BATCH'
    IF +G-TASK-NUMBER = 0
      +G-TASK-NUMBER := 1
    END-IF
    RMTASK-P.FUNCTION       := 'L'
    RMTASK-P.SUBTASK-NUMBER := +G-TASK-NUMBER
    CALLNAT 'RMTASKID' RMTASK-P
    LG-USERID := RMTASK-P.TASK-ID
  WHEN XXRLOG-USER SPECIFIED AND XXRLOG-USER NE ' '
    LG-USERID := XXRLOG-USER
  WHEN NONE
    LG-USERID := *USER
END-DECIDE
*
IF XXRLOG-FUNCTION  = 'M' /* Resolve message only
  SEPARATE XXRLOG-MSG INTO #XX-ERROR-CODE-A #XX-MSG-DYNA (*) IGNORE
  IF #XX-ERROR-CODE-A NE MASK (NNNN)
    ESCAPE ROUTINE
  END-IF
  #XX-ERROR-CODE   := VAL(#XX-ERROR-CODE-A)
  IF XXRLOG-MSGTYPE SPECIFIED
    #XX-ERROR-TYPE := XXRLOG-MSGTYPE
  END-IF
  CALLNAT 'XXGMSG-N' #XX-GMSG-PARMS
  XXRLOG-MSG       := #XX-SHORT-TEXT
ELSE
  LG-MSG      := XXRLOG-MSG
  LG-FUNCTION := XXRLOG-FUNCTION
  CALLNAT 'RLOG' PL-PARMS
  IF *DEVICE NE 'BATCH' AND XXRLOG-FUNCTION = 'W'
    XXRLOG-MSG := LG-MSG
  END-IF
  IF +CMRDC = 'S'
    CALL 'CMRDC' 'T' 'ALL'                  /* Trace all events
  END-IF
END-IF
*
END-SUBROUTINE /* XXRLOG-WRITE-LOG
*
END
