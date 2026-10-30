* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXMVAR-S - Fill an alpha array into a long alpha variable
*
*  Nom often stores structures in Adabas using multiple A250 fields.
*  To get a better handling of these structures with dynamic variables
*  this routine assumes arrays of #PORTION fields which are moved into
*  a single dynamic variable regardless of contained blanks.
*
*  Maintenance
*  User ID   yyyy-mm-dd Issue         Remark
* -----------------------------------------------------------------------------
*  fhi       2010-10-08 NOMALL-97     Created.
*  fhi       2014-06-04 NOMALL-1425   Avoid NAT1326 with empty arrays
*  fhi       2014-06-12 NOMALL-1430   Avoid NAT5747 with empty arrays
*  fhi       2018-01-16 NOMALL-1917   Add variable field length
*                                     Not all changes tagged.
************************************* data ************************************
DEFINE DATA
PARAMETER
1 TARGET-FIELD          (A)         DYNAMIC BY VALUE RESULT
1 SOURCE-ARRAY          (A250/1:V)  BY VALUE
1 ARRAY-LENGTH          (I4)        BY VALUE OPTIONAL
************************************************************************
INDEPENDENT
1 +DEVICE               (A8)
************************************************************************
LOCAL
1 #I                    (I4)
1 #POS                  (I4)
1 #LEN1                 (I4)
1 #LEN2                 (I4)
1 #SUBST                (A250)
1 #TRACING              (L)
1 #TRACE-MSG            (A250)
1 #PORTION              (I4)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
********************************************************************************
DEFINE SUBROUTINE XXMVAR-S-MOVE-ARRAY
************************************************************************
MOVE ALL H'01' TO #SUBST
DECIDE FOR EVERY CONDITION
  WHEN ARRAY-LENGTH SPECIFIED
    #PORTION   := ARRAY-LENGTH
  WHEN NOT ARRAY-LENGTH SPECIFIED
    #PORTION   := 250
  WHEN #PORTION > 250
    *ERROR-NR  := 999 /* Unexpected value, internal error.
  WHEN +DEVICE  =  'BATCH'
    PERFORM RMGTRACE-GET-SETTINGS #TRACING
  WHEN +DEVICE NE 'BATCH'
    PERFORM RMGTRACO-GET-SETTINGS #TRACING
  WHEN #TRACING
    COMPRESS 'Subr. MOVE-ARRAY - occurrence of source-array:'
      *OCC (SOURCE-ARRAY)
      TO #TRACE-MSG
    PERFORM XXRLOG-WRITE-LOG 'T' #TRACE-MSG
  WHEN NONE
    IGNORE
END-DECIDE

REDUCE DYNAMIC TARGET-FIELD TO 0
FOR #I = 1 TO *OCC (SOURCE-ARRAY)
  #POS := #PORTION * (#I - 1) + 1
  MOVE #SUBST TO SUBSTR (TARGET-FIELD,#POS)
  IF SOURCE-ARRAY (#I) NE ' '
    EXAMINE SOURCE-ARRAY (#I) FOR 'X' GIVING LENGTH #LEN1
    EXAMINE FULL SUBSTR (TARGET-FIELD,#POS) FOR 'X'
      GIVING LENGTH #LEN2
    IF #LEN1 > #LEN2
      #LEN1 := #LEN2
    END-IF
    MOVE SUBSTR (SOURCE-ARRAY (#I),1,#LEN1)
      TO SUBSTR (TARGET-FIELD,#POS)
  ELSE
    EXAMINE SUBSTR (TARGET-FIELD,#POS) FOR H'01' REPLACE ' '
  END-IF
END-FOR
*                                                                       ********
END-SUBROUTINE /* XXMVAR-S-MOVE-ARRAY
*                                                                       ********
END
