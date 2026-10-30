* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RHANMOS - FOLLOW MONITOR STATUS
*
* MAINTENANCE:
* GW  92-05-07  avoid NAT0936
* gw  94-01-05 s(999999) status in English and German
* sju 00-03-10 s(999999) avoid Nat0936
* fhi 00-09-05 S(191603) Monitor status not updated in OSD
* xsetggr 2005-10-26 p(270950) ISN fields must be P10, not P8
* xsetggr 2007-05-02 NOm3201  support 5 byte node numbers
* fhi     2010-09-03 NOMALL-97 Extend message line
* fhi     2016-12-02 NOMALL-1961 Use Node-Name
* ----------------------------------------------------------------------
DEFINE DATA
GLOBAL USING NRM-GL
LOCAL
1 #RHANMONP
  2 #STATUS          (A24)
  2 #LAST-TIME       (A8)
  2 #LAST-DATE       (A10)
  2 G-MONITOR-NODE   (N5)
  2 G-MONITOR-JOBNAME(A8)
  2 G-SPOOL-TYPE     (A8)
  2 G-WAIT-MINIMUM   (N4)
  2 G-WAIT-MAXIMUM   (N4)
  2 G-WAIT-INCREMENT (N4)
  2 G-WAIT-FACTOR    (N4)
  2 G-DATE-FORMAT    (A1)
  2 G-LANGUAGE       (I1)
  2 G-NATRP-ERT      (A250)
  2 G-NATRP-ERC      (N4)
1 #ISN               (P10)
1 #TASK-NUMBER       (N3) CONST <1>
1 #NODE-NAME         (A16)
1 #LINE              (N4)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE FOLLOW-MONITOR
************************************************************************
MOVE BY NAME NRM-GL TO #RHANMONP
CALLNAT 'RHANMON' #RHANMONP #ISN #TASK-NUMBER #NODE-NAME #LINE
MOVE BY NAME #RHANMONP TO NRM-GL
IF #RHANMONP.G-LANGUAGE = 2
  COMPRESS 'NOM0005 - Monitor zuletzt aktiv um'
    #LAST-TIME #LAST-DATE TO NRM-GL.G-NATRP-ERT
ELSE
  COMPRESS 'NOM0005 - Monitor last active at'
    #LAST-TIME #LAST-DATE TO NRM-GL.G-NATRP-ERT
END-IF
NRM-GL.G-NATRP-ERC := 5
*
END-SUBROUTINE /* FOLLOW-MONITOR
*
END
