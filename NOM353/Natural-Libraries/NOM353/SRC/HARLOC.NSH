* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HARLOC    Helproutine for location values of active reports
*
* Maintenance
* XXX     yyyy-mm-dd s(999999) ...
* xsetggr 2007-11-13 NRT2774   created
* xsetggr 2007-11-14 p(300542) make ' 'value possible
* xsetggr 2009-07-07 P312418   restow doe to chages in HARLOCM&
* SU1     2017-10-09 NOMALL-1823 NOM 3.5: remove CONNECT
* ----------------------------------------------------------------------
DEFINE DATA PARAMETER
1 #FIELD-NAME                 (A65)
1 #CODE                        (A1)
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
SET CONTROL 'MT'
INPUT USING MAP 'HARLOCM&'
IF *PF-KEY = 'PF3'
  #CODE := '*'
ELSE
/*SU1 IF NOT (#CODE ='*' OR='A' OR='C' OR='S' OR='D' OR='B' OR = ' ')
  IF NOT (#CODE ='*' OR='A' OR='S' OR='D' OR='B' OR = ' ')
    REINPUT *7 ALARM
  END-IF
  SET CONTROL 'Q'
END-IF
SET CONTROL 'M21'
*
END
