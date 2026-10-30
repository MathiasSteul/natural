* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RMINITRP - Init Active Report Parameters
*
* Maintenance:
* uuu yy-mm-dd s(999999) ....
* mrs 93-01-12           clean up
* wcd 00-04-01 CE 7267  Increase to 20 printers
* sju 04-12-06 NOM31     Add date and time (tenths of second) to trace
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* fhi     2012-08-20 NOMALL-1004 Add report formatting parameters
* fhi     2013-04-17 NOMALL-1004 Supply converted fileid
* fhi     2014-03-03 NOMALL-1363 Get cat cate into trace messages
* fhi     2016-08-01 NOMALL-1748 Backout Report Formatting
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* SU1     2018-02-01 NOMALL-1823 NOM 3.5: remove CONNECT
* ----------------------------------------------------------------------
*
DEFINE DATA GLOBAL USING MONIT-GL
INDEPENDENT
1 +CMRDC     (A1)
* *****
LOCAL
1 #TRACING   (L)
1 #CATDATE   (A19)
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
DEFINE SUBROUTINE INIT-REPORT-PARMS
************************************************************************
IF G-TRACE GE *LEVEL
  #TRACING := TRUE
  WRITE *PROGRAM *TIMX (EM=YYYY'-'MM'-'DD' 'HH':'II':'SS'.'T) 'Start'
  PERFORM XXCATAL-GET-CATDATE #CATDATE
  WRITE *PROGRAM 'cataloged at'  #CATDATE
END-IF
INCLUDE CMRDC
*
RESET G-PROCESSING-PARMS
*
G-STORE-NATRPT        := REPORTS.R-STORE-NATRPT
G-NATRPT-DIST (1:10)  := REPORTS.R-NATRPT-DIST (1:10)
G-NATRPT-DIST-NO      := REPORTS.C*R-NATRPT-DIST
G-JPRINTER-NO         := REPORTS.C*R-PRINTERS
G-PRINTERS (1:20)     := REPORTS.R-PRINTERS(1:20)
G-HOLD                := REPORTS.R-HOLD-PRINT
G-SEPMEM              := REPORTS.R-SEPMEM
G-SEPNO               := REPORTS.R-SEPNO
G-KEYWORDS (1:6)      := REPORTS.R-KEYWORDS(1:6)
G-ARCHIVE             := REPORTS.R-ARCHIVE
G-RETENTION-PERIOD    := REPORTS.R-RETENTION-PERIOD
G-RETENTION-ACTION    := REPORTS.R-RETENTION-ACTION
*
IF REPORTS.R-STORE-NATRPT = 'Y'
  ##IN-NRM := TRUE
END-IF
*
IF #TRACING
  COMPRESS 'Ended with --->' G-NATRP-ERC-A G-NATRP-ERT TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END TRANSACTION
END-IF
*
END-SUBROUTINE /* INIT-REPORT-PARMS
*
END
