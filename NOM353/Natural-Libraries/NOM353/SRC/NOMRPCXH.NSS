* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* NOMRPCXH - Hide tags according to OPO-36 with "key1=value1;key2=..."
*           Templates: NOMRPCXD
*
* Maintenance
* uuuuuu  yyyy-mm-dd P999999     Remark
* fhi     2013-05-29 OPO-36      Created from NOMRPCX
* fhi     2014-03-31 NOMALL-1393 Set contents of tags into lower case
* ----------------------------------------------------------------------
DEFINE DATA
PARAMETER
1 #STRING                  (A)     DYNAMIC BY VALUE RESULT
************************************************************************
LOCAL
1 #STRING-TEMP             (A)     DYNAMIC
1 #TAG                     (A)     DYNAMIC
1 #VALUE                   (A)     DYNAMIC
1 #POS                     (I4)
1 #LEN                     (I4)
1 #MAX-TAGS                (I4)
1 #TAGS                    (A/100) DYNAMIC
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE HIDE-TAGS
************************************************************************
EXAMINE #STRING FOR 'showproperties' GIVING POSITION IN #POS
IF #POS = 0
  ESCAPE ROUTINE
END-IF
SEPARATE SUBSTR(#STRING,#POS) INTO #TAG IGNORE WITH DELIMITERS ';'
SEPARATE #TAG INTO #TAG #TAG IGNORE WITH DELIMITERS '='
EXAMINE #TAG AND TRANSLATE INTO LOWER /* NOMALL-1393 2014-03-31 fhi in
REPEAT
  UNTIL #TAG = ' '
  SEPARATE #TAG INTO #VALUE REMAINDER #TAG WITH DELIMITERS ','
  #MAX-TAGS  := #MAX-TAGS + 1
  IF #MAX-TAGS > 100      /* should not occur
    *ERROR-NR := 999
  END-IF
  #TAGS (#MAX-TAGS) := #VALUE
END-REPEAT
#STRING-TEMP := #STRING
RESET           #STRING
REDUCE DYNAMIC  #STRING TO 0
REPEAT
  UNTIL #STRING-TEMP = ' '
  SEPARATE #STRING-TEMP INTO #TAG REMAINDER #STRING-TEMP
    WITH DELIMITERS ';'
  SEPARATE #TAG INTO #VALUE IGNORE WITH DELIMITERS '='
  EXAMINE #TAGS(*) FOR #VALUE GIVING INDEX IN #POS
  IF #POS NE 0
    COMPRESS #STRING #TAG ';' TO #STRING LEAVING NO
  END-IF
END-REPEAT
#LEN      := *LENGTH(#STRING)
IF #LEN > 1 AND SUBSTR(#STRING,#LEN,1) = ';'
  SUBTRACT 1 FROM #LEN
  #STRING := SUBSTR(#STRING,1,#LEN)
END-IF
*
END-SUBROUTINE /* HIDE-TAGS
*
END
