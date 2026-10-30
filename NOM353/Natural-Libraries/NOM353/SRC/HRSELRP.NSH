* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRSELRP
* Function:  Select a Report
*
* Maintenance
* mrs 91-08-27   completly new
* mrs 92-04-22   s(147814) support wild card selection
* xsisgg 00-08-04 (CE7461) Extend Report and Bundle names
* ----------------------------------------------------------------------
DEFINE DATA
GLOBAL USING NRM-GL
PARAMETER
1 #REPNAME             (A25)
************************************************************************
LOCAL
1 REPORTS VIEW OF NRM-REPORTS-NEW
  2 R-REPNAME
*
1 #I                   (P2)
1 #J                   (P2)
1 #NOFLINES            (I2)   CONST <10>
1 #SCREEN  (1:#NOFLINES)
  2 L-REPNAME          (A25)
  2 REDEFINE L-REPNAME
    3 L-REPNAME-17     (A17)
    3 L-REPNAME-R      (A8)
1 CV-MARK              (C/1:#NOFLINES)
1 L-MARK               (A1/1:#NOFLINES)
1 END-OF-PROCESSING    (L)
1 END-OF-DISPLAY       (L)
1 END-OF-DATA          (L)
1 NEW-SEARCH           (L)
1 #ERC                 (N4)
1 #PAGE                (P3)  INIT <1>
1 #NOFPAGES            (I2)  CONST <20>
1 #S-REPNAME           (A25/1:#NOFPAGES)
1 #E-REPNAME           (A25)
1 #T-REPNAME           (A25)
1 REDEFINE #T-REPNAME
  2 #T-R               (A1/1:25)
1 I                    (P2)
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
PERFORM PF-KEYS
EXAMINE FULL VALUE OF #REPNAME FOR '*' GIVING POSITION IN I
IF I > 0
  #T-REPNAME := #E-REPNAME := #S-REPNAME (1) := #T-REPNAME
  #T-R (I:25) := H'00'
  #T-R (I:25) := H'FF'
ELSE
  MOVE ALL H'00' TO #S-REPNAME (1)
  MOVE ALL H'FF' TO #E-REPNAME
END-IF
*
MAIN. REPEAT UNTIL END-OF-PROCESSING
  RESET #I
  RESET INITIAL END-OF-DATA NEW-SEARCH
  REA. READ REPORTS BY R-REPNAME = #S-REPNAME (#PAGE)
      ENDING AT     #E-REPNAME
    IF #I = #NOFLINES
      PERFORM SCREEN-IO
      IF END-OF-PROCESSING OR NEW-SEARCH
        ESCAPE BOTTOM (REA.)
      END-IF
    END-IF
    ADD 1 TO #I
    PERFORM REPORT-TO-SCREEN
  END-READ
  DECIDE FOR FIRST CONDITION
    WHEN #I > 0
      END-OF-DATA := TRUE
    WHEN *COUNTER (REA.) = 0
      ESCAPE BOTTOM (MAIN.)
    WHEN ANY
      PERFORM SCREEN-IO
    WHEN NONE
      IGNORE
  END-DECIDE
END-REPEAT
*
************************************************************************
* End of main line (now subroutines):
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE SCREEN-IO
************************************************************************
IF #I < #NOFLINES
  CV-MARK (#I+1:#NOFLINES) := (AD=DP)
END-IF
IF NOT G-DISPLAY-LONG-NAMES
  L-REPNAME-R(*) := H'FA'
END-IF
RESET END-OF-DISPLAY
REPEAT
  DECIDE FOR FIRST CONDITION
    WHEN #ERC NE 0
      IGNORE
    WHEN END-OF-DATA AND #PAGE > 1
      #ERC := 12                   /* bottom of data
    WHEN END-OF-DATA AND #PAGE = 1
      #ERC := 14                   /* all
    WHEN NOT END-OF-DATA AND #PAGE = 1
      #ERC := 11                   /* top of data
    WHEN NONE
      #ERC := 13                   /* more
  END-DECIDE
  SET CONTROL 'M17'
  SET CONTROL 'Y41'
  SET CONTROL 'WFC20L41B01/39'
  INPUT WITH TEXT *#ERC USING MAP 'HSELRPM&'
  SET CONTROL 'M11'
  RESET #ERC
  PERFORM COMMAND-PF-KEY
  UNTIL END-OF-DISPLAY
END-REPEAT
RESET #I #SCREEN (*)
*
END-SUBROUTINE /* SCREEN-IO
*
************************************************************************
DEFINE SUBROUTINE REPORT-TO-SCREEN
************************************************************************
L-REPNAME (#I) := REPORTS.R-REPNAME
CV-MARK (#I) := (AD=I)
*
END-SUBROUTINE /* REPORT-TO-SCREEN
*
************************************************************************
DEFINE SUBROUTINE COMMAND-PF-KEY
************************************************************************
FOR #J = 1 TO #I
  IF L-MARK (#J) NE ' '
    IF G-DISPLAY-LONG-NAMES
      #REPNAME := L-REPNAME (#J)
    ELSE
      #REPNAME := L-REPNAME-17 (#J)
    END-IF
    END-OF-PROCESSING := END-OF-DISPLAY := TRUE
    ESCAPE ROUTINE
  END-IF
END-FOR
DECIDE ON FIRST *PF-KEY
  VALUE 'PF3'
    END-OF-PROCESSING := END-OF-DISPLAY := TRUE
  VALUE 'PF7'
    IF #PAGE > 1
      SUBTRACT 1 FROM #PAGE
      END-OF-DATA := FALSE
      END-OF-DISPLAY := NEW-SEARCH := TRUE
    END-IF
  VALUE 'PF8'
    IF NOT END-OF-DATA
      #PAGE := #PAGE + 1
      IF #PAGE > #NOFPAGES
        #PAGE := #NOFPAGES
        #S-REPNAME (1:19) := #S-REPNAME (2:20)
      END-IF
      #S-REPNAME (#PAGE) := REPORTS.R-REPNAME
      END-OF-DISPLAY := TRUE
    END-IF
  NONE           IGNORE
END-DECIDE
*
END-SUBROUTINE /* COMMAND-PF-KEY
*
************************************************************************
DEFINE SUBROUTINE PF-KEYS
************************************************************************
SET KEY PF1 = PGM PF2 = PGM PF3 = PGM PF4 = PGM PF5 = PGM PF6 = PGM
  PF7 = PGM PF8 = PGM PF9 = PGM PF10 = PGM PF11 = PGM PF12 = PGM
*
END-SUBROUTINE /* PF-KEYS
*
END
