* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HPHAPHT - Select Physical Printer Type
*
* Maintenance
* UUU YY-MM-DD Sagsis Desciption
* --- -------- ------ --------------------------------------------------
* gw  93-03-11        created
* gw  94-03-07        sort printer types
* gw  96-01-29        cleanup and add type BS2ORIGA
* gw  96-06-24 153703 HPHAPHT/500 - NAT0937 Conflict for array definitio
* fhi 00-11-07 fhi01  Delete Unix- and OS2 printers from help screen,
*                     but keep functionality in programs
* fhi 05-05-18 264664 Reactivate UNIXLP printer
* xsetggr 2009-09-02 P314431  allow only NATUNIX&DISKUNIX printers for
*                      Unix systems, UNIXLP printers only on mainframe
* xsetggr 2010-11-03 NOMALL-865 restow due to changes in EOMPHTYE
* fhi     2011-01-11 NOMALL-936 Increase window size
* raya    2012-03-05 nomall-1103 display map with window
* SU1     2013-06-05 NOMALL-1262 remove OS2PM,HPSPOOL,WINPM,WINPM32
* SU2     2017-10-09 NOMALL-1823 NOM 3.5: remove CONNECT
* SU3     2024-03-07 ES-34613    NOM 3.6 Remove power / BS2
* ----------------------------------------------------------------------
DEFINE DATA PARAMETER
1 #FIELD-NAME                        (A65)
1 #PARM                              (A8)
* *****
LOCAL USING EOMPHTYE /*##PHYS-MAX-TYPES=12
LOCAL
1 #I                                 (I1)
1 #J                                 (I1)
1 #K                                 (I1)
1 L-MARK                             (A1/1:##PHYS-MAX-TYPES+2)
1 #PHYS-TYPES                        (A8/1:##PHYS-MAX-TYPES+2)
1 CV-MARK                            (C/1:##PHYS-MAX-TYPES+2)
1 #TEMP1                             (A8)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
DEFINE WINDOW PH SIZE 18 * 41 BASE 2/15 FRAMED
IF #PARM NE SCAN '*'
  CALLNAT 'EOMPHH-N' #FIELD-NAME  (AD=O)
END-IF
*
SET KEY PF3
*
#K := ##PHYS-MAX-TYPES - 1
CV-MARK (*) := (AD=PN)
FOR #J 1 #K
  #TEMP1 := ##PHYS-TYPES (#J)
END-ALL
SORT #TEMP1 USING #J
  IF #TEMP1 = ' '
      OR (*MACHINE-CLASS = 'MAINFRAME' AND #TEMP1 = ##PHYS-NATUNIX)
      OR (*MACHINE-CLASS NE 'MAINFRAME' AND
      (NOT (#TEMP1= ##PHYS-DISKUNIX OR = ##PHYS-NATUNIX)))
    IGNORE
  ELSE
    ADD 1 TO #I
    #PHYS-TYPES (#I) := #TEMP1
    CV-MARK(#I):= (AD=I)
  END-IF
END-SORT
*
INPUT WINDOW='PH' USING MAP 'HPHAPHT&'
##PHYS-TYPES (*) := #PHYS-TYPES (1:##PHYS-MAX-TYPES)
*
IF *PF-KEY = 'PF3'
  ESCAPE ROUTINE
END-IF
*
FOR #I 1 TO ##PHYS-MAX-TYPES
  IF L-MARK (#I) NE ' ' AND ##PHYS-TYPES (#I) NE ' '
    #PARM := ##PHYS-TYPES (#I)
    SET CONTROL 'N'
    ESCAPE ROUTINE
  END-IF
END-FOR
*
REINPUT ' '
*
END
