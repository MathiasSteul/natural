* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* --- NRPHLP1 --- copied from NRPHLP
*
* SU1     2018-02-19 NOM 3.5 created  special helproutine for direct cmd
* -------------------------------------------------------------------
DEFINE DATA
GLOBAL USING NRM-GL
PARAMETER
1 #INPUT-MEMBER (A20) BY VALUE OPTIONAL
************************************************************************
LOCAL
1 #PAGESIZE      (I2)
1 #CONTROL       (A5)
1 #INPUT-MEMBER1 (A20)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
PERFORM CONTROL
IF #INPUT-MEMBER SPECIFIED /* NOMALL-1007 in
  IF *PF-KEY ='PF1' OR='PF13'
    #INPUT-MEMBER1 := #INPUT-MEMBER
  ELSE /* '?'
    #INPUT-MEMBER1 := 'HCOMMAND'
  END-IF
  FETCH RETURN 'NRMHELP' #INPUT-MEMBER1
ELSE
  FETCH RETURN 'NRMHELP'
END-IF
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
