* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RMCRTNRM
* Function  Container = NOM DB
* Version   1.3
*
* Maintenance:
* uuu yy-mm-dd s(999999) ....
* mrs 93-01-19 s(999999) clean up
* mrs 95-05-30 s(218707) lines are lost if contents is h'0140'
* fhi 00-03-03 S(192651) Line length > 253 not stored in DB
* sju 04-12-06 NOM31     Add date and time (tenths of second) to trace
* fhi      2010-10-12 NOMALL-97 Use trace levels, use XXRLOG
* SPLILDAV 2012-06-27 NOMALL-1078 SUPPORT COMPRESSION 16K BYTE RECORDS
* fhi     2014-03-03 NOMALL-1363 Get cat cate into trace messages
* SU1     2014-11-17 NOMALL-1450 fill fields for Adabas Vista
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
* ----------------------------------------------------------------------
*
DEFINE DATA GLOBAL USING MONIT-GL
INDEPENDENT
1 +CMRDC (A1)        /* NOMALL-2009 fhi in
* *****
LOCAL  USING VFSYS-L
LOCAL  USING RLOG-L
*
LOCAL
1 COMPCB                     (B40)
1 REDEFINE    COMPCB
  2 COMPCB-OP                (A1)
  2 COMPCB-CHAR              (B1)
  2 COMPCB-ILEN-OLD          (B1)
  2 COMPCB-OLEN-OLD          (B1)
  2 COMPCB-ILEN              (B2)
  2 COMPCB-OLEN              (B2)
1 #CP                        (P3)
1 #TRACING                   (L)
1 #CATDATE                   (A19) /* NOMALL-1363 fhi in
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
DEFINE SUBROUTINE CREATE-IN-NRM
************************************************************************
IF G-TRACE GE *LEVEL AND G-TRACE-SET = SCAN ('CREATE')
  #TRACING := TRUE
  COMPRESS 'Start -> Report'  G-REPORT 'Rnb' G-REPRNB
    'Seq' ##REC-COUNT 'Lines' ##CUR-RECORD TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  PERFORM XXCATAL-GET-CATDATE #CATDATE
  COMPRESS *PROGRAM 'cataloged at'  #CATDATE TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
END-IF
INCLUDE CMRDC                  /* NOMALL-2009 fhi in
*
COMPCB-OP          := 'C'
COMPCB-CHAR :=        'N'            /* 'N' - New parm list
*
RESET  REPORT-TEXT.F-TEXT(*)
REPORT-TEXT.F-REPNAME := G-REPORT
REPORT-TEXT.F-REPRNB := G-REPRNB
*
FOR #CP 1 TO ##CUR-RECORD
* NOMALL-1078 INSERT 1
  RESET COMPCB-OLEN       /* Zero output length
  DECIDE FOR FIRST CONDITION
    WHEN #TEXT-ARRAY (#CP) = ' '
      REPORT-TEXT.F-TEXT (#CP) := H'0103'
    WHEN #TEXT-ARRAY (#CP) = H'01'
      REPORT-TEXT.F-TEXT (#CP) := H'0101'
    WHEN NONE
      COMPCB-ILEN := ##RECLEN-VEC(#CP)
* NOMALL-1078 INSERT 1
      COMPCB-ILEN-OLD := ##RECLEN-VEC(#CP) /* For compat
      IF ##RECLEN-VEC(#CP) > 251
        COMPCB-ILEN := 251
* NOMALL-1078 INSERT 1
        COMPCB-ILEN-OLD := 251 /* For compat
        LG-USERID := G-MONITOR-ID
        LG-CODE := 'MO'
        COMPRESS '7205' ##REC-COUNT REPORT-TEXT.F-REPNAME INTO LG-MSG
        CALLNAT 'RLOG' PL-PARMS
        END TRANSACTION
      END-IF
      CALLNAT 'R-NRMCMP' COMPCB #TEXT-ARRAY(#CP) REPORT-TEXT.F-TEXT(#CP)
        G-NATRP-ERC G-NATRP-ERT
      IF G-NATRP-ERC NE 0
        ESCAPE ROUTINE
      END-IF
  END-DECIDE
END-FOR
*
REPORT-TEXT.F-SEQ := ##REC-COUNT
F-OBJECT-TYPE := 'FS' /*SU1
F-OBJECT-TIME := *TIMX /*SU1
*
STORE REPORT-TEXT
END TRANSACTION
*
IF #TRACING
  COMPRESS 'Ended with:' G-NATRP-ERC-A G-NATRP-ERT TO G-TRACE-MSG
  PERFORM XXRLOG-WRITE-LOG 'T' G-TRACE-MSG
  END TRANSACTION
END-IF
*
END-SUBROUTINE
*
END
