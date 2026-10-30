* >Natural Source Header 000000
* :Mode R
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXPARAMS - Set Natural parameters on the fly
*  Description:
*  Changes some Natural startup parameters within the session. /*
*  Fill Parameter field with:
*  <key>=<value>,<key>=<value>,...
*  Subroutine will be extended if other parameters are needed to be set
*
* Maintenance
* User ID   yyyy-mm-dd Issue         Remark
* -----------------------------------------------------------------------------
* fhi       2011-02-07 NOMALL-929    Created.
************************************* data ************************************
DEFINE DATA
PARAMETER
1 P-PARAM  (A250) BY VALUE                 /**in: parameter to be set
************************************************************************
LOCAL
1 #PARAM         (A250)
1 #KEY           (A250)
1 #VALUE         (A250)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
********************************************************************************
DEFINE SUBROUTINE XXPARAMS-SET-PARAM
********************************************************************************
REPEAT
  UNTIL P-PARAM = ' '
  SEPARATE P-PARAM INTO #PARAM REMAINDER P-PARAM WITH DELIMITERS ','
  SEPARATE #PARAM INTO #KEY #VALUE WITH DELIMITERS '=' IGNORE
  DECIDE ON FIRST VALUE OF #VALUE
    VALUE 'ON'
      DECIDE ON FIRST VALUE OF #KEY
        VALUE  'WH'
          SET GLOBALS WH=ON
        NONE
          IGNORE
      END-DECIDE
    VALUE 'OFF'
      DECIDE ON FIRST VALUE OF #KEY
        VALUE  'WH'
          SET GLOBALS WH=OFF
        NONE
          IGNORE
      END-DECIDE
    NONE
      IGNORE
  END-DECIDE
LOOP
*
END-SUBROUTINE /* rowdown
*
END
