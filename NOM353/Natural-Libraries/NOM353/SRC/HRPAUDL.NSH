* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRPAUDL - Active Help for User or Distribution List in a Report
*              Definition
*
* Maintenance
* UUU YY-MM-DD s(999999) ...
* mrs 93-09-09           created
* xsetggr 02-10-11       add PF3 - Exit
* xsetggr 03-07-04 p(240465) set key pf3
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
  SET KEY PF4 PF5
  SET KEY PF3
  SET CONTROL 'WC10L40F'
  INPUT USING MAP 'HMDLMEM&'
  DECIDE ON FIRST VALUE OF *PF-KEY
    VALUE 'PF4'
      CALLNAT 'RSELUS-N' #MEMBER
    VALUE 'PF5'
      CALLNAT 'RSELDL-N' #MEMBER
    VALUE 'PF3'
      RESET #MEMBER
      ESCAPE ROUTINE
    NONE VALUE
      IGNORE
  END-DECIDE
  IF #OLD-MEM NE #MEMBER
    G-MAP-MODIFIED := TRUE
  END-IF
ELSE
  CALLNAT 'EOMRPH-N' #FIELD-NAME  (AD=O)
END-IF
*
END
