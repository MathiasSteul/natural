* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HBRAPRT * Active Help for Printer in a Report Definition
*
* Maintenance
* UUU     yyyy-mm-dd s(999999) ...
* xsetggr 2009-09-01 P314431   created
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #FIELD-NAME                        (A65)
1 #PRINTER                           (A8)
************************************************************************
LOCAL
1 #OLD-PRINTER                       (A8)
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
  INPUT USING MAP 'HBRPRT&'
END-IF
*
END
