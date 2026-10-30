* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HKY - Active/Passive Help for keywords for Reports and Active ReportS
*       RP: (HE='HKY',=,'RP') or (HE='HKY',=,'RP',EOMRPM-KEYWORDS (*))
*       AR: (HE='HKY',=,'AR') or (HE='HKY',=,'AR',EOMRPM-KEYWORDS (*))
*           or (HE='HKY',=,'AR',#L-KEYWORD(*),1X)
*       Second is for multiple selection.
*
* Maintenance
* uuu yyyy-mm-dd itrac      ...
* SU  2023-04-13 ES-33831   created
************************************************************************
DEFINE DATA PARAMETER
1 #FIELD-NAME   (A65)
1 #TYPE         (A2) OPTIONAL
1 #KY-IN-TAB    (A15/*) BY VALUE RESULT OPTIONAL
1 #OLD-KY       (A15/*) BY VALUE RESULT OPTIONAL
* Implicit parameters - must be the last two:
1 #KY-IN        (A15) BY VALUE RESULT
1 #INDEX        (I2) OPTIONAL
************************************************************************
LOCAL
1 AR VIEW OF NRM-ACTIVE-REPORTS
  2 AR-KEYWORDS (A15/1)
1 RP VIEW OF NRM-REPORTS-NEW
  2 R-KEYWORDS  (A15/1)
*
1 #KY-INPUT     (A15)
1 CV-KY         (C) INIT <(AD=I CD=NE)>
1 #FROM         (A15)
1 #THRU         (A15)
1 #OT           (A15)
1 #IS-AR        (L)
1 #END          (L)
1 #I            (I2)
1 #I1           (I2)
1 #I2           (I2)
1 #IND          (I2)
1 #MAX          (I2) CONST <18>
1 #MAX-TAB      (I2)
1 #SEL          (I2)
1 #TITLE        (A45)
1 #MAP          (#MAX)
  2 #KY         (A15)
  2 #USED       (P10)
  2 CV-MARK     (C) INIT (*) <(AD=PN)>
  2 CV-KY1      (C) INIT (*) <(AD=I CD=NE)> /*not used: intensified
  2 L-MARK      (A1)
1 #PC           (A1) /*prefix character
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
IF NOT(#KY-IN =SCAN '*' OR=SCAN'?') /*Passive
  CALLNAT 'EOMRPH-N' #FIELD-NAME  (AD=O)
  ESCAPE MODULE
END-IF
* Active help:
SET KEY ALL
DEFINE WINDOW KY SIZE 18 * 55 BASE 2/15 TITLE #TITLE FRAMED
*
IF #INDEX SPECIFIED
  #IND := #INDEX
END-IF
IF #KY-IN =SCAN '*'
  #PC := '*'
ELSE
  #PC := '?'
END-IF
IF #KY-IN-TAB SPECIFIED
  #MAX-TAB := *OCC(#KY-IN-TAB)
END-IF
IF #TYPE SPECIFIED AND #TYPE ='AR'
  #IS-AR := TRUE
  #OT := F#GETMSG (<8605>) /*Active Reports
ELSE
  #OT := F#GETMSG (<8601>) /*Reports
END-IF
#TITLE := F#GETMSG (<5052>) /* Keywords
IF *LANGUAGE = 2
  COMPRESS #TITLE ' Auswahlliste (' #OT ')' TO #TITLE LEAVING NO
ELSE
  COMPRESS #TITLE ' Selection List (' #OT ')' TO #TITLE LEAVING NO
END-IF
#KY-INPUT := #KY-IN
REPEAT
  IF CV-KY MODIFIED OR #FROM = ' '
    RESET INITIAL CV-KY
    EXAMINE #KY-INPUT FOR #PC GIVING POSITION #I2
    IF #I2 > 0
      #KY-INPUT := SUBSTR(#KY-INPUT,1,#I2)
    END-IF
    #FROM := #THRU := #KY-INPUT
    EXAMINE #FROM FOR #PC REPLACE H'00'
    EXAMINE #THRU FOR #PC REPLACE H'FF'
  END-IF
  IF #IS-AR
    #AR. HISTOGRAM AR FOR AR-KEYWORDS FROM #FROM THRU #THRU
      PERFORM #NEW-ENTRY
    END-HISTOGRAM
  ELSE /*RP
    #RP. HISTOGRAM RP FOR R-KEYWORDS FROM #FROM THRU #THRU
      PERFORM #NEW-ENTRY
    END-HISTOGRAM
  END-IF
  IF CV-KY MODIFIED
    ESCAPE TOP
  END-IF
  #END := TRUE
  PERFORM #INPUT
END-REPEAT
*
************************************************************************
* End of main line (now subroutines):
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE #NEW-ENTRY
************************************************************************
ADD 1 TO #I
CV-MARK (#I) := (AD=I)
FOR #I2 = 1 TO #MAX-TAB /*ky already used: not intensified
  IF (#I2 =  #IND AND #KY-IN          NE #KY (#I))
  OR (#I2 NE #IND AND #KY-IN-TAB(#I2) NE #KY (#I))                    /*
    ESCAPE TOP
  END-IF
  CV-KY1 (#I) := (AD=VD) /*used: Default
  ESCAPE BOTTOM
END-FOR
IF #IS-AR
  #KY   (#I) := AR-KEYWORDS (1)
  #USED (#I) := *NUMBER (#AR.)
ELSE
  #KY   (#I) := R-KEYWORDS (1)
  #USED (#I) := *NUMBER (#RP.)
END-IF
IF #I = #MAX
  PERFORM #INPUT
END-IF
*
END-SUBROUTINE /* #NEW-ENTRY
*
************************************************************************
DEFINE SUBROUTINE #INPUT
************************************************************************
INPUT WINDOW='KY' USING MAP 'HKYM&'
IF *PF-KEY NE 'ENTR'
  IF #KY-IN = SCAN #PC AND #OLD-KY SPECIFIED AND #IND NE 0
    #KY-IN := #OLD-KY (#IND)
  END-IF
  ESCAPE MODULE
END-IF
IF CV-KY MODIFIED
  RESET INITIAL #MAP (*) #I
  IF #END
    RESET #END
    ESCAPE TOP /*HISTOGRAM
  END-IF
  ESCAPE BOTTOM /*HISTOGRAM
END-IF
FOR #I1 = 1 TO #I /*anything marked ?
  IF L-MARK (#I1) = ' ' OR (#KY (#I1) = #KY-IN OR=#KY-IN-TAB (*))
    ESCAPE TOP
  END-IF
  ADD 1 TO #SEL
  IF #MAX-TAB = 0 OR #SEL = 1 /*only field or field with '*'
    #KY-IN := #KY (#I1)
    IF #OLD-KY SPECIFIED AND #IND NE 0
      #OLD-KY (#IND) := #KY-IN
    END-IF
  ELSE
    FOR #I2 = 1 TO #MAX-TAB /*fill rest of tab
      IF #I2 = #IND OR NOT (#KY-IN-TAB (#I2) =' ' OR=SCAN #PC)
        ESCAPE TOP
      END-IF
      #KY-IN-TAB (#I2) := #KY (#I1)
      ESCAPE BOTTOM
    END-FOR
  END-IF
  IF #SEL GE #MAX-TAB
    ESCAPE BOTTOM
  END-IF
END-FOR
RESET #I1 /*anything free ?
FOR #I2 = 1 TO #MAX-TAB
  IF (#I2 = #IND AND #KY-IN NE SCAN #PC)
  OR NOT(#KY-IN-TAB(#I2) =' ' OR=SCAN #PC)                            /*
    ESCAPE TOP
  END-IF
  ADD 1 TO #I1
END-FOR
IF #I1 = 0
  ESCAPE MODULE /*all filled
END-IF
RESET INITIAL #MAP (*) #I
*
END-SUBROUTINE /* #INPUT
*
END
