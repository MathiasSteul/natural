* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RMEX002 - Standard Exit 002
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* mrs 93-03-07 s(999999) created
* mrs 93-10-07 s(999999) invalid #string-line and #pageline if h'89'
* mrs 93-11-09 s(999999) seq. Files MVS added
* mrs 94-03-01 s(999999) seq. Files BS2 added
* mrs 94-05-09 s(999999) h'81' is a valid ff (write and skip) in BS2
* mrs 95-09-27 s(999999)  update number of lines in source record
*                         if unknown (=0)
* gw  95-01-08 s(238783)  3148 in line 2570 program rmex001
* mrs 95-01-19 s(238783)  modification 95-01-08 removed
* jvd 98-05-04 p(168326) Increase display size to show lines > 10m
* jvd 98-09-10 p(164220) NOM141ÖNAT23
*                        p(168326) is now in p(164220) so I have removed
*                        all refferance to P(168326) to make easier
*                        reading
* fhi 00-03-03 S(192651) Line length > 253 not stored in DB
* xsiszha 2000-07-31 (CE7461) Extend Report and Bundle Names
* fhi     2000-10-04 QA05     Improve error message
* sju   04-12-06 NOM31     Add date and time (tenths of second) to trace
* fhi     05-04-19 NOM31107  Support 7-byte job numbers
* xsetggr 2005-11-28 p(271774) support more than 40 Power segments
* fhi     2009-07-28 P319282 Binary files on Linux corrupted
* fhi     2009-09-15 P320367 Use compression routine NOMCOMPR
* fhi     2010-06-14 NOMALL-815  User RMSETTIM instead of *TIMD for Ux
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
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
* fhi     2017-07-11 NOMALL-2021 NPR error: use RECORD temporarily ÜÜÜ
* SU5     2018-78-06 NOMALL-2130 sep.var.:GDA MONIT-GL -> PDA RMEXSEPA
* fhi     2018-12-14 NOM 3.5     Improve CPU measures, no tags
* SU6     2021-10-12 ES-31134    Unix:BS2:use ESA transl/no hex
* SU7     2024-03-07 ES-34613    NOM 3.6 Remove power
* ---------------------------------------------------------------------
DEFINE DATA
GLOBAL USING MONIT-GL
PARAMETER USING RMEXSEPA
************************************************************************
INDEPENDENT
1 +NOD-CURRENT-NAME  (A16)
1 +CMRDC             (A1)
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
  2 RECORD /*MUST - HEX
  2 RECORD-HEX1
  2 RECORD-HEX2
  2 RECORD-HEX3
1 READ-FILE VIEW OF READ-FILE
  2 ERROR-CODE
  2 ERROR-TEXT
  2 RECORD-NUMBER
  2 RECORD /*MUST - HEX
  2 RECORD-HEX1
  2 RECORD-HEX2
  2 RECORD-HEX3
  2 SEGMENT-LENGTH
  2 SEGMENT-NUMBER
1 READ-FILE-ESA VIEW OF READ-FILE /*SU6
  2 ERROR-CODE
  2 ERROR-TEXT
  2 RECORD-NUMBER
  2 RECORD /*not used, but must defined to get HEX fields filled
  2 SEGMENT-LENGTH
  2 SEGMENT-NUMBER
1 SOURCE-TEXT VIEW OF NRM-SOURCE-TEXT
  2 ST-ID
  2 ST-TEXT                      (1:66)
  2 REDEFINE ST-TEXT
    3 ST-TEXT-LOB                (A16381)
1 SOURCE VIEW OF NRM-SOURCE
  2 SR-NUMBER-OF-LINES
1 REPORT VIEW OF NRM-REPORTS-NEW
  2 R-E-PARAMS                   (1:4)
  2 REDEFINE R-E-PARAMS
    3 R-STD2-IDENT-LINE          (N3)
    3 R-STD2-IDENT-STRING        (A78)
    3 REDEFINE R-STD2-IDENT-STRING
      4 R-STD2-IDENT-STRNG       (A50)
    3 R-STD2-TAB                 (1:5)
      4 R-STD2-BREAK-LINE        (N3)
      4 R-STD2-BREAK-START       (N3)
      4 R-STD2-BREAK-END         (N3)
      4 R-STD2-REPORT-PREFIX-17  (A17)
      4 R-STD2-BUNDLE-PREFIX-8   (A8/1:5)
    3 R-STD2-TAB-R               (1:5)
      4 R-STD2-REPORT-PREFIX-R   (A8)
      4 R-STD2-BUNDLE-PREFIX-R   (A17/1:5)
* -----------------------------local variables-------------------------
1 SEPARATION-PARAMETER
  2 R-STD002-ENTRIES             (N2)
  2 R-STD002-IDENT-LINE          (N3)
  2 R-STD002-IDENT-STRING        (A78)
  2 R-STD002-PARAMETER           (1:5)
    3 R-STD002-REPORT-PREFIX     (A25)
    3 REDEFINE R-STD002-REPORT-PREFIX
      4 R-STD002-REPORT-PREFIX-17(A17)
      4 R-STD002-REPORT-PREFIX-R (A8)
    3 R-STD002-BUNDLE-PREFIX     (A25/1:5)
    3 REDEFINE R-STD002-BUNDLE-PREFIX
      4 R-STD002-BUNDLE-PREFIX-A (1:5)
        5 R-STD002-BUNDLE-PREFIX-8(A8)
        5 R-STD002-BUNDLE-PREFIX-R(A17)
    3 R-STD002-BREAK-LINE        (N3)
    3 R-STD002-COLUMN-FROM       (N3)
    3 R-STD002-COLUMN-TO         (N3)
*
1 #J                             (P2)
1 #S                             (P3)
1 #E                             (P3)
1 #L                             (P3)
1 #ENTRIES                       (P2)
1 #STD002-TAB (1:5)
  2 IN-REPORT                    (L)
  2 #FROMLINE                    (N9)
  2 #TOLINE                      (N9)
  2 #IDENT-OLD                   (A253)
  2 #LINE-BREAK                  (N9)
  2 #BREAK-START                 (P3)
  2 #BREAK-END                   (P3)
  2 #BREAK-LENGTH                (P3)
  2 #SAVE-LINE                   (A253)
  2 REDEFINE #SAVE-LINE
    3 #SAVE-B                    (A1/1:253)
1 #IDENT                         (A253)
1 REDEFINE #IDENT
  2 #IDENT-B                     (A1/1:253)
1 TOP-OF-PAGE                    (L)
1 STRING-FOUND                   (L)
1 #RECORD-NUMBER                 (N7)
1 #RECORD                        (A253)
1 REDEFINE #RECORD
  2 #REC-CC                      (A1)
1 REDEFINE #RECORD
  2 #REC                         (A1/1:253)
1 #LINE-STRING                   (N9)
1 #LINE-PAGE                     (N9)
1 I                              (P2)
1 J                              (P2)
1 #I                             (P2)
1 #ST-ID-LINE                    (B10)
1 REDEFINE #ST-ID-LINE
  2 #ST-ID                       (P10)
  2 #ST-LINE                     (B4)
1 #NSMCOMP-CB                    (B40)
1 REDEFINE #NSMCOMP-CB
  2 #NSMCOMP-COMMAND             (A1)
  2 #NSMCOMP-CODE                (B1)
  2 #NSMCOMP-INLENGTH-OLD        (B1)
  2 #NSMCOMP-OUTLENGTH-OLD       (B1)
  2 #NSMCOMP-INLENGTH            (B2)
  2 #NSMCOMP-OUTLENGTH           (B2)
1 #NSMCOMP-RC                    (B2)
1 #NSMCOMP-WORK                  (B4)
1 #NSMCOMP-LINE                  (A251)
1 #NSMCOMP-BUFFER-LENGTH         (B4)
1 #G-SOURCE-TYPE-BIN             (B2)
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
FORMAT LS=100 PS=60
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-002
************************************************************************
IF G-TRACE GE *LEVEL
  #TRACING := TRUE
  G-TRACE-MSG := 'Start STD-EXIT-002'
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
* End of main line (now subroutines):
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE SEPARATION-PROCESSING
************************************************************************
RESET P-EXIT-PARMS ##REC-COUNT
TOP-OF-PAGE := TRUE
*
#ENTRIES := R-STD002-ENTRIES
*
FOR #J = 1 TO #ENTRIES
  MOVE ALL H'FF' TO #IDENT-OLD (#J)
  #BREAK-START  (#J) := R-STD002-COLUMN-FROM (#J)
  #BREAK-END    (#J) := R-STD002-COLUMN-TO  (#J)
  #BREAK-LENGTH (#J) :=R-STD002-COLUMN-TO(#J) - R-STD002-COLUMN-FROM(#J)
    + 1
END-FOR
*
#RECORD-NUMBER := 1
PERFORM TOP-OF-PAGE-HANDLING
#SOURCE-ATTRIBUTES := RMEX-SOURCE-ATTRIBUTES
#G-SOURCE-TYPE-BIN := RMEX-SOURCE-TYPE
CALLNAT 'RMSR7--N' #SOURCE-ATTRIBUTES #G-SOURCE-TYPE-BIN  /*Jobnr:N5->N7
*
DECIDE ON FIRST VALUE OF RMEX-SOURCE-TYPE
  VALUE JES2, JES3            PERFORM STD-EXIT-002-JES
/*SU7  VALUE POWER                 PERFORM STD-EXIT-002-POWER
/*SU7  VALUE SEQUENTIAL-FILE-VSE   PERFORM STD-EXIT-002-FVSE
  VALUE SEQUENTIAL-FILE-MVS   PERFORM STD-EXIT-002-FMVS
  VALUE SEQUENTIAL-FILE-BS2   PERFORM STD-EXIT-002-FBS2
  VALUE NOM-DATA-BASE         PERFORM STD-EXIT-002-NOMDB
  NONE
    G-NATRP-ERC := 9999
    COMPRESS NUMERIC *PROGRAM 'Invalid Source Type' RMEX-SOURCE-TYPE
      TO G-NATRP-ERT
END-DECIDE
*
PERFORM TOP-OF-PAGE-HANDLING
#LINE-PAGE := #RECORD-NUMBER + 1
FOR #J = 1 TO #ENTRIES
  PERFORM BREAK-OCCURED
END-FOR
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
  R-STD002-IDENT-LINE := R-STD2-IDENT-LINE
  CALLNAT 'RMEXMSKN' R-STD2-IDENT-STRNG R-STD002-IDENT-STRING
  FOR I = 1 TO 5
    IF R-STD2-BREAK-LINE  (I) = 0 AND R-STD2-BREAK-START (I) = 0
    AND R-STD2-BREAK-END   (I) = 0                                    /*
      ESCAPE TOP
    END-IF
    ADD 1 TO J
    R-STD002-ENTRIES := J
    R-STD002-REPORT-PREFIX-17(J)   := R-STD2-REPORT-PREFIX-17 (I)
    R-STD002-REPORT-PREFIX-R (J)   := R-STD2-REPORT-PREFIX-R (I)
    R-STD002-BUNDLE-PREFIX-8 (J,*) := R-STD2-BUNDLE-PREFIX-8(I,*)
    R-STD002-BUNDLE-PREFIX-R (J,*) := R-STD2-BUNDLE-PREFIX-R(I,*)
    R-STD002-BREAK-LINE      (J)   := R-STD2-BREAK-LINE   (I)
    R-STD002-COLUMN-FROM     (J)   := R-STD2-BREAK-START  (I)
    R-STD002-COLUMN-TO       (J)   := R-STD2-BREAK-END    (I)
  END-FOR
END-FIND
*
IF R-STD002-IDENT-STRING = ' ' OR J = 0
  G-NATRP-ERC := 0005
  COMPRESS'invalid std2 parameter:' R-STD002-IDENT-STRING 'J=' J
    TO G-NATRP-ERT
END-IF
*
END-SUBROUTINE /* INIT-FUNCTION
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-002-JES
************************************************************************
FNDJES. FIND READ-SPOOL WITH NODE =#JES-NODE AND JOB-NAME =#JES-JOB-NAME
AND JOB-NUMBER = #JES-JOB-NUMBER AND TYPE = #JES-TYPE                 /*
AND DATA-SET-KEY = #JES-DATA-SET-KEY                                  /*
  PERFORM HANDLE-IT_READ-SPOOL
END-FIND
*
END-SUBROUTINE /* STD-EXIT-002-JES
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-002-FMVS
************************************************************************
FNDFMVS. FIND READ-FILE WITH NODE = #FMVS-NODE AND DSNAME = #FMVS-DSNAME
AND LRECL   = #FMVS-LRECL AND RECFM   = #FMVS-RECFM                   /*
AND BLKSIZE = #FMVS-BLKSIZE AND SEGMENT-LENGTH = 251                  /*
  PERFORM HANDLE-IT_READ-FILE
END-FIND
*
END-SUBROUTINE /* STD-EXIT-002-FMVS
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-002-FBS2
************************************************************************
IF *MACHINE-CLASS NE 'MAINFRAME' /*SU6
  IF F#ESA (<#FBS2-NODE>) /*must be separate IF ÜÜ
   CALLNAT 'NOMESA' #FBS2-NODE(AD=O) +NOD-CURRENT-NAME(AD=O) 1X #USE-ESA
  END-IF
END-IF
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
END-SUBROUTINE /* STD-EXIT-002-FBS2
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-002-NOMDB
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
        COMPRESS 'Error decompressing data:RC=' #NSMCOMP-RC
          TO G-NATRP-ERT LEAVING NO
        ESCAPE BOTTOM (FNDNOMDB.)
    END-DECIDE
*
    ADD 1 TO #RECORD-NUMBER
    #RECORD := #NSMCOMP-LINE
*
    PERFORM STD-EXIT-002-COMMON
    IF G-NATRP-ERC NE 0
      ESCAPE BOTTOM (FNDNOMDB.)
    END-IF
*
  END-REPEAT
END-READ
*
END-SUBROUTINE /* STD-EXIT-002-NOMDB
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
/*SU7 IF RMEX-SOURCE-TYPE= POWER ADD 1 TO #RECORD-NUMBER ELSE
#RECORD-NUMBER := READ-SPOOL.RECORD-NUMBER
/*SU7 END-IF
IF #USE-ESA /*SU6
  #RECORD := READ-FILE.RECORD
ELSE
  #RECORD:=F#CONVERT-RECORD-HEX (<READ-SPOOL.RECORD-HEX1,
    READ-SPOOL.RECORD-HEX2,
    READ-SPOOL.RECORD-HEX3, #TRACING,RMEX-SOURCE-CODEPAGE>)
END-IF
PERFORM STD-EXIT-002-COMMON
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
#RECORD-NUMBER := READ-FILE.RECORD-NUMBER
#RECORD := F#CONVERT-RECORD-HEX
  (<READ-FILE.RECORD-HEX1,READ-FILE.RECORD-HEX2,READ-FILE.RECORD-HEX3,
  #TRACING,RMEX-SOURCE-CODEPAGE>)
IF READ-FILE.SEGMENT-NUMBER > 1 AND READ-FILE.SEGMENT-LENGTH < 251
  COMPRESS '§' #RECORD TO #RECORD LEAVING NO /*1. is cc-character
  EXAMINE SUBSTR (#RECORD,1,1) FOR '§' REPLACE WITH ' '
END-IF
PERFORM STD-EXIT-002-COMMON
IF G-NATRP-ERC NE 0
  ESCAPE BOTTOM
END-IF
*
END-SUBROUTINE /* HANDLE-IT_READ-FILE
*
************************************************************************
DEFINE SUBROUTINE STD-EXIT-002-COMMON
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
OR (R-STD002-IDENT-LINE = 0 AND NOT STRING-FOUND)                     /*
  PERFORM SEARCH-STRING
END-IF
*
FOR #J = 1 TO #ENTRIES
  IF #RECORD-NUMBER = #LINE-BREAK (#J)
    #SAVE-LINE (#J) := #RECORD
  END-IF
END-FOR
*
END-SUBROUTINE /* STD-EXIT-002-COMMON
*
************************************************************************
DEFINE SUBROUTINE TOP-OF-PAGE-HANDLING
************************************************************************
IF STRING-FOUND
  FOR #J = 1 TO #ENTRIES
    #S := #BREAK-START  (#J)
    #E := #BREAK-END    (#J)
    #L := #BREAK-LENGTH (#J)
    #IDENT-B (1:#L) := #SAVE-B (#J, #S:#E)
    IF #IDENT NE #IDENT-OLD (#J)
      PERFORM BREAK-OCCURED
    END-IF
    RESET #IDENT-B (1:#L)
    IN-REPORT (#J) := TRUE
  END-FOR
END-IF
*
IF (#REC-CC = H'89' AND RMEX-SOURCE-CC-TYPE = MACHINE-CODE)
OR (#REC-CC = H'81' AND RMEX-SOURCE-CC-TYPE = BS2000-CC)              /*
  #LINE-PAGE := #RECORD-NUMBER + 1
ELSE
  #LINE-PAGE := #RECORD-NUMBER
END-IF
*
#LINE-STRING := #LINE-PAGE + R-STD002-IDENT-LINE - 1
*
FOR #J = 1 TO #ENTRIES
  IF R-STD002-BREAK-LINE (#J) = 0
    IF R-STD002-IDENT-LINE NE 0
      #LINE-BREAK (#J) := #LINE-STRING
    ELSE
      RESET  #LINE-BREAK (#J)
    END-IF
  ELSE
    #LINE-BREAK (#J) := #LINE-PAGE + R-STD002-BREAK-LINE (#J) - 1
  END-IF
END-FOR
*
RESET STRING-FOUND
*
END-SUBROUTINE /* TOP-OF-PAGE-HANDLING
*
************************************************************************
DEFINE SUBROUTINE BREAK-OCCURED
************************************************************************
IF IN-REPORT (#J)
  #TOLINE (#J) := #LINE-PAGE - 1
  P-TOLINE     := #TOLINE (#J)
  P-FROMLINE   := #FROMLINE (#J)
  COMPRESS R-STD002-REPORT-PREFIX (#J) #IDENT-OLD (#J)
    TO P-REPNAME LEAVING NO
  RESET P-BUNDLE (*)
  FOR #I 1 TO 5
    IF R-STD002-BUNDLE-PREFIX (#J, #I) NE ' '
      COMPRESS R-STD002-BUNDLE-PREFIX(#J, #I) #IDENT-OLD (#J)
        TO P-BUNDLE (#I) LEAVING NO
    END-IF
  END-FOR
  IF #TRACING
    COMPRESS 'Create->' P-REPNAME P-FROMLINE P-TOLINE TO G-TRACE-MSG
    PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END-IF
  PERFORM CREATE-REPORT #RMEXSEPA /*RMCRTREP
END-IF
#IDENT-OLD (#J) := #IDENT
#FROMLINE  (#J) := #LINE-PAGE
RESET  #TOLINE (#J)
*
END-SUBROUTINE /* BREAK-OCCURED
*
************************************************************************
DEFINE SUBROUTINE SEARCH-STRING
************************************************************************
IF #RECORD = MASK R-STD002-IDENT-STRING
  STRING-FOUND := TRUE
  FOR #J = 1 TO #ENTRIES
    IF #LINE-BREAK (#J) = 0
      #LINE-BREAK (#J) := #RECORD-NUMBER
    END-IF
  END-FOR
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
END-SUBROUTINE /* STD-EXIT-002
*
END
