* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
************************************************************************
* Software AG - Entire Output Management
* RMSETTIM - Calculate a time difference like *TIMD.
*
* Description:
* Avoids the usage of Natural statements SET TIME in conjunction with
* the time differential function *TIMD. This has been done because
* *TIMD does not work under virtual machines. The time difference
* could be negative if the virtual clock is adjusted. --> NAT1319
*
* Until NOM 3.4:
* The routine can handle up to 10 'slots' which means that up to
* 10 independent time differences can be run.
*
* From NOM 3.5 and above:
* The slot design has been dropped. Now each module can call this
* routine and will be supplied with its individual CPU time consumed.
*
* Maintenance:
* uuu     yy-mm-dd   itrac
* ------- ---------- ----------- ---------------------------------------
* fhi     2010-06-14 NOMALL-815  Created.
* fhi     2011-03-16 NOMALL-947  Add slots of measurements.
* fhi     2012-11-08 NOMALL-1143 Add CPU Time
* fhi     2018-12-14 NOM 3.5     Rewritten for usage of prog name
* SU1     2022-11-03 NOMALL-2587 avoid NAT1319(Daylight saving time)
************************************************************************
*
DEFINE DATA
PARAMETER
1 FUNCTION   (A1)    /* In:  S=Set time/G=GetTimeDiff./R=ResetTable
1 ERC        (N4)    /* Out:
  /* 0=OK
  /* 1=Invalid function
  /* 2=Get without set: No values
  /* 3=Error in table processing
1 MSG        (A250)  /* Out: Formatted text or error message
1 OUT-TIME   (I4)    BY VALUE RESULT OPTIONAL
*                    /* Out: 1/10 sec of time diff
1 CPUTIME    (I4)    BY VALUE RESULT OPTIONAL
*                    /* Out: 1/100 sec of cpu-time diff
************************************************************************
LOCAL
1 #CPU-COLS   (I4) CONST <4>
  /*(1) = Calling pgm
  /*(2) = Elapsed time up to 1/10 sec
  /*(3) = Elapsed time: microseconds
  /*(4) = CPU-time in steps of 10 ms
1 #CPU-FCT    (A1)
1 #CPU-VALUES (A/#CPU-COLS) DYNAMIC
1 #CPU-IX     (I4)
1 #CPU-ERC    (N4)
* *****
INDEPENDENT
1 +CPU-TBLE   (A/*,#CPU-COLS) DYNAMIC
1 +CPU-LASTIX (I4)
1 +CPU-TEMP1  (I4)
1 +CPU-TEMP2  (I4)
* *****
LOCAL
1 #LASTPROG   (A8)
1 #TIME1      (T)
1 REDEFINE #TIME1
  2 #TIME1-P  (P12)
1 #TIME2      (T)
1 #TIME-A     (A10)
1 #CPUTIME    (N9.2)
1 #CPUTIME-A  (A12)
1 #MICROSEC   (P5)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE RMSETTIM-SETTIME
************************************************************************
RESET ERC MSG
PERFORM XXLSLEVL-GET-LAST-LEVEL #LASTPROG
DECIDE ON FIRST VALUE OF FUNCTION
  VALUE 'R' /*R=ResetTable
    #CPU-FCT := 'K' /* Reset table (kill)
    INCLUDE XXTABLE2 '#CPU-FCT'    '+CPU-TBLE'
      '#CPU-VALUES'  '#CPU-IX'     '+CPU-LASTIX'
      '+CPU-TEMP1'   '+CPU-TEMP2'  '#CPU-COLS'     '#CPU-ERC'
  VALUE 'S' /*S=Set time
    PERFORM SATTIMST-GET-TIME 'L' 1X #MICROSEC 1X #TIME1
    #CPU-VALUES (1) := #LASTPROG
    MOVE EDITED #TIME1(EM=YYYY''-''MM''-''DD''-''HH'':''II'':''SS''.''T)
      TO #CPU-VALUES (2)
    #CPU-VALUES (3) := #MICROSEC
    #CPU-VALUES (4) := *CPU-TIME
    #CPU-FCT := 'A' /* Add values if not existing
    INCLUDE XXTABLE2 '#CPU-FCT'    '+CPU-TBLE'
      '#CPU-VALUES'  '#CPU-IX'     '+CPU-LASTIX'
      '+CPU-TEMP1'   '+CPU-TEMP2'  '#CPU-COLS'     '#CPU-ERC'
    #CPU-FCT := 'U' /* Update values if existing
    INCLUDE XXTABLE2 '#CPU-FCT'    '+CPU-TBLE'
      '#CPU-VALUES'  '#CPU-IX'     '+CPU-LASTIX'
      '+CPU-TEMP1'   '+CPU-TEMP2'  '#CPU-COLS'     '#CPU-ERC'
  VALUE 'G' /*GetTimeDiff.
    #CPU-VALUES (1) := #LASTPROG
    #CPU-FCT        := 'F' /* Retrieve values
    INCLUDE XXTABLE2 '#CPU-FCT' '+CPU-TBLE' '#CPU-VALUES' '#CPU-IX'
      '+CPU-LASTIX' '+CPU-TEMP1' '+CPU-TEMP2' '#CPU-COLS' '#CPU-ERC'
    IF #CPU-IX = 0
      ERC := 2  /* no value set, unavailable
      COMPRESS 'CPU time unavailable in' #LASTPROG TO MSG
      PERFORM CLEAR
      ESCAPE ROUTINE
    END-IF
    MOVE EDITED #CPU-VALUES (2)
      TO #TIME2 (EM=YYYY''-''MM''-''DD''-''HH'':''II'':''SS''.''T)
    PERFORM SATTIMST-GET-TIME 'L' 1X #MICROSEC 1X #TIME1
    IF #TIME1 < #TIME2 /*avoid NAT1319(Daylight saving time) SU1 ->
      IF #TIME1 + 36000 > #TIME2
        #TIME1 := #TIME1 + 36000 /*1 hour
      ELSE
        #TIME1 := #TIME2 + 10 /*1 sec
      END-IF
    END-IF /*SU1 <-
    #TIME1 := #TIME1 - #TIME2
    IF OUT-TIME SPECIFIED
      OUT-TIME := #TIME1-P
    END-IF
    MOVE EDITED #TIME1 (EM=HH'':''II'':''SS''.''T) TO #TIME-A
    #CPUTIME   := VAL(#CPU-VALUES (4))
    #CPUTIME   := *CPU-TIME - #CPUTIME
    IF CPUTIME SPECIFIED
      CPUTIME  := #CPUTIME
    END-IF
    IF #CPUTIME > 0
      #CPUTIME   := #CPUTIME / 100 /* in seconds
      MOVE EDITED #CPUTIME (EM=ZZZZZZZZ9.99) TO #CPUTIME-A
      MOVE LEFT   #CPUTIME-A                 TO #CPUTIME-A
    ELSE
      #CPUTIME-A := '< 0.01'
    END-IF
    COMPRESS #LASTPROG 'elapsed time:' #TIME-A
      '- CPU sec:' #CPUTIME-A TO MSG
  ANY
    IF #CPU-ERC NE 0
      ERC := 3                     /* error in table processing
      COMPRESS *PROGRAM 'Internal error:' #CPU-ERC
        '/ called from' #LASTPROG TO MSG
    END-IF
  NONE
    ERC := 1                       /* Unknown function
    COMPRESS *PROGRAM 'Invalid function:' FUNCTION
      '/ called from' #LASTPROG TO MSG
    PERFORM CLEAR
    ESCAPE ROUTINE
END-DECIDE
PERFORM CLEAR
*
************************************************************************
* End of main line (now subroutines):
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE CLEAR
************************************************************************
IF ERC NE 0
  IF OUT-TIME SPECIFIED
    RESET OUT-TIME
  END-IF
  IF CPUTIME SPECIFIED
    RESET CPUTIME
  END-IF
END-IF
*
END-SUBROUTINE /* CLEAR
*
END-SUBROUTINE /*RMSETTIM
*
END
