* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRDLMEM - HELP FOR MEMBER IN DIST LIST
*
* xsetggr 2002-10-14 CE7553  PF3 for exit from map
************************************************************************
DEFINE DATA
GLOBAL USING NRM-GL
PARAMETER
1 #MEMBER(A8)
************************************************************************
LOCAL
1 #PF-KEY(A4)
1 #OLD-MEM  (A8)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
SET KEY PF4 PF5 PF3
SET CONTROL 'WC10L40F'
INPUT USING MAP 'HMDLMEM&'
DECIDE ON FIRST VALUE OF *PF-KEY
  VALUE 'PF4' CALLNAT 'RSELUS-N' #MEMBER
  VALUE 'PF5' CALLNAT 'RSELDL-N' #MEMBER
  VALUE 'PF3' RESET #MEMBER ESCAPE ROUTINE
  NONE        IGNORE
END-DECIDE
IF #OLD-MEM NE #MEMBER
  G-MAP-MODIFIED := TRUE
END-IF
END
