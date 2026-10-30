* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HUXSTAT   Helproutine for status code of unix node
*
* Maintenance
* uuu     yyyy-mm-dd s(999999) ...
* xsetggr 2009-04-02 P312501   created
* ----------------------------------------------------------------------
DEFINE DATA PARAMETER
1 #FIELD-NAME                 (A65)
1 #CODE                        (A1)
END-DEFINE
SET CONTROL 'MT'
INPUT USING MAP 'HUXSTAM&'
IF *PF-KEY = 'PF3'
  #CODE := 'N'
ELSE
   IF NOT (#CODE = 'Y' OR = 'N' OR = 'D' OR = 'M' OR = 'L')
      REINPUT *7 ALARM
     ELSE
      SET CONTROL 'Q'
   END-IF
END-IF
SET CONTROL 'M21'
END
