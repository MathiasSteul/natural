* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RMCRTPRT - Create printout record for automatic report print
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* gw  93-07-06           clean up
* gw  94-05-13 s(999999) new field po-esy-userid
* mrs 95-03-23 s(221931) not all lines printed when report is reopened
*                        because to-line is the number of lines at
*                        first open
* gw  96-07-18 s(999999) extended attributes BS2
* gw  96-11-06 s(257035) logon with report owner only if G-USE-OWNER
* gw  97-01-13 s(259980) if 0 set copies to 1
* SJU 97-04-16 P(162097) ALLOW LAYOUT FOR AUTO-PRINTED REPORTS
* JWO 97-05-07 P(162258) set correct SPACE parameter for BS2000
* mwi 97-06-10 p(162737) spool-attr account-number
* jwo 97-09-22  p(165064) new logic to get PO-ID
* sju 00-11-28 p(203645) copies on printer ignored
* xsetggr 01-09-25 p(205839) allow headerlines for auto-printed reports
* sju 03-06-02 p(241125) not all lines of separated report printed
* sju 03-12-15 p(248535) Default print class not taken
* sju 2004-04-22 p(250355) correct handling of recfm
* sju 04-12-07 NOM31     Tracing
* sju 2005-01-12 p(260836) correct handling of recfm
* fhi 05-12-14 P272732   cataloged, because VPRINT-L was changed.
* xsetggr 2007-06-27 NOM3201   support 5 byte node and 11 byte run numbe
*                              numbers, restow - changes in eompom-parms
* xsetggr 2007-10-25 NRT2185   default values for UNIXLP printers
* xsetggr 2008-02-18 p(301593) not release printouts for dtopped printer
* xsetggr 2008-11-28 p(311915) default printers DEFAULTA - DEFAULTZ
* fhi     2009-05-19 N3463     Extend metadata for OPO
* xsetggr 2009-09-01 P314431   allow only NATUNIX&DISKUNIX printers for
*                       Unix systems, UNIXLP printers only for mainframe
* fhi     2010-10-08 NOMALL-97 Use dynamic memory handling
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* xsetggr 2010-11-15 NOMALL-865 restow due to changes in EOMPHTYE
* raya    2012-02-12 NOMALL-98   check exit member to avoide err 82
*                    if not exist no printouts
* raya    2012-04-18 NOMALL-98   change err 1585 TO 1587 remove-steplib
* raya    2012-06-20 NOMALL-1142 add lib to add-steplib
* raya    2013-01-03 NOMALL-1214 check cat date to exit member
* raya    2013-09-10 NOMALL-932  use dynamic instead of array
* SU1     2014-11-17 NOMALL-1450 fill fields for Adabas Vista
* fhi     2016-04-23 NOMALL-1846 Avoid Ada response 3144
* fhi     2016-12-02 NOMALL-1621 +NOD-LOCAL-NODE instead of G-MONITOR-NODE
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* fhi     2017-04-07 NOMALL-1961 Omit field PO-MONITOR
* SU2     2019-01-16 NOMALL-2085 NOM35 printer:sep.pages
* SU4     2020-05-18 NOMALL-2349 use N-CHKCAT
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING  MONIT-GL
PARAMETER
1 RMEX-SPOOL-ATTRIBUTES   (A250) /*OPTIONAL /*SU2
************************************************************************
INDEPENDENT
1 +G-SPOOL-ATTR-EXTENDED (A) DYNAMIC
1 +IN-SEPARATION         (L)
1 +NOD-LOCAL-NODE        (N5)
1 +CMRDC                 (A1)
* *****
LOCAL USING VPRINT-L
LOCAL USING VPRRP-L
LOCAL USING EOMPOM-P
LOCAL USING EOMPHTYE
* *****
LOCAL
1 PHYSICAL-PRINTER VIEW OF NRM-PHYSICAL-PRINTERS
  2 PH-VTAMID
  2 PH-ESCAPE-CHAR
  2 PH-JCL-SKELETON
  2 PH-PRINT-PGM
  2 PH-PRINTER-TYPE
  2 PH-STATUS
1 DEFAULT-PRINTERS VIEW OF NRM-PRINTERS
  2 P-ID
  2 P-PHYSICAL-NAME
  2 P-ATTRIBUTES    (1:25)
1 PRINT-LAYOUT VIEW OF NRM-REP-TARGET
  2 RD-LAYOUT
    3 RD-FROM       (1:10)
    3 RD-TO         (1:10)
  2 RD-HEADLINES
*
1 #MAX-POID         (N7)
1 #P                (P3)
1 #I                (I2)
1 #VAR              (A16)
1 #VALUE            (A72)
1 #RMPOID-FUNC      (A1)
1 #J                (I2)
1 #RESET-RECFM      (L)
1 #P-ID-E           (A8)
1 #P-ID             (A8) INIT <'DEFAULT'>
1 REDEFINE #P-ID
  2 #P-ID-1         (A7)
  2 #SUFFIX         (A1)
1 #BS2-SPOOL-ATTR-EXTENDED  (A750)
1 #TRACING          (L)
1 #CAT-DATE-1       (A10)
1 #CAT-DATE-2       (A10)
1 #CALLER           (A8) INIT <*PROGRAM>
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE CREATE-PRINTOUTS
************************************************************************
*
IF G-TRACE GE *LEVEL AND G-TRACE-SET = SCAN ('CREATE')
  #TRACING := TRUE
  COMPRESS 'Start' *PROGRAM G-REPORT G-REPRNB G-PRINTERS-P (*)
    TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
INCLUDE CMRDC
FOR #P 1 TO G-JPRINTER-NO
  FNDP. FIND PRINTERS WITH P-ID = G-PRINTERS-P(#P)
    IF P-EXITMEM NE ' ' AND P-EXITLIB NE ' '
      CALLNAT 'N-CHKCAT' G-NATRP-ERC G-NATRP-ERT P-EXITMEM /*SU4
        P-EXITLIB #CALLER #CAT-DATE-1 #CAT-DATE-2 'X' /*no ET Ü
      IF G-NATRP-ERC = 1591 OR=1592
        COMPRESS P-EXITLIB '(' P-EXITMEM ')' TO G-TRACE-MSG LEAVING NO
        COMPRESS '1587' G-REPORT G-TRACE-MSG G-PRINTERS-P(#P)
          TO G-TRACE-MSG /*Rejected printout :1:, prt. exit :2: in :3:..
        PERFORM XXRLOG-WRITE-LOG 'W' G-TRACE-MSG
        ESCAPE ROUTINE
      END-IF
    END-IF
*
    FPH. FIND (1) PHYSICAL-PRINTER WITH PH-VTAMID = P-PHYSICAL-NAME
      IF *MACHINE-CLASS = 'MAINFRAME'
        IF PH-PRINTER-TYPE = ##PHYS-NATUNIX
          ESCAPE BOTTOM (FPH.)
        END-IF
      ELSE
        IF NOT(PH-PRINTER-TYPE = ##PHYS-DISKUNIX OR = ##PHYS-NATUNIX)
          ESCAPE BOTTOM (FPH.)
        END-IF
      END-IF
*
      RESET PRINTOUTS
      #RMPOID-FUNC := 'M'
      CALLNAT 'RMPOID-N' PRINTOUTS.PO-ID G-NATRP-ERC G-NATRP-ERT
        #RMPOID-FUNC
      PRINTOUTS.PO-ID-INV := 9999998 - PRINTOUTS.PO-ID
*
      PERFORM ASSIGN-PO-COPIES
      PO-PRINT-SEPARATION := G-PRINTERS-S (#P) /*SU2
      PO-NODE        := +NOD-LOCAL-NODE
      PO-CREATED     := *TIMX
      PO-ESCAPE-CHAR := PH-ESCAPE-CHAR
      PO-EXITLIB     := P-EXITLIB
      PO-EXITMEM     := P-EXITMEM
      RESET PO-FROM-LINE
      IF PH-STATUS NE 'S'
        IF G-HOLD = 'H' OR = 'C'
          PO-STATUS := G-HOLD
        ELSE
          PO-STATUS := 'R'
        END-IF
      ELSE
        IF G-HOLD = 'H' OR = 'C'
          PO-HOLD := G-HOLD
        END-IF
        PO-STATUS := 'S'
      END-IF
      PO-JCL-SKELETON := PH-JCL-SKELETON
*
      PERFORM ASSIGN-PO-JOBCARD
*
      PO-LANGUAGE      := *LANGUAGE
      PO-LOGICAL       := P-ID
      PO-PHYSICAL-NAME := P-PHYSICAL-NAME
      PO-PRINT-PGM     := PH-PRINT-PGM
      PO-PRINTER-TYPE  := PH-PRINTER-TYPE
      PO-PRIORITY      := P-PRIORITY
      PO-REPNAME       := G-REPORT
      PO-REPRNB        := G-REPRNB
*
      IF PO-STATUS = 'R'
        PERFORM ASSIGN-PO-SCHEDULED
      ELSE
        RESET PO-SCHEDULED
      END-IF
      RESET PO-TO-LINE
      PO-USERID := ACTIVE-REPORTS.AR-USERID
      IF G-USE-OWNER
        PO-ESY-USERID := ACTIVE-REPORTS.AR-USERID
      ELSE
        RESET PO-ESY-USERID
      END-IF
      PERFORM ASSIGN-PO-ATTRIBUTES
      FIND PRINT-LAYOUT WITH RD-REPNAME = G-REPORT
      AND RD-TARGET-ID = 'AUTOPRNT'                                   /*
        PO-LAYOUT-FROM(1:10):= RD-FROM(1:10)
        PO-LAYOUT-TO  (1:10):= RD-TO  (1:10)
        PO-HEADLINES := RD-HEADLINES
      END-FIND
      IF +IN-SEPARATION
        EXAMINE PO-STATUS TRANSLATE INTO LOWER
      END-IF
      PO-OBJECT-TYPE := 'PO'
      PO-OBJECT-TIME := *TIMX
      STORE PRINTOUTS
      ADD 1 TO #MAX-POID
    END-FIND
  END-FIND
END-FOR
*
************************************************************************
* End of main line (now subroutines):
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE ASSIGN-PO-ATTRIBUTES
************************************************************************
PO-ATTRIBUTES (*) := PRINTERS.P-ATTRIBUTES (*)
RESET #RESET-RECFM
*
FOR #I 1 25
  IF P-ATTR-VAR(#I) = 'DCB1' OR = 'DCB2'
    EXAMINE PRINTERS.P-ATTR-VALUE(#I) FOR 'RECFM=' GIVING INDEX #J
    IF #J GT 0
      #RESET-RECFM:= TRUE
    END-IF
  END-IF
  IF PRINTERS.P-ATTR-VALUE (#I) = ' '
    #BS2-SPOOL-ATTR-EXTENDED := +G-SPOOL-ATTR-EXTENDED /*nomall-932 in
    CALLNAT 'RPRTATTN' RMEX-SPOOL-ATTRIBUTES #BS2-SPOOL-ATTR-EXTENDED
      PRINTERS.P-ATTR-VAR (#I) PRINTERS.P-ATTR-VALUE (#I)
      ACTIVE-REPORTS.AR-CC-TYPE
    IF PRINTERS.P-ATTR-VAR(#I) = 'CLASS' AND P-ATTR-VALUE(#I) = ' '
      PRINTERS.P-ATTR-VALUE(#I):= G-PRINT-CLASS
    END-IF
    IF PRINTERS.P-ATTR-VAR(#I) = 'RECFM' AND #RESET-RECFM
      RESET #RESET-RECFM PRINTERS.P-ATTR-VALUE(#I)
    END-IF
    IF PH-PRINTER-TYPE = ##PHYS-UNIXLP AND P-ATTR-VALUE (#I) = ' '
      PERFORM DEFAULT-UNIXLP-VALUES
    ELSE
      PO-ATTRIBUTES (#I) := PRINTERS.P-ATTRIBUTES (#I)
    END-IF
  END-IF
END-FOR
*
END-SUBROUTINE /* ASSIGN-PO-ATTRIBUTES
*
************************************************************************
DEFINE SUBROUTINE DEFAULT-UNIXLP-VALUES
************************************************************************
#SUFFIX := 'Z'
#P-ID-E := #P-ID
* RESET #SUFFIX
#SUFFIX := 'A'
FIND (1) DEFAULT-PRINTERS WITH P-PHYSICAL-NAME = PH-VTAMID
WHERE P-ID = #P-ID THRU #P-ID-E                                       /*
  PRINTOUTS.PO-ATTRIBUTES(#I) := DEFAULT-PRINTERS.P-ATTRIBUTES(#I)
END-FIND
*
END-SUBROUTINE /* DEFAULT-UNIXLP-VALUES
*
************************************************************************
DEFINE SUBROUTINE ASSIGN-PO-COPIES
************************************************************************
RESET PO-COPIES
*
IF G-PRINTERS-C (#P) IS (N3)
  PO-COPIES := VAL (G-PRINTERS-C (#P))
  IF PO-COPIES = 0
    PO-COPIES:= PRINTERS.P-COPIES
  END-IF
ELSE
  PO-COPIES := PRINTERS.P-COPIES
END-IF
*
IF PO-COPIES = 0
  #BS2-SPOOL-ATTR-EXTENDED := +G-SPOOL-ATTR-EXTENDED
  #VAR := 'COPIES'
  CALLNAT 'RPRTATTN' RMEX-SPOOL-ATTRIBUTES #BS2-SPOOL-ATTR-EXTENDED
    #VAR #VALUE ACTIVE-REPORTS.AR-CC-TYPE
  IF #VALUE NE ' '
    PO-COPIES := VAL (#VALUE)
  END-IF
END-IF
*
IF NOT SYSTEM-INFO-VIEW.SYSTEM-TYPE = SCAN 'BS2'
  IF PO-COPIES = 0
    PO-COPIES := 1
  END-IF
END-IF
*
END-SUBROUTINE /* ASSIGN-PO-COPIES
*
************************************************************************
DEFINE SUBROUTINE ASSIGN-PO-JOBCARD
************************************************************************
IF REPORTS.R-PRINT-JOBCARD (*) NE ' '
  PO-JOBCARD (*) := REPORTS.R-PRINT-JOBCARD           (*)
ELSE
  PO-JOBCARD (*) := P-JOBCARD           (*)
END-IF
#BS2-SPOOL-ATTR-EXTENDED := +G-SPOOL-ATTR-EXTENDED
#VAR := 'JOBNAME'
CALLNAT 'RPRTATTN' RMEX-SPOOL-ATTRIBUTES #BS2-SPOOL-ATTR-EXTENDED
  #VAR #VALUE ACTIVE-REPORTS.AR-CC-TYPE
COMPRESS PH-ESCAPE-CHAR 'JOBNAME' TO #VAR LEAVING NO
EXAMINE PO-JOBCARD (1) FOR #VAR REPLACE #VALUE
**        looking for an entry "ACCOUNT=&ACCOUNT" in the job-card
**        and replace &ACCOUNT with the original:
#VAR := 'ACCOUNT-NUMBER'
CALLNAT 'RPRTATTN' RMEX-SPOOL-ATTRIBUTES #BS2-SPOOL-ATTR-EXTENDED #VAR
  #VALUE ACTIVE-REPORTS.AR-CC-TYPE
COMPRESS PH-ESCAPE-CHAR 'ACCOUNT' TO #VAR LEAVING NO
EXAMINE PO-JOBCARD (1) FOR #VAR REPLACE #VALUE
*
END-SUBROUTINE /* ASSIGN-PO-JOBCARD
*
************************************************************************
DEFINE SUBROUTINE ASSIGN-PO-SCHEDULED
************************************************************************
EOMPOM-PHYSICAL-NAME := PO-PHYSICAL-NAME
CALLNAT 'EOMPOTWN' EOMPOM-PARMS
PO-SCHEDULED := EOMPOM-SCHEDULED
*
END-SUBROUTINE /* ASSIGN-PO-SCHEDULED
*
************************************************************************
ON ERROR
************************************************************************
  IF *ERROR-NR = 3145 RETRY END-IF
*
END-ERROR
*
END-SUBROUTINE /* CREATE-PRINTOUTS
*
END
