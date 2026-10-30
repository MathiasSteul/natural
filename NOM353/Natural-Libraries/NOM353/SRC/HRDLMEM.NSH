* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRDLMEM   HELP FOR MEMBER IN DIST LIST
*
* MAINTENANCE:
*
* GW  91-07-31  REMOVED PARM FROM CALLNAT 'RSELDL-N'
* xsetggr 03-07-04 p(240465) make possible  PF3-exit
* ----------------------------------------------------------------------
DEFINE DATA
GLOBAL USING NRM-GL
PARAMETER
1 #MEMBER(A8)
LOCAL
1 #PF-KEY(A4)
1 #OLD-MEM  (A8)
END-DEFINE
*
SET KEY PF4 PF5
SET KEY PF3                       /* xsetggr 03-07-04 p(240465) insert
*
SET CONTROL 'WC10L40F'
INPUT USING MAP 'HMDLMEM&'
MOVE *PF-KEY TO #PF-KEY
DECIDE ON FIRST VALUE OF #PF-KEY
  VALUE 'PF4'
     CALLNAT 'RSELUS-N' #MEMBER
  VALUE 'PF5'
*    CALLNAT 'RSELDL-N' #MEMBER G-USERID
* gw 91-07-31 above line replaced by the following
     CALLNAT 'RSELDL-N' #MEMBER
* xsetggr 03-07-04 p(240465) insert lines
  VALUE 'PF3'
     RESET #MEMBER
     ESCAPE ROUTINE
* xsetggr 03-07-04 p(240465) end insertion
  NONE VALUE IGNORE
END-DECIDE
IF #OLD-MEM NE #MEMBER
  MOVE TRUE TO G-MAP-MODIFIED
END-IF
.
