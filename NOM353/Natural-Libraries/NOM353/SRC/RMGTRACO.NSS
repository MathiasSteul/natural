* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
/*******************************************************************************
/*  Software AG - Entire Output Management
/*  Group:    Monitor
/*  Module:   RMGTRACO
/*  Template: RMGTRACE
/*
/*  Function:
/** Returns the current trace settings to #TRACING */
/*
/*  User ID   yyyy-mm-dd Issue         Remark
/* -----------------------------------------------------------------------------
/*  fhi       2011-01-10 NOMALL-97     Created.
/*  raya      2011-07-29 NOMALL-1034   Use correct library-id
/*  fhi       2012-04-23 FHI279        Allow TRACE:VALUE and TRACE=VALUE
/*  fhi       2016-11-15 NOMALL-1961   Use new task IDs
* SU1     2017-03-02 NOM3.5 remove RGETLIB
* SU2     2018-10-30 NOMALL-2164 remove RLOG STACK
* SU3     2020-11-10 NOMALL-2440 recat for VMONIT-L
/************************************* data ************************************
DEFINE DATA GLOBAL USING NRM-GL /*SU3 GDA not used Ü?
PARAMETER
1 #TRACING                (L) OPTIONAL
************************************************************************
/*SU3 LOCAL  USING VMONIT-L
LOCAL
1 NRM-MONITOR VIEW OF NRM-MONITOR
  2 M-JOBCARD     (A72/1:3)
*
1 #G-TRACE-A       (A3)
1 #G-TRACE         (N3)
1 #TRACE-SET       (A250)
1 #LEVEL           (I2)
1 #POS             (I2)
1 #SPEC-CHAR-TABLE (A2/16)
  INIT <', ','. ','; ',': ','* ','/ ','( ',
  'Ü ','" ','@ ','$ ','% ','& ','? ','§ ',':='>
1 #MONITOR-ID      (A20) /*SU3
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
********************************************************************************
DEFINE SUBROUTINE RMGTRACO-GET-SETTINGS
********************************************************************************
RESET #G-TRACE #TRACE-SET #POS
#LEVEL := *LEVEL - 1
#MONITOR-ID := F#MONITOR-TASK-ID1 (<>)
FIND-MONIT. FIND NRM-MONITOR WITH M-MONITOR-ID = #MONITOR-ID
  IF NO RECORDS FOUND
    *ERROR-NR := 999 /*SU2
/*SU2 G-NATRP-ERC   := 114 G-NATRP-ERT   := G-NATRP-ERC
/*SU2 PERFORM XXRLOG-WRITE-LOG 'S'G-NATRP-ERT ESCAPE BOTTOM(FIND-MONIT.)
  END-NOREC
  COMPRESS M-JOBCARD (1:3) TO #TRACE-SET LEAVING NO
  EXAMINE #TRACE-SET TRANSLATE INTO UPPER
  EXAMINE #TRACE-SET TRANSLATE USING #SPEC-CHAR-TABLE (*)
  DECIDE FOR EVERY CONDITION
    WHEN #POS = 0
      EXAMINE #TRACE-SET FOR 'TRACE=OFF' GIVING POSITION IN #POS
    WHEN #POS > 0
      RESET #TRACE-SET
      IF #TRACING SPECIFIED
        RESET #TRACING
      END-IF
      ESCAPE BOTTOM (FIND-MONIT.)
    WHEN #POS = 0
      EXAMINE #TRACE-SET FOR 'TRACE=ON' GIVING POSITION IN #POS
    WHEN #POS > 0
      #G-TRACE     := 100
      IF #TRACING SPECIFIED
        #TRACING    := TRUE
      END-IF
      #TRACE-SET := 'SCAN COPY CREATE PRINT'
      ESCAPE BOTTOM (FIND-MONIT.)
    WHEN #POS = 0
      EXAMINE #TRACE-SET FOR 'TRACE=' GIVING POSITION IN #POS
    WHEN #POS = 0
      ESCAPE BOTTOM (FIND-MONIT.)
    WHEN #POS > 0
      #POS       := #POS + 6
      #TRACE-SET := SUBSTR(#TRACE-SET,#POS)
      IF SUBSTR(#TRACE-SET,1,1) = ' '
        #TRACE-SET := SUBSTR(#TRACE-SET,2)
      END-IF
      EXAMINE #TRACE-SET FOR ')' GIVING POSITION IN #POS
    WHEN #POS > 1
      #POS := #POS - 1
      #TRACE-SET := SUBSTR(#TRACE-SET,1,#POS)
    WHEN #POS > -1
      SEPARATE #TRACE-SET INTO #G-TRACE-A REMAINDER #TRACE-SET
      IF #G-TRACE-A IS (N3)
        #G-TRACE  := VAL(#G-TRACE-A)
        IF #TRACING SPECIFIED
          IF #G-TRACE GE #LEVEL
            #TRACING := TRUE
          ELSE
            #TRACING := FALSE
          END-IF
        END-IF
        IF #TRACE-SET = ' '
          #TRACE-SET := 'SCAN COPY CREATE PRINT'
        END-IF
      ELSE
        COMPRESS #G-TRACE-A #TRACE-SET INTO #TRACE-SET /* back to it
        #G-TRACE  := 100
        IF #TRACING SPECIFIED
          #TRACING := TRUE
        END-IF
      END-IF
      ESCAPE BOTTOM (FIND-MONIT.)
    WHEN NONE
      IGNORE
  END-DECIDE
END-FIND
*
END-SUBROUTINE /* RMGTRACO-GET-SETTINGS
*
END
