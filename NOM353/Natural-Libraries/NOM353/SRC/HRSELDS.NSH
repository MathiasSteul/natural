* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRSELDS
* Function           printer selection list
*
* Maintenance
* mrs 92-05-22   s(150306)     restrict printer selection
* XSETOBA 2001-10-29 P(208366) PRINTING ATRIBUTES CONTROL FOR BUNDLE DEF
* xsetggr 2008-01-23 p(302721) prevent NAT0082 due to call of N-SELDS
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #DEST        (A8)
************************************************************************
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
IF NOT G-USE-SPOOLER
  IF #DEST = SCAN '*'
    CALLNAT 'HRSELPRN' #DEST G-USERID G-USER-TYPE
    IF #DEST = SCAN '*'
      RESET #DEST
    END-IF
  ELSE
    IF #DEST = ' '
      INPUT USING MAP 'HBUPRT&'
    END-IF
  END-IF
END-IF
*
END
