* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRPAUSR - Active Help for User a Report Definition
*
* Maintenance
* UUU YY-MM-DD s(999999) ...
* mrs 93-09-09           created
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #FIELD-NAME (A65)
1 #MEMBER     (A8)
************************************************************************
LOCAL
1 #OLD-MEM    (A8)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
IF #MEMBER = SCAN '*'
  #OLD-MEM := #MEMBER
  CALLNAT 'RSELUS-N' #MEMBER
  IF #OLD-MEM NE #MEMBER
    G-MAP-MODIFIED := TRUE
  END-IF
ELSE
  CALLNAT 'EOMRPH-N' #FIELD-NAME  (AD=O)
END-IF
*
END
