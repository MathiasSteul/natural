* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRPAUDA - Active Help for Archive type in a Report Definition
*
* Maintenance
* UUU YY-MM-DD s(999999) ...
* sju 02-04-23 NOM221    created
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #FIELD-NAME       (A65)
1 #ARCHIVE-TYPE     (A1)
************************************************************************
LOCAL
1 #OLD-ARCHIVE-TYPE (A1)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
IF #ARCHIVE-TYPE = '*'
  #OLD-ARCHIVE-TYPE := #ARCHIVE-TYPE
  CALLNAT 'HRSEUDAN' #ARCHIVE-TYPE G-USERID G-USER-TYPE
  IF #OLD-ARCHIVE-TYPE NE #ARCHIVE-TYPE
    G-MAP-MODIFIED := TRUE
  END-IF
ELSE
  CALLNAT 'EOMRPH-N' #FIELD-NAME  (AD=O)
END-IF
*
END
