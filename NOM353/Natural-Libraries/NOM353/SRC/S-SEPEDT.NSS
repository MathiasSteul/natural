* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* S-SEPEDT (subroutine to be able to use GDA for S-COMMIT)
* - Handle edit of Separator/Exit Member
*
* Maintenance:
* uuu     yyyy-mm-dd itrac      ....
* SU      2016-10-12 NOM3.5     created (was internal subr. EDIT-MEMBER)
* SU1     2019-02-12 EVI Test   RDEFRP--
* SU2     2019-08-26 NOMALL-2314 called from RDEFEM too
* BLI     2020-04-08 NOMALL-2391 Force Nat9 editor usage with SEPEDT9
* SU3     2024-04-29 NOM 36      remove unused
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
* *****
PARAMETER /* G-NATRP-ERC + G-NATRP-ERT from GDA
1 #CALLING-PGM      (A8)   /*in: RDEFBU/RDEFRP/RDFLRP/RDEFPH/RDEFPO/
  /*                       /*    RDEFPR/RDEFRV/RDEFUDA/RDEFEM
1 #CURS-FIELD       (I4)   /*in
1 #POS-START        (I4)   /*in/out
1 #MEM-START        (A8)   /*in/out
1 #POS-END          (I4)   /*in
1 #MEM-END          (A8)   /*in/out
1 #POS-EXIT-MEM     (I4)   OPTIONAL /*in
1 #POS-EXIT-LIB     (I4)   OPTIONAL /*in
1 #EXIT-MEM         (A8)   OPTIONAL /*in
1 #EXIT-LIB         (A8)   OPTIONAL /*in
1 #USERARC-NAMES    (A8/1:9) OPTIONAL /*in (only RDEFUDA)
1 #FUNC             (A1)   /*in: function:Display/Modify/Add
1 #ID               (A50) BY VALUE OPTIONAL /*report/bundle ID
1 #PANEL            (I2) OPTIONAL
************************************************************************
INDEPENDENT
1 +G-RLISRP-SEL-REPNAME     (A25)
1 +G-RLISRP-SEL-REPORT-TYPE (A1)
* *****
LOCAL
1 #EXIT             (L)
1 #EDIT-MEMBER      (A8)
1 #EDIT-LIB         (A8)
1 #MEMBER-TYPE      (A8) /*only PRTEXIT used in N-LISMEM
/*SU3 1 #MEM (A8) 1 #PRE (A1) 1 #I (I2)
1 #NEW-MEMBER       (L)
1 SPF-ACTIVE        (L)
1 #NSPFCOM          (A50)
1 #COMMAND          (A50)
1 #STACK-IT         (L) INIT <TRUE>
1 #LIBRARY-ID       (A8)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE S-SEPEDT
************************************************************************
RESET G-NATRP-ERC G-NATRP-ERT
DECIDE FOR FIRST CONDITION
* ***** Just edit skelleton/exit member (no position check):
  WHEN #CALLING-PGM ='RDEFPH' OR='RDEFPO' OR='RDEFPR' OR='RDEFUDA'
  OR='RDEFAV' OR='RDEFRV' OR='RDEFRP--' OR='RDEFEM' /*see RDEFRP SU1 SU2
    #EDIT-MEMBER := #EXIT-MEM
    IF #EXIT-LIB SPECIFIED
      #EDIT-LIB  := #EXIT-LIB
    END-IF
* *****
  WHEN #CURS-FIELD = #POS-START
    #EDIT-MEMBER := #MEM-START
    IF #EDIT-MEMBER = ' ' AND #FUNC NE 'D'
      IF #CALLING-PGM = 'RDEFBU'
        COMPRESS 'BSNOMS-' *LANGUAGE TO #MEM-START LEAVING NO
      ELSE
        COMPRESS 'RSNOMS-' *LANGUAGE TO #MEM-START LEAVING NO
      END-IF
      G-NATRP-ERC := 4028 /*Std separator page will be edited with :1:
    END-IF
    IF (#EDIT-MEMBER = 'NONE' OR = 'KEIN' OR=' ') AND G-NATRP-ERC=0
      G-NATRP-ERC := 4024 /*No separator page defined.
    END-IF
* *****
  WHEN #CURS-FIELD = #POS-END
    #POS-START := #POS-END /*for INPUT MARK
    #EDIT-MEMBER := #MEM-END
    IF #EDIT-MEMBER = ' ' AND #FUNC NE 'D'
      IF #CALLING-PGM = 'RDEFBU'
        COMPRESS 'BSNOME-' *LANGUAGE TO #MEM-END LEAVING NO
      ELSE
        COMPRESS 'RSNOME-' *LANGUAGE TO #MEM-END LEAVING NO
      END-IF
      G-NATRP-ERC := 4028
    END-IF
    IF (#EDIT-MEMBER = 'NONE' OR = 'KEIN' OR=' ') AND G-NATRP-ERC=0
      G-NATRP-ERC := 4024
    END-IF
* ***** RDEFBU
  WHEN #POS-EXIT-MEM SPECIFIED AND #EXIT-MEM NE ' ' AND #EXIT-LIB NE ' '
      AND #CURS-FIELD = #POS-EXIT-MEM OR=#POS-EXIT-LIB
    #POS-START := #POS-EXIT-MEM /*for INPUT MARK
    #EDIT-MEMBER:= #EXIT-MEM
    #EDIT-LIB   := #EXIT-LIB
    IF #CALLING-PGM = 'RDEFRP'
      #MEMBER-TYPE := 'PRTEXIT'
    ELSE
      #EXIT := TRUE
    END-IF
* *****
  WHEN ANY
    IF G-NATRP-ERC = 4028 OR=4024 /*SU1
      G-MAP-MODIFIED := TRUE
      IF #CALLING-PGM ='RDFLRP' OR='RDEFAV' OR='RDEFRV'
        G-NATRP-ERT := '''PF11'''
      ELSE
        G-NATRP-ERT := '''PF10'''
      END-IF
    END-IF
    IF (#EDIT-MEMBER = 'NONE' OR = 'KEIN' OR=' ') /*SU1
      ESCAPE ROUTINE
    END-IF
    IF #EDIT-LIB = ' '
      CALLNAT 'RGETLIB' #EDIT-LIB
      COMPRESS #EDIT-LIB 'U' TO #EDIT-LIB LEAVING NO
    END-IF
    PERFORM CHECK-FOR-SPF
    PERFORM CHECK-MEMBER
    IF #NEW-MEMBER AND NOT SPF-ACTIVE
/* #POS-START for INPUT MARK already set
      IF #EXIT
        G-NATRP-ERC := 1079 /*Library or member not found :1:.
        COMPRESS #EDIT-MEMBER '(' #EDIT-LIB ')'
          TO G-NATRP-ERT LEAVING NO
      ELSE
        G-NATRP-ERC := 2103 /*Separator member not found
      END-IF
    ELSE
      PERFORM EDIT-MEMBER
    END-IF
  WHEN NONE
    G-NATRP-ERC := 1200 /* 1205/4024 ???
END-DECIDE
*
************************************************************************
* End of main line (now subroutines):
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE CHECK-FOR-SPF
************************************************************************
RESET G-NATRP-ERC G-NATRP-ERT SPF-ACTIVE
CALLNAT 'N-SPFACT' G-USERID (AD=O) SPF-ACTIVE G-NATRP-ERC G-NATRP-ERT
/* Handle G-NATRP-ERC G-NATRP-ERT ??
*
END-SUBROUTINE /* CHECK-FOR-SPF
*
************************************************************************
DEFINE SUBROUTINE CHECK-MEMBER
************************************************************************
RESET G-NATRP-ERC G-NATRP-ERT #NEW-MEMBER
CALLNAT 'N-LISMEM' #EDIT-LIB #EDIT-MEMBER #MEMBER-TYPE
  G-NATRP-ERC G-NATRP-ERT
IF G-NATRP-ERC = 1052
  RESET G-NATRP-ERC G-NATRP-ERT
  #NEW-MEMBER := TRUE
END-IF
*
END-SUBROUTINE /* CHECK-MEMBER
*
************************************************************************
DEFINE SUBROUTINE EDIT-MEMBER
************************************************************************
PERFORM COMMIT-WORK /*S-COMMIT
*
IF SPF-ACTIVE
  COMPRESS #EDIT-LIB '(' #EDIT-MEMBER ')' TO #NSPFCOM LEAVING NO
  IF #FUNC = 'D'
    COMPRESS 'B N' #NSPFCOM TO #NSPFCOM /*Browse Natural
  ELSE
    COMPRESS 'E N' #NSPFCOM TO #NSPFCOM /*Edit Natural
  END-IF
ELSE
  IF #FUNC = 'D'
    COMPRESS 'L' #EDIT-MEMBER TO #NSPFCOM /*List
  ELSE
    COMPRESS 'E' #EDIT-MEMBER TO #NSPFCOM /*Edit
  END-IF
/*SET CONTROL 'MT' RDEFAV/RDEFRV ??
END-IF
*
IF #FUNC NE 'D' AND #CALLING-PGM ='RDFLRP' OR='RDEFAV' OR='RDEFRV'
  G-C-FUNC := 'X'
END-IF
DECIDE ON FIRST VALUE OF #CALLING-PGM
  VALUE 'RDFLRP'   PERFORM #RDFLRP
  VALUE 'RDEFRP'   PERFORM #RDEFRP
  VALUE 'RDEFBU'   PERFORM #RDEFBU
  VALUE 'RDEFPH'   PERFORM #RDEFPH
  VALUE 'RDEFPO'   PERFORM #RDEFPO
  VALUE 'RDEFPR'   PERFORM #RDEFPR
  VALUE 'RDEFUDA'  PERFORM #RDEFUDA
  VALUE 'RDEFAV '  PERFORM #RDEFAV
  VALUE 'RDEFRV '  PERFORM #RDEFRV
  VALUE 'RDEFRP--' PERFORM #RDEFRP /*see RDEFR SU1
  VALUE 'RDEFEM'   PERFORM #RDEFEM /*SU2
  ANY
    IF #STACK-IT
      PERFORM #STACK-IT
    END-IF
    STOP /*<<<<<<<<<<
  NONE IGNORE
END-DECIDE
*
END-SUBROUTINE /* EDIT-MEMBER
*
************************************************************************
DEFINE SUBROUTINE #RDEFRP
************************************************************************
*** When a 'LOGON library' is issued, Natural clears AIV variables.
*** We put them in the stack and restore them.
*** To solve our problem, we restore 2 variables - report name,type
*** These commands will be executed when the SPF session ends.
*   STACK  COMMAND 'LOGON' *LIBRARY-ID
*   STACK  COMMAND 'NRMRSAIV'   /*  Reads variables from stack
*   STACK  DATA  +G-RLISRP-SEL-REPNAME
*   STACK  DATA  +G-RLISRP-SEL-REPORT-TYPE
* use NRMGETAI & NRMGETGL as NRMPUTAI & NRMPUTGL is used for mainframes
* for unix systems leave using NRMRSAIV
*
IF *MACHINE-CLASS = 'MAINFRAME'
  STACK TOP DATA FORMATTED #FUNC #ID #PANEL
  STACK TOP COMMAND 'RDEFRP'
ELSE
  RESET #STACK-IT
  STACK COMMAND 'NRMRSAIV'   /*  Reads variables from stack
  STACK DATA  +G-RLISRP-SEL-REPNAME
  STACK DATA  +G-RLISRP-SEL-REPORT-TYPE
  CALLNAT 'RGETLIB' #LIBRARY-ID
  STACK COMMAND 'LOGON' #LIBRARY-ID
  IF #FUNC = 'D'
    COMPRESS 'MENU DISPLAY REPORT' #ID TO #COMMAND
  ELSE
    COMPRESS 'MENU MODIFY REPORT' #ID TO #COMMAND
  END-IF
  STACK COMMAND #COMMAND
  CALLNAT 'RGETLIB' #LIBRARY-ID
  COMPRESS 'LOGON' #LIBRARY-ID TO #COMMAND
  STACK TOP COMMAND #COMMAND
*
  STACK TOP COMMAND #NSPFCOM
  STACK TOP COMMAND 'SEPEDT9'   /* Forces NAT9 CUI editor NOMALL-2391
  STACK TOP COMMAND 'LOGON' #EDIT-LIB
*
END-IF
*
END-SUBROUTINE /* #RDEFRP
*
************************************************************************
DEFINE SUBROUTINE #RDEFBU
************************************************************************
IF *MACHINE-CLASS = 'MAINFRAME'
  STACK TOP DATA FORMATTED #FUNC #ID #PANEL
  STACK TOP COMMAND 'RDEFBU'
ELSE
  IF #FUNC = 'D'
    COMPRESS 'MENU DISPLAY BUNDLE' #ID TO #COMMAND
  ELSE
    COMPRESS 'MENU MODIFY BUNDLE' #ID TO #COMMAND
  END-IF
  STACK TOP COMMAND #COMMAND
END-IF
*
END-SUBROUTINE /* #RDEFBU
*
************************************************************************
DEFINE SUBROUTINE #RDFLRP
************************************************************************
IF *MACHINE-CLASS = 'MAINFRAME'
  STACK TOP COMMAND 'RDFLRP'
ELSE
  STACK TOP COMMAND 'MENU DEFAULTS'
END-IF
*
END-SUBROUTINE /* #RDFLRP
*
************************************************************************
DEFINE SUBROUTINE #RDEFRV
************************************************************************
IF *MACHINE-CLASS = 'MAINFRAME'
  STACK TOP COMMAND 'RDEFRV'
ELSE
  STACK TOP COMMAND 'MENU DEFAULTS'
END-IF
*
END-SUBROUTINE /* #RDEFRV
*
************************************************************************
DEFINE SUBROUTINE #RDEFPH
************************************************************************
STACK TOP DATA FORMATTED #FUNC #ID #PANEL
STACK TOP COMMAND 'RDEFPH'
*
END-SUBROUTINE /* #RDEFPH
*
************************************************************************
DEFINE SUBROUTINE #RDEFPO
************************************************************************
STACK TOP DATA FORMATTED #FUNC #ID #PANEL
STACK TOP COMMAND 'RDEFPO'
*
END-SUBROUTINE /* #RDEFPO
*
************************************************************************
DEFINE SUBROUTINE #RDEFPR
************************************************************************
IF *MACHINE-CLASS = 'MAINFRAME'
  STACK TOP DATA FORMATTED #FUNC #ID #PANEL
  STACK TOP COMMAND 'RDEFPR'
ELSE
  IF #FUNC = 'D'
    COMPRESS 'MENU DISPLAY PRINTERS' #ID TO #COMMAND
  ELSE
    COMPRESS 'MENU MODIFY PRINTERS' #ID TO #COMMAND
  END-IF
  STACK TOP COMMAND #COMMAND
END-IF
*
END-SUBROUTINE /* #RDEFPR
*
************************************************************************
DEFINE SUBROUTINE #RDEFUDA
************************************************************************
IF *MACHINE-CLASS = 'MAINFRAME'
  STACK TOP DATA FORMATTED #ID #USERARC-NAMES(1:9) #FUNC #PANEL
  STACK TOP COMMAND 'RDEFUDA'
ELSE
  STACK TOP COMMAND 'MENU DEFAULTS'
END-IF
*
END-SUBROUTINE /* #RDEFUDA
*
************************************************************************
DEFINE SUBROUTINE #RDEFAV
************************************************************************
IF *MACHINE-CLASS = 'MAINFRAME'
  STACK TOP COMMAND 'RDEFAV'
ELSE
  STACK TOP COMMAND 'MENU DEFAULTS'
END-IF
*
END-SUBROUTINE /* #RDEFAV
*
************************************************************************
DEFINE SUBROUTINE #RDEFEM /*SU2
************************************************************************
IF *MACHINE-CLASS = 'MAINFRAME'
  STACK TOP DATA FORMATTED #FUNC #ID
  STACK TOP COMMAND 'RDEFEM'
ELSE
  STACK TOP COMMAND 'MENU DEFAULTS'
END-IF
*
END-SUBROUTINE /* #RDEFEM
*
************************************************************************
DEFINE SUBROUTINE #STACK-IT
************************************************************************
FETCH RETURN 'NRMPUTAI'
STACK TOP COMMAND 'NRMGETAI'
STACK TOP COMMAND 'NRMGETGL'
CALLNAT 'RGETLIB' #LIBRARY-ID
STACK TOP COMMAND 'LOGON' #LIBRARY-ID
*
IF NOT SPF-ACTIVE
  STACK TOP COMMAND #NSPFCOM
  STACK TOP COMMAND 'SEPEDT9'   /* Forces NAT9 CUI editor NOMALL-2391
  STACK TOP COMMAND 'LOGON' #EDIT-LIB
ELSE
  SET CONTROL 'K0'
  STACK TOP DATA #NSPFCOM
  STACK TOP COMMAND 'SPF'
END-IF
*
STACK TOP COMMAND 'NRMPUTGL'
*
END-SUBROUTINE /* #STACK-IT
************************************************************************
END-SUBROUTINE /* S-SEPEDT
*
END
