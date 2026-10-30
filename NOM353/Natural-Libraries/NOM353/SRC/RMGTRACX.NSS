* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
/*******************************************************************************
/*  Software AG - Entire Output Management
/*  Group:    Monitor
/*  Module:   RMGTRACX
/*  Template: RMGTRACE
/*
/*  Function:
/** Common Subroutine for all RMGTR* modules  */
/*
/*  User ID   yyyy-mm-dd Issue       Remark
/* -----------------------------------------------------------------------------
/*  fhi       2015-05-06 NOMALL-1585 Created.
/*  SU1     2015-11-23 NOMALL-1784 avoid NAT1301 (P10->B4/I4 - big ISNs)
/*  fhi       2016-02-01 NOMALL-1820 Avoid loop during UX installation
/*  fhi       2016-11-15 NOMALL-1961 Use new task IDs
/*  SU2       2017-03-02 NOM3.5      remove RGETLIB
/*  fhi       2017-04-05 NOMALL-2009 Trace RDC if TRACE-RDC=ON is found
/*  fhi       2017-06-29 NOMALL-2029   Correct wrong trace level
/*  fhi       2019-08-15 NOMALL-2294   Introduce TRACE-ORDER in jobcards
* SU3     2020-11-10 NOMALL-2440 recat for VMONIT-L
/************************************* data ************************************
DEFINE DATA
PARAMETER
1 L-NATRP-ERC             (N4)
1 L-NATRP-ERT             (A250)
1 #TRACING                (L)       OPTIONAL
1 L-TRACE                 (I2)      OPTIONAL
1 L-TRACE-SET             (A200)    OPTIONAL
************************************************************************
INDEPENDENT
1 +TRACE-WRAP             (I2)
1 +TRACE-PROG             (A8)
1 +TRACE-ORDER            (A1)      /* NOMALL-2294 fhi in
1 +TRACE-RDC              (L)       /* NOMALL-2009 fhi in
* *****
/*SU3 LOCAL USING VMONIT-L
LOCAL
1 NRM-MONITOR VIEW OF NRM-MONITOR /*SU3
  2 M-JOBCARD            (A72/1:3)
1 G-TRACE                 (I2)
1 G-TRACE-SET             (A200)
1 #G-TRACE-A              (A3)
1 #LEVEL                  (I2)
1 #POS                    (I2)
1 #ISN                    (P10) /*NOMALL-77 fhi in /*SU1 was I4
1 #TRACE-WRAP             (A250)
1 #TRACE-PROG             (A250)
1 #SPEC-CHAR-TABLE        (A2/16)
  INIT <', ','. ','; ',': ','* ','/ ','( ',
  'Ü ','" ','@ ','$ ','% ','& ','? ','§ ',':='>
1 #MONITOR-ID             (A20)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
********************************************************************************
DEFINE SUBROUTINE RMGTRACX-GET-VALUES
********************************************************************************
IF L-TRACE SPECIFIED
  G-TRACE := L-TRACE
END-IF
IF L-TRACE-SET SPECIFIED
  G-TRACE-SET := L-TRACE-SET
END-IF
RESET G-TRACE G-TRACE-SET
#LEVEL := *LEVEL - 2 /* NOMALL-2029 was '- 1'
#MONITOR-ID := F#MONITOR-TASK-ID1 (<>)
FIND-MONIT. FIND NRM-MONITOR WITH M-MONITOR-ID = #MONITOR-ID
  IF NO RECORDS FOUND /* = installation error or installation ongoing.
    RESET G-TRACE G-TRACE-SET /* treat it as 'Trace Off'
    IF #TRACING SPECIFIED
      RESET #TRACING
    END-IF
    ESCAPE MODULE /* don't try anything else.
  END-NOREC
  #ISN := *ISN (FIND-MONIT.)
  COMPRESS M-JOBCARD (1:3) TO G-TRACE-SET LEAVING NO
  EXAMINE G-TRACE-SET TRANSLATE INTO UPPER
  EXAMINE G-TRACE-SET TRANSLATE USING #SPEC-CHAR-TABLE (*)
  #TRACE-WRAP := #TRACE-PROG := G-TRACE-SET
  DECIDE FOR EVERY CONDITION
    WHEN #POS = 0
      EXAMINE G-TRACE-SET FOR 'TRACE=OFF' GIVING POSITION #POS
    WHEN #POS > 0
      RESET G-TRACE G-TRACE-SET
      IF #TRACING SPECIFIED
        RESET #TRACING
      END-IF
      ESCAPE BOTTOM (FIND-MONIT.)
    WHEN #POS = 0
      EXAMINE G-TRACE-SET FOR 'TRACE=ON' GIVING POSITION #POS
    WHEN #POS > 0
      G-TRACE     := 100
      IF #TRACING SPECIFIED
        #TRACING    := TRUE
      END-IF
      G-TRACE-SET := 'SCAN COPY CREATE PRINT'
      ESCAPE BOTTOM (FIND-MONIT.)
    WHEN #POS = 0
      EXAMINE G-TRACE-SET FOR 'TRACE=' GIVING POSITION #POS
    WHEN #POS = 0
      ESCAPE BOTTOM (FIND-MONIT.)
    WHEN #POS > 0
      ADD 6 TO #POS
      G-TRACE-SET := SUBSTR(G-TRACE-SET,#POS)
      IF SUBSTR(G-TRACE-SET,1,1) = ' '
        G-TRACE-SET := SUBSTR(G-TRACE-SET,2)
      END-IF
      EXAMINE G-TRACE-SET FOR ')' GIVING POSITION #POS
    WHEN #POS > 1
      SUBTRACT 1 FROM #POS
      G-TRACE-SET := SUBSTR(G-TRACE-SET,1,#POS)
    WHEN #POS > -1
      SEPARATE G-TRACE-SET INTO #G-TRACE-A REMAINDER G-TRACE-SET
      IF #G-TRACE-A IS (N3)
        G-TRACE   := VAL(#G-TRACE-A)
        IF #TRACING SPECIFIED
          IF G-TRACE GE #LEVEL
            #TRACING := TRUE
          ELSE
            #TRACING := FALSE
          END-IF
        END-IF
        IF G-TRACE-SET = ' '
          G-TRACE-SET := 'SCAN COPY CREATE PRINT'
        END-IF
      ELSE
        COMPRESS #G-TRACE-A G-TRACE-SET TO G-TRACE-SET
        G-TRACE   := 100
        IF #TRACING SPECIFIED
          #TRACING := TRUE
        END-IF
      END-IF
      ESCAPE BOTTOM (FIND-MONIT.)
    WHEN NONE
      IGNORE
  END-DECIDE
END-FIND
/* Check for wrap around buffer
IF #ISN NE 0 AND G-TRACE > 0
  RESET #POS +TRACE-WRAP
  DECIDE FOR EVERY CONDITION
    WHEN #POS = 0
      EXAMINE #TRACE-WRAP FOR 'TRACE-WRAP=' GIVING POSITION #POS
    WHEN #POS > 0
      ADD 11 TO #POS
      #TRACE-WRAP := SUBSTR (#TRACE-WRAP,#POS)
      SEPARATE #TRACE-WRAP INTO #TRACE-WRAP IGNORE
      IF #TRACE-WRAP IS (N5)
        +TRACE-WRAP := VAL (#TRACE-WRAP)
      END-IF
    WHEN NONE
      IGNORE
  END-DECIDE
END-IF
/* Check for TRACE-RDC=ON parameter and set +TRACE-RDC
EXAMINE #TRACE-PROG FOR 'TRACE-RDC=ON' GIVING POSITION #POS
IF #POS > 0
  +TRACE-RDC := TRUE
ELSE
  +TRACE-RDC := FALSE
END-IF
EXAMINE #TRACE-PROG FOR 'TRACE-RDC=OFF' GIVING POSITION #POS
IF #POS > 0
  +TRACE-RDC := FALSE
END-IF
/* Check for TRACE-PROG= parameter
RESET #POS +TRACE-PROG
DECIDE FOR EVERY CONDITION
  WHEN #POS = 0
    EXAMINE #TRACE-PROG FOR 'TRACE-PROG=' GIVING POSITION #POS
  WHEN #POS > 0
    ADD 11 TO #POS
    +TRACE-PROG := SUBSTR (#TRACE-PROG,#POS)
    SEPARATE +TRACE-PROG INTO +TRACE-PROG IGNORE
  WHEN NONE
    IGNORE
END-DECIDE
RESET #POS +TRACE-ORDER
DECIDE FOR EVERY CONDITION
  WHEN #POS = 0
    EXAMINE #TRACE-PROG FOR 'TRACE-ORDER' GIVING POSITION #POS
  WHEN #POS > 0
    +TRACE-ORDER := 'Y' /* Do a special order trace
  WHEN #POS < 1
    +TRACE-ORDER := 'N' /* Avoid special order trace
  WHEN NONE
    IGNORE
END-DECIDE
IF L-TRACE SPECIFIED
  L-TRACE := G-TRACE
END-IF
IF L-TRACE-SET SPECIFIED
  L-TRACE-SET := G-TRACE-SET
END-IF
*
END-SUBROUTINE /* RMGTRACX-GET-VALUES
*
END
