* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RMINSERT - Insert Lines (Active Report)
*
* Maintenance:
* uuu yy-mm-dd s(999999) ....
* mrs 93-03-10 s(999999) clean up
* mrs 94-10-18 s(999999) assign report-is-opened to allow proper
*                        creation of reports containing inserted lines
* sju 04-12-07 NOM31     Tracing
* fhi 08-02-29 P302579   Limit Occurrencies of ##CUR-RECORD
* fhi     2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* SU1     2014-09-08 NOMALL-1447 TEST files > 16k - only restruct
* SU2    2014-11-17 NOMALL-1450 fill fields for Adabas Vista
* SU3     2016-01-20 NOMALL-1802 do not update Adabas Vista fields
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* SU4     2018-02-13 NOMALL-1823 NOM 3.5: remove CONNECT
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING MONIT-GL
INDEPENDENT
1 +CMRDC (A1)
************************************************************************
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
1 #IL                 (I2)
1 #REC                (A253)
1 #LEN                (I2)
1 #CUR-RECORD-MAX     (P2)
1 #TRACING            (L)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE INSERT-LINES
************************************************************************
INCLUDE RMCURREC
IF G-TRACE GE *LEVEL
  #TRACING := TRUE
  COMPRESS 'insert' P-RECNO 'lines into' G-REPORT G-REPRNB
    TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
INCLUDE CMRDC
IF P-RECNO =  1 THRU 10
  ##REPORT-IS-OPENED := TRUE
  IF ##IN-NRM /*SU4OR ##IN-CONNECT
    FOR #IL 1 TO P-RECNO
      ADD 1 TO ##REC-COUNT
      ADD 1 TO ##CUR-RECORD
      #TEXT-ARRAY(##CUR-RECORD) := #REC := P-INSERT-LINES(#IL)
      EXAMINE #REC FOR 'X' GIVING LENGTH IN #LEN
      ##RECLEN-VEC(##CUR-RECORD) := #LEN
      IF ##CUR-RECORD = #CUR-RECORD-MAX
        PERFORM PROCESS-BUFFER
        RESET ##CUR-RECORD #TEXT-ARRAY(1:20) ##RECLEN-VEC(*)
      END-IF
    END-FOR
  ELSE
    PERFORM  HANDLE-CONTENTS-POINTERS
    RESET REPORT-CONTENTS ##C-CONTENTS
    FOR #IL 1 TO P-RECNO
      ADD 1 TO ##REC-COUNT
      REPORT-CONTENTS.AC-INSERTED-LINE(#IL) := P-INSERT-LINES(#IL)
    END-FOR
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
    END OF TRANSACTION
    RESET REPORT-CONTENTS
  END-IF
END-IF
RESET ##PREVIOUS-IN ##C-CONTENTS ##START-LINE ##END-LINE
*
END-SUBROUTINE /* INSERT-LINES
*
END
