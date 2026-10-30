* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RMDSTNRM  Distribute to NOM users and distribution list
*
* MAINTENANCE:
*
* GW  92-11-11  Coding moved to callnat 'RMDST--N' for error recovery
*               NATURAL zap ... must be applied !
* ----------------------------------------------------------------------
DEFINE DATA
*
GLOBAL USING MONIT-GL
*
LOCAL
1 #ERROR-COUNT                 (I1)
1 #MEMBERS                     (A8/1:1000)
*
END-DEFINE
* -------------------------------------
DEFINE SUBROUTINE DISTRIBUTE-VIA-NATREP
* -------------------------------------
*
REPEAT
  CALLNAT 'RMDST--N'
                   G-REPORT
                   G-REPRNB
                   ACTIVE-REPORTS.AR-PROCESS-TIME-INV
                   #MEMBERS (*)
                   G-NATRPT-DIST-NO
                   G-JOBUSERID
                   G-NATRPT-DIST (*)
                   G-HOLD
                   G-NATRP-ERC
*
ADD 1 TO #ERROR-COUNT
*
UNTIL G-NATRP-ERC = 0 OR #ERROR-COUNT = 3
*
END-REPEAT
*
END-SUBROUTINE
*
END
