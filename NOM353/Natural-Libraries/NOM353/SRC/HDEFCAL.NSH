* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member       HDEFCAL
* Function     Active Help for Calendar in Default Definitions
* Version      2.1
*
* Maintenance
* UUU YY-MM-DD s(999999) ...
* xsetggr 2001-05-03     created
* sju     2003-03-04     year parm for RSELCA-N
* SU1     2016-08-30 NOM3.5 beautification
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #FIELD-NAME      (A65)
1 #CALENDAR        (A8)
* *****
LOCAL
1 #OLD-CALENDAR    (A8)
1 #YEAR            (N4)
1 REDEFINE #YEAR
  2 #YEAR-A        (A4)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
#OLD-CALENDAR := #CALENDAR
MOVE EDITED *DATX (EM=YYYY) TO #YEAR-A
CALLNAT 'RSELCA-N' #CALENDAR #YEAR
IF #OLD-CALENDAR NE #CALENDAR
  G-MAP-MODIFIED := TRUE
END-IF
*
END
