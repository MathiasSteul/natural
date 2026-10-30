* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRPAPRT - Active Help for Printer in a Report Definition
*
* Maintenance
* UUU YY-MM-DD s(999999) ...
* mrs 93-09-09           created
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #FIELD-NAME  (A65)
1 #PRINTER     (A8)
************************************************************************
LOCAL
1 #OLD-PRINTER (A8)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
IF #PRINTER = SCAN '*'
  #OLD-PRINTER := #PRINTER
  CALLNAT 'HRSELPRN' #PRINTER G-USERID G-USER-TYPE
  IF #OLD-PRINTER NE #PRINTER
    G-MAP-MODIFIED := TRUE
  END-IF
ELSE
  CALLNAT 'EOMRPH-N' #FIELD-NAME  (AD=O)
END-IF
*
END
