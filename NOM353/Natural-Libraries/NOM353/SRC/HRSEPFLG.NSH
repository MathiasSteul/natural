* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
*** func: checks if Y N or blank entered
***
*** mwi 96-06-14 s(153781)  no input (blank) is also allowed
***
DEFINE DATA
GLOBAL USING NRM-GL
PARAMETER
1 #CODE(A1)
LOCAL
1 CV-CODE(C)
END-DEFINE
INPUT USING MAP 'HSEPFLG&'
IF NOT(#CODE = 'Y' OR = 'N' OR= ' ')      /* mwi 96-06-14 s(153781)
  REINPUT *0007 ALARM
END-IF
IF CV-CODE MODIFIED
   MOVE TRUE TO G-MAP-MODIFIED
END-IF
END
