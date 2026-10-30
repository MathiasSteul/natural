* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    S-SEPED2 (subroutine to be able to use GDA for S-COMMIT)
* Function  Invoke S-SEPEDT to edit Exit Member (less parms here)
*
* Version   3.5
*
* Maintenance:
* uuu     yyyy-mm-dd itrac ....
* SU      2016-10-12 NOM3.5     created
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
* *****
PARAMETER /*for description see S-SEPEDT
1 #CALLING-PGM  (A8)
1 #EXIT-MEM     (A8)
1 #FUNC         (A1)
1 #ID           (A50) BY VALUE OPTIONAL
1 #PANEL        (I2) OPTIONAL
* *****
LOCAL
1 #POS          (I4)
1 #A8           (A8)
1 #ID2          (A50)
1 #PANEL2       (I2)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE S-SEPED2
************************************************************************
IF #ID SPECIFIED
  #ID2 := #ID
END-IF
IF #PANEL SPECIFIED
  #PANEL2 := #PANEL
END-IF
PERFORM S-SEPEDT #CALLING-PGM #POS #POS #A8 #POS #A8 2X
  #EXIT-MEM 2X #FUNC #ID2 #PANEL2
************************************************************************
END-SUBROUTINE /* S-SEPEDT
*
END
