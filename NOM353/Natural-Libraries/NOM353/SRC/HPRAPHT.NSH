* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HPRAPHT - Active Help for Phisical Printer in a Printer Definition
*
* Maintenance
* UUUUUUU YYYY-MM-DD s(999999) ...
* xsetoba 2001-09-11  created
* sju     2002-09-23  NOM221   NAT0923 entering ? in phys. printer name
* xsetggr 2008-11-20  p(308982) missing pfkeys for unix
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #FIELD-NAME   (A65)
1 #PRINTER      (A8)
************************************************************************
LOCAL
1 #OLD-PRINTER  (A8)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
IF #PRINTER = SCAN '*'
  #OLD-PRINTER := #PRINTER
  CALLNAT 'RSELPH-N' #PRINTER G-USER-TYPE G-USERID
  IF #OLD-PRINTER NE #PRINTER
    G-MAP-MODIFIED := TRUE
  END-IF
ELSE
  CALLNAT 'EOMPRH-N' #FIELD-NAME  (AD=O)
END-IF
*
END
