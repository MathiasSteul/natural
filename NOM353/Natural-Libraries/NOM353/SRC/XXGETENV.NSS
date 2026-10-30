* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXGETENV - Resolve all environment variables in a string
*  Gets a string which contains environment variables in format
*  $variable or $ävariableü. If all variables can be resolved they
*  are replaced in the string, if not, an error code is returned and
*  only the variable in error is returned the string.
*
*  Maintenance
*  User ID   yyyy-mm-dd Issue         Remark
* --------------------------------------------------------------------- --------
*  fhi       2010-09-23 NOMALL-800    Created.
*  xsetggr   2011-09-30 NOMALL-1057 do not call XXUX---N if no variable
*                       found, just trace message
*  xsetggr   2011-10-07 NOMALL-1057 save value of P-FILE-NAME
* fhi     2012-04-03 NOMALL-1119 Recataloged due to changes of XXUX---P
* fhi     2012-11-08 NOMALL-1004 Backouted NOMALL-1057 for this module
* SU1     2013-01-31 unused      Deactivate unused data areas
* fhi     2013-12-04 NOMALL-1004 Change to asynchronous COMMAND call
* fhi     2014-02-20 NOMALL-1338 Change parameter sequence for xxux---p
* fhi     2014-08-29 NOMALL-1454 Recataloged due to changes of XXUX---P
* fhi     2015-06-25 NOMALL-1573 Add show internal NAT variable
* fhi     2017-03-31 NOMALL-2009 Improve RDC handling
************************************** data ************************************
DEFINE DATA
PARAMETER
1 XXGETENV-VAR       (A)    DYNAMIC BY VALUE RESULT /** inout: Variable
1 XXGETENV-ERC       (N4)             /** out: <>0: Not found
1 XXGETENV-ERT       (A250)           /** out: Error Text
PARAMETER USING XXUX---P
PARAMETER
1 XXGETENV-TRACE     (I2)   OPTIONAL   /** in: optional trace level
1 XXGETENV-INTERNAL  (L)    OPTIONAL   /** in: Nat-internal variable
************************************************************************
INDEPENDENT
1 +CMRDC (A1)
LOCAL
1 #CHCKVAR           (A)    DYNAMIC
1 #POS               (I4)
1 #LEN               (I4)
1 #TRACING           (L)
1 #LG-MSG            (A250)
1 #ENV-VARIABLE      (A250)
1 #DELIMS            (A24)  CONST
  <' Ü"@§%&/Ö()=?*+ß#,;.:'''> /* special chars without '$','-', and '_'
1 USR1053L
  2 INPUTS
    3 ENV-VARIABLE    (A80)
  2 OUTPUTS
    3 CHAR-STRING     (A253)
    3 RESPONSE        (I04)
*
END-DEFINE
*                                                                       ********
********************************************************************************
DEFINE SUBROUTINE XXGETENV-GET-VARS
********************************************************************************
IF XXGETENV-TRACE SPECIFIED AND XXGETENV-TRACE GE *LEVEL
  #TRACING := TRUE
END-IF
*
RESET XXGETENV-ERC XXGETENV-ERT
IF XXGETENV-INTERNAL SPECIFIED AND XXGETENV-INTERNAL = TRUE
    AND *MACHINE-CLASS NE 'MAINFRAME'
  ENV-VARIABLE := XXGETENV-VAR
  CALL 'CMGETENV'  ENV-VARIABLE CHAR-STRING
  RESPONSE := RET ('CMGETENV')
  XXGETENV-ERC := RESPONSE
  IF XXGETENV-ERC NE 0
    COMPRESS 'Internal environment variable not found:' ENV-VARIABLE
      TO XXGETENV-ERT
  ELSE
    XXGETENV-VAR := CHAR-STRING
  END-IF
ELSE
  #CHCKVAR   := XXGETENV-VAR
  REPEAT
    UNTIL #CHCKVAR = ' '
    SEPARATE #CHCKVAR INTO #ENV-VARIABLE
      REMAINDER #CHCKVAR WITH DELIMITERS #DELIMS
    EXAMINE #ENV-VARIABLE FOR '$' GIVING POSITION IN #POS
      LENGTH IN #LEN
    IF #POS NE 0 AND #POS < #LEN
      #ENV-VARIABLE := SUBSTR(#ENV-VARIABLE,#POS)
      P-FILE-NAME := SUBSTR(#ENV-VARIABLE,2)
    ELSE
      ESCAPE TOP
    END-IF
    EXAMINE P-FILE-NAME FOR 'ä' GIVING POSITION IN #POS
      LENGTH IN #LEN
    IF #POS NE 0 AND #POS < #LEN
      #POS := #POS + 1
      P-FILE-NAME := SUBSTR(P-FILE-NAME,#POS)
    END-IF
    EXAMINE P-FILE-NAME FOR 'ü' GIVING POSITION IN #POS
    IF #POS > 1
      #POS := #POS - 1
      P-FILE-NAME := SUBSTR(P-FILE-NAME,1,#POS)
    END-IF
    EXAMINE #ENV-VARIABLE FOR 'ü' GIVING POSITION IN #POS
    IF #POS NE 0
      #ENV-VARIABLE := SUBSTR(#ENV-VARIABLE,1,#POS)
    END-IF
    IF #TRACING
      COMPRESS
        ' Checking env-variable:'  #ENV-VARIABLE 'using'
        P-FILE-NAME TO #LG-MSG
      PERFORM XXRLOG-WRITE-LOG 'T' #LG-MSG
    END-IF
    INCLUDE CMRDC
    IF P-FILE-NAME = ' '
      IF #TRACING
        COMPRESS 'No env variables found in:' XXGETENV-VAR TO #LG-MSG
        PERFORM XXRLOG-WRITE-LOG 'T' #LG-MSG
      END-IF
      ESCAPE ROUTINE
    END-IF
    P-FUNCTION := 'GETENV'
    IF #TRACING
      CALLNAT 'XXUX---N' XXUX---P XXGETENV-TRACE
    ELSE
      CALLNAT 'XXUX---N' XXUX---P
    END-IF
    IF P-ERC = 0
      IF #TRACING
        COMPRESS 'Found value' P-RECORD TO #LG-MSG
        PERFORM XXRLOG-WRITE-LOG 'T' #LG-MSG
      END-IF
      EXAMINE XXGETENV-VAR FOR #ENV-VARIABLE REPLACE P-RECORD
    ELSE
      IF #TRACING
        COMPRESS ' Got error' P-ERC 'in GETENV:' P-ERT TO #LG-MSG
        PERFORM XXRLOG-WRITE-LOG 'T' #LG-MSG
      END-IF
      XXGETENV-ERC := P-ERC
      XXGETENV-ERT := P-ERT
    END-IF
  END-REPEAT
END-IF
*
END-SUBROUTINE /* XXGETENV-GET-VARS
*
END
