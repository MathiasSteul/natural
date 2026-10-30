* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member
* Function  Distribute an active Report to an User
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* mrs 92-09-15           clean up
* xsetoba 31-07-02 (CE7553) Default Profile non-defined users
* SU1     2013-10-09 show correct msg if report already exist
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
LOCAL
1 LISTS VIEW OF NRM-DISTRIBUTION-LIST
  2 D-LIST-NAME
1 USERS VIEW OF NRM-USERS
  2 USER-ID
*
1 #NEW-USERID                  (A8)
1 IS-LIST                      (L)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE DISTRIBUTE-REPORT
************************************************************************
SET CONTROL 'WC09L40B10/20F'
SET CONTROL 'MT'
INPUT USING MAP 'RADDADM&'
IF *PF-KEY = 'PF3'
  RESET G-NATRP-ERC G-NATRP-ERT
  SET CONTROL 'WB'
  ESCAPE ROUTINE
END-IF
*
FIND-USER. FIND NUMBER USERS WITH USER-ID = #NEW-USERID
IF *NUMBER(FIND-USER.) = 0 OR #NEW-USERID = 'DEFAULT'
  FIND-LIST. FIND NUMBER LISTS WITH D-LIST-NAME =  #NEW-USERID
  IF *NUMBER(FIND-LIST.) = 0
    REINPUT USING HELP MARK *#NEW-USERID
  END-IF
  IS-LIST := TRUE
END-IF
*
IF NOT IS-LIST
  CALLNAT 'RADDMAIL' G-C-REPORT G-C-REPRNB G-USERID #NEW-USERID
    G-NATRP-ERC
  IF G-NATRP-ERC = 1
    REINPUT *0033, 'report' /*SU1 was 'User'
  END-IF
ELSE
  FETCH RETURN 'REXPMAIL' #NEW-USERID
  END TRANSACTION
END-IF
SET CONTROL 'WB'
*
END-SUBROUTINE /* DISTRIBUTE-REPORT
*
END /* DISTRIBUTE-REPORT
