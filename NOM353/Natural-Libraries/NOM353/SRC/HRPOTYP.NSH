* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRPOTYP
* HELP ROUTINE FOR PRINTOUT SELECTION
* Maintenance
* SU1     2013-01-31 unused      Deactivate unused data areas
* ----------------------------------------------------------------------
DEFINE DATA
**GLOBAL USING NRM-GL /*SU1 out
PARAMETER
1 #CODE(A1)
LOCAL
1 CV-CODE(C)
END-DEFINE
INPUT USING MAP 'HPOTYP&'
IF NOT (#CODE= ' ' OR ='D' OR ='E' OR ='F')
   REINPUT *0007 ALARM
END-IF
.
