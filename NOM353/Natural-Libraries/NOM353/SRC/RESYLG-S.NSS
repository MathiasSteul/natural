* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RESYLG-S - Logon to ESY (NOM Online)
*
* Maintenance:
* uuu     yyyy-mm-dd s(999999) ...
* mrs     1994-05-03 s(999999) created
* jvd     1998-09-14 p(164220) NAT23ÖNOM141
* fhi     2005-06-23 p(266530) Make Monitor NPR Mainframe independent
* xsetggr 2007-05-07 NOM3201   Support 5 byte node numbers
* SU1     2013-01-31 unused      Deactivate unused data areas
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING  NRM-GL
LOCAL USING SATSL03P
LOCAL USING SATSL--E
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE LOGON-TO-ESY
************************************************************************
RESET SATSL-PARMS-03 (*)
*
SATSL-NODE-N5  := G-MONITOR-NODE
SATSL-USER     := G-NPR-USERID
SATSL-PASSWORD := G-PASSWORD
SATSL-FUNCTION := SATSL-SPECIAL-LOGON
SATSL-SATVERS  := 21
CALLNAT 'RMSATSLN' SATSL-SATVERS SATSL-PARMS-03(*)
IF SATSL-ERROR-CODE = 0
  G-NPR-USERID-CURRENT := G-NPR-USERID
ELSE
  G-NATRP-ERC := 0005
  G-NATRP-ERT := SATSL-ERROR-TEXT
  RESET G-NPR-USERID-CURRENT
END-IF
*
END-SUBROUTINE /* LOGON-TO-ESY
*
END
