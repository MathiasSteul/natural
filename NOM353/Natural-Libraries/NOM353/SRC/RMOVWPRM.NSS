* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RMOVWPRM
* Function  Overwrite Report Parameters
* Version   1.3
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* mrs 94-03-14 s(197015) overwrite owner if specified in p-owner
* mrs 94-06-08 s(200550) save p-bundle-... in g-bundle-... variables
* gw  95-11-02 s(224867) correct handling of P-HOLD at CLOSE
* gw  98-09-07 s(999999) sequence-nr and group added
* sju 99-07-21 p(184568) set bundle printers correctly
* sju 99-10-13 p(187672) report printers ignored if bundle printer given
* ws  00-04-01 CE 7267   Increase to 20 printers
* ws  00-06-30 CE 5630   bundle flush lines exceeded
* HH  04-08-10 HH HEX-CODE ENTFERNEN
* sju 04-12-06 NOM31     Add date and time (tenths of second) to trace
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* fhi     2014-03-03 NOMALL-1363 Get cat cate into trace messages
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* SU1     2019-01-16 NOMALL-2085 NOM35 printer:sep.pages: AR
* SU2     2022-11-28 NOMALL-2583 reduce trace;itrac for uqac only
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING MONIT-GL
INDEPENDENT
1 +CMRDC    (A1)
LOCAL
1 I         (P2)
1 #TRACING  (L)
1 #CATDATE  (A19)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
FORMAT LS=100
*
************************************************************************
DEFINE SUBROUTINE OVERWRITE-PARMS
************************************************************************
IF G-TRACE GE *LEVEL
  #TRACING := TRUE
  PERFORM XXCATAL-GET-CATDATE #CATDATE
  WRITE *PROGRAM *TIMX (EM=YYYY'-'MM'-'DD' 'HH':'II':'SS'.'T)
    'Start. cataloged at' #CATDATE
END-IF
INCLUDE CMRDC
*
IF P-KEYWORDS (*) NE ' '
  G-KEYWORDS (*) := P-KEYWORDS (*)
END-IF
*
IF P-DISTRIBUTION (*) NE ' '
  G-NATRPT-DIST (*) := P-DISTRIBUTION (*)
  EXAMINE FULL P-DISTRIBUTION(*) FOR FULL '        '
    GIVING INDEX IN G-NATRPT-DIST-NO
  IF G-NATRPT-DIST-NO > 0
    SUBTRACT 1 FROM G-NATRPT-DIST-NO
  ELSE
    G-NATRPT-DIST-NO := 10
  END-IF
END-IF
*
IF P-PRINTERS (*) NE ' '
  RESET G-JPRINTER-NO G-PRINTERS (*)
  FOR I = 1 TO 20
    IF P-PRINTERS (I) NE ' '
      ADD 1 TO G-JPRINTER-NO
      G-PRINTERS-P (G-JPRINTER-NO) := P-PRINTERS (I)
      G-PRINTERS-C (G-JPRINTER-NO) := P-COPIES (I)
      G-PRINTERS-S (G-JPRINTER-NO) := P-SEP-PAGES (I) /*SU1
    END-IF
  END-FOR
END-IF
*
IF P-BUNDLE-PRINTERS (*) NE ' '
  RESET G-BUNDLE-PRINTERS(*) G-BUNDLE-PRINTERS-COPIES(*)
  FOR I = 1 TO 20
    IF P-BUNDLE-PRINTERS (I) NE ' '
      G-BUNDLE-PRINTERS(I):= P-BUNDLE-PRINTERS(I)
      G-BUNDLE-PRINTERS-COPIES(I):= P-BUNDLE-PRINTERS-COPIES(I)
    END-IF
  END-FOR
END-IF
*
IF P-OWNER NE ' '
  G-JOBUSERID := P-OWNER
END-IF
IF P-BUNDLE (*) NE ' '
  RESET G-BUNDLES (*) G-BUNDLE-NO
  FOR I = 1 TO 5
    IF P-BUNDLE (I) NE ' '
      ADD 1 TO G-BUNDLE-NO
      G-BUNDLES (G-BUNDLE-NO) := P-BUNDLE (I)
      G-BUNDLES-SEQUENCE-NR (G-BUNDLE-NO) :=
        P-BUNDLE-SEQUENCE-NR (I)
      G-BUNDLES-GROUP (G-BUNDLE-NO) := P-BUNDLE-GROUP (I)
    END-IF
  END-FOR
END-IF
IF P-BUNDLE-JOBCARDS (*) NE ' '
  G-BUNDLE-JOBCARDS (*) := P-BUNDLE-JOBCARDS (*)
END-IF
IF P-BUNDLE-COORDINATOR NE ' '
  G-BUNDLE-COORDINATOR := P-BUNDLE-COORDINATOR
END-IF
IF P-BUNDLE-FLUSH-LINES NE 0
  G-BUNDLE-FLUSH-LINES := P-BUNDLE-FLUSH-LINES
END-IF
IF P-FLUSH-TIME NE 0
  G-BUNDLE-FLUSH-TIME := P-FLUSH-TIME
END-IF
IF P-BUNDLE-SEPSTART NE ' '
  G-BUNDLE-SEPSTART := P-BUNDLE-SEPSTART
END-IF
IF P-BUNDLE-REPORT-SEPARATORS NE ' '
  G-BUNDLE-REPORT-SEPARATORS := P-BUNDLE-REPORT-SEPARATORS
END-IF
IF P-BUNDLE-SEPEND NE ' '
  G-BUNDLE-SEPEND := P-BUNDLE-SEPEND
END-IF
IF P-BUNDLE-SEPNO NE 0
  G-BUNDLE-SEPNO := P-BUNDLE-SEPNO
END-IF
IF P-BUNDLE-PRINTER NE ' '
  G-BUNDLE-PRINTER := P-BUNDLE-PRINTER
END-IF
IF P-HOLD NE ' '
  G-HOLD := P-HOLD
END-IF
IF #TRACING
  COMPRESS 'Ended with: --->' G-NATRP-ERC-A G-NATRP-ERT TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END TRANSACTION
END-IF
*
END-SUBROUTINE /* OVERWRITE-PARMS
*
END
