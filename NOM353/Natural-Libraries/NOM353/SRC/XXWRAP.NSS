* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXWRAP - Get a string and create lines that are formatted in blocks
*
* Maintenance
* User ID   yyyy-mm-dd Issue         Remark
* -----------------------------------------------------------------------------
* fhi       2010-09-01 NOMALL-97     Created.
* fhi       2014-09-04 NOMALL-1454   Correct msgs with blanks
* fhi       2019-05-27 NOMALL-2281   Avoid scrambled chars or truncatn
* fhi       2019-07-16 NOMALL-2287   Honour stronger syntax: Variable
*                                    'ARRAY' renamed to 'ARR' to avoid
*                                    reserved words in Natural
************************************* data ************************************
DEFINE DATA
PARAMETER
1 FUNCTION    (A1)
/*                                     'L' or ' ' - Left justified
/*                                     'R'        - Right justified
/*                                     'J'        - Justified, blocks
/*                                     'D'        - Decimal Point jstf.,
/*                                                  values separated by
/*                                                  blanks
1 STRING      (A)    DYNAMIC BY VALUE         /** in: String
1 ARR         (A/*)  DYNAMIC BY VALUE RESULT  /** out: Justified array
1 LINESIZE    (I2)           BY VALUE         /** in: Length of line
************************************************************************
LOCAL
1 #LINE       (A)    DYNAMIC
1 #LINELENGTH    (I4)
1 #I             (I4)   INIT <1>
1 #J             (I4)
1 #K             (I4)
1 #L             (I4)
1 #POS           (I4)
1 #POS2          (I4)
1 #DIFF          (I4)
1 #F             (F4)
1 #F2            (F4)
1 #FILLER        (A750)
1 #DECIMAL-POINT (A1)
1 #ALINE         (I2)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE XXWRAP-WORD-WRAP
************************************************************************
REDUCE ARRAY ARR TO 0
EXPAND ARRAY ARR TO (1:10)
RESET ARR (*)
RESET INITIAL #I
MOVE ALL '&%&' TO #FILLER
REPEAT
  UNTIL STRING =' ' OR='/' OR=',' OR=';' OR=':' OR='.' OR='-' OR='_'
  SEPARATE STRING INTO #LINE REMAINDER STRING
    WITH RETAINED DELIMITERS ' /,;:.-_'
  REPSTR. REPEAT
    UNTIL *LENGTH(STRING) < 2
    IF SUBSTR(STRING,1,1) = ' ' OR='/' OR=',' OR=';'
        OR=':' OR='.' OR='-' OR='_'
      COMPRESS FULL #LINE SUBSTR(STRING,1,1) TO #LINE LEAVING NO
      EXAMINE FULL #LINE FOR ' ' REPLACE '?'
      STRING := SUBSTR(STRING,2) /* Delete leading delimiters
    ELSE
      ESCAPE BOTTOM (REPSTR.)
    END-IF
  END-REPEAT
  #LINELENGTH := *LENGTH (ARR (#I)) + *LENGTH (#LINE)
  IF #LINELENGTH < LINESIZE AND FUNCTION NE 'D'
    #L := *LENGTH(ARR(#I))
    DECIDE FOR FIRST CONDITION
      WHEN *LENGTH(#LINE) = 0
        COMPRESS ARR (#I) '?' TO ARR (#I) LEAVING NO
      WHEN #L > 0 AND  SUBSTR(ARR(#I),#L,1) = ' '
        COMPRESS ARR (#I) '?' #LINE TO ARR (#I) LEAVING NO
      WHEN NONE
        COMPRESS FULL ARR (#I) #LINE TO ARR (#I) LEAVING NO
    END-DECIDE
  ELSE
    #F   := #I
    #F   := #F / 10
    #F   := FRAC (#F)
    #F2  := #I
    #F2  := #F / 11
    #F2  := FRAC (#F2)
    IF #F = 0 OR #F2 = 0 /* Occurrence at a limit of 10 or 11
      #J := #I + 10  /* Give it new 10 occurrencies
      EXPAND ARRAY ARR TO (1:#J)
    END-IF
    DECIDE FOR EVERY CONDITION
      WHEN *LENGTH (ARR (#I)) < LINESIZE AND *LENGTH (ARR (#I)) > 0
      AND (FUNCTION = 'R'    /* right justify                         /*
      OR   FUNCTION = 'D')   /* justify decimal point                 /*
        #POS := 3 * (LINESIZE - *LENGTH (ARR (#I)))
        COMPRESS SUBSTR (#FILLER,1,#POS) ARR (#I) TO
          ARR (#I) LEAVING NO
        EXAMINE ARR (#I) FOR '&%&' AND REPLACE WITH FULL ' '
      WHEN *LENGTH (ARR (#I)) < LINESIZE AND *LENGTH (ARR (#I)) > 0
      AND FUNCTION = 'J'    /* justify by blocking                    /*
        REPEAT
          #DIFF := LINESIZE - *LENGTH (ARR (#I))
          EXAMINE ARR (#I) FOR ' ' REPLACE WITH '&%&'
          #POS  := 1
          #POS2 := 0
          FOR. FOR #J = 1 TO #DIFF
            IF #POS > *LENGTH (ARR (#I))
              ESCAPE BOTTOM (FOR.)
            END-IF
            EXAMINE SUBSTR (ARR (#I),#POS) FOR '&%&'
              REPLACE FIRST WITH FULL '  '
              GIVING POSITION IN #POS2
            IF #POS2 = 0
              ESCAPE BOTTOM (FOR.)
            END-IF
            #POS := #POS + #POS2 + 2
          END-FOR
          EXAMINE ARR (#I) FOR '&%&' REPLACE WITH ' '
          UNTIL #POS = 1
        END-REPEAT
      WHEN *LENGTH (ARR (#I)) > LINESIZE /* no delimiter found
        #J := LINESIZE + 1
        COMPRESS SUBSTR (ARR (#I),#J) #LINE
          TO #LINE
        ARR (#I) := SUBSTR (ARR (#I),1,LINESIZE)
        #K := #I + 1
        COMPRESS ARR (#K) SUBSTR(ARR(#I),#J) TO ARR (#K) LEAVING NO
      WHEN *LENGTH (ARR (#I)) > 0
        ADD 1 TO #I
      WHEN NONE
        IGNORE
    END-DECIDE
    ARR (#I) := #LINE
  END-IF
END-REPEAT
EXAMINE ARR (*) FOR '?' REPLACE WITH ' '
IF *LENGTH (ARR (#I)) = 0
  SUBTRACT 1 FROM #I
END-IF
IF #I > 0
  REDUCE ARRAY ARR TO (1:#I)
  IF FUNCTION = 'D'    /* justify decimal point for numeric lists
    RESET #POS
    DECIDE ON EVERY VALUE OF #POS
      VALUE 0
        EXAMINE ARR (*) FOR '.' GIVING POSITION IN #POS
        #DECIMAL-POINT := '.'
      VALUE 0
        EXAMINE ARR (*) FOR ',' GIVING POSITION IN #POS
        #DECIMAL-POINT := ','
      VALUE 0
        ESCAPE ROUTINE
      NONE
        IGNORE
    END-DECIDE
    #ALINE := LINESIZE + 1
    FOR #I = 1 TO *OCC (ARR)
      #POS  := 1
      #POS2 := 0
      REPEAT
        #POS := #POS + #POS2
        IF #POS > *LENGTH (ARR (#I))
          ESCAPE BOTTOM
        END-IF
        EXAMINE SUBSTR (ARR (#I),#POS) FOR #DECIMAL-POINT
          GIVING POSITION IN #POS2
        UNTIL #POS2 = 0
      END-REPEAT
      IF #POS > 1 AND #POS < #ALINE
        #ALINE := #POS
      END-IF
    END-FOR
    #DIFF := #ALINE - LINESIZE - 1
    IF #DIFF = 0
      ESCAPE ROUTINE
    END-IF
    FOR #I = 1 TO *OCC (ARR)
      #POS  := 1
      #POS2 := 0
      REPEAT
        #POS := #POS + #POS2
        IF #POS > *LENGTH (ARR (#I))
          ESCAPE BOTTOM
        END-IF
        EXAMINE SUBSTR (ARR (#I),#POS) FOR #DECIMAL-POINT
          GIVING POSITION IN #POS2
        UNTIL #POS2 = 0
      END-REPEAT
      IF #POS = 1
        #DIFF := LINESIZE - #ALINE + 3
      ELSE
        #DIFF := #POS - #ALINE + 1
      END-IF
      IF #DIFF LE *LENGTH (ARR (#I))
        ARR (#I) := SUBSTR (ARR (#I),#DIFF)
      END-IF
    END-FOR
  END-IF
END-IF
*
END-SUBROUTINE /* XXWRAP-WORD-WRAP
*
END
