* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXLOGERR - Writes a string to log. Regards error numbers
*  Calls the WRITE-LOG routine if the ERC variable is non-zero.
*  Regards RLOG functions 'W' and 'S'
*
*  Maintenance
*  User ID   yyyy-mm-dd Issue         Remark
* -----------------------------------------------------------------------------
*  fhi       2010-09-23 NOMALL-800    Created.
*  fhi       2012-05-02 NOMALL-1118   Parameter error corrected.
************************************* data ************************************
DEFINE DATA
PARAMETER
1 XXLOGERR-FUNCTION  (A1) BY VALUE
/* 'L' Log only, 'W' Write to output, too.
/*SU 2018-10-30 no longer: 'S' Stack Log.
1 XXLOGERR-ERC       (N4)
1 XXLOGERR-ERT       (A250)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
********************************************************************************
DEFINE SUBROUTINE XXLOGERR-LOG-ERROR
************************************************************************
IF XXLOGERR-ERC NE 0
  IF XXLOGERR-ERT = ' '
    XXLOGERR-ERT := XXLOGERR-ERC
  END-IF
  PERFORM XXRLOG-WRITE-LOG XXLOGERR-FUNCTION XXLOGERR-ERT
END-IF
*
END-SUBROUTINE /* XXLOGERR-LOG-ERROR
*
END
