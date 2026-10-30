* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* ----------------------------------------------------------------------
* Member    NOMRPCXD
* Version   3.4
* Function  Delete a tag in a string containing "key1=value1;key2=..."
*           Templates: NOMRPCX
* ----------------------------------------------------------------------
*
* Maintenance
* -----------
* uuuuuu  yyyy-mm-dd P999999 Remark
* fhi     2013-05-29 OPO-36  Created from NOMRPCX
* ----------------------------------------------------------------------
DEFINE DATA
*
PARAMETER
1 #STRING                  (A)    DYNAMIC BY VALUE RESULT
1 #TAG-DELETE              (A250)         BY VALUE
LOCAL
1 #STRING-TEMP             (A)    DYNAMIC
1 #TAG                     (A)    DYNAMIC
1 #VALUE                   (A)    DYNAMIC
1 #POS                     (I4)
1 #LEN                     (I4)
END-DEFINE
* ------------------------------------------- delete-tag ---------------
*
DEFINE SUBROUTINE DELETE-TAG
*                 ----------
#STRING-TEMP := #STRING
RESET           #STRING
REDUCE DYNAMIC  #STRING TO 0
REPEAT
  UNTIL #STRING-TEMP = ' '
  SEPARATE #STRING-TEMP INTO #TAG
    REMAINDER #STRING-TEMP
    WITH DELIMITERS ';'
  SEPARATE #TAG  INTO #VALUE
    IGNORE
    WITH DELIMITERS '='
  IF #VALUE NE  SCAN(#TAG-DELETE)
    COMPRESS #STRING #TAG ';' TO #STRING LEAVING NO
  END-IF
END-REPEAT
#LEN      := *LENGTH(#STRING)
IF #LEN > 1 AND SUBSTR(#STRING,#LEN,1) = ';'
  #LEN    := #LEN - 1
  #STRING := SUBSTR(#STRING,1,#LEN)
END-IF
*
END-SUBROUTINE
*
* ----------------------------------------------------------------------
*
END
