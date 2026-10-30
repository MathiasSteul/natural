* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRREPNAM
* HELP ROUTINE FOR REPORT NAME
* DISPLAY SHORT  HELP TEXT
* AND REPORT SELECTION LIST
*
*
* wcd 00-04-01           re-cat VMREP-L changes
* xsethz  2000-08-07 (CE7461) Extend Report and Bundle Names
* raya    2011-06-20 nomall-1007 avoid cat problem with params
* SU1   2021-01-08 NOMALL-2443 recat VMREP-L
************************************************************************
DEFINE DATA
GLOBAL USING NRM-GL
PARAMETER
**1 #FIELD-NAME(A65)   /* raya nomall-1007 out
1 #REPORT(A25)
************************************************************************
LOCAL USING VMREP-L
LOCAL
1 GRANTED           (L)
1 L-SCREEN          (8)
  2 L-REPORT        (A25)
  2 REDEFINE L-REPORT
    3 L-REPORT-17   (A17)
    3 L-REPORT-R    (A8)
  2 L-MARK          (A1)
  2 CV-MARK         (C)
  2 CVU             (C)
1 #BOTLINE          (A40)
1 REDEFINE #BOTLINE
  2 #BOT-1          (A12)
  2 #BOT-2          (A16)
  2 #BOT-3          (A12)
1 REDEFINE #BOTLINE
  2 #MORE-1         (A15)
  2 #MORE-2         (A10)
  2 #MORE-3         (A15)
1 I                 (N5)
1 #TOP              (N5) INIT <1>
1 #MAXREC           (N5)
1 #PF-KEY           (A4)
1 #OPTION           (A1/1,1:6)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
SET KEY PF3
INPUT USING MAP 'HMRPNAM&'
IF *PF-KEY  = 'PF3'
  ESCAPE ROUTINE
END-IF
*
* SELECTION SCREEN -----
SET KEY CLR
  PF1  NAMED 'Help'
  PF2  NAMED OFF
  PF3  NAMED 'End'
  PF5  NAMED OFF
  PF6  NAMED OFF
  PF7  NAMED 'Up'
  PF8  NAMED 'Down'
  PF9  NAMED OFF
  PF10 NAMED OFF
  PF11 NAMED OFF
  PF12 NAMED OFF
*
REPEAT
  PERFORM GET-RECORDS
  SET CONTROL 'WC17L40'
  INPUT  USING MAP 'RSELRPM&'
  #PF-KEY := *PF-KEY
  DECIDE ON FIRST VALUE OF #PF-KEY
    VALUE 'PF3' ESCAPE ROUTINE
    VALUE 'PF7'  SUBTRACT 8  FROM #TOP
    VALUE 'PF8'  ADD 8  TO #TOP
    NONE VALUE IGNORE
  END-DECIDE
  FOR I 1 TO 8
    IF L-MARK(I) NE ' '
      IF G-DISPLAY-LONG-NAMES
        #REPORT := L-REPORT(I)
      ELSE
        #REPORT := L-REPORT-17(I)
      END-IF
      ESCAPE ROUTINE
    END-IF
  END-FOR
END-REPEAT
*
************************************************************************
* End of main line (now subroutines):
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE GET-RECORDS
************************************************************************
IF #TOP > #MAXREC
  #TOP := #MAXREC - 2
END-IF
IF #TOP < 1
  #TOP := 1
END-IF
RESET L-SCREEN(*)  I
CV-MARK(*) := (AD=P)
*
READ REPORTS BY R-REPNAME
  CALLNAT 'RCHKGRT' 'D' G-USERID 'R' R-REPNAME #OPTION(1,*) GRANTED
  ACCEPT IF GRANTED
*
  AT END OF DATA #MAXREC := *COUNTER
  END-ENDDATA
*
  ACCEPT IF *COUNTER >=#TOP
  ADD 1 TO I
  IF I > 8
    MOVE ALL '*' TO #MORE-1
    MOVE ALL '*' TO #MORE-3
    #MORE-2 := ' M O R E '
    ESCAPE BOTTOM
  END-IF
  L-REPORT(I) := R-REPNAME
  IF NOT G-DISPLAY-LONG-NAMES
    L-REPORT-R(I) := H'FA'
  END-IF
  RESET CV-MARK(I)
END-READ
IF I <= 8
  MOVE ALL '*' TO #BOT-1
  MOVE ALL '*' TO #BOT-3
  #BOT-2 := ' Bottom of Data '
END-IF
*
END-SUBROUTINE /* GET-RECORDS
*
END
