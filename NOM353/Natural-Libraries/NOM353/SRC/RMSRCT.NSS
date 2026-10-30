* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RMSRCT
* Function  Store Contents Pointer
* Version   1.3
*
* Maintenance:
* uuu yy-mm-dd s(999999) ....
* mrs 93-01-19           clean up
* mrs 93-03-15           build fragments only if needed
* jvd 98-05-04 p(168326)  Increase display size to show lines > 10m
* jvd 98-09-10 p(164220) NOM141ÖNAT23
*                        p(168326) is now in p(164220)so I have removed
*                        all refferance to P(168326) to make easier
*                        reading
* sju 04-12-06 NOM31     Add date and time (tenths of second) to trace
* xsetggr 2006-05-14 p(271961) correct writing in report-contents
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* fhi     2014-03-03 NOMALL-1363 Get cat cate into trace messages
* SU1     2014-08-14 NOMALL-1447 TEST files > 16k - only restruct
* SU2    2014-11-17 NOMALL-1450 fill fields for Adabas Vista
* SU3     2016-01-20 NOMALL-1802 do not update Adabas Vista fields
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* ----------------------------------------------------------------------
*
DEFINE DATA GLOBAL USING MONIT-GL
INDEPENDENT
1 +CMRDC (A1)        /* NOMALL-2009 fhi in
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
    3 AC-TO-LINE-N9   (1:99)  /*SU3 <-
* *****
1 #TRACING    (L)
1 #CATDATE    (A19) /* NOMALL-1363 fhi in
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
DEFINE SUBROUTINE STORE-REPORT-CONTENTS
************************************************************************
IF G-TRACE GE *LEVEL
  #TRACING := TRUE
  PERFORM XXCATAL-GET-CATDATE #CATDATE
  COMPRESS 'Start' *PROGRAM 'cataloged at'  #CATDATE TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
INCLUDE CMRDC                  /* NOMALL-2009 fhi in
*
IF ##C-CONTENTS > 0
AND REPORT-CONTENTS.AC-TO-LINE (##C-CONTENTS) = ##START-LINE - 1      /*
AND REPORT-CONTENTS.AC-FROM-LINE(##C-CONTENTS) NE 0                   /*
  REPORT-CONTENTS.AC-TO-LINE (##C-CONTENTS) := ##END-LINE
  ESCAPE ROUTINE
END-IF
IF ##C-CONTENTS > 0
AND REPORT-CONTENTS.AC-TO-LINE-N9 (##C-CONTENTS) = ##START-LINE - 1   /*
AND REPORT-CONTENTS.AC-FROM-LINE-N9(##C-CONTENTS) NE 0                /*
  REPORT-CONTENTS.AC-TO-LINE-N9 (##C-CONTENTS) := ##END-LINE
  ESCAPE ROUTINE
END-IF
*
IF ##C-CONTENTS = 99
  REPORT-CONTENTS.AC-REPNAME := G-REPORT
  REPORT-CONTENTS.AC-REPRNB := G-REPRNB
  ##REC-COUNT := ##REC-COUNT - (##END-LINE - ##START-LINE + 1)
  REPORT-CONTENTS.AC-SEQNO := ##REC-COUNT
  ##REC-COUNT := ##REC-COUNT + (##END-LINE - ##START-LINE + 1)
/* copy content of GDA view to local view (just to be sure) SU3
  MOVE BY NAME REPORT-CONTENTS TO REPORT-CONTENTS-LOC /*SU3
  REPORT-CONTENTS-LOC.AC-OBJECT-TYPE := 'AC' /*SU3
  REPORT-CONTENTS-LOC.AC-OBJECT-TIME := *TIMX /*SU3
  ST. STORE REPORT-CONTENTS-LOC
/* copy content of local view to GDA (just to be sure) SU3
  MOVE BY NAME REPORT-CONTENTS-LOC TO REPORT-CONTENTS /*SU3
  IF #TRACING
    COMPRESS 'store contents pointer' REPORT-CONTENTS.AC-REPNAME
      REPORT-CONTENTS.AC-REPRNB TO G-TRACE-MSG
    PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END-IF
  END OF TRANSACTION
  RESET REPORT-CONTENTS.AC-FROM-LINE(*) REPORT-CONTENTS.AC-TO-LINE(*)
    REPORT-CONTENTS.AC-FROM-LINE-N9(*) REPORT-CONTENTS.AC-TO-LINE-N9(*)
    ##C-CONTENTS
END-IF
*
ADD 1 TO ##C-CONTENTS
REPORT-CONTENTS.AC-FROM-LINE-N9 (##C-CONTENTS) := ##START-LINE
REPORT-CONTENTS.AC-TO-LINE-N9 (##C-CONTENTS)   := ##END-LINE
*
IF #TRACING
  G-TRACE-MSG := 'End'
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END TRANSACTION
END-IF
*
END-SUBROUTINE /* STORE-REPORT-CONTENTS
*
END
