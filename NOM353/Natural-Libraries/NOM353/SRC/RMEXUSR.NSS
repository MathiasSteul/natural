* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 5
* <Natural Source Header
* RMEXUSR - User Separation
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* mrs 93-03-09 s(999999) created
* mrs 93-10-26 s(999999) add steplib with NAT00009 in RMPROCRP
* mrs 93-11-09 s(999999) seq. Files MVS added
* mrs 93-12-23 s(999999) do not fill p-dist from master definition
* mrs 94-03-01 s(999999) seq. Files BS2 added
* mrs 94-05-09 s(999999) h'81' is a valid ff (write and skip) in BS2
* mrs 94-11-21 p(134192) aiv variables added to make spool attributes
*                        available in the user routine
* mrs 95-05-11 s(224957) avoid NAT1305 if DSNO > 999
* gw  96-07-14 s(999999) new action BUNDLE
* gw  96-09-09 s(999999) bundle attributes for action BUNDLE
* mrs 97-05-27 p(162705) make extended spool attributes available
*                        extended spool attributes are assigned only
*                        once at start of processing (performace
*                        overhead)
* jvd 97-06-06 p(162868) inserted a NO REC FOUND clause
* gw  98-04-02 s(266466) lines with lrecl = 256 are suppressed when
*                        stored in the data base, reason is that
*                        array ##reclen-vec is only (b1), so for
*                        value 256 it becomes 0. If > 251 we now
*                        set it to 251 which is max for nom.
* gw  98-04-04 s(278966) Allow dynamic bundling by ignoring existing
*                        report in bundle definitions.
*                        The report is bundled only in those specified
*                        in G-BUNDLE (*).
* jvd 98-05-04 p(168326)  Increase display size to show lines > 10m
* gw  98-08-26 s(999999) Incorporate P-UEXITN into P-UEXIT and adapt
*                        MONIT-GL accordingly. This means that all
*                        separation exits must be changed as follows:
*                        1. remove DEFINE DATA LOCAL P-UEXITN
*                        2. remove P-SPOOL-ATTRIBUTES := +P-SPOOL-AT...
* gw  98-08-26 s(999999) commented out code for old fields
*                        P-JOBNAME, P-JOBNO, P-NODE, P-DSTYPE, P-DSNO
* gw  98-11-03 s(300070) stowed because spool-jes-dsno  N5 instead of N3
* jvd 99-02-17 P(179657) - same as P(179404) in NOM135
*                        Increase cache size, due to NAT22 USIZE
*                        Increased from 40 to 80.(for NOM142 this
*                        can be increased to a greater value with NAT23
*                        to compile program).
* jvd 99-04-21 p(181377) NAT1305 when processing > 10m lines
* fhi 00-03-03 S(192651) Line length > 253 not stored in DB
* fhi 00-08-23 FHI01     Increasing cache to 126 lines to satisfy
*                        P(179657) 99-02-17
* fhi 02-08-23 p(225736) Setting default of chaching to 'ON'
* sju 03-02-07 special   TYPE=AL in Jes
* sju 04-07-26 p(255079) Speed up ADDR of current line only
* sju 04-12-06 NOM31     Add date and time (tenths of second) to trace
* fhi 05-04-19 NOM3107   Support 7-byte job numbers
* xsetggr 2005-10-26 p(270950) Field G-ACTIVE-ISN must be P10, not P8
* xsetggr 2005-11-28 p(271774) support more than 40 Power segments
* xsetggr 2006-05-14 p(271961) correct writing in report-contents
* xsetggr 2008-01-15 p(300297) prevent NAT1305
* fhi     2008-02-29 P302579   Limit Occurrencies of ##CUR-RECORD
* xsetggr 2008-05-05 p(304350) restow due to changes in RMSPL--L
* fhi     2009-05-19 N3461     Support large blocks
* fhi     2009-05-19 N3463     Extend metadata for OPO
* fhi     2009-07-23 P319198   Message of Compression routine too long
* fhi     2009-07-28 P319282 Binary files on Linux corrupted
* fhi     2009-09-15 P320367 Use compression routine NOMCOMPR
* fhi     2010-10-08 NOMALL-97 Use dynamic memory handling
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* xsetggr 2011-06-15 NOMALL-1011 get record length from source record
*                    for source type NOM-DATA-BASE
* xsetggr 2012-02-01 NOMALL-1100 write language independant msgs in log
* SPLILDAV 2012-06-27 NOMALL-1078 SUPPORT COMPRESSION 16K BYTE RECORDS
* raya     2012-09-27 NOMALL-1143 work with lob fields
* fhi      2012-11-09 NOMALL-1143 Add cpu time output
* xsetggr  2013-04-18 NOMALL-1227 improve trace,display B format numbers
* raya     2013-09-10 NOMALL-932  use dynamic and not array
* SU1     2014-01-27 NOMALL-1341 remove LA-fields
* SU2     2014-02-06 NOMALL-1345 avoid corrupted report
* SU3     2014-07-21 NOMALL-1279 fill fields for Adabas Vista
* SU4     2014-11-17 NOMALL-1450 fill fields for Adabas Vista
* SU5     2016-01-19 NOMALL-1802 do not update Adabas Vista fields
* SU6     2016-09-01 NOMALL-1912 show compression err. not in hex
* fhi     2017-01-18 NOMALL-1916 Use binary NPR RECORD* fields
* fhi     2017-01-27 NOMALL-1961 Show node name in errors
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* fhi     2017-07-11 NOMALL-2021 NPR error: use RECORD temporarily ÜÜÜ
* SU7     2018-01-26 NOM 3.5: remove CON-NECT + check parms
* SU8     2018-08-30 NOMALL-2130 sep.var.:GDA MONIT-GL -> PDA RMEXSEPA
* fhi     2018-12-14 NOM 3.5     Improve CPU measures, no tags
* SU9     2021-10-12 ES-31134    Unix:BS2:use ESA transl/no hex
* SU10    2024-03-07 ES-34613    NOM 3.6 Remove power
* ---------------------------------------------------------------------
DEFINE DATA GLOBAL USING MONIT-GL
PARAMETER USING RMEXSEPA
************************************************************************
INDEPENDENT
1 +SOURCE-ID                   (P10)
1 +CARRIAGE-CONTROL            (A1)
1 +G-SPOOL-ATTR-EXTENDED       (A) DYNAMIC
1 +P-SPOOL-ATTRIBUTES-EXTENDED (A) DYNAMIC
1 +G-ACTIVE-ISN-P10            (P10)
1 +NOD-CURRENT-NAME            (A16)
1 +CMRDC                       (A1)
* *****
LOCAL USING RCCTYP-E
LOCAL USING RMSR---E
LOCAL USING RMSR---L
LOCAL USING RMSPL--L
LOCAL USING RMGT---P
LOCAL USING RLOG-L
*
LOCAL
1 READ-SPOOL VIEW OF READ-SPOOL
  2 ERROR-CODE
  2 ERROR-TEXT
  2 RECORD /*MUST - HEX
  2 RECORD-HEX1
  2 RECORD-HEX2
  2 RECORD-HEX3
  2 RECORD-NUMBER
  2 RECORD-LENGTH
1 READ-FILE VIEW OF READ-FILE
  2 ERROR-CODE
  2 ERROR-TEXT
  2 RECORD /*not used, but must defined to get HEX fields filled
  2 RECORD-HEX1
  2 RECORD-HEX2
  2 RECORD-HEX3
  2 RECORD-LENGTH
  2 RECORD-NUMBER
  2 SEGMENT-LENGTH
  2 SEGMENT-NUMBER
1 READ-FILE-ESA VIEW OF READ-FILE /*SU9
  2 ERROR-CODE
  2 ERROR-TEXT
  2 RECORD /*MUST - HEX
  2 RECORD-LENGTH
  2 RECORD-NUMBER
  2 SEGMENT-LENGTH
  2 SEGMENT-NUMBER
1 SOURCE-TEXT VIEW OF NRM-SOURCE-TEXT
  2 ST-ID
  2 ST-LINE-START
  2 ST-LINE-END
  2 ST-TEXT                  (1:66)
  2 REDEFINE ST-TEXT
    3 ST-TEXT-LOB            (A16381)
1 NRM-SOURCE VIEW OF NRM-SOURCE
  2 SR-ID
  2 SR-CONTROL-FLAG
  2 SR-TYPE
  2 SR-ATTRIBUTES-IDENT
  2 SR-SPOOL-ATTRIBUTES
/*SU10 ->  2 SR-SPOOL-ATTR-EXTENDED   (1:3)
/*  2 REDEFINE SR-SPOOL-ATTR-EXTENDED
/*SU10 <- 3 #EXTRA-SEGMENTS  (N3) 3 #EXTRA-LAST-LINES (B4/41:127)
  2 SR-CC-TYPE
  2 SR-RECORD-LENGTH
  2 SR-OBJECT-TYPE
  2 SR-OBJECT-TIME
* -----------------------------local variables-------------------------
1 SW-EXIT                    (L)
1 GET-IT                     (L)
1 TOP-OF-PAGE                (L)
1 GOTO-NEXT-PAGE             (L)
1 #CMUB-STEPLIB              (A9)
1 #STEPLIB                   (A9)
1 #ADD-PAGE                  (N2)
1 #TOP-RECNO                 (N9)
1 #RECORD-LENGTH             (N5)
1 #RECORD-NUMBER             (N9)
1 #RECORD                    (A253)
1 REDEFINE #RECORD
  2 #REC-CC                  (A1)
1 CACHE                      (L) INIT <TRUE>
1 #CACHE-SIZE                (P3) CONST <126>
1 #CACHE-FROM                (P10)
1 #CACHE-TO                  (P10)
1 #CACHE-POINTER             (P3)
1 #FROM-POINTER              (P3)
1 #CACHE (1:#CACHE-SIZE)
  2 #CACHE-RECORD-NUMBER     (P10)
  2 #CACHE-RECORD-LENGTH     (P5)
  2 #CACHE-RECORD            (A251)
1 #ST-ID-LINE                (B10)
1 REDEFINE #ST-ID-LINE
  2 #ST-ID                   (P10)
  2 #ST-LINE                 (B4)
1 #NSMCOMP-CB                (B40)
1 REDEFINE #NSMCOMP-CB
  2 #NSMCOMP-COMMAND         (A1)
  2 #NSMCOMP-CODE            (B1)
  2 #NSMCOMP-INLENGTH-OLD    (B1)
  2 #NSMCOMP-OUTLENGTH-OLD   (B1)
  2 #NSMCOMP-INLENGTH        (B2)
  2 #NSMCOMP-OUTLENGTH       (B2)
1 #NSMCOMP-RC                (B2)
1 #NSMCOMP-WORK              (B4)
1 #NSMCOMP-LINE              (A251)
1 #NSMCOMP-BUFFER-LENGTH     (B4)
1 #I                         (I2)
1 #OLD-SOURCE-TYPE           (I2 )
1 #OLD-REC-COUNT             (P10)
1 #P-SOURCE-TYPE-BIN         (B2)
1 #RECLEN                    (N3)
1 #CUR-RECORD-MAX            (P2)
1 #TRACING                   (L)
1 RMSETTIM
  2 FUNCTION                 (A1)
  2 ERC                      (N4)
  2 MSG                      (A250)
1 #ST-LINE-START             (I4)
1 #ERC                       (I2)
1 #ST-LINE-END               (I4)
1 #ESC                       (L)
1 #USE-ESA                   (L)   /*SU9
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
FORMAT LS=100
************************************************************************
DEFINE SUBROUTINE PROCESS-USER-SEPARATION
************************************************************************
INCLUDE RMCURREC
*
IF G-TRACE GE *LEVEL
  #TRACING := TRUE
  RMSETTIM.FUNCTION := 'S'
  PERFORM RMSETTIM-SETTIME RMSETTIM
  COMPRESS 'Start' ##EXITLIB ##EXITMEM TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
INCLUDE CMRDC
*
+SOURCE-ID       := RMEX-SOURCE-ID
#OLD-SOURCE-TYPE := RMEX-SOURCE-TYPE
#OLD-REC-COUNT   := RMEX-SOURCE-REC-COUNT
*
+P-SPOOL-ATTRIBUTES-EXTENDED := +G-SPOOL-ATTR-EXTENDED
*
RESET G-NATRP-ERC G-NATRP-ERT ##REPOSITION ##PROCESS-ERROR
RESET ##CUR-RECORD #TEXT-ARRAY(*) ##RECLEN-VEC(*) P-WORK
*
P-REPNAME := G-REPORT
PERFORM OPEN-NEW-REPORT #RMEXSEPA
IF G-NATRP-ERC NE 0
  IF #TRACING
    RMSETTIM.FUNCTION := 'G'
    PERFORM RMSETTIM-SETTIME RMSETTIM
    PERFORM XXRLOG-WRITE-LOG 'T' RMSETTIM.MSG
  END-IF
  ESCAPE ROUTINE
END-IF
*
RESET ##REC-COUNT TOP-OF-PAGE #ADD-PAGE GOTO-NEXT-PAGE P-ACTION P-WORK
*
##SYSOUT-RECNO := 1
SW-EXIT        := TRUE
#STEPLIB       := *STEPLIB
#CMUB-STEPLIB  := ##EXITLIB
#SOURCE-ATTRIBUTES := RMEX-SOURCE-ATTRIBUTES
CALLNAT 'RMSR7--N' #SOURCE-ATTRIBUTES SR-TYPE /*conv. Jobnr:N5->N7
*
IF *MACHINE-CLASS NE 'MAINFRAME' /*SU9
AND RMEX-SOURCE-TYPE = SEQUENTIAL-FILE-BS2                            /*
  IF F#ESA (<#FBS2-NODE>) /*must be separate IF ÜÜ
    CALLNAT 'NOMESA' #FBS2-NODE (AD=O) +NOD-CURRENT-NAME (AD=O)
      P-REPNAME (AD=O) #USE-ESA
  END-IF
END-IF
*
REPOSITION. REPEAT
  IF #TRACING
    COMPRESS 'Position to Line' ##SYSOUT-RECNO TO G-TRACE-MSG
    PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END-IF
  IF ##FILTER-BY-NAT OR ##FILTER-BY-ASM
    SW-EXIT := TRUE
  END-IF
  DECIDE ON FIRST VALUE OF RMEX-SOURCE-TYPE
    VALUE JES2, JES3            PERFORM USER-SEPARATION-JES
/*SU10 VALUE POWER                 PERFORM USER-SEPARATION-POWER
/*SU10 VALUE SEQUENTIAL-FILE-VSE   PERFORM USER-SEPARATION-FVSE
    VALUE SEQUENTIAL-FILE-MVS   PERFORM USER-SEPARATION-FMVS
    VALUE SEQUENTIAL-FILE-BS2   PERFORM USER-SEPARATION-FBS2
    VALUE NOM-DATA-BASE         PERFORM USER-SEPARATION-NOMDB
    NONE
      G-NATRP-ERC := 9999
      COMPRESS NUMERIC *PROGRAM 'Invalid Source' RMEX-SOURCE-TYPE
        TO G-NATRP-ERT
  END-DECIDE
  IF ##REPOSITION
    RESET ##REPOSITION
  ELSE
    ESCAPE BOTTOM(REPOSITION.)
  END-IF
END-REPEAT
*
PERFORM CLOSE-REPORT RMEX-SPOOL-ATTRIBUTES /*RMCLSREP
*
IF RMEX-SOURCE-ID NE +SOURCE-ID
  RMEX-SOURCE-ID := +SOURCE-ID /*???? SU 2018-10
END-IF
IF RMEX-SOURCE-TYPE NE #OLD-SOURCE-TYPE
  RMEX-SOURCE-TYPE := #OLD-SOURCE-TYPE
END-IF
IF RMEX-SOURCE-REC-COUNT NE #OLD-REC-COUNT
  RMEX-SOURCE-REC-COUNT := #OLD-REC-COUNT
END-IF
IF #TRACING
  COMPRESS 'Ended with:' G-NATRP-ERC-A G-NATRP-ERT TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  IF #TRACING
    RMSETTIM.FUNCTION := 'G'
    PERFORM RMSETTIM-SETTIME RMSETTIM
    PERFORM XXRLOG-WRITE-LOG 'T' RMSETTIM.MSG
  END-IF
  END TRANSACTION
END-IF
*
************************************************************************
* End of main line (now subroutines):
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE USER-SEPARATION-JES
************************************************************************
JES. FIND READ-SPOOL WITH NODE = #JES-NODE AND JOB-NAME = #JES-JOB-NAME
AND JOB-NUMBER = #JES-JOB-NUMBER AND TYPE = #JES-TYPE                 /*
AND DATA-SET-KEY   = #JES-DATA-SET-KEY                                /*
AND RECORD-NUMBER >= ##SYSOUT-RECNO                                   /*
  IF NO RECORD FOUND
    COMPRESS '1076' #JES-JOB-NAME TO LG-MSG LEAVING NO
    CALLNAT 'RLOG' PL-PARMS
    END OF TRANSACTION
    ESCAPE BOTTOM (JES.)
  END-NOREC
  PERFORM HANDLE-IT_SPOOL-FILE
END-FIND
*
END-SUBROUTINE /* USER-SEPARATION-JES
*
************************************************************************
DEFINE SUBROUTINE HANDLE-IT_SPOOL-FILE
************************************************************************
IF READ-SPOOL.ERROR-CODE NE 0
  G-NATRP-ERC := 0005
  COMPRESS READ-SPOOL.ERROR-TEXT '/' +NOD-CURRENT-NAME '/' *PROGRAM
    '/' *LINE TO G-NATRP-ERT
  ESCAPE BOTTOM
END-IF
#RECORD := F#CONVERT-RECORD-HEX (<READ-SPOOL.RECORD-HEX1,
  READ-SPOOL.RECORD-HEX2,READ-SPOOL.RECORD-HEX3,
  #TRACING,RMEX-SOURCE-CODEPAGE>)
#RECORD-NUMBER := READ-SPOOL.RECORD-NUMBER
#RECORD-LENGTH := READ-SPOOL.RECORD-LENGTH
IF CACHE AND #RECORD-NUMBER >= ##SYSOUT-RECNO - #CACHE-SIZE
  PERFORM MOVE-RECORD-INTO-CACHE
END-IF
PERFORM TOP-OF-PAGE
IF #RECORD-NUMBER < ##SYSOUT-RECNO            /* go forward within
  ESCAPE TOP                                  /* same find loop
END-IF
RESET #ESC
##CACHE1. REPEAT
  PERFORM SEPARATION-PROCESSING
  IF ##SYSOUT-RECNO < #TOP-RECNO            /* record is not
    RESET #TOP-RECNO                        /* on current page
  END-IF
  DECIDE FOR FIRST CONDITION
    WHEN G-NATRP-ERC NE 0                      /* error occured
      RESET ##REPOSITION                    /* finish processing
      #ESC := TRUE
      ESCAPE BOTTOM
    WHEN RMEX-SOURCE-TYPE=JES2 OR=JES3 AND P-ACTION='ALLJES' AND P-RC=5
      PERFORM ALL-JES-FILES
      #ESC := TRUE
      ESCAPE BOTTOM
    WHEN NOT ##REPOSITION                      /* end of processing
      #ESC := TRUE
      ESCAPE BOTTOM
    WHEN ##SYSOUT-RECNO > RMEX-SOURCE-REC-COUNT    /* Line not within
      RESET ##REPOSITION                    /* range
      #ESC := TRUE
      ESCAPE BOTTOM
    WHEN ##SYSOUT-RECNO = #RECORD-NUMBER       /* process same
      RESET ##REPOSITION                    /* record again
    WHEN ##SYSOUT-RECNO = #CACHE-FROM THRU #CACHE-TO /* rec. in cache
      RESET ##REPOSITION                    /* and reassign
      PERFORM INDICATE-RECORD-IN-CACHE      /* page start
      IF G-NATRP-ERC NE 0
        #ESC := TRUE
        ESCAPE BOTTOM
      END-IF
    WHEN ##SYSOUT-RECNO > #RECORD-NUMBER       /* go forward but use
      RESET ##REPOSITION                    /* same find loop
      ESCAPE BOTTOM
    WHEN ##SYSOUT-RECNO < #RECORD-NUMBER       /* go backward
      PERFORM EMPTY-CACHE                   /* and terminate
      #ESC := TRUE
      ESCAPE BOTTOM
    WHEN NONE
      RESET ##REPOSITION                    /* should not occur
      #ESC := TRUE
      ESCAPE BOTTOM
  END-DECIDE
END-REPEAT /*(##CACHE1.)
IF #ESC
  ESCAPE BOTTOM
END-IF
*
END-SUBROUTINE /* HANDLE-IT_SPOOL-FILE
*
************************************************************************
DEFINE SUBROUTINE USER-SEPARATION-FMVS
************************************************************************
FMVS. FIND READ-FILE WITH NODE = #FMVS-NODE AND DSNAME = #FMVS-DSNAME
AND RECFM = #FMVS-RECFM AND LRECL = #FMVS-LRECL AND SEGMENT-LENGTH = 251
AND BLKSIZE = #FMVS-BLKSIZE AND RECORD-NUMBER >= ##SYSOUT-RECNO       /*
  PERFORM HANDLE-IT_READ-FILE
END-FIND
*
END-SUBROUTINE /* USER-SEPARATION-FMVS
*
************************************************************************
DEFINE SUBROUTINE USER-SEPARATION-FBS2
************************************************************************
IF #USE-ESA /*SU9
  #ESA. FIND READ-FILE-ESA WITH NODE =#FBS2-NODE AND DSNAME=#FBS2-DSNAME
  AND RECORD-NUMBER >= ##SYSOUT-RECNO AND SEGMENT-LENGTH = 251        /*
    MOVE BY NAME READ-FILE-ESA TO READ-FILE
    PERFORM HANDLE-IT_READ-FILE
  END-FIND
ELSE /*NPR
  FBS2. FIND READ-FILE WITH NODE = #FBS2-NODE AND DSNAME = #FBS2-DSNAME
  AND RECORD-NUMBER >= ##SYSOUT-RECNO AND SEGMENT-LENGTH = 251        /*
    PERFORM HANDLE-IT_READ-FILE
  END-FIND
END-IF
*
END-SUBROUTINE /* USER-SEPARATION-FBS2
*
************************************************************************
DEFINE SUBROUTINE HANDLE-IT_READ-FILE
************************************************************************
IF READ-FILE.ERROR-CODE NE 0
  G-NATRP-ERC := 0005
  COMPRESS READ-FILE.ERROR-TEXT '/' +NOD-CURRENT-NAME '/' *PROGRAM
    '/' *LINE TO G-NATRP-ERT
  ESCAPE BOTTOM /*(FVSE.)/(FMVS.)/(#ESA.)/(FBS2.)
END-IF
IF #USE-ESA /*SU9
  #RECORD := READ-FILE.RECORD
ELSE
  #RECORD := F#CONVERT-RECORD-HEX (<READ-FILE.RECORD-HEX1,
    READ-FILE.RECORD-HEX2,READ-FILE.RECORD-HEX3,
    #TRACING,RMEX-SOURCE-CODEPAGE>)
END-IF
#RECORD-NUMBER := READ-FILE.RECORD-NUMBER
#RECORD-LENGTH := READ-FILE.SEGMENT-LENGTH
IF READ-FILE.SEGMENT-NUMBER > 1 AND READ-FILE.SEGMENT-LENGTH < 251
  COMPRESS '§' #RECORD TO #RECORD LEAVING NO /*1. byte is cc-character
  EXAMINE SUBSTRING (#RECORD,1,1) FOR '§' REPLACE WITH ' '
END-IF
IF CACHE AND #RECORD-NUMBER >= ##SYSOUT-RECNO - #CACHE-SIZE
  PERFORM MOVE-RECORD-INTO-CACHE
END-IF
PERFORM TOP-OF-PAGE
IF #RECORD-NUMBER < ##SYSOUT-RECNO              /* go forward within
  ESCAPE TOP /*(FVSE.)/(FMVS.)/(#ESA.)/(FBS2.) same find loop
END-IF
RESET #ESC
##CACHE. REPEAT
  PERFORM SEPARATION-PROCESSING
  IF ##SYSOUT-RECNO < #TOP-RECNO               /* record is not
    RESET #TOP-RECNO                          /* on current page
  END-IF
  DECIDE FOR FIRST CONDITION
    WHEN G-NATRP-ERC NE 0                      /* error occured
      RESET ##REPOSITION                    /* finish processing
      #ESC := TRUE
      ESCAPE BOTTOM
    WHEN NOT ##REPOSITION                      /* end of processing
      #ESC := TRUE
      ESCAPE BOTTOM
    WHEN ##SYSOUT-RECNO > RMEX-SOURCE-REC-COUNT /* Line not within
      RESET ##REPOSITION                    /* range
      #ESC := TRUE
      ESCAPE BOTTOM
    WHEN ##SYSOUT-RECNO = #RECORD-NUMBER       /* process same
      RESET ##REPOSITION                    /* record again
    WHEN ##SYSOUT-RECNO = #CACHE-FROM THRU #CACHE-TO /*rec. in cache
      RESET ##REPOSITION                    /* and reassign
      PERFORM INDICATE-RECORD-IN-CACHE      /* page start
      IF G-NATRP-ERC NE 0
        #ESC := TRUE
        ESCAPE BOTTOM
      END-IF
    WHEN ##SYSOUT-RECNO > #RECORD-NUMBER       /* go forward but use
      RESET ##REPOSITION                    /* same find loop
      ESCAPE BOTTOM
    WHEN ##SYSOUT-RECNO < #RECORD-NUMBER       /* go backward
      PERFORM EMPTY-CACHE                   /* and terminate
      #ESC := TRUE
      ESCAPE BOTTOM                         /* current find loop
    WHEN NONE
      RESET ##REPOSITION                    /* should not occur
      #ESC := TRUE
      ESCAPE BOTTOM
  END-DECIDE
END-REPEAT /*(##CACHE.)
IF #ESC
  ESCAPE BOTTOM /*(FVSE.)/(FMVS.)/(#ESA.)/(FBS2.)
END-IF
*
END-SUBROUTINE /* HANDLE-IT_READ-FILE
*
************************************************************************
DEFINE SUBROUTINE USER-SEPARATION-NOMDB
************************************************************************
#NSMCOMP-BUFFER-LENGTH := 16381 - 7
#NSMCOMP-CODE    := 'N'  /* 'N' - NEW PARM LIST
#NSMCOMP-COMMAND := 'D'
*
#ST-ID           := #NOMDB-ID
#ST-LINE         := ##SYSOUT-RECNO
#RECORD-LENGTH   := RMEX-SOURCE-LRECL
*
READ-NOMDB. READ SOURCE-TEXT BY ST-ID-LINE STARTING FROM #ST-ID-LINE
  IF ST-ID NE #ST-ID
    RESET ##REPOSITION
    ESCAPE BOTTOM (READ-NOMDB.)
  END-IF
  IF #TRACING
    COMPRESS 'read block ID=' ST-ID ',FROM=' #ST-LINE-START
      ',TO=' #ST-LINE-END TO G-TRACE-MSG LEAVING NO
    PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END-IF
  RESET   #NSMCOMP-WORK
  #RECORD-NUMBER := ST-LINE-START
  SUBTRACT 1 FROM #RECORD-NUMBER
  NOMDB-BLOCK. REPEAT
    RESET #NSMCOMP-LINE
    INCLUDE C-NSMCMP 'SOURCE-TEXT.ST-TEXT-LOB'
    DECIDE ON FIRST #NSMCOMP-RC
      VALUE 0
        IGNORE
      VALUE 4
        ESCAPE BOTTOM (NOMDB-BLOCK.)
      NONE
        G-NATRP-ERC := 0005
        #ERC := #NSMCOMP-RC
        MOVE EDITED #NSMCOMP-RC (EM=H(4)) TO G-NATRP-ERT
        COMPRESS 'Compression Routine rc=' G-NATRP-ERT TO G-NATRP-ERT
        RESET  ##REPOSITION
        ESCAPE BOTTOM (READ-NOMDB.)
    END-DECIDE
    ADD 1 TO #RECORD-NUMBER
    IF #TRACING
      COMPRESS 'Decompressing Line=' #RECORD-NUMBER',TXT=' #NSMCOMP-LINE
        TO G-TRACE-MSG LEAVING NO
      PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
    END-IF
    IF #RECORD-NUMBER > ##SYSOUT-RECNO
      RESET  ##REPOSITION
      G-NATRP-ERC := 0005
      G-NATRP-ERT := 'Start Line not found'
      ESCAPE BOTTOM (READ-NOMDB.)
    END-IF
    #RECORD               := #NSMCOMP-LINE
    PERFORM TOP-OF-PAGE
    IF #RECORD-NUMBER < ##SYSOUT-RECNO
      ESCAPE TOP
    END-IF
    NOMDB-RECORD. REPEAT
      PERFORM SEPARATION-PROCESSING
      DECIDE FOR FIRST CONDITION
        WHEN G-NATRP-ERC NE 0
          RESET ##REPOSITION
          ESCAPE BOTTOM (READ-NOMDB.)
        WHEN P-ACTION = 'ALLJES' AND P-RC = 5
          PERFORM ALL-JES-FILES
          ESCAPE BOTTOM (READ-NOMDB.)
        WHEN ##REPOSITION AND                    /* do not reposition
            ##SYSOUT-RECNO > RMEX-SOURCE-REC-COUNT /* if record number
          RESET ##REPOSITION                  /* is out of range
          ESCAPE BOTTOM (READ-NOMDB.)
        WHEN ##REPOSITION AND                    /* process same record
            ##SYSOUT-RECNO = #RECORD-NUMBER     /* again
          RESET ##REPOSITION
        WHEN ##REPOSITION AND                    /* forward within same
            ##SYSOUT-RECNO > #RECORD-NUMBER AND /* block -> decompress
            ##SYSOUT-RECNO <= ST-LINE-END       /* same block from
          RESET ##REPOSITION                  /* current position
          ESCAPE BOTTOM (NOMDB-RECORD.)
        WHEN ##REPOSITION AND                    /* backward within same
            ##SYSOUT-RECNO < #RECORD-NUMBER AND /* block -> decompress
            ##SYSOUT-RECNO >= ST-LINE-START     /* same block from
          RESET ##REPOSITION                  /* beginning
          RESET #NSMCOMP-WORK
          #RECORD-NUMBER := ST-LINE-START
          SUBTRACT 1 FROM #RECORD-NUMBER
          IF ##SYSOUT-RECNO < #TOP-RECNO      /* record is no on
            RESET #TOP-RECNO                 /* current page
          END-IF
          ESCAPE BOTTOM (NOMDB-RECORD.)
        WHEN ##REPOSITION                        /* forward, backward
          IF ##SYSOUT-RECNO < #TOP-RECNO OR   /* not within current
              ##SYSOUT-RECNO > #RECORD-NUMBER + 1
            RESET #TOP-RECNO
          END-IF
          ESCAPE BOTTOM (READ-NOMDB.)
        WHEN NONE                                /* finish processing
          ESCAPE BOTTOM (READ-NOMDB.)
      END-DECIDE
    END-REPEAT
  END-REPEAT
END-READ
*
END-SUBROUTINE /* USER-SEPARATION-NOMDB
*
************************************************************************
DEFINE SUBROUTINE TOP-OF-PAGE
************************************************************************
IF (#REC-CC = H'89' AND RMEX-SOURCE-CC-TYPE = MACHINE-CODE)
OR (#REC-CC = H'8B' AND RMEX-SOURCE-CC-TYPE = MACHINE-CODE)           /*
OR (#REC-CC = '1'   AND RMEX-SOURCE-CC-TYPE = ASA-CODE)               /*
OR (#REC-CC = H'81' AND RMEX-SOURCE-CC-TYPE = BS2000-CC)              /*
OR (#REC-CC = 'A'   AND RMEX-SOURCE-CC-TYPE = BS2000-CC)              /*
OR #RECORD-NUMBER = 1                                                 /*
  IF (#REC-CC = H'89' AND RMEX-SOURCE-CC-TYPE = MACHINE-CODE)
  OR (#REC-CC = H'81' AND RMEX-SOURCE-CC-TYPE = BS2000-CC)            /*
    #TOP-RECNO := #RECORD-NUMBER + 1
  ELSE
    #TOP-RECNO := #RECORD-NUMBER
  END-IF
END-IF
*
END-SUBROUTINE /* TOP-OF-PAGE
*
************************************************************************
DEFINE SUBROUTINE SEPARATION-PROCESSING
************************************************************************
GET-IT := TRUE
*
IF #TOP-RECNO = #RECORD-NUMBER
  TOP-OF-PAGE := TRUE
ELSE
  RESET TOP-OF-PAGE
END-IF
*
IF TOP-OF-PAGE AND GOTO-NEXT-PAGE
  GOTO-NEXT-PAGE := FALSE
  IF ##FILTER-BY-NAT OR ##FILTER-BY-ASM
    SW-EXIT := TRUE
  END-IF
END-IF
*
IF GOTO-NEXT-PAGE AND NOT TOP-OF-PAGE
  ##REPOSITION   := TRUE
  ##SYSOUT-RECNO := #RECORD-NUMBER + 1
  ESCAPE ROUTINE
END-IF
*
IF #ADD-PAGE > 0 AND TOP-OF-PAGE
  SUBTRACT 1 FROM #ADD-PAGE
  IF ##FILTER-BY-NAT OR ##FILTER-BY-ASM
    SW-EXIT := TRUE
  END-IF
END-IF
*
IF #ADD-PAGE > 0
  SW-EXIT := FALSE
  GET-IT := TRUE
END-IF
*
IF SW-EXIT
  PERFORM CALL-USER-EXIT
  PERFORM EXIT-ACTION
ELSE
  IF GET-IT
    ##REPORT-IS-OPENED := TRUE
    IF ##PREVIOUS-IN
      ##END-LINE := #RECORD-NUMBER
    ELSE
      ##START-LINE := ##END-LINE := #RECORD-NUMBER
      ##PREVIOUS-IN := TRUE
    END-IF
    ADD 1 TO ##REC-COUNT
    IF ##IN-NRM
      ADD 1 TO ##CUR-RECORD
      #TEXT-ARRAY(##CUR-RECORD) := #RECORD
      IF #RECORD-LENGTH > 251
        #RECORD-LENGTH := 251
      END-IF
      ##RECLEN-VEC(##CUR-RECORD) := #RECORD-LENGTH
      IF ##CUR-RECORD = #CUR-RECORD-MAX
        PERFORM PROCESS-BUFFER
        RESET ##CUR-RECORD #TEXT-ARRAY(1:20) ##RECLEN-VEC(*)
      END-IF
    END-IF
  ELSE
    IF ##PREVIOUS-IN
      RESET ##PREVIOUS-IN
      PERFORM STORE-REPORT-CONTENTS
    END-IF
  END-IF
  ##REPOSITION := TRUE
  ##SYSOUT-RECNO := #RECORD-NUMBER + 1
END-IF
*
END-SUBROUTINE /* SEPARATION-PROCESSING
*
************************************************************************
DEFINE SUBROUTINE CALL-USER-EXIT
************************************************************************
RESET P-BUNDLE (*)
MONIT-GL.P-RECORD                 := #RECORD
MONIT-GL.P-RECNO                  := #RECORD-NUMBER
MONIT-GL.P-MASTER                 := ##MASTER-REPNAME
MONIT-GL.P-REPNAME                := G-REPORT
MONIT-GL.P-SOURCE-NUMBER-OF-LINES := RMEX-SOURCE-REC-COUNT
MONIT-GL.P-SOURCE-ATTRIBUTES      := RMEX-SOURCE-ATTRIBUTES
MONIT-GL.P-SOURCE-TYPE := #P-SOURCE-TYPE-BIN := RMEX-SOURCE-TYPE
CALLNAT 'RMSR7--N' MONIT-GL.P-SOURCE-ATTRIBUTES #P-SOURCE-TYPE-BIN
MONIT-GL.P-SOURCE-CC-TYPE := RMEX-SOURCE-CC-TYPE
IF #RECORD-LENGTH > 251
  #RECLEN := 251
ELSE
  #RECLEN := #RECORD-LENGTH
END-IF
MONIT-GL.P-SOURCE-RECORD-LENGTH   := #RECLEN
P-SPOOL-ATTRIBUTES := RMEX-SPOOL-ATTRIBUTES
*
IF ##FILTER-BY-NAT
  IF #TRACING
    COMPRESS 'Call Exit=' ##EXITMEM ',Lib=' #CMUB-STEPLIB
      TO G-TRACE-MSG LEAVING NO
    PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END-IF
  P-UPARM1 (1:5) := REPORTS.R-UPARMS (1:5)
  CALLNAT ##EXITMEM P-EXIT-PARMS
  IF 1 NE 1 /*NEVER ÜÜ
    CALLNAT 'UEXDEF' P-EXIT-PARMS /*for CAT: just to check parms
  END-IF
  IF #TRACING
    MOVE 'CPU consumed so far:' TO G-TRACE-MSG
    PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
    RMSETTIM.FUNCTION := 'G'
    PERFORM RMSETTIM-SETTIME RMSETTIM
    PERFORM XXRLOG-WRITE-LOG 'T' RMSETTIM.MSG
  END-IF
END-IF
IF ##FILTER-BY-ASM
  CALL  REPORTS.R-ASM-EXIT P-RC
  IF #TRACING
    MOVE 'CPU consumed so far:' TO G-TRACE-MSG
    PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
    RMSETTIM.FUNCTION := 'G'
    PERFORM RMSETTIM-SETTIME RMSETTIM
    PERFORM XXRLOG-WRITE-LOG 'T' RMSETTIM.MSG
  END-IF
END-IF
*
END-SUBROUTINE /* CALL-USER-EXIT
*
************************************************************************
DEFINE SUBROUTINE EXIT-ACTION
************************************************************************
DECIDE ON FIRST VALUE OF P-RC
  VALUE 0  GET-IT := TRUE
  VALUE 1  GET-IT := FALSE
  VALUE 3  ESCAPE ROUTINE
  VALUE 5
    IF P-ACTION = 'ALLJES'
      ESCAPE ROUTINE
    END-IF
  NONE     IGNORE
END-DECIDE
*
IF #TRACING
  #ERC := P-RC
  COMPRESS 'RC from Exit = ' P-RC #ERC TO G-NATRP-ERT
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
*
IF GET-IT
  ##REPORT-IS-OPENED := TRUE
  IF ##PREVIOUS-IN
    ##END-LINE := #RECORD-NUMBER
  ELSE
    ##START-LINE := ##END-LINE := #RECORD-NUMBER
    ##PREVIOUS-IN := TRUE
  END-IF
  ADD 1 TO ##REC-COUNT
  IF ##IN-NRM
    ADD 1 TO ##CUR-RECORD
    #TEXT-ARRAY (##CUR-RECORD) := #RECORD
    IF #RECORD-LENGTH > 251
      #RECORD-LENGTH := 251
    END-IF
    ##RECLEN-VEC(##CUR-RECORD) := #RECORD-LENGTH
    IF ##CUR-RECORD = #CUR-RECORD-MAX
      PERFORM PROCESS-BUFFER
      RESET ##CUR-RECORD #TEXT-ARRAY(1:20) ##RECLEN-VEC(*)
    END-IF
  END-IF
ELSE
  IF ##PREVIOUS-IN
    RESET ##PREVIOUS-IN
    PERFORM STORE-REPORT-CONTENTS
  END-IF
END-IF
*
DECIDE ON EVERY VALUE OF P-ACTION
  VALUE 'CACHEON'
    CACHE := TRUE
    ##SYSOUT-RECNO := #RECORD-NUMBER
    ##REPOSITION := TRUE
  VALUE 'CACHEOFF'
    IF CACHE
      CACHE := FALSE
      PERFORM EMPTY-CACHE
    END-IF
    ##SYSOUT-RECNO := #RECORD-NUMBER
    ##REPOSITION := TRUE
  VALUE 'FORW'
    ##SYSOUT-RECNO := #RECORD-NUMBER + P-RECNO
  VALUE 'BACKW'
    ##SYSOUT-RECNO := #RECORD-NUMBER - P-RECNO
  VALUE 'GOTO'
    ##REPOSITION := TRUE
    ##SYSOUT-RECNO := P-RECNO
  VALUE 'TOPP','GOTOP'
    ##REPOSITION := TRUE
    IF #TOP-RECNO > 0
      ##SYSOUT-RECNO := #TOP-RECNO
    ELSE
      RMGT-PARMS.P-RECORD-NUMBER := #RECORD-NUMBER
      RESET  RMGT-PARMS.P-TOP-RECORD
      RMGT-PARMS.P-CC-TYPE     := RMEX-SOURCE-CC-TYPE
      RMGT-PARMS.P-SOURCE-TYPE := RMEX-SOURCE-TYPE
      RMGT-PARMS.P-CODEPAGE    := RMEX-SOURCE-CODEPAGE
      RMGT-PARMS.P-SOURCE-ATTRIBUTES := RMEX-SOURCE-ATTRIBUTES
      CALLNAT 'RMGT---N' RMGT-PARMS RMEX-SOURCE-ISN
      IF RMGT-PARMS.P-ERROR-CODE NE 0
        G-NATRP-ERC := RMGT-PARMS.P-ERROR-CODE
        G-NATRP-ERT := RMGT-PARMS.P-ERROR-TEXT
      ELSE
        #TOP-RECNO := ##SYSOUT-RECNO := RMGT-PARMS.P-TOP-RECORD
      END-IF
    END-IF
  VALUE 'NEXTP'
    GOTO-NEXT-PAGE := ##REPOSITION := TRUE
    ##SYSOUT-RECNO := #RECORD-NUMBER + 1
  VALUE 'FORW','BACKW','GOTO','TOPP','NEXTP', 'GOTOP'
    ##REPOSITION := TRUE
    IF ##PREVIOUS-IN
      PERFORM STORE-REPORT-CONTENTS
    END-IF
    RESET ##PREVIOUS-IN
  VALUE 'ADDP'
    #ADD-PAGE := 1
    ##REPOSITION := TRUE
    ##SYSOUT-RECNO := #RECORD-NUMBER
  VALUE 'ADDFP'
    IF #TOP-RECNO > 0
      ##SYSOUT-RECNO := #TOP-RECNO
    ELSE
      RMGT-PARMS.P-RECORD-NUMBER := #RECORD-NUMBER
      RESET  RMGT-PARMS.P-TOP-RECORD
      RMGT-PARMS.P-CC-TYPE     := RMEX-SOURCE-CC-TYPE
      RMGT-PARMS.P-SOURCE-TYPE := RMEX-SOURCE-TYPE
      RMGT-PARMS.P-CODEPAGE    := RMEX-SOURCE-CODEPAGE
      RMGT-PARMS.P-SOURCE-ATTRIBUTES := RMEX-SOURCE-ATTRIBUTES
      CALLNAT 'RMGT---N' RMGT-PARMS RMEX-SOURCE-ISN
      IF RMGT-PARMS.P-ERROR-CODE NE 0
        G-NATRP-ERC := RMGT-PARMS.P-ERROR-CODE
        G-NATRP-ERT := RMGT-PARMS.P-ERROR-TEXT
      ELSE
        #TOP-RECNO     := RMGT-PARMS.P-TOP-RECORD
        ##SYSOUT-RECNO := RMGT-PARMS.P-TOP-RECORD
      END-IF
    END-IF
    #ADD-PAGE := 2
    ##REPOSITION := TRUE
  VALUE 'ADDR'
* NPR V3 has to read spool-files from the beginning whenever you
* reposition (NPR V2 had some sort of fast index) so performance is
* very bad when using ADDR extensively for reports stored on NOM DB
* (because RMADDRAN does a FIND READ-SPOOL for the range to be added).
* In the case of the customer who reported p(255079), their exit only
* ever uses ADDR to add the current line - we can avoid using RMADDRAN
* for that and improve performance back to what it was with NPR 2.2.
    IF P-FROMLINE = P-TOLINE           /* only 1 line?
        AND P-FROMLINE = #RECORD-NUMBER    /* and it's the current line?
      RESET P-RC                       /* if so, convert it to a normal
        P-ACTION                   /* 'include current line'
      PERFORM EXIT-ACTION
      ESCAPE ROUTINE
    END-IF
    IF ##PREVIOUS-IN
      PERFORM STORE-REPORT-CONTENTS
    END-IF
    IF ##IN-NRM
      PERFORM ADD-RANGE #RMEXSEPA
    ELSE
      ##REC-COUNT := ##REC-COUNT + (P-TOLINE - P-FROMLINE + 1)
    END-IF
    ##REPORT-IS-OPENED := TRUE
    ##START-LINE := P-FROMLINE
    ##END-LINE := P-TOLINE
    PERFORM STORE-REPORT-CONTENTS
    RESET ##PREVIOUS-IN
    ##SYSOUT-RECNO := P-TOLINE + 1
    ##REPOSITION := TRUE
  VALUE 'CLOSE'
    ##CLOSE-REPORT := TRUE
    PERFORM OVERWRITE-PARMS
    PERFORM CLOSE-REPORT RMEX-SPOOL-ATTRIBUTES /*RMCLSREP
  VALUE 'OPEN'
    IF ##REPORT-IS-OPENED
      PERFORM CLOSE-REPORT RMEX-SPOOL-ATTRIBUTES /*RMCLSREP
    END-IF
    PERFORM OPEN-NEW-REPORT #RMEXSEPA
    ##SYSOUT-RECNO := #RECORD-NUMBER
    ##REPOSITION := TRUE
  VALUE 'CREATE'
    PERFORM CREATE-REPORT #RMEXSEPA /*RMCRTREP
  VALUE 'BUNDLE'
    IF P-BUNDLE (*) NE ' '
      G-REPORT := P-REPNAME
      FOR #I 1 TO 5
        IF P-BUNDLE (#I) = ' '
          ESCAPE TOP
        END-IF
        G-BUNDLE := P-BUNDLE (#I)
        G-COPIES := P-COPIES (#I)
        G-BUNDLE-SEPNO        := P-BUNDLE-SEPNO
        G-BUNDLE-SEPSTART     := P-BUNDLE-SEPSTART
        G-BUNDLE-SEPEND       := P-BUNDLE-SEPEND
        G-BUNDLE-JOBCARDS (*) := P-BUNDLE-JOBCARDS (*)
        G-BUNDLE-COORDINATOR  := P-BUNDLE-COORDINATOR
        IF P-BUNDLE-PRINTERS (*) NE ' '
          G-BUNDLE-PRINTERS (*) := P-BUNDLE-PRINTERS (*)
          G-BUNDLE-PRINTERS-COPIES (*) := P-BUNDLE-PRINTERS-COPIES (*)
        ELSE
          G-BUNDLE-PRINTER := P-PRINTERS (1)
        END-IF
        PERFORM DEFINE-REPORT-IN-BUNDLE
      END-FOR
    END-IF
    ##REPOSITION := TRUE
    ##SYSOUT-RECNO := #RECORD-NUMBER
  VALUE 'INSL'
    IF ##PREVIOUS-IN
      ##END-LINE := #RECORD-NUMBER
    END-IF
    PERFORM INSERT-LINES
    G-INSERTED := 'Y'
    ##REPOSITION := TRUE
    ##SYSOUT-RECNO := #RECORD-NUMBER + 1
  NONE VALUE
    ##REPOSITION := TRUE
    ##SYSOUT-RECNO := #RECORD-NUMBER + 1
END-DECIDE
*
IF #TRACING
  COMPRESS 'Action=' P-ACTION ',p-repname=' P-REPNAME
    ',p-recno=' P-RECNO ',p-from=' P-FROMLINE ',p-to=' P-TOLINE
    TO G-TRACE-MSG LEAVING NO
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
*
END-SUBROUTINE /* EXIT-ACTION
*
************************************************************************
DEFINE SUBROUTINE MOVE-RECORD-INTO-CACHE
************************************************************************
ADD 1 TO #CACHE-POINTER
IF #CACHE-POINTER > #CACHE-SIZE
  #CACHE-POINTER := 1
END-IF
*
#CACHE-RECORD-NUMBER (#CACHE-POINTER) := #RECORD-NUMBER
#CACHE-RECORD-LENGTH (#CACHE-POINTER) := #RECORD-LENGTH
#CACHE-RECORD        (#CACHE-POINTER) := #RECORD
#CACHE-TO                             := #RECORD-NUMBER
*
IF #CACHE-POINTER = #CACHE-SIZE
  #FROM-POINTER := 1
ELSE
  #FROM-POINTER := #CACHE-POINTER + 1
END-IF
*
IF #CACHE-RECORD-NUMBER (#FROM-POINTER) > 0
  #CACHE-FROM := #CACHE-RECORD-NUMBER (#FROM-POINTER)
ELSE
  #CACHE-FROM := #CACHE-RECORD-NUMBER (1)
END-IF
*
END-SUBROUTINE /* MOVE-RECORD-INTO-CACHE
*
************************************************************************
DEFINE SUBROUTINE EMPTY-CACHE
************************************************************************
IF CACHE
  RESET #CACHE (*) #CACHE-POINTER #CACHE-FROM #CACHE-TO
END-IF
*
END-SUBROUTINE /* EMPTY-CACHE
*
************************************************************************
DEFINE SUBROUTINE INDICATE-RECORD-IN-CACHE
************************************************************************
IF #CACHE-POINTER = #CACHE-SIZE
OR #CACHE-RECORD-NUMBER (#CACHE-POINTER + 1) = 0                      /*
  #FROM-POINTER := 1
ELSE
  #FROM-POINTER := #CACHE-POINTER + 1
END-IF
*
INDICATE. REPEAT
  #RECORD        := #CACHE-RECORD       (#FROM-POINTER)
  #RECORD-LENGTH := #CACHE-RECORD-LENGTH (#FROM-POINTER)
  #RECORD-NUMBER := #CACHE-RECORD-NUMBER (#FROM-POINTER)
  PERFORM TOP-OF-PAGE
  IF #CACHE-RECORD-NUMBER (#FROM-POINTER) = ##SYSOUT-RECNO
    ESCAPE BOTTOM (INDICATE.)
  END-IF
  ADD 1 TO #FROM-POINTER
  IF #FROM-POINTER > #CACHE-SIZE
    #FROM-POINTER := 1
  END-IF
  IF #CACHE-RECORD-NUMBER (#FROM-POINTER) = 0 OR
      #CACHE-RECORD-NUMBER (#FROM-POINTER) > ##SYSOUT-RECNO
    G-NATRP-ERC := 0005
    G-NATRP-ERT := 'Error in Cache Routine'
    ESCAPE BOTTOM (INDICATE.)
  END-IF
END-REPEAT
*
END-SUBROUTINE /* INDICATE-RECORD-IN-CACHE
*
************************************************************************
DEFINE SUBROUTINE ALL-JES-FILES
************************************************************************
#SPOOL-ATTRIBUTES:= RMEX-SPOOL-ATTRIBUTES
CALLNAT 'RMSPL7-N'#SPOOL-ATTRIBUTES #SPOOL-TYPE /*conv. Jobnr & node nr
FIND (1) READ-SPOOL WITH NODE = #SPOOL-JES-NODE
AND JOB-NAME = #SPOOL-JES-JOB-NAME AND RECORD-NUMBER GE -1            /*
AND JOB-NUMBER = #SPOOL-JES-JOB-NUMBER AND TYPE = 'AL'                /*
  IF NO RECORDS FOUND
    WRITE *PROGRAM *TIMX (EM=YYYY-MM-DD' 'HH:II:SS)
      'Error reading TYPE=AL for' #SPOOL-JES-JOB-NAME
      #SPOOL-JES-JOB-NUMBER
      / 'no records found'
    ESCAPE BOTTOM
  END-NOREC
  IF READ-SPOOL.ERROR-CODE NE 0
    WRITE *PROGRAM *TIMX (EM=YYYY-MM-DD' 'HH:II:SS)
      'Error reading TYPE=AL for' #SPOOL-JES-JOB-NAME
      #SPOOL-JES-JOB-NUMBER
      / READ-SPOOL.ERROR-CODE READ-SPOOL.ERROR-TEXT
    ESCAPE BOTTOM
  END-IF
  UPDSRC. FIND NRM-SOURCE WITH SR-ID = RMEX-SOURCE-ID
    IF NO RECORDS FOUND
      WRITE *PROGRAM *TIMX (EM=YYYY-MM-DD' 'HH:II:SS)
        'Unable to update source -' 'Id' RMEX-SOURCE-ID 'not found'
      ESCAPE BOTTOM
    END-NOREC
    ##REPOSITION:= TRUE                /* force processing to start
    ##SYSOUT-RECNO:= 1                 /* again at line 1
    IF MONIT-GL.P-SOURCE-TYPE = NOM-DATA-BASE
      MONIT-GL.P-SOURCE-TYPE:= RMEX-SOURCE-TYPE := #SPOOL-TYPE
      RESET #SOURCE-ATTRIBUTES
      #JES-NODE         := #SPOOL-JES-NODE
      #JES-JOB-NAME     := #SPOOL-JES-JOB-NAME
      #JES-JOB-NUMBER   := #SPOOL-JES-JOB-NUMBER
      #JES-DATA-SET-KEY := #SPOOL-JES-DATASET-KEY
      #JES-PROCNAME     := #SPOOL-JES-PROCNAME
      #JES-STEPNAME     := #SPOOL-JES-STEPNAME
      #JES-DDNAME       := #SPOOL-JES-DDNAME
      #JES-DATA-SET     := #SPOOL-JES-DSNO
    END-IF
    #JES-TYPE := #SPOOL-JES-DSTYPE:= 'AL'
    MONIT-GL.P-SOURCE-ATTRIBUTES:= RMEX-SOURCE-ATTRIBUTES
      := #SOURCE-ATTRIBUTES
    P-SPOOL-ATTRIBUTES  := RMEX-SPOOL-ATTRIBUTES := #SPOOL-ATTRIBUTES
    SR-TYPE             := MONIT-GL.P-SOURCE-TYPE
    RMEX-SOURCE-REC-COUNT := RECORD-NUMBER
    SR-ATTRIBUTES-IDENT := RMEX-SOURCE-ATTRIBUTES
    SR-SPOOL-ATTRIBUTES := RMEX-SPOOL-ATTRIBUTES
    SR-RECORD-LENGTH    := RMEX-SOURCE-LRECL
    SR-CONTROL-FLAG     := 'X'
    DECIDE ON FIRST VALUE OF +CARRIAGE-CONTROL
      VALUE 'A'  SR-CC-TYPE := ASA-CODE
      VALUE 'M'  SR-CC-TYPE := MACHINE-CODE
      NONE       SR-CC-TYPE := NO-CC
    END-DECIDE
    REPEAT
      CALLNAT 'RMSRID-N' NRM-SOURCE.SR-ID G-NATRP-ERC G-NATRP-ERT
      UNTIL G-NATRP-ERC NE 3145
    END-REPEAT
*
    IF G-NATRP-ERC NE 0
      WRITE *PROGRAM *TIMX (EM=YYYY-MM-DD' 'HH:II:SS)
        'Unable to create new source record'
      ESCAPE BOTTOM
    END-IF
    RMEX-SOURCE-ID := NRM-SOURCE.SR-ID
    SR-OBJECT-TYPE := 'SR'
    SR-OBJECT-TIME := *TIMX
    STORE NRM-SOURCE
    GETAREP. GET ACTIVE-REPORTS +G-ACTIVE-ISN-P10
    ACTIVE-REPORTS.AR-SPOOL-ATTRIBUTES := RMEX-SPOOL-ATTRIBUTES
    ACTIVE-REPORTS.AR-SOURCE-ID        := RMEX-SOURCE-ID
    IF RMEX-SOURCE-LRECL GT ACTIVE-REPORTS.AR-RECORD-LENGTH
      ACTIVE-REPORTS.AR-RECORD-LENGTH   := RMEX-SOURCE-LRECL
    END-IF
    ACTIVE-REPORTS.AR-CC-TYPE := SR-CC-TYPE
    UPDATE (GETAREP.)
    END TRANSACTION
  END-FIND
END-FIND
*
END-SUBROUTINE /* ALL-JES-FILES
*
END-SUBROUTINE /* PROCESS-USER-SEPARATION
*
END
