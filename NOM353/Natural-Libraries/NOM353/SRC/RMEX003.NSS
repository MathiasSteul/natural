* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RMEX003 - Standard Exit 003 (Filter)
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* mrs 93-06-03 s(999999) created
* mrs 93-10-07 s(999999) invalid #string-line and #pageline if h'89'
* mrs 93-11-09 s(999999) seq. Files MVS added
* mrs 94-03-01 s(999999) seq. Files BS2 added
* mrs 94-05-09 s(999999) h'81' is a valid ff (write and skip) in BS2
* mrs 94-07-05 s(204661) NAT1316 if #ident length > 50
* mrs 95-09-27 s(999999)  update number of lines in source record
*                         if unknown (=0)
* fhi 00-03-03 S(192651) Line length > 253 not stored in DB
* fhi 00-10-04 QA05      Improve error message
* sju 04-12-06 NOM31     Add date and time (tenths of second) to trace
* fhi 05-04-19 NOM31107  Support 7-byte job numbers
* xsetggr 2005-11-28 p(271774) support more than 40 Power segments
* xsetggr 2008-01-15 p(300297) record length N5
* fhi     2008-02-29 P302579   Limit Occurrencies of ##CUR-RECORD
* fhi     2009-07-28 P319282 Binary files on Linux corrupted
* fhi     2009-09-15 P320367 Use compression routine NOMCOMPR
* fhi     2010-06-14 NOMALL-815  User RMSETTIM instead of *TIMD for Ux
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* SPLILDAV 2012-06-27 NOMALL-1078 SUPPORT COMPRESSION 16K BYTE RECORDS
* raya     2012-09-24 NOMALL-1143 work with lob fields
* fhi      2012-11-09 NOMALL-1143 Add cpu time output
* SU1     2014-01-27 NOMALL-1341 remove LA-fields
* SU2     2014-02-06 NOMALL-1345 avoid corrupted report
* SU3     2014-11-17 NOMALL-1450 fill fields for Adabas Vista
* SU4     2016-01-20 NOMALL-1802 do not update Adabas Vista fields
* fhi     2017-01-18 NOMALL-1916 Use binary NPR RECORD* fields
* fhi     2017-01-27 NOMALL-1961 Show node name in errors
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* fhi     2017-07-11 NOMALL-2021 NPR error: use RECORD temporarily ÜÜÜ
* SU5     2018-02-13 NOMALL-1823 NOM 3.5: remove CONNECT
* SU6     2018-78-06 NOMALL-2130 sep.var.:GDA MONIT-GL -> PDA RMEXSEPA
* fhi     2018-12-14 NOM 3.5     Improve CPU measures, no tags
* SU7     2021-10-12 ES-31134    Unix:BS2:use ESA transl/no hex
* SU8     2024-03-07 ES-34613    NOM 3.6 Remove power
* ---------------------------------------------------------------------
DEFINE DATA GLOBAL USING MONIT-GL
PARAMETER USING RMEXSEPA
************************************************************************
INDEPENDENT
1 +NOD-CURRENT-NAME (A16)
1 +CMRDC            (A1)
* -----------------------------LDA's-----------------------------------
LOCAL USING RCCTYP-E
LOCAL USING RMSR---E
LOCAL USING RMSR---L
*
LOCAL
1 READ-SPOOL VIEW OF READ-SPOOL
  2 ERROR-CODE
  2 ERROR-TEXT
  2 RECORD-NUMBER
  2 RECORD-LENGTH
  2 RECORD /*MUST - HEX
  2 RECORD-HEX1
  2 RECORD-HEX2
  2 RECORD-HEX3
1 READ-FILE VIEW OF READ-FILE
  2 ERROR-CODE
  2 ERROR-TEXT
  2 RECORD-NUMBER
  2 RECORD /*not used, but must defined to get HEX fields filled
  2 RECORD-HEX1
  2 RECORD-HEX2
  2 RECORD-HEX3
  2 SEGMENT-LENGTH
  2 SEGMENT-NUMBER
1 READ-FILE-ESA VIEW OF READ-FILE /*SU7
  2 ERROR-CODE
  2 ERROR-TEXT
  2 RECORD-NUMBER
  2 RECORD /*MUST - HEX
  2 SEGMENT-LENGTH
  2 SEGMENT-NUMBER
1 SOURCE-TEXT VIEW OF NRM-SOURCE-TEXT
  2 ST-ID
  2 ST-TEXT                        (1:66)
  2 REDEFINE ST-TEXT
    3 ST-TEXT-LOB                  (A16381)
1 SOURCE VIEW OF NRM-SOURCE
  2 SR-NUMBER-OF-LINES
1 REPORT VIEW OF NRM-REPORTS-NEW
  2 R-E-PARAMS                     (1:2)
  2 REDEFINE R-E-PARAMS
    3 R-STD3-IDENT-LINE            (N3)
    3 R-STD3-IDENT-STRING          (A78)
    3 REDEFINE R-STD3-IDENT-STRING
      4  R-STD3-IDENT-STRNG        (A50)
    3 R-STD3-START-LINE            (N3)
    3 R-STD3-HEADER-LINES          (N2)
    3 R-STD3-TAB (1:5)
      4 R-STD3-VALUE-TYPE          (A1)
      4 R-STD3-VALUE-FROM          (N3)
      4 R-STD3-VALUE-TO            (N3)
      4 R-STD3-REL-CHARACTER       (A2)
      4 R-STD3-VALUE               (A50)
      4 R-STD3-BOOL-CONNECTOR      (A3)
* -----------------------------local variables-------------------------
1 SEPARATION-PARAMETER
  2 R-STD003-ENTRIES               (N2)
  2 R-STD003-IDENT-LINE            (N3)
  2 R-STD003-IDENT-STRING          (A78)
  2 R-STD003-START-LINE            (N3)
  2 R-STD003-HEADER-LINES          (N2)
  2 R-STD003-PARAMETER             (1:5)
    3 R-STD003-VALUE-FROM          (N3)
    3 R-STD003-VALUE-TO            (N3)
    3 R-STD003-VALUE-TYPE          (A1)
    3 R-STD003-REL-CHARACTER       (A2)
    3 R-STD003-VALUE               (A50)
    3 REDEFINE R-STD003-VALUE
      4 R-STD003-NUM               (N27)
    3 R-STD003-BOOL-CONNECTOR      (A3)
*
1 #F                               (P3)
1 #J                               (P3)
1 #T                               (P3)
1 #L                               (P3)
*
1 ADD-LINE                         (L)
*
1 IN-OR                            (L)
1 STRING-FOUND                     (L)
1 #RECORD-LENGTH                   (N5)
1 #RECORD-NUMBER                   (P10)
1 #RECORD                          (A253)
1 REDEFINE #RECORD
  2 #REC-CC                        (A1)
1 REDEFINE #RECORD
  2 #REC                           (A1/1:253)
1 #IDENT-NUM                       (N27)
1 #IDENT                           (A251)
1 REDEFINE #IDENT
  2 #IDENT-B                       (A1/1:251)
1 #LINE-STRING                     (P10)
1 #LINE-PAGE                       (P10)
1 #LINE-START                      (P10)
1 #HEADER-START                    (P10)
1 #HEADER-END                      (P10)
1 #HEADER (1:20)
  2 #HEADER-LINE                   (A251)
  2 #HEADER-LENGTH                 (N5)
1 #H                               (P2)
1 #K                               (P2)
1 I                                (P2)
1 J                                (P2)
1 #WE                              (I2) CONST <5>
1 #WI                              (I2)   /* index for wtab
1 #WJ                              (I2)   /* index for wind
1 #WIN                             (I2)   /* entries in wtab
1 #WTAB (1:#WE)
  2 #WJN                           (I2)   /* entries in wind
  2 #WINTAB (1:#WE)
    3 #WFLAG                       (A3)   /* and, or
    3 #WIND                        (I2)   /* pointer to std003-tab
1 #ST-ID-LINE                      (B10)
1 REDEFINE #ST-ID-LINE
  2 #ST-ID                         (P10)
  2 #ST-LINE                       (B4)
1 #NSMCOMP-CB                      (B40)
1 REDEFINE #NSMCOMP-CB
  2 #NSMCOMP-COMMAND               (A1)
  2 #NSMCOMP-CODE                  (B1)
  2 #NSMCOMP-INLENGTH-OLD          (B1)
  2 #NSMCOMP-OUTLENGTH-OLD         (B1)
  2 #NSMCOMP-INLENGTH              (B2)
  2 #NSMCOMP-OUTLENGTH             (B2)
1 #NSMCOMP-RC                      (B2)
1 #NSMCOMP-WORK                    (B4)
1 #NSMCOMP-LINE                    (A251)
1 #NSMCOMP-BUFFER-LENGTH           (B4)
1 #G-SOURCE-TYPE-BIN               (B2)
1 #CUR-RECORD-MAX                  (P2)
1 RMSETTIM
  2 FUNCTION                 (A1)
  2 ERC                      (N4)
  2 MSG                      (A250)
1 #TRACING                   (L)
1 #USE-ESA                   (L)   /*SU7
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
FORMAT LS=100 PS=60
************************************************************************
DEFINE SUBROUTINE STD-EXIT-003
************************************************************************
INCLUDE RMCURREC
*
IF G-TRACE GE *LEVEL
  #TRACING := TRUE
  G-TRACE-MSG := 'Start'
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
INCLUDE CMRDC
*
RMSETTIM.FUNCTION := 'S'
PERFORM RMSETTIM-SETTIME RMSETTIM
*
RESET G-NATRP-ERC G-NATRP-ERT
*
PERFORM INIT-FUNCTION
*
IF G-NATRP-ERC = 0
  PERFORM FILTER-SYSOUT
  IF G-NATRP-ERC = 0 AND RMEX-SOURCE-REC-COUNT = 0
    PERFORM UPDATE-SOURCE-RECORD
  END-IF
END-IF
*
IF #TRACING
  RMSETTIM.FUNCTION := 'G'
  PERFORM RMSETTIM-SETTIME RMSETTIM
  PERFORM XXRLOG-WRITE-LOG 'T' RMSETTIM.MSG
END-IF
*
************************************************************************
* End of main line (now subroutines):
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE FILTER-SYSOUT
************************************************************************
#SOURCE-ATTRIBUTES := RMEX-SOURCE-ATTRIBUTES
*
P-REPNAME := G-REPORT
PERFORM OPEN-NEW-REPORT #RMEXSEPA
IF G-NATRP-ERC NE 0
  ESCAPE ROUTINE
END-IF
*
#G-SOURCE-TYPE-BIN := RMEX-SOURCE-TYPE
CALLNAT 'RMSR7--N' #SOURCE-ATTRIBUTES #G-SOURCE-TYPE-BIN  /*Jobnr:N5->N7
*
DECIDE ON FIRST VALUE OF RMEX-SOURCE-TYPE
  VALUE JES2, JES3            PERFORM STD-EXIT-003-JES
/*SU8  VALUE POWER                 PERFORM STD-EXIT-003-POWER
/*SU8  VALUE SEQUENTIAL-FILE-VSE   PERFORM STD-EXIT-003-FVSE
  VALUE SEQUENTIAL-FILE-MVS   PERFORM STD-EXIT-003-FMVS
  VALUE SEQUENTIAL-FILE-BS2   PERFORM STD-EXIT-003-FBS2
  VALUE NOM-DATA-BASE         PERFORM STD-EXIT-003-NOMDB
  NONE
    G-NATRP-ERC := 9999
    COMPRESS NUMERIC *PROGRAM 'Invalid Source Type' RMEX-SOURCE-TYPE
      TO G-NATRP-ERT
END-DECIDE
*
IF ##IN-NRM AND ##REC-COUNT > 0
  ##START-LINE := 1
  ##END-LINE   := ##REC-COUNT
  PERFORM STORE-REPORT-CONTENTS
END-IF
PERFORM CLOSE-REPORT RMEX-SPOOL-ATTRIBUTES /*RMCLSREP
*
END-SUBROUTINE /* FILTER-SYSOUT
*
************************************************************************
DEFINE SUBROUTINE INIT-FUNCTION
************************************************************************
FNDRP. FIND REPORT WITH R-REPNAME = G-MASTER-DEFINITION
  IF NO RECORDS FOUND
    G-NATRP-ERC := 0005
    G-NATRP-ERT := 'unable to read master definition'
    ESCAPE ROUTINE
  END-NOREC
  R-STD003-IDENT-LINE := R-STD3-IDENT-LINE
  CALLNAT 'RMEXMSKN' R-STD3-IDENT-STRNG R-STD003-IDENT-STRING
  R-STD003-START-LINE := R-STD3-START-LINE
  IF R-STD3-HEADER-LINES > 20
    R-STD003-HEADER-LINES := 20
  ELSE
    R-STD003-HEADER-LINES := R-STD3-HEADER-LINES
  END-IF
*
  RESET  R-STD3-BOOL-CONNECTOR (1)
*
  FOR I = 1 TO 5
    IF R-STD3-VALUE-FROM (I) = 0 AND R-STD3-VALUE-TO (I) = 0
    AND R-STD3-VALUE-TYPE (I) = ' '                                   /*
      ESCAPE TOP
    END-IF
    ADD 1 TO J
    R-STD003-ENTRIES := J
    R-STD003-VALUE-FROM            (J) := R-STD3-VALUE-FROM    (I)
    R-STD003-VALUE-TO              (J) := R-STD3-VALUE-TO      (I)
    R-STD003-VALUE-TYPE            (J) := R-STD3-VALUE-TYPE    (I)
    R-STD003-REL-CHARACTER         (J) := R-STD3-REL-CHARACTER (I)
    IF R-STD003-VALUE-TYPE (J) = 'N'
      R-STD003-NUM (J) := VAL(R-STD3-VALUE (I))
    ELSE
      R-STD003-VALUE (J) := R-STD3-VALUE (I)
    END-IF
    R-STD003-BOOL-CONNECTOR (J) := R-STD3-BOOL-CONNECTOR (I)
*
    DECIDE FOR FIRST CONDITION
      WHEN J = 1
        ADD 1 TO #WIN
      WHEN R-STD003-BOOL-CONNECTOR (J) = 'OR'
        IF R-STD003-VALUE-FROM (J) > 0 OR R-STD003-VALUE-TO (J) > 0
          ADD 1 TO #WIN
        ELSE
          IN-OR := TRUE
        END-IF
      WHEN IN-OR
        IN-OR := FALSE
        ADD 1 TO #WIN
      WHEN NONE
        IGNORE
    END-DECIDE
*
    ADD 1 TO #WJN (#WIN)
    #WJ := #WJN (#WIN)
    #WFLAG (#WIN, #WJ) := R-STD003-BOOL-CONNECTOR (J)
    #WIND  (#WIN, #WJ) := J
    IF J > 1 AND R-STD003-BOOL-CONNECTOR (J) = 'OR'
    AND R-STD003-VALUE-FROM (J) = 0 AND R-STD003-VALUE-TO (J) = 0     /*
      R-STD003-VALUE-FROM (J) := R-STD003-VALUE-FROM (J - 1)
      R-STD003-VALUE-TO   (J) := R-STD003-VALUE-TO  (J - 1)
    END-IF
*
  END-FOR
END-FIND
*
IF J = 0
  G-NATRP-ERC := 0005
  G-NATRP-ERT := 'invalid std3 parameter'
END-IF
*
END-SUBROUTINE /* INIT-FUNCTION
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-003-JES
************************************************************************
FNDJES. FIND READ-SPOOL WITH NODE = #JES-NODE
AND JOB-NAME = #JES-JOB-NAME AND JOB-NUMBER = #JES-JOB-NUMBER         /*
AND TYPE = #JES-TYPE AND DATA-SET-KEY    = #JES-DATA-SET-KEY          /*
  PERFORM HANDLE-IT_READ-SPOOL
END-FIND
*
END-SUBROUTINE /* STD-EXIT-003-JES
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-003-FMVS
************************************************************************
FNDFMVS. FIND READ-FILE WITH NODE = #FMVS-NODE AND DSNAME = #FMVS-DSNAME
AND LRECL   = #FMVS-LRECL AND RECFM   = #FMVS-RECFM                   /*
AND BLKSIZE = #FMVS-BLKSIZE AND SEGMENT-LENGTH = 251                  /*
  PERFORM HANDLE-IT_READ-FILE
END-FIND
*
END-SUBROUTINE /* STD-EXIT-003-FMVS
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-003-FBS2
************************************************************************
IF *MACHINE-CLASS NE 'MAINFRAME' /*SU7
  IF F#ESA (<#FBS2-NODE>) /*must be separate IF ÜÜ
   CALLNAT 'NOMESA' #FBS2-NODE(AD=O) +NOD-CURRENT-NAME(AD=O) 1X #USE-ESA
  END-IF
END-IF
IF #USE-ESA /*SU7
  #ESA. FIND READ-FILE-ESA WITH NODE =#FBS2-NODE AND DSNAME=#FBS2-DSNAME
  AND SEGMENT-LENGTH = 251                                            /*
    MOVE BY NAME READ-FILE-ESA TO READ-FILE
    PERFORM HANDLE-IT_READ-FILE
  END-FIND
ELSE /*NPR
  FNDFBS2. FIND READ-FILE WITH NODE = #FBS2-NODE AND DSNAME=#FBS2-DSNAME
  AND SEGMENT-LENGTH = 251                                            /*
    PERFORM HANDLE-IT_READ-FILE
  END-FIND
END-IF
*
END-SUBROUTINE /* STD-EXIT-003-FBS2
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-003-NOMDB
************************************************************************
#NSMCOMP-BUFFER-LENGTH := 16381 - 7
#NSMCOMP-CODE    := 'N'  /* 'N' - NEW PARM LIST
#NSMCOMP-COMMAND := 'D'
*
#ST-ID := #NOMDB-ID
RESET #ST-LINE #RECORD-NUMBER
*
FNDNOMDB. READ SOURCE-TEXT BY ST-ID-LINE STARTING FROM #ST-ID-LINE
  IF ST-ID NE #ST-ID
    ESCAPE BOTTOM (FNDNOMDB.)
  END-IF
  RESET #NSMCOMP-WORK
  REP. REPEAT
    RESET #NSMCOMP-LINE
    INCLUDE C-NSMCMP 'SOURCE-TEXT.ST-TEXT-LOB'
    DECIDE ON FIRST #NSMCOMP-RC
      VALUE 0
        IGNORE
      VALUE 4
        ESCAPE BOTTOM (REP.)
      NONE
        G-NATRP-ERC := 0005
        COMPRESS 'Error decompressing data RC=' #NSMCOMP-RC
          TO G-NATRP-ERT LEAVING NO
        ESCAPE BOTTOM (FNDNOMDB.)
    END-DECIDE
    ADD 1 TO #RECORD-NUMBER
    #RECORD        := #NSMCOMP-LINE
    #RECORD-LENGTH := #NSMCOMP-OUTLENGTH
    IF #RECORD-LENGTH = 0       /* still using old nsmcmp ?
      #RECORD-LENGTH := #NSMCOMP-OUTLENGTH-OLD
    END-IF
    PERFORM STD-EXIT-003-COMMON
    IF G-NATRP-ERC NE 0
      ESCAPE BOTTOM (FNDNOMDB.)
    END-IF
  END-REPEAT
END-READ
*
END-SUBROUTINE /* STD-EXIT-003-NOMDB
*
************************************************************************
DEFINE SUBROUTINE HANDLE-IT_READ-SPOOL
************************************************************************
IF READ-SPOOL.ERROR-CODE NE 0
  G-NATRP-ERC := 0005
  COMPRESS READ-SPOOL.ERROR-TEXT '/' +NOD-CURRENT-NAME '/' *PROGRAM
    '/' *LINE TO G-NATRP-ERT
  ESCAPE BOTTOM
END-IF
#RECORD-LENGTH := READ-SPOOL.RECORD-LENGTH
/*SU8 IF RMEX-SOURCE-TYPE = POWER ADD 1 TO #RECORD-NUMBER ELSE
#RECORD-NUMBER := READ-SPOOL.RECORD-NUMBER
/*SU8 END-IF
IF #USE-ESA /*SU7
  #RECORD := READ-FILE.RECORD
ELSE
  #RECORD := F#CONVERT-RECORD-HEX (<READ-SPOOL.RECORD-HEX1,
    READ-SPOOL.RECORD-HEX2,READ-SPOOL.RECORD-HEX3,
    #TRACING,RMEX-SOURCE-CODEPAGE>)
END-IF
PERFORM STD-EXIT-003-COMMON
IF G-NATRP-ERC NE 0
  ESCAPE BOTTOM
END-IF
*
END-SUBROUTINE /* HANDLE-IT_READ-SPOOL
*
************************************************************************
DEFINE SUBROUTINE HANDLE-IT_READ-FILE
************************************************************************
IF READ-FILE.ERROR-CODE NE 0
  G-NATRP-ERC := 0005
  COMPRESS READ-FILE.ERROR-TEXT '/' +NOD-CURRENT-NAME '/' *PROGRAM
    '/' *LINE TO G-NATRP-ERT
  ESCAPE BOTTOM
END-IF
#RECORD-LENGTH := READ-FILE.SEGMENT-LENGTH
#RECORD-NUMBER := READ-FILE.RECORD-NUMBER
#RECORD := F#CONVERT-RECORD-HEX
  (<READ-FILE.RECORD-HEX1,READ-FILE.RECORD-HEX2,READ-FILE.RECORD-HEX3,
  #TRACING,RMEX-SOURCE-CODEPAGE>)
IF READ-FILE.SEGMENT-NUMBER > 1 AND READ-FILE.SEGMENT-LENGTH < 251
  COMPRESS '§' #RECORD TO #RECORD LEAVING NO /*1.byte is cc-character
  EXAMINE SUBSTR (#RECORD,1,1) FOR '§' REPLACE WITH ' '
END-IF
PERFORM STD-EXIT-003-COMMON
IF G-NATRP-ERC NE 0
  ESCAPE BOTTOM
END-IF
*
END-SUBROUTINE /* HANDLE-IT_READ-FILE
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-003-COMMON
************************************************************************
IF (#REC-CC = H'89' AND RMEX-SOURCE-CC-TYPE = MACHINE-CODE)
OR (#REC-CC = H'8B' AND RMEX-SOURCE-CC-TYPE = MACHINE-CODE)           /*
OR (#REC-CC = '1'   AND RMEX-SOURCE-CC-TYPE = ASA-CODE)               /*
OR (#REC-CC = H'81' AND RMEX-SOURCE-CC-TYPE = BS2000-CC)              /*
OR (#REC-CC = 'A'   AND RMEX-SOURCE-CC-TYPE = BS2000-CC)              /*
  PERFORM TOP-OF-PAGE-HANDLING
END-IF
*
IF #RECORD-NUMBER = #HEADER-START THRU #HEADER-END
  ADD 1 TO #H
  #HEADER-LINE   (#H) := #RECORD
  #HEADER-LENGTH (#H) := #RECORD-LENGTH
END-IF
*
IF #RECORD-NUMBER = #LINE-STRING
  PERFORM SEARCH-STRING
END-IF
*
IF STRING-FOUND AND #RECORD-NUMBER >= #LINE-START
  PERFORM CHECK-LINE
END-IF
*
END-SUBROUTINE /* STD-EXIT-003-COMMON
*
************************************************************************
DEFINE SUBROUTINE CHECK-LINE
************************************************************************
RESET ADD-LINE
FOR #WI = 1 TO #WIN
  IF (ADD-LINE AND #WFLAG (#WI, 1) = 'OR')
  OR (NOT ADD-LINE AND #WFLAG (#WI, 1) = 'AND')                       /*
    ESCAPE TOP
  END-IF
  FOR #WJ = 1 TO #WJN (#WI)
    RESET ADD-LINE
    #J := #WIND (#WI, #WJ)
    #F := R-STD003-VALUE-FROM (#J)
    #T := R-STD003-VALUE-TO (#J)
    #L := R-STD003-VALUE-TO (#J) - R-STD003-VALUE-FROM (#J) + 1
    #IDENT-B (1:#L) := #REC (#F:#T)
    DECIDE ON FIRST R-STD003-VALUE-TYPE (#J)
      VALUE 'N' PERFORM NUMERIC-CHECK
      VALUE 'M' PERFORM MASK-CHECK
      NONE      PERFORM ALPHA-CHECK
    END-DECIDE
    RESET #IDENT-B (1:#L)
    IF (ADD-LINE AND (#WJ = #WJN (#WI) OR #WFLAG (#WI, #WJ + 1) = 'OR'))
    OR (NOT ADD-LINE AND (#WJ=#WJN(#WI) OR #WFLAG (#WI,#WJ + 1) ='AND'))
      ESCAPE BOTTOM
    END-IF
  END-FOR
END-FOR
*
IF ADD-LINE
  PERFORM ADD-CURRENT-LINE
END-IF
*
END-SUBROUTINE /* CHECK-LINE
*
************************************************************************
DEFINE SUBROUTINE MASK-CHECK
************************************************************************
IF #IDENT = MASK R-STD003-VALUE (#J)
  ADD-LINE := TRUE
END-IF
*
END-SUBROUTINE /* MASK-CHECK
*
************************************************************************
DEFINE SUBROUTINE NUMERIC-CHECK
************************************************************************
MOVE LEFT #IDENT TO #IDENT
IF NOT(#IDENT IS (N27))
  ESCAPE ROUTINE
END-IF
*
#IDENT-NUM := VAL(#IDENT)
*
DECIDE ON FIRST R-STD003-REL-CHARACTER (#J)
  VALUE 'EQ', '='
    IF #IDENT-NUM EQ R-STD003-NUM (#J)
      ADD-LINE := TRUE
    END-IF
  VALUE 'NE', '!='
    IF #IDENT-NUM NE R-STD003-NUM (#J)
      ADD-LINE := TRUE
    END-IF
  VALUE 'LT', '<'
    IF #IDENT-NUM LT R-STD003-NUM (#J)
      ADD-LINE := TRUE
    END-IF
  VALUE 'LE', '<='
    IF #IDENT-NUM LE R-STD003-NUM (#J)
      ADD-LINE := TRUE
    END-IF
  VALUE 'GT', '>'
    IF #IDENT-NUM GT R-STD003-NUM (#J)
      ADD-LINE := TRUE
    END-IF
  VALUE 'GE', '>='
    IF #IDENT-NUM GE R-STD003-NUM (#J)
      ADD-LINE := TRUE
    END-IF
  NONE
    IF #IDENT-NUM EQ R-STD003-NUM (#J)
      ADD-LINE := TRUE
    END-IF
END-DECIDE
*
END-SUBROUTINE /* NUMERIC-CHECK
*
************************************************************************
DEFINE SUBROUTINE ALPHA-CHECK
************************************************************************
DECIDE ON FIRST R-STD003-REL-CHARACTER (#J)
  VALUE 'EQ', '='
    IF #IDENT EQ R-STD003-VALUE (#J)
      ADD-LINE := TRUE
    END-IF
  VALUE 'NE', '!='
    IF #IDENT NE R-STD003-VALUE (#J)
      ADD-LINE := TRUE
    END-IF
  VALUE 'LT', '<'
    IF #IDENT LT R-STD003-VALUE (#J)
      ADD-LINE := TRUE
    END-IF
  VALUE 'LE', '<='
    IF #IDENT LE R-STD003-VALUE (#J)
      ADD-LINE := TRUE
    END-IF
  VALUE 'GT', '>'
    IF #IDENT GT R-STD003-VALUE (#J)
      ADD-LINE := TRUE
    END-IF
  VALUE 'GE', '>='
    IF #IDENT GE R-STD003-VALUE (#J)
      ADD-LINE := TRUE
    END-IF
  NONE  IF #IDENT EQ R-STD003-VALUE (#J)
      ADD-LINE := TRUE
    END-IF
END-DECIDE
*
END-SUBROUTINE /* ALPHA-CHECK
*
************************************************************************
DEFINE SUBROUTINE TOP-OF-PAGE-HANDLING
************************************************************************
IF (#REC-CC = H'89' AND RMEX-SOURCE-CC-TYPE = MACHINE-CODE)
OR (#REC-CC = H'81' AND RMEX-SOURCE-CC-TYPE = BS2000-CC)              /*
  #LINE-PAGE := #RECORD-NUMBER + 1
ELSE
  #LINE-PAGE := #RECORD-NUMBER
END-IF
*
IF R-STD003-IDENT-LINE > 0
  #LINE-STRING := #LINE-PAGE + R-STD003-IDENT-LINE - 1
ELSE
  RESET #LINE-STRING
END-IF
*
IF R-STD003-START-LINE > 0
  #LINE-START := #LINE-PAGE + R-STD003-START-LINE - 1
ELSE
  #LINE-START := #LINE-PAGE
END-IF
*
IF #LINE-STRING > 0 AND #LINE-START < #LINE-STRING
  #LINE-START := #LINE-STRING
END-IF
*
RESET #HEADER-START #HEADER-END #H
IF R-STD003-HEADER-LINES > 0
  #HEADER-START := #LINE-PAGE
  #HEADER-END   := #LINE-PAGE + R-STD003-HEADER-LINES - 1
END-IF
*
IF R-STD003-IDENT-STRING = ' ' AND R-STD003-IDENT-LINE = 0
  STRING-FOUND := TRUE
ELSE
  RESET STRING-FOUND
END-IF
*
END-SUBROUTINE /* TOP-OF-PAGE-HANDLING
*
************************************************************************
DEFINE SUBROUTINE SEARCH-STRING
************************************************************************
IF #RECORD = MASK R-STD003-IDENT-STRING
  STRING-FOUND := TRUE
END-IF
*
END-SUBROUTINE /* SEARCH-STRING
*
************************************************************************
DEFINE SUBROUTINE ADD-CURRENT-LINE
************************************************************************
##REPORT-IS-OPENED := TRUE
*
IF #HEADER-START > 0 AND #HEADER-END > 0
  IF ##IN-NRM
    FOR #K = 1 TO #H
      ADD 1 TO ##CUR-RECORD
      ADD 1 TO ##REC-COUNT
      #TEXT-ARRAY (##CUR-RECORD) := #HEADER-LINE (#K)
      ##RECLEN-VEC (##CUR-RECORD) := #HEADER-LENGTH (#K)
      IF ##CUR-RECORD = #CUR-RECORD-MAX
        PERFORM PROCESS-BUFFER
        RESET ##CUR-RECORD #TEXT-ARRAY(1:20) ##RECLEN-VEC(*)
      END-IF
    END-FOR
  ELSE
    ##START-LINE := #HEADER-START
    ##END-LINE   := #HEADER-END
    ##REC-COUNT  := ##REC-COUNT + #HEADER-END - #HEADER-START + 1
    PERFORM STORE-REPORT-CONTENTS
  END-IF
  RESET #HEADER-START #HEADER-END
END-IF
*
ADD 1 TO ##REC-COUNT
##START-LINE := ##END-LINE := #RECORD-NUMBER
*
IF ##IN-NRM
  ADD 1 TO ##CUR-RECORD
  #TEXT-ARRAY(##CUR-RECORD) := #RECORD
  ##RECLEN-VEC(##CUR-RECORD) := #RECORD-LENGTH
  IF ##CUR-RECORD = #CUR-RECORD-MAX
    PERFORM PROCESS-BUFFER
    RESET ##CUR-RECORD #TEXT-ARRAY(1:20) ##RECLEN-VEC(*)
  END-IF
ELSE
  PERFORM STORE-REPORT-CONTENTS
END-IF
*
END-SUBROUTINE /* ADD-CURRENT-LINE
*
************************************************************************
DEFINE SUBROUTINE UPDATE-SOURCE-RECORD
************************************************************************
IF #TRACING
  COMPRESS 'update source record, new line count' #RECORD-NUMBER
    TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
*
GETSR. GET SOURCE RMEX-SOURCE-ISN
SR-NUMBER-OF-LINES (GETSR.) := #RECORD-NUMBER
RMEX-SOURCE-REC-COUNT := #RECORD-NUMBER
UPDATE (GETSR.)
END TRANSACTION
*
END-SUBROUTINE /* UPDATE-SOURCE-RECORD
*
END-SUBROUTINE /* STD-EXIT-003
*
END
