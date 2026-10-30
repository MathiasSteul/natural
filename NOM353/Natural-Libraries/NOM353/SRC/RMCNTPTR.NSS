* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RMCNTPTR
* Function  Handle Active Report Contents Pointer
* Version   1.3
*
* Maintenance:
* uuu yy-mm-dd s(999999) ....
* mrs 93-01-20           clean up
* sju 04-12-06 NOM31     Add date and time (tenths of second) to trace
* fhi     2010-09-03 NOMALL-97 Extend message line
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* fhi     2014-03-03 NOMALL-1363 Get cat cate into trace messages
* SU1     2014-09-08 NOMALL-1447 TEST files > 16k - only restruct
* SU2     2014-11-17 NOMALL-1450 fill fields for Adabas Vista
* SU3     2016-01-20 NOMALL-1802 do not update Adabas Vista fields
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING MONIT-GL
INDEPENDENT
1 +CMRDC (A1)
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
1 #TRACING         (L)
1 #CATDATE         (A19)
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
DEFINE SUBROUTINE HANDLE-CONTENTS-POINTERS
************************************************************************
IF G-TRACE GE *LEVEL
  #TRACING := TRUE
  PERFORM XXCATAL-GET-CATDATE #CATDATE
  COMPRESS 'Start' *PROGRAM 'cataloged at'  #CATDATE TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
INCLUDE CMRDC
*
IF ##PREVIOUS-IN
  RESET ##PREVIOUS-IN
  PERFORM STORE-REPORT-CONTENTS
END-IF
IF ##C-CONTENTS > 0
  REPORT-CONTENTS.AC-REPNAME := G-REPORT
  REPORT-CONTENTS.AC-REPRNB  := G-REPRNB
  REPORT-CONTENTS.AC-SEQNO   := ##REC-COUNT
/* copy content of GDA view to local view
  MOVE BY NAME REPORT-CONTENTS TO REPORT-CONTENTS-LOC
  REPORT-CONTENTS-LOC.AC-OBJECT-TYPE := 'AC'
  REPORT-CONTENTS-LOC.AC-OBJECT-TIME := *TIMX
  ST. STORE REPORT-CONTENTS-LOC
/* copy content of local view to GDA (just to be sure)
  MOVE BY NAME REPORT-CONTENTS-LOC TO REPORT-CONTENTS
  IF #TRACING
    COMPRESS 'store contents pointer' REPORT-CONTENTS.AC-REPNAME
      REPORT-CONTENTS.AC-REPRNB ##REC-COUNT TO G-TRACE-MSG
    PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END-IF
  END OF TRANSACTION
END-IF
*
IF #TRACING
  COMPRESS 'Ended with --->' G-NATRP-ERC-A G-NATRP-ERT TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END TRANSACTION
END-IF
*
END-SUBROUTINE /* HANDLE-CONTENTS-POINTERS
*
END
