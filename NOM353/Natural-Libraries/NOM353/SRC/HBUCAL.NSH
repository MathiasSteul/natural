* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member       HBUCAL
* Function     Active Help for Calendar in a Bundle Definition
* Version      2.1
*
* Maintenance
* UUU YY-MM-DD s(999999) ...
* xsetggr 2001-03-21     created
* xsetggr 2001-10-05 p(208009) additional parameter for RSELCA-N
* xsetoba 01-10-03 p(208366) check Y/M for field Time schedule ...
* sju     2003-03-04     year parm for RSELCA-N
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #FIELD-NAME      (A65)
1 #CALENDAR        (A8)
************************************************************************
LOCAL
1 #OLD-CALENDAR    (A8)
1 #YEAR            (N4)
1 REDEFINE #YEAR
  2 #YEAR-A        (A4)
*
END-DEFINE
*
IF #CALENDAR = SCAN '*'
  MOVE EDITED *DATX (EM=YYYY) TO #YEAR-A
  #OLD-CALENDAR := #CALENDAR
  CALLNAT 'RSELCA-N' #CALENDAR #YEAR
  IF #OLD-CALENDAR NE #CALENDAR
    G-MAP-MODIFIED := TRUE
  END-IF
  IF #CALENDAR = SCAN '*'
    #CALENDAR := ' '
  END-IF
ELSE
  INPUT USING MAP 'HXXPCAL&'
END-IF
*
END
