* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXMVFI-S - Fill a long alpha variable into an alpha array
*
*  Nom often stores structures in Adabas using multiple #PORTION fields.
*  To get a better handling of these structures with dynamic variables
*  this routine assumes a single dynamic variable containing portions
*  of #PORTION fields and moves these data into an array
*  regardless of any blanks in the strings.
*
*  Maintenance
*  User ID   yyyy-mm-dd Issue         Remark
* -----------------------------------------------------------------------------
*  fhi       2010-10-08 NOMALL-97     Created.
*  fhi       2018-01-18 NOMALL-1917   Add variable field length.
*                                     Rewritten.
************************************* data ************************************
DEFINE DATA
PARAMETER
1 TARGET-ARRAY          (A250/1:V)  BY VALUE RESULT
1 SOURCE-FIELD          (A)         DYNAMIC BY VALUE
1 ARRAY-LENGTH          (I4)        BY VALUE OPTIONAL
************************************************************************
INDEPENDENT
1 +DEVICE               (A8)
************************************************************************
LOCAL
1 #I                    (I4)
1 #J                    (I4)
1 #LEN                  (I4)
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
DEFINE SUBROUTINE XXMVFI-S-MOVE-FIELD
************************************************************************
DECIDE FOR EVERY CONDITION
  WHEN ARRAY-LENGTH SPECIFIED
    #PORTION := ARRAY-LENGTH
  WHEN NOT ARRAY-LENGTH SPECIFIED
    #PORTION := 250
  WHEN #PORTION > 250
    *ERROR-NR := 999 /* Unexpected value, internal error.
  WHEN +DEVICE = 'BATCH'
    PERFORM RMGTRACE-GET-SETTINGS #TRACING
  WHEN +DEVICE NE 'BATCH'
    PERFORM RMGTRACO-GET-SETTINGS #TRACING
  WHEN #TRACING
    COMPRESS 'Subr. MOVE-FIELD - length of source-field:'
      *LENGTH (SOURCE-FIELD) TO #TRACE-MSG
    PERFORM XXRLOG-WRITE-LOG 'T' #TRACE-MSG
  WHEN NONE
    IGNORE
END-DECIDE
RESET TARGET-ARRAY (*) #J
FOR #I = 1 TO *LENGTH (SOURCE-FIELD) STEP #PORTION
  ADD 1 TO #J
  MOVE SUBSTR (SOURCE-FIELD,#I) TO TARGET-ARRAY (#J)
END-FOR
*
END-SUBROUTINE /* XXMVFI-S-MOVE-FIELD
*
END
