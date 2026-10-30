* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
************************************************************************
* Module: XXCHKFN - Check file-ids for correct slash and dot entries
*
* Maintenance
* User ID yyyy-mm-dd Issue       Remark
* ------- ---------- ----------- ---------------------------------------
* fhi     2015-05-28 NOMALL-1585 Created.
* fhi     2015-08-12 NOMALL-1663 Avoid 'output file not found'
* fhi     2015-10-13 NOMALL-1743 Resolve short names
* SU1     2015-10-19 NOMALL-1743 correct above
* SU2     2016-03-01 NOMALL-1722 support long path names
* fhi     2016-05-24 NOMALL-1830 Correct Windows path names
* BLI     2019-11-08 NOMALL-2324 Remove Disallow check
* SU3     2022-04-12 NOMALL-2543 avoid NAT0999 in RMSCUX in QA ('..')
/************************************* data ****************************
DEFINE DATA
PARAMETER
/* Composed file id. If empty it will be composed by the other elements:
1 FILE-ID              (A250)      BY VALUE RESULT
1 RC                   (N4) /* '0' = filename ok
  /*                           '1' = filename including path
  /*                           '2' = wrong filename
1 FILEPATH             (A)    DYNAMIC BY VALUE RESULT OPTIONAL
1 FILENAME             (A)    DYNAMIC BY VALUE RESULT OPTIONAL
1 FILETYPE             (A)    DYNAMIC BY VALUE RESULT OPTIONAL
  /* Last slash position in file-id:
1 SLASH                (I4)           BY VALUE RESULT OPTIONAL
  /* Last dot   position in file-id:
1 DOT                  (I4)           BY VALUE RESULT OPTIONAL
1 NO-CHANGE            (A1) OPTIONAL /*any char=do no change nameÜ SU3
************************************************************************
LOCAL USING XXHASH-P
LOCAL
1 #EXTMAX              (I4) CONST <14>
1 #EXTENSIONS          (A10/#EXTMAX)
  CONST <'.ps','.eps','.pdf','.prn','.jpg','.jpeg',
  '.png','.bmp','.rtf','.html','.htm','.tiff','.tif','.txt'>
1 #MASK                (A250)
1 #POS                 (I4)
1 #POS1                (I4)
1 #NUM                 (I4)
1 #BLANK               (I4)
1 #LEN                 (I4)
1 #LEN2                (I4)
1 #SLASH               (I4)
1 #DOT                 (I4)
1 #I                   (I4)
1 #NO-CHANGE           (A1) /*SU3
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE XXCHKFN-CHECK-FILENAME
************************************************************************
RESET RC
IF NO-CHANGE SPECIFIED /*SU3
  #NO-CHANGE := NO-CHANGE
END-IF
IF FILE-ID = ' ' /* compose it from other fields
  DECIDE FOR EVERY CONDITION
    WHEN FILEPATH SPECIFIED AND FILEPATH NE ' '
      IF FILEPATH = SCAN '?' /*required, since FILE-ID is dyn SU2 ->
        XXHASH-PARMS.P-FUNCTION   := 'L' /*short -> long
        XXHASH-PARMS.P-SHORT-NAME := FILEPATH /*Adyn -> A50 ÜÜ
        PERFORM XXHASH XXHASH-PARMS
        FILE-ID := XXHASH-PARMS.P-LONG-NAME
      ELSE /*SU2 <-
        FILE-ID := FILEPATH
      END-IF
    WHEN FILENAME SPECIFIED AND FILENAME NE ' '
      IF FILENAME = SCAN '?' /*required, since FILE-ID is dyn
        XXHASH-PARMS.P-FUNCTION   := 'L' /*short -> long
        XXHASH-PARMS.P-SHORT-NAME := FILENAME /*Adyn -> A50 ÜÜ
        PERFORM XXHASH XXHASH-PARMS
      ELSE
        XXHASH-PARMS.P-LONG-NAME := FILENAME
      END-IF
      IF FILE-ID = ' '
        FILE-ID := XXHASH-PARMS.P-LONG-NAME
      ELSE
        COMPRESS FILE-ID '/' XXHASH-PARMS.P-LONG-NAME
          TO FILE-ID LEAVING NO
      END-IF
    WHEN FILETYPE SPECIFIED AND FILETYPE NE ' '
      IF FILE-ID = ' '
        FILE-ID := FILETYPE
      ELSE
        COMPRESS FILE-ID '.' FILETYPE TO FILE-ID LEAVING NO
      END-IF
    WHEN NONE
      IGNORE
  END-DECIDE
END-IF
IF #NO-CHANGE = ' ' /*SU3
  EXAMINE      FILE-ID FOR 'Ö' REPLACE '/'
  REPEAT
    EXAMINE    FILE-ID FOR '//' REPLACE '/' GIVING POSITION #POS
    UNTIL #POS = 0
  END-REPEAT
  REPEAT
    EXAMINE    FILE-ID FOR '..' REPLACE '.' GIVING POSITION #POS
    UNTIL #POS = 0
  END-REPEAT
  REPEAT
    EXAMINE    FILE-ID FOR ' ' AND DELETE GIVING POSITION #POS
    UNTIL #POS = 0
  END-REPEAT
END-IF
EXAMINE FULL FILE-ID FOR ' ' GIVING POSITION #BLANK LENGTH #LEN
MOVE ALL 'P' TO #MASK /* printable contents
DECIDE FOR EVERY CONDITION
  WHEN FILE-ID = ' '
    RC := 2  /* Nothing
    ESCAPE ROUTINE
  WHEN SUBSTR(FILE-ID,#LEN,1) = '/'
    RC := 2  /* Path instead of name
    ESCAPE ROUTINE
  WHEN FILE-ID NE MASK #MASK OR #POS NE 0 OR #BLANK < #LEN /*blanks
    RC := 2
    ESCAPE ROUTINE
  WHEN NONE
    IGNORE
END-DECIDE
IF #NO-CHANGE = ' ' /*SU3
  FOR #I = 1 TO #EXTMAX
    EXAMINE FILE-ID FOR #EXTENSIONS(#I) GIVING NUMBER #NUM
    REPEAT
      IF #NUM > 1
        EXAMINE FILE-ID FOR #EXTENSIONS(#I) AND DELETE FIRST
          GIVING NUMBER #NUM
      END-IF
      UNTIL #NUM < 2
    END-REPEAT
  END-FOR
END-IF
EXAMINE DIRECTION BACKWARD FILE-ID FOR '/' GIVING POSITION #SLASH
EXAMINE DIRECTION BACKWARD FILE-ID FOR '.' GIVING POSITION #DOT
  LENGTH #LEN
IF #DOT EQ #LEN
  RESET #DOT
END-IF
*
DECIDE FOR EVERY CONDITION
  WHEN #SLASH > 0
    RC := 1
  WHEN SLASH SPECIFIED
    SLASH := #SLASH
  WHEN DOT SPECIFIED
    DOT   := #DOT
  WHEN FILEPATH SPECIFIED
    RESET FILEPATH
  WHEN FILENAME SPECIFIED
    RESET FILENAME
  WHEN FILETYPE SPECIFIED
    RESET FILETYPE
  WHEN FILEPATH SPECIFIED AND #SLASH > 1
    #LEN2      := #SLASH - 1
    FILEPATH   := SUBSTR(FILE-ID,1,#LEN2)
  WHEN FILENAME SPECIFIED AND #LEN > #SLASH AND #LEN > 0
    #POS1      := #SLASH + 1
    IF #DOT LE #POS1
      #LEN2    := #LEN - #POS1 + 1
    ELSE
      #LEN2    := #DOT - #POS1
    END-IF
    FILENAME := SUBSTR(FILE-ID,#POS1,#LEN2)
  WHEN FILETYPE SPECIFIED AND #LEN > 0 AND #SLASH < #DOT
    #POS1 := #SLASH + 2
    #POS  := #DOT   + 1
    IF #POS > #POS1 AND #POS LE #LEN
      FILETYPE := SUBSTR(FILE-ID,#POS)
    END-IF
  WHEN NONE
    IGNORE
END-DECIDE
*
END-SUBROUTINE /* XXCHKFN-CHECK-FILENAME
*
END
