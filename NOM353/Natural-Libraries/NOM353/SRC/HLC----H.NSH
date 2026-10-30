* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HLC----H  general line command Helproutine
*
* Maintenance
* XXX YY-MM-DD s(999999) ...
*
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
            PARAMETER
1 #CODE                        (A2)
            LOCAL
1 #I                           (P2)
END-DEFINE
IF G-LCH-NUM < 20
   RESET G-LCH-CODE (G-LCH-NUM + 1:20)
         G-LCH-TEXT (G-LCH-NUM + 1:20)
END-IF
SET CONTROL 'MT'
DECIDE ON FIRST G-LCH-NUM
  VALUE 01 : 04 INPUT USING MAP 'HLC1---&'
  VALUE 05 : 08 INPUT USING MAP 'HLC2---&'
  VALUE 09 : 12 INPUT USING MAP 'HLC3---&'
  VALUE 13 : 16 INPUT USING MAP 'HLC4---&'
  VALUE 17 : 20 INPUT USING MAP 'HLC5---&'
  NONE           IGNORE
END-DECIDE
IF *PF-KEY = 'PF3'
   RESET #CODE
  ELSE
   EXAMINE FULL VALUE OF G-LCH-CODE (1:G-LCH-NUM)
       FOR FULL VALUE OF #CODE
    GIVING INDEX IN #I
   IF #I = 0
      REINPUT *7 ALARM
     ELSE
      SET CONTROL 'Q'
   END-IF
END-IF
SET CONTROL 'M21'
END
