* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRPAUSR - Active Help for Calendar in a Report Definition
*
* Maintenance
* UUU YY-MM-DD s(999999) ...
* mrs 93-09-09           created
* xsetggr 2001-10-05 p(208009) additional parameter for RSELCA-N
* sju     2003-03-04     year parm for RSELCA-N
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #FIELD-NAME     (A65)
1 #CALENDAR       (A8)
************************************************************************
LOCAL
1 #OLD-CALENDAR   (A8)
1 #YEAR           (N4)
1 REDEFINE #YEAR
  2 #YEAR-A       (A4)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
IF #CALENDAR = SCAN '*'
  MOVE EDITED *DATX (EM=YYYY) TO #YEAR-A
  #OLD-CALENDAR := #CALENDAR
  CALLNAT 'RSELCA-N' #CALENDAR #YEAR
  IF #OLD-CALENDAR NE #CALENDAR
    MOVE TRUE TO G-MAP-MODIFIED
  END-IF
ELSE
  CALLNAT 'EOMRPH-N' #FIELD-NAME  (AD=O)
END-IF
*
END
