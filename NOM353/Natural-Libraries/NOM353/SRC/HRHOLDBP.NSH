* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRHOLDBP
* XSETOBA 01-10-29 P(208366) PRINTING ATRIBUTES CONTROL FOR BUNDULE DEF.
************************************************************************
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #CODE (A1)
************************************************************************
LOCAL
1 CV-CODE (C)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
INPUT USING MAP 'HBUHOLD&'
IF NOT(#CODE = 'Y' OR = 'N')
  REINPUT *0007 ALARM
END-IF
IF CV-CODE MODIFIED
  G-MAP-MODIFIED := TRUE
END-IF
*
END
