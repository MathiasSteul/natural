* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RMCRTREP - Create Active Report
*
* Maintenance:
* uuu yy-mm-dd s(999999) ....
* mrs 93-01-19           clean up
* gw  96-09-24 s(999999) overwrite with exit parms for P-ACTION 'CREATE'
* jvd 98-05-04 p(168326)  Increase display size to show lines > 10m
* gw  98-05-14 p(168326) number of lines gt 9999999
* jvd 98-09-18 p(164220) NOM14ÖNAT23
*                        Import Note: As the MONIT-GL has being changed
*                        for NOM141 to include new NRM-REPORT-CONTENS
*                        so I have backout all changes made by for
*                        " jvd 98-05-04 p(168326)" and used the global
* fhi 00-12-20 s(204275) Wrong records in REPORT-CONTENS, rep. missing
* jwo 00-12-21 s(204275) Back out changes from FHI
* sju 04-12-06 NOM31     Add date and time (tenths of second) to trace
* xsetggr 2008-03-13 p(302418) reject creation of report if erc > 0
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* SU1     2013-11-22 NOMALL-82 new class: activate error
*                                No tags, only restructured
* fhi     2014-03-03 NOMALL-1363 Get cat cate into trace messages
* SU2     2014-09-08 NOMALL-1447 TEST files > 16k - only restruct
* SU3     2014-11-17 NOMALL-1450 fill fields for Adabas Vista
* SU4     2016-01-20 NOMALL-1802 do not update Adabas Vista fields
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* SU5     2018-02-13 NOMALL-1823 NOM 3.5: remove CONNECT
* SU6     2018-08-30 NOMALL-2130 sep.var.:GDA MONIT-GL -> PDA RMEXSEPA
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING MONIT-GL
PARAMETER USING RMEXSEPA
************************************************************************
INDEPENDENT
1 +CMRDC              (A1)
* *****
LOCAL
1 REPORT-CONTENTS-LOC VIEW OF NRM-REPORT-CONTENTS
  2 AC-OBJECT-TYPE
  2 AC-OBJECT-TIME
  2 AC-REPNAME
  2 AC-REPRNB
  2 AC-SEQNO
  2 C*AC-INSERTED-LINE
  2 AC-INSERTED-LINE  (1:10)
  2 C*AC-CONTENTS
  2 AC-CONTENTS
    3 AC-FROM-LINE    (1:99)
    3 AC-TO-LINE      (1:99)
  2 C*AC-CONTENTS-N9
  2 AC-CONTENTS-N9
    3 AC-FROM-LINE-N9 (1:99)
    3 AC-TO-LINE-N9   (1:99)
* *****
1 #TRACING            (L)
1 #CATDATE            (A19)
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
DEFINE SUBROUTINE CREATE-REPORT
************************************************************************
IF G-TRACE GE *LEVEL AND G-TRACE-SET = SCAN ('CREATE')
  #TRACING := TRUE
  PERFORM XXCATAL-GET-CATDATE #CATDATE
  COMPRESS 'Start' *PROGRAM 'cataloged at'  #CATDATE TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
INCLUDE CMRDC
*
IF ##REPORT-IS-OPENED
  PERFORM CLOSE-REPORT RMEX-SPOOL-ATTRIBUTES /*RMCLSREP
END-IF
*
RESET G-PRINTERS (*) G-JPRINTER-NO
IF P-TOLINE = 0
  P-TOLINE := RMEX-SOURCE-REC-COUNT
END-IF
RESET ##PREVIOUS-IN ##C-CONTENTS ##AC-SEQNO G-BUNDLE-NO
*
PERFORM OPEN-NEW-REPORT #RMEXSEPA
IF G-NATRP-ERC > 0
  ESCAPE ROUTINE
END-IF
*
##REPORT-IS-OPENED := TRUE
IF ##IN-NRM /*SU5 OR ##IN-CONNECT
  PERFORM ADD-RANGE #RMEXSEPA /*RMADDRAN
ELSE
  ##REC-COUNT := ##REC-COUNT + P-TOLINE - P-FROMLINE + 1
END-IF
*
REPORT-CONTENTS.AC-REPNAME          := G-REPORT
REPORT-CONTENTS.AC-REPRNB           := G-REPRNB
REPORT-CONTENTS.AC-SEQNO            := ##REC-COUNT
REPORT-CONTENTS.AC-FROM-LINE-N9 (1) := P-FROMLINE
REPORT-CONTENTS.AC-TO-LINE-N9   (1) := P-TOLINE
/* copy content of GDA view to local view (just to be sure)
MOVE BY NAME REPORT-CONTENTS TO REPORT-CONTENTS-LOC
REPORT-CONTENTS-LOC.AC-OBJECT-TYPE := 'AC'
REPORT-CONTENTS-LOC.AC-OBJECT-TIME := *TIMX
ST. STORE REPORT-CONTENTS-LOC
/* copy content of local view to GDA (just to be sure)
MOVE BY NAME REPORT-CONTENTS-LOC TO REPORT-CONTENTS
*
IF P-ACTION = 'CREATE'
  PERFORM OVERWRITE-PARMS
END-IF
PERFORM CLOSE-REPORT RMEX-SPOOL-ATTRIBUTES /*RMCLSREP
*
##REPOSITION := TRUE
##SYSOUT-RECNO := P-TOLINE + 1
IF #TRACING
  COMPRESS 'Ended with --->' G-NATRP-ERC-A G-NATRP-ERT TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END TRANSACTION
END-IF
*
END-SUBROUTINE /* CREATE-REPORT
*
END
