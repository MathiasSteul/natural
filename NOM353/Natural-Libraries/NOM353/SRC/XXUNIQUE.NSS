* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXUNIQUE - Delete doubled parts from a string to be unique.
*  Regard NOM error messages only.
*  If force parameter is set to 'F' do it anyway and don't expect an
*  error message line.
*
*  Maintenance
*  User ID   yyyy-mm-dd Issue         Remark
* -----------------------------------------------------------------------------
*  fhi       2014-04-02 NOMALL-1346   Created.
*  fhi       2014-08-27 NOMALL-1454   Check for 'NOMNOM'
*  fhi       2015-10-05 NOMALL-1737   Allow for all strings with 'F'
*  fhi       2015-10-29 NOMALL-1760   Allow defined delimiters
*  fhi       2015-12-22 NOMALL-1796   Execution with delimiter fails
*                                     replace word* with token'
*  fhi       2016-01-21 NOMALL-1796   Correct delimiter handling
************************************* data ************************************
DEFINE DATA
PARAMETER
1 STRING               (A)         DYNAMIC BY VALUE RESULT
1 FORCE                (A1)        BY VALUE OPTIONAL
1 DELIM                (A1)        BY VALUE OPTIONAL
************************************************************************
LOCAL
1 #TOKENS              (I2)
1 #NUMBER-TOKENS       (I2)
1 #DELIM               (A1)
1 #FOUND               (L)
1 #TOKEN-ARRAY         (A/500)     DYNAMIC
1 #LOOP                (I2)
1 #LOOP-MAX            (I2)        INIT <100>
1 #FROM-K              (I2)
1 #TO-I                (I2)
1 #TO-J                (I2)
1 #TO-K                (I2)
1 #I                   (I2)
1 #J                   (I2)
1 #K                   (I2)
1 #DOT                 (I2)
1 #FORCE               (A1)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
********************************************************************************
DEFINE SUBROUTINE XXUNIQUE-DEL-DOUBLE
************************************************************************
IF FORCE SPECIFIED
  #FORCE := FORCE
END-IF
IF DELIM SPECIFIED
  #DELIM := DELIM
END-IF
EXAMINE STRING FOR 'NOMNOM' REPLACE 'NOM'
IF STRING NE MASK (...NNNN) AND STRING NE MASK (NNNN' ')
    AND #FORCE NE 'F'
  ESCAPE ROUTINE /* For error messages only
END-IF
RESET #LOOP
REP. REPEAT
  RESET #FOUND
  REDUCE DYNAMIC #TOKEN-ARRAY (*) TO 0
  SEPARATE STRING INTO #TOKEN-ARRAY (*) IGNORE
    WITH DELIMITERS #DELIM GIVING NUMBER IN #TOKENS
  IF #TOKENS < 3
    ESCAPE BOTTOM (REP.)
  END-IF
  IF #FORCE NE 'F'
    EXAMINE #TOKEN-ARRAY (#TOKENS) FOR '.' GIVING POSITION IN #DOT
    IF #DOT > 0
      EXAMINE #TOKEN-ARRAY (#TOKENS) FOR '.' AND DELETE
    END-IF
  END-IF
  #NUMBER-TOKENS := #TOKENS / 2
  FORI. FOR #I = #NUMBER-TOKENS TO 1 STEP -1 /* NOMALL-1796 was 'TO 2'
    #TO-I := #TOKENS - #I
    FOR #J = 1 TO #TO-I
      #TO-J   := #J + #I - 1
      #FROM-K := #J + #I
      FORK. FOR #K = #FROM-K TO #TOKENS
        #TO-K   := #K + #I - 1
        IF #TO-K > #TOKENS
          ESCAPE BOTTOM (FORK.)
        END-IF
        IF #TOKEN-ARRAY (#J:#TO-J) = #TOKEN-ARRAY (#K:#TO-K)
            AND *LENGTH (#TOKEN-ARRAY (#J:#TO-J)) > 1
          RESET #TOKEN-ARRAY (#K:#TO-K)
          REDUCE DYNAMIC STRING TO 0
          COMPRESS #TOKEN-ARRAY (1:#TOKENS) TO STRING
            WITH DELIMITER #DELIM
          IF #DOT > 0 AND #FORCE NE 'F'
            COMPRESS STRING '.' TO STRING LEAVING NO
          END-IF
          MOVE TRUE TO #FOUND
          ESCAPE BOTTOM (FORI.)
        END-IF
      END-FOR
    END-FOR
  END-FOR
  ADD 1 TO #LOOP
  UNTIL #LOOP GE #LOOP-MAX OR NOT #FOUND
END-REPEAT
*
END-SUBROUTINE /* XXUNIQUE-DEL-DOUBLE
*
END
