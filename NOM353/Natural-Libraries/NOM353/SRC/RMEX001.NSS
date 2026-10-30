* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RMEX001 - Standard Exit 001
*
* Maintenance
* uuu yy-mm-dd s(999999)  ...
* mrs 93-01-26 s(999999)  created
* mrs 93-10-07 s(999999)  invalid #string-line and #pageline if h'89'
* mrs 93-10-28 s(999999)  correct length of prefixes
* mrs 93-11-09 s(999999)  seq. Files MVS added
* mrs 94-03-01 s(999999)  seq. Files BS2 added
* mrs 94-05-09 s(999999)  h'81' is a valid ff (write and skip) in BS2
* mrs 95-09-27 s(999999)  update number of lines in source record
*                         if unknown (=0)
* gw 95-01-08 s(238783)   3148 in line 2570 program rmex001
* mrs 95-01-19 s(238783)  modification 95-01-08 removed
* jvd 97-06-06 p(162868) inserted a NO REC FOUND clause
* jvd 98-05-04 p(168326) Increase display size to show lines > 10m
* jvd 98-09-10 p(164220) NOM141ÖNAT23
*                        p(168326) is now in p(164220) so I have removed
*                        all refferance to P(168326) to make easier
*                        reading
* fhi 00-03-03 S(192651) Line length > 253 not stored in DB
* xsiszha 2000-07-31 (CE7461) Extend Report and Bundle Names
* fhi     2000-10-04 QA05     Improve error message
* sju 04-12-06 NOM31     Add date and time (tenths of second) to trace
* xsetggr 2005-11-28 p(271774) support more than 40 Power segments
* fhi     2009-07-28 P319282 Binary files on Linux corrupted
* fhi     2009-09-15 P320367 Use compression routine NOMCOMPR
* fhi     2010-06-14 NOMALL-815  User RMSETTIM instead of *TIMD for Ux
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* xsetggr 2012-02-01 NOMALL-1100 write lamnguage independant msgs to log
* SPLILDAV 2012-06-27 NOMALL-1078 SUPPORT COMPRESSION 16K BYTE RECORDS
* raya     2012-09-27 NOMALL-1143 work with lob fields
* fhi      2012-11-09 NOMALL-1143 Add cpu time output
* SU1     2014-01-27 NOMALL-1341 remove LA-fields
* SU2     2014-02-06 NOMALL-1345 avoid corrupted report
* SU3     2014-11-17 NOMALL-1450 fill fields for Adabas Vista
* SU4     2016-01-20 NOMALL-1802 do not update Adabas Vista fields
* fhi     2017-01-18 NOMALL-1916 Use binary NPR RECORD* fields
* fhi     2017-01-27 NOMALL-1961 Show node name in errors
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* SU5     2018-78-06 NOMALL-2130 sep.var.:GDA MONIT-GL -> PDA RMEXSEPA
* SU6     2021-10-12 ES-31134    Unix:BS2:use ESA transl/no hex
* SU7     2024-03-07 ES-34613    NOM 3.6 Remove power
* ---------------------------------------------------------------------
DEFINE DATA GLOBAL USING MONIT-GL
PARAMETER USING RMEXSEPA /*SU5
************************************************************************
INDEPENDENT
1 +NOD-CURRENT-NAME  (A16)
1 +CMRDC             (A1)
* -----------------------------LDA's-----------------------------------
LOCAL USING RCCTYP-E
LOCAL USING RMSR---E
LOCAL USING RMSR---L
LOCAL USING RLOG-L
* -----------------------------View's----------------------------------
LOCAL
1 REPORT VIEW OF NRM-REPORTS-NEW
  2 R-E-IDENT-LINE
  2 R-E-IDENT-STRING
  2 REDEFINE R-E-IDENT-STRING
    3 R-E-IDENT-STRNG    (A50)
  2 R-E-BREAK-LINE
  2 R-E-BREAK-START
  2 R-E-BREAK-END
  2 R-E-REP-PREFIX
  2 R-BUNDLE (1:5)
1 SYSOUT VIEW OF READ-SPOOL
  2 ERROR-CODE
  2 ERROR-TEXT
  2 RECORD-NUMBER
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
1 READ-FILE-ESA VIEW OF READ-FILE /*SU6
  2 ERROR-CODE
  2 ERROR-TEXT
  2 RECORD-NUMBER
  2 RECORD /*MUST - HEX
  2 SEGMENT-LENGTH
  2 SEGMENT-NUMBER
1 SOURCE VIEW OF NRM-SOURCE
  2 SR-NUMBER-OF-LINES
1 SOURCE-TEXT VIEW OF NRM-SOURCE-TEXT
  2 ST-ID
  2 ST-TEXT                    (1:66)
  2 REDEFINE ST-TEXT
    3 ST-TEXT-LOB              (A16381)
* -----------------------------local Variables-------------------------
1 #IEX-IDENT-LINE              (P3)
1 #IEX-BREAK-LINE              (P3)
1 #IEX-BREAK-LEN               (P3)
1 #IEX-BREAK-START             (P3)
1 #IEX-BREAK-END               (P3)
1 #IEX-BREAK-STRING            (A78)
1 #IEX-REPPREFIX               (A25)
1 #IEX-BUNPREFIX               (A25/1:5)
*
1 #FROMLINE                    (N9)
1 #TOLINE                      (N9)
1 #IDENT                       (A253)
1 REDEFINE #IDENT
  2 #IDENT-B                   (A1/1:253)
1 #IDENT-OLD                   (A253)
*
1 IN-REPORT                    (L)
1 TOP-OF-PAGE                  (L)
1 STRING-FOUND                 (L)
1 #LINE-STRING                 (N9)
1 #LINE-BREAK                  (N9)
1 #LINE-PAGE                   (N9)
1 #SAVE-LINE                   (A253)
1 REDEFINE #SAVE-LINE
  2 #SAVE-B                    (A1/1:253)
1 #I                           (P2)
1 #RECORD-NUMBER               (N9)
1 #RECORD                      (A253)
1 REDEFINE #RECORD
  2 #REC-CC                    (A1)
1 REDEFINE #RECORD
  2 #REC                       (A1/1:253)
1 #ST-ID-LINE                  (B10)
1 REDEFINE #ST-ID-LINE
  2 #ST-ID                     (P10)
  2 #ST-LINE                   (B4)
1 #NSMCOMP-CB                  (B40)
1 REDEFINE #NSMCOMP-CB
  2 #NSMCOMP-COMMAND           (A1)
  2 #NSMCOMP-CODE              (B1)
  2 #NSMCOMP-INLENGTH-OLD      (B1)
  2 #NSMCOMP-OUTLENGTH-OLD     (B1)
  2 #NSMCOMP-INLENGTH          (B2)
  2 #NSMCOMP-OUTLENGTH         (B2)
*
1 #NSMCOMP-RC                  (B2)
1 #NSMCOMP-WORK                (B4)
1 #NSMCOMP-LINE                (A251)
1 #NSMCOMP-BUFFER-LENGTH       (B4)
1 #G-SOURCE-TYPE-BIN           (B2)
1 RMSETTIM
  2 FUNCTION                 (A1)
  2 ERC                      (N4)
  2 MSG                      (A250)
  2 TIME                     (I4)
1 #TRACING                   (L)
1 #USE-ESA                   (L)   /*SU6
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
FORMAT LS=100
************************************************************************
DEFINE SUBROUTINE STD-EXIT-001
************************************************************************
IF G-TRACE GE *LEVEL
  #TRACING := TRUE
  G-TRACE-MSG := 'Start STD-EXIT-001'
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
INCLUDE CMRDC
*
RESET G-NATRP-ERC G-NATRP-ERT
*
RMSETTIM.FUNCTION := 'S'
PERFORM RMSETTIM-SETTIME RMSETTIM
*
PERFORM INIT-FUNCTION
IF G-NATRP-ERC = 0
  PERFORM SEPARATION-PROCESSING
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
DEFINE SUBROUTINE SEPARATION-PROCESSING
************************************************************************
#SOURCE-ATTRIBUTES := RMEX-SOURCE-ATTRIBUTES
#G-SOURCE-TYPE-BIN := RMEX-SOURCE-TYPE
CALLNAT 'RMSR7--N' #SOURCE-ATTRIBUTES #G-SOURCE-TYPE-BIN /*Jobnr:5->7
*
IF *MACHINE-CLASS NE 'MAINFRAME' /*SU6
AND RMEX-SOURCE-TYPE = SEQUENTIAL-FILE-BS2                            /*
  IF F#ESA (<#FBS2-NODE>) /*must be separate IF ÜÜ
   CALLNAT 'NOMESA' #FBS2-NODE(AD=O) +NOD-CURRENT-NAME(AD=O) 1X #USE-ESA
  END-IF
END-IF
*
RESET P-EXIT-PARMS ##REC-COUNT
*
#IEX-BREAK-LEN := #IEX-BREAK-END - #IEX-BREAK-START + 1
TOP-OF-PAGE := TRUE
*
MOVE ALL H'FF' TO #IDENT-OLD
#RECORD-NUMBER := 1
PERFORM TOP-OF-PAGE-HANDLING
*
DECIDE ON FIRST VALUE OF RMEX-SOURCE-TYPE
  VALUE JES2, JES3            PERFORM STD-EXIT-001-JES
/*SU7  VALUE POWER                 PERFORM STD-EXIT-001-POWER
/*SU7  VALUE SEQUENTIAL-FILE-VSE   PERFORM STD-EXIT-001-FVSE
  VALUE SEQUENTIAL-FILE-MVS   PERFORM STD-EXIT-001-FMVS
  VALUE SEQUENTIAL-FILE-BS2   PERFORM STD-EXIT-001-FBS2
  VALUE NOM-DATA-BASE         PERFORM STD-EXIT-001-NOMDB
  NONE
    G-NATRP-ERC := 9999
    COMPRESS NUMERIC *PROGRAM 'Invalid Source Type' RMEX-SOURCE-TYPE
      TO G-NATRP-ERT
END-DECIDE
*
PERFORM TOP-OF-PAGE-HANDLING
#LINE-PAGE := #RECORD-NUMBER + 1
PERFORM BREAK-OCCURED
*
END-SUBROUTINE /* SEPARATION-PROCESSING
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
  CALLNAT 'RMEXMSKN' /* build ident string for Standard separation rout
    R-E-IDENT-STRNG #IEX-BREAK-STRING
  #IEX-IDENT-LINE      := R-E-IDENT-LINE
  #IEX-BREAK-LINE      := R-E-BREAK-LINE
  #IEX-BREAK-START     := R-E-BREAK-START
  #IEX-BREAK-END       := R-E-BREAK-END
  #IEX-REPPREFIX       := R-E-REP-PREFIX
  #IEX-BUNPREFIX (1:5) := R-BUNDLE (1:5)
END-FIND
*
END-SUBROUTINE /* INIT-FUNCTION
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-001-JES
************************************************************************
FNDJES. FIND SYSOUT WITH NODE = #JES-NODE AND JOB-NAME = #JES-JOB-NAME
AND JOB-NUMBER = #JES-JOB-NUMBER AND TYPE = #JES-TYPE                 /*
AND DATA-SET-KEY    = #JES-DATA-SET-KEY                               /*
  IF NO RECORD FOUND
    COMPRESS '1076' #JES-JOB-NAME TO LG-MSG
    CALLNAT 'RLOG' PL-PARMS
    END OF TRANSACTION
    ESCAPE BOTTOM (FNDJES.)
  END-NOREC
  PERFORM HANDLE-IT_SYSOUT-FILE
END-FIND
*
END-SUBROUTINE /* STD-EXIT-001-JES
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-001-FMVS
************************************************************************
FNDFMVS. FIND READ-FILE WITH NODE = #FMVS-NODE AND DSNAME = #FMVS-DSNAME
AND LRECL   = #FMVS-LRECL AND RECFM   = #FMVS-RECFM                   /*
AND BLKSIZE = #FMVS-BLKSIZE AND SEGMENT-LENGTH = 251                  /*
  PERFORM HANDLE-IT_READ-FILE
END-FIND
*
END-SUBROUTINE /* STD-EXIT-001-FMVS
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-001-FBS2
************************************************************************
IF #USE-ESA /*SU6
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
END-SUBROUTINE /* STD-EXIT-001-FBS2
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-001-NOMDB
************************************************************************
#NSMCOMP-BUFFER-LENGTH := 16381 - 7
#NSMCOMP-CODE    := 'N'  /* 'N' - NEW PARM LIST
#NSMCOMP-COMMAND := 'D'
#ST-ID           := #NOMDB-ID
RESET  #ST-LINE #RECORD-NUMBER
*
FNDNOMDB. READ SOURCE-TEXT BY ST-ID-LINE STARTING FROM #ST-ID-LINE
  IF ST-ID NE #ST-ID
    ESCAPE BOTTOM (FNDNOMDB.)
  END-IF
*
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
        COMPRESS 'Error decompressing data RC='
          #NSMCOMP-RC TO G-NATRP-ERT LEAVING NO
        ESCAPE BOTTOM (FNDNOMDB.)
    END-DECIDE
*
    ADD 1 TO #RECORD-NUMBER
    #RECORD := #NSMCOMP-LINE
*
    PERFORM STD-EXIT-001-COMMON
    IF G-NATRP-ERC NE 0
      ESCAPE BOTTOM (FNDNOMDB.)
    END-IF
*
  END-REPEAT
END-READ
*
END-SUBROUTINE /* STD-EXIT-001-NOMDB
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
*
#RECORD-NUMBER := READ-FILE.RECORD-NUMBER
IF #USE-ESA /*SU6
  #RECORD := READ-FILE.RECORD
ELSE
  #RECORD := F#CONVERT-RECORD-HEX (<READ-FILE.RECORD-HEX1,
    READ-FILE.RECORD-HEX2,READ-FILE.RECORD-HEX3,
    #TRACING,RMEX-SOURCE-CODEPAGE>)
END-IF
IF READ-FILE.SEGMENT-NUMBER > 1 AND READ-FILE.SEGMENT-LENGTH < 251
  COMPRESS '§' #RECORD TO #RECORD LEAVING NO /*1. byte is cc-character
  EXAMINE SUBSTRING (#RECORD,1,1) FOR '§' REPLACE WITH ' '
END-IF
*
PERFORM STD-EXIT-001-COMMON
IF G-NATRP-ERC NE 0
  ESCAPE BOTTOM
END-IF
*
END-SUBROUTINE /* HANDLE-IT_READ-FILE
*
************************************************************************
DEFINE SUBROUTINE HANDLE-IT_SYSOUT-FILE
************************************************************************
IF SYSOUT.ERROR-CODE NE 0
  G-NATRP-ERC := 0005
  COMPRESS SYSOUT.ERROR-TEXT '/' +NOD-CURRENT-NAME '/' *PROGRAM
    '/' *LINE TO G-NATRP-ERT
  ESCAPE BOTTOM
END-IF
IF RMEX-SOURCE-TYPE= JES2 OR=JES3
  #RECORD-NUMBER := SYSOUT.RECORD-NUMBER
ELSE
  ADD 1 TO #RECORD-NUMBER
END-IF
#RECORD := F#CONVERT-RECORD-HEX
  (<SYSOUT.RECORD-HEX1,SYSOUT.RECORD-HEX2,SYSOUT.RECORD-HEX3,
  #TRACING,RMEX-SOURCE-CODEPAGE>)
PERFORM STD-EXIT-001-COMMON
IF G-NATRP-ERC NE 0
  ESCAPE BOTTOM
END-IF
*
END-SUBROUTINE /* HANDLE-IT_SYSOUT-FILE
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-001-COMMON
************************************************************************
IF (#REC-CC = H'89' AND RMEX-SOURCE-CC-TYPE = MACHINE-CODE)
OR (#REC-CC = H'8B' AND RMEX-SOURCE-CC-TYPE = MACHINE-CODE)           /*
OR (#REC-CC = '1'   AND RMEX-SOURCE-CC-TYPE = ASA-CODE)               /*
OR (#REC-CC = H'81' AND RMEX-SOURCE-CC-TYPE = BS2000-CC)              /*
OR (#REC-CC = 'A'   AND RMEX-SOURCE-CC-TYPE = BS2000-CC)              /*
  PERFORM TOP-OF-PAGE-HANDLING
END-IF
*
IF #RECORD-NUMBER = #LINE-STRING
OR (#IEX-IDENT-LINE = 0 AND NOT STRING-FOUND)                         /*
  PERFORM SEARCH-STRING
END-IF
*
IF #RECORD-NUMBER = #LINE-BREAK
  #SAVE-LINE := #RECORD
END-IF
*
END-SUBROUTINE /* STD-EXIT-001-COMMON
*
************************************************************************
DEFINE SUBROUTINE TOP-OF-PAGE-HANDLING
************************************************************************
IF STRING-FOUND
  #IDENT-B (1:#IEX-BREAK-LEN):= #SAVE-B(#IEX-BREAK-START:#IEX-BREAK-END)
  IF #IDENT NE #IDENT-OLD
    PERFORM BREAK-OCCURED
  END-IF
  IN-REPORT := TRUE
END-IF
*
IF (#REC-CC = H'89' AND RMEX-SOURCE-CC-TYPE = MACHINE-CODE)
OR (#REC-CC = H'81' AND RMEX-SOURCE-CC-TYPE = BS2000-CC)              /*
  #LINE-PAGE := #RECORD-NUMBER + 1
ELSE
  #LINE-PAGE := #RECORD-NUMBER
END-IF
*
#LINE-STRING := #LINE-PAGE + #IEX-IDENT-LINE - 1
*
IF #IEX-BREAK-LINE = 0
  IF #IEX-IDENT-LINE NE 0
    #LINE-BREAK := #LINE-STRING
  ELSE
    RESET  #LINE-BREAK
  END-IF
ELSE
  #LINE-BREAK := #LINE-PAGE + #IEX-BREAK-LINE - 1
END-IF
*
RESET STRING-FOUND
*
END-SUBROUTINE /* TOP-OF-PAGE-HANDLING
*
************************************************************************
DEFINE SUBROUTINE BREAK-OCCURED
************************************************************************
IF IN-REPORT
  #TOLINE := #LINE-PAGE - 1
  P-TOLINE := #TOLINE
  P-FROMLINE := #FROMLINE
  COMPRESS #IEX-REPPREFIX #IDENT-OLD TO P-REPNAME LEAVING NO
  FOR #I 1 TO 5
    IF #IEX-BUNPREFIX (#I) NE ' '
      COMPRESS #IEX-BUNPREFIX(#I) #IDENT-OLD TO P-BUNDLE (#I) LEAVING NO
    END-IF
  END-FOR
  IF #TRACING
    COMPRESS 'Create->' P-REPNAME P-FROMLINE P-TOLINE TO G-TRACE-MSG
    PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END-IF
  PERFORM CREATE-REPORT #RMEXSEPA /*RMCRTREP /*SU5
END-IF
#IDENT-OLD := #IDENT
#FROMLINE := #LINE-PAGE
RESET  #TOLINE
*
END-SUBROUTINE /* BREAK-OCCURED
*
************************************************************************
DEFINE SUBROUTINE SEARCH-STRING
************************************************************************
IF #RECORD = MASK #IEX-BREAK-STRING
  STRING-FOUND := TRUE
  IF #LINE-BREAK = 0
    #LINE-BREAK := #RECORD-NUMBER
  END-IF
END-IF
*
END-SUBROUTINE /* SEARCH-STRING
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
END-SUBROUTINE /* STD-EXIT-001
*
END
