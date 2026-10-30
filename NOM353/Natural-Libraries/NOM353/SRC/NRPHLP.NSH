* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* --- NRPHLP ---
*
* SPLIAR  2009-07-06 P(304313) MESSAGE LINE - FORCE L21
* XSETGGR 2009-12-09 P(322145) SET MSG LINE TO TOP AFTER WORK
* fhi     2010-01-21 P(322145) SET MSG LINE TO Pagesize - 3
* fhi     2011-06-09 NOMALL-1007 Correct parameter handling
* -------------------------------------------------------------------
DEFINE DATA
GLOBAL USING NRM-GL
PARAMETER
* 1 #INPUT-MEMBER(A8)
* fhi     2011-06-09 NOMALL-1007 Line above out, below in
1 #INPUT-MEMBER (A20) BY VALUE OPTIONAL
**1 #INPUT-MEMBER2(A20) BY VALUE OPTIONAL
************************************************************************
LOCAL
1 #PAGESIZE (I2)
1 #CONTROL  (A5)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
PERFORM CONTROL
IF #INPUT-MEMBER SPECIFIED /* NOMALL-1007 in
  FETCH RETURN 'NRMHELP' #INPUT-MEMBER
* fhi     2011-06-09 NOMALL-1007 start insertion
ELSE
  FETCH RETURN 'NRMHELP'
END-IF
* fhi     2011-06-09 NOMALL-1007 end   insertion
PERFORM CONTROL
*
************************************************************************
* End of main line (now subroutines):
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE CONTROL
************************************************************************
#PAGESIZE := *PAGESIZE - 3
COMPRESS 'M' #PAGESIZE TO #CONTROL LEAVING NO
SET CONTROL #CONTROL
*
END-SUBROUTINE /* CONTROL
*
END
