* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    HRSCHWEK
* Version   1.3
* Function  Weekdays Help Routine
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* mrs 93-09-15           rewritten
* jvd 97-08-01 p(164220) Replace Call 'CMULT' with Examine Translate
* SU1     2013-01-31 unused      Deactivate unused data areas
* SU2     2015-02-27 NOMALL-1569 restructured
* ----------------------------------------------------------------------
DEFINE DATA PARAMETER
1 #DAY   (A2)
* *****
LOCAL
1 #DAYS  (A2/7)
1 #DATE  (D)
1 I      (P2)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
MOVE EDITED '19930912' TO #DATE (EM=YYYYMMDD)
FOR I = 1 TO 7
  MOVE EDITED #DATE (EM=N(2)) TO #DAYS (I)
  ADD 1 TO #DATE
END-FOR
*
INPUT USING MAP 'HSCHWEK&'
DECIDE ON FIRST VALUE OF *CURS-LINE
  VALUE 7
    IF *CURS-COL = 8 THRU 21
      #DAY := #DAYS (1)
    END-IF
    IF *CURS-COL = 28 THRU 40
      #DAY := #DAYS (5)
    END-IF
  VALUE 8
    IF *CURS-COL = 8 THRU 21
      #DAY := #DAYS (2)
    END-IF
    IF *CURS-COL = 28 THRU 40
      #DAY := #DAYS (6)
    END-IF
  VALUE 9
    IF *CURS-COL = 8 THRU 21
      #DAY := #DAYS (3)
    END-IF
    IF *CURS-COL = 28 THRU 40
      #DAY := #DAYS (7)
    END-IF
  VALUE 10
    IF *CURS-COL = 8 THRU 21
      #DAY := #DAYS (4)
    END-IF
  NONE VALUE
    IGNORE
END-DECIDE
EXAMINE #DAY TRANSLATE INTO UPPER CASE
*
END
