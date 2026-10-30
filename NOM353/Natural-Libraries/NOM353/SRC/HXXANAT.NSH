* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HXXANAT - Select Natural Member
*
* Maintenance
* UUU YY-MM-DD Sagsis Desciption
* --- -------- ------ --------------------------------------------------
* gw  93-06-03        created
* sju 00-10-23 QA     NAT0936 owing to changed SELALPHA parms
* HH 05-01-18 use callnat NATA1100 instead of SYSTEM-FNAT/SYSTEM-FUSER
* sju 05-02-04 NOM31  Use N-LISMEM
* fhi     2010-09-03 NOMALL-97 Extend message line
* SU1     2016-09-15 NOM3.5 restruct
* ----------------------------------------------------------------------
DEFINE DATA PARAMETER
1 #FIELD-NAME     (A65)
1 #PARM           (A8)
************************************************************************
LOCAL
1 G-NATRP-ERC     (N4)
1 G-NATRP-ERT     (A250)
1 #KEY            (A20)
1 REDEFINE #KEY
  2 #KEY-LIB      (A8)
  2 #KEY-MEMBER   (A8)
  2 #KEY-SEQ      (B2)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
IF #PARM NE SCAN '*'
  DECIDE FOR EVERY CONDITION
    WHEN #FIELD-NAME = SCAN 'EOMPH'
      CALLNAT 'EOMPHH-N' #FIELD-NAME (AD=O)
    WHEN #FIELD-NAME = SCAN 'EOMPR'
      CALLNAT 'EOMPRH-N' #FIELD-NAME (AD=O)
    WHEN NONE
      IGNORE
  END-DECIDE
  ESCAPE ROUTINE
END-IF
*
CALLNAT 'RGETLIB' #KEY-LIB
COMPRESS #KEY-LIB 'U' TO #KEY-LIB LEAVING NO
#KEY-MEMBER:= #PARM
CALLNAT 'N-LISMEM' #KEY-LIB #KEY-MEMBER
  'PRTSKEL ' G-NATRP-ERC G-NATRP-ERT
IF #KEY-MEMBER NE ' '
  #PARM:= #KEY-MEMBER
END-IF
*
END
