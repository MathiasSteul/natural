* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXHEXPRT - Get a string and return hex values to print them below
*
*  Will look like:
*  ABCDEFG1234567890     --> string example (EBCDIC)
*  CCCCCCCFFFFFFFFFF     --> hexhigh
*  12345671234567890     --> hexlow
*  ----5---10----5--     --> ruler
*
*  Examples:
*
* 1) INPUT-STRING is specified, output portions of 75 characters
*    and convert STRING-PORTION into printable characters
*    ...
*    1 INPUT-STRING   (A)   DYNAMIC
*    1 STRING-PORTION (A75)
*    1 HEX-HIGH       (A75)
*    1 HEX-LOW        (A75)
*    1 RULER          (A75)
*    1 RULER-OFFSET   (A75)
*    ...
*    REP.
*    REPEAT
*      PERFORM XXHEXPRT STRING-PORTION HEXHIGH HEXLOW RULER
*        RULER-OFFSET TRUE INPUT-STRING 75
*    IF RULER-OFFSET = -1
*      ESCAPE BOTTOM (REP.)
*    END-IF
*    * Now log the data:
*      PERFORM XXRLOG-WRITE-LOG 'T' STRING-PORTION
*      PERFORM XXRLOG-WRITE-LOG 'T' HEXHIGH
*      PERFORM XXRLOG-WRITE-LOG 'T' HEXLOW
*      PERFORM XXRLOG-WRITE-LOG 'T' RULER
*    ...
*      END TRANSACTION
*    END-REPEAT
*    ...
*
* 2) INPUT-STRING is not specified, output 75 characters, ruler
*    begins with 1. Convert string-portion into printable characters
*    ...
*    1 STRING-PORTION (A75)
*    1 HEX-HIGH       (A75)
*    1 HEX-LOW        (A75)
*    1 RULER          (A75)
*    ...
*      PERFORM XXHEXPRT STRING-PORTION HEXHIGH HEXLOW RULER 1X TRUE
*    * Now log the data:
*      PERFORM XXRLOG-WRITE-LOG 'T' STRING-PORTION
*      PERFORM XXRLOG-WRITE-LOG 'T' HEXHIGH
*      PERFORM XXRLOG-WRITE-LOG 'T' HEXLOW
*      PERFORM XXRLOG-WRITE-LOG 'T' RULER
*    ...
*      END TRANSACTION
*    ...
*
* 3) Simplest call, output 75 characters without ruler
*    ...
*    1 STRING-PORTION (A75)
*    1 HEX-HIGH       (A75)
*    1 HEX-LOW        (A75)
*    ...
*      PERFORM XXHEXPRT STRING-PORTION HEXHIGH HEXLOW
*    * Now log the data:
*      PERFORM XXRLOG-WRITE-LOG 'T' STRING-PORTION
*      PERFORM XXRLOG-WRITE-LOG 'T' HEXHIGH
*      PERFORM XXRLOG-WRITE-LOG 'T' HEXLOW
*    ...
*      END TRANSACTION
*    ...
*
*
*******************************************************************************
*  Maintenance
*  User ID   yyyy-mm-dd Issue         Remark
* -----------------------------------------------------------------------------
*  fhi       2014-08-15 NOMALL-1454   Created.
*  fhi       2016-04-08 NOMALL-1632   Omit control characters for displ
*  fhi       2016-10-06 NOMALL-1930   Add optional ruler
*  fhi       2016-10-31 NOMALL-1946   change STRING only optional
*  fhi       2018-09-19 NOMALL-1632   Rewritten. Only Printable strings
*  fhi       2018-10-05 NOMALL-2125   Rewritten. Add INPUT-STRING
************************************* data ************************************
DEFINE DATA
*
PARAMETER
/*
1  STRING-PORTION      (A)       DYNAMIC BY VALUE RESULT       /* in/out
/* The string to be printed, can be a portion of the whole string
/* if INPUT-STRING is specified
/*
1  HEXHIGH             (A)       DYNAMIC BY VALUE RESULT          /* out
/* The high-order half byte of the hex equivalent of the string byte
/*
1  HEXLOW              (A)       DYNAMIC BY VALUE RESULT          /* out
/* The low-order  half byte of the hex equivalent of the string byte
/*
1  RULER               (A)       DYNAMIC BY VALUE RESULT OPTIONAL /* out
/* A ruler to be printed as last line to see the offsets of the contents
/*
1  RULER-OFFSET        (I4)              BY VALUE RESULT OPTIONAL /* i/o
/* The start position which is displayed in the ruler - 1
/* (beginning with position 0)
/*
1  PRINTABLE           (L)               BY VALUE        OPTIONAL /* in
/* If TRUE: Replace non-printable characters in STRING-PORTION with
/* degree char (°)
/*
1  INPUT-STRING        (A)       DYNAMIC BY VALUE        OPTIONAL /* in
/* If specified, take it for repeated calls and generate portions
/* of length LEN
/*
1  LEN                 (I4)              BY VALUE        OPTIONAL /* in
/* If INPUT-STRING specified, generate portions of this length,
/* if not, assume a single call with length of STRING-PORTION.
/*
/* Notes: 1) STRING-PORTION may be modified to get rid of control chars.
/*        2) If INPUT-STRING is specified, repeated calls
/*           will return STRING-PORTION/HEXHIGH/HEXLOW/RULER
/*           in length LEN by each call. STRING-PORTION will be
/*           overwritten.
/*        3) If INPUT-STRING is specified, LEN and RULER-OFFSET must
/*           also be specified to allow repeated calls. In this case
/*           RULER-OFFSET must not be changed by the caller.
/*        4) If INPUT-STRING is not specified, STRING-PORTION will be
/*           taken in full length and HEXHIGH/HEXLOW/RULER will be
/*           filled. This call is only once, no repetition possible.
/*        5) This routine only allows (A) strings to be printed in
/*           hex codes.
/*
LOCAL
1 #I                   (I4)
1 #J                   (I4)
1 #K                   (I4)
1 #R                   (I4)
1 #STRING              (A50)
1 #HEXSTRING           (A)         DYNAMIC
1 #RULER               (A)         DYNAMIC
1 #LEN                 (I4)
1 #LEN-A               (I4)
1 #DIGITS              (P9)
1 #A                   (A)         DYNAMIC
1 #L                   (I4)
1 #LOG10               (F4) CONST <2.302585E+00> /* logarithm LOG(10)
1 #STRING-LEN          (I4)
1 #OFFSET              (I4)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
********************************************************************************
DEFINE SUBROUTINE XXHEXPRT
************************************************************************
REDUCE DYNAMIC HEXHIGH   TO 0
REDUCE DYNAMIC HEXLOW    TO 0
DECIDE FOR EVERY CONDITION /* check specifications of variables
  WHEN RULER SPECIFIED
    REDUCE DYNAMIC RULER   TO 0
  WHEN     INPUT-STRING     SPECIFIED
    IF              LEN NOT SPECIFIED
        OR RULER-OFFSET NOT SPECIFIED
      *ERROR-NR    := 999 /* programming error. Specification mandatory.
    END-IF
    IF RULER-OFFSET = -1 /* ruler-offset says end of string at beginning
      RESET RULER-OFFSET
    END-IF
    #OFFSET        := RULER-OFFSET + 1
    #STRING-LEN    := LEN
    DECIDE FOR FIRST CONDITION
      WHEN #OFFSET > *LENGTH(INPUT-STRING)
        RULER-OFFSET := -1
        ESCAPE ROUTINE
      WHEN #OFFSET + #STRING-LEN > *LENGTH(INPUT-STRING)
        #STRING-LEN := *LENGTH(INPUT-STRING) - #OFFSET + 1
      WHEN NONE
        IGNORE
    END-DECIDE
    STRING-PORTION := SUBSTR(INPUT-STRING,#OFFSET,#STRING-LEN)
  WHEN INPUT-STRING NOT SPECIFIED
    #STRING-LEN    := *LENGTH(STRING-PORTION)
  WHEN NONE
    IGNORE
END-DECIDE
FOR #J = 1 TO #STRING-LEN STEP 50
  #STRING := SUBSTR(STRING-PORTION,#J)
  REDUCE DYNAMIC #HEXSTRING TO 0
  MOVE EDITED #STRING (EM=H(50)) TO #HEXSTRING
  FOR #I = 1 TO *LENGTH(#HEXSTRING)
    #K := (#J - 1) * 2 + #I + 1
    DIVIDE 2 INTO #K REMAINDER #R
    IF #R = 0
      MOVE SUBSTR(#HEXSTRING,#I,1) TO SUBSTR(HEXHIGH,#K)
    ELSE
      MOVE SUBSTR(#HEXSTRING,#I,1) TO SUBSTR(HEXLOW,#K)
    END-IF
  END-FOR
END-FOR
#LEN     := *LENGTH(STRING-PORTION)
IF RULER SPECIFIED
  MOVE ALL '-' TO #RULER UNTIL #LEN
  FOR #I = 1 TO #LEN
    #J   := #K := #I
    IF RULER-OFFSET SPECIFIED
      #J := #K := #K + RULER-OFFSET
    END-IF
    #DIGITS := (LOG (#K) / #LOG10) + 1
    #A   := #J
    EXAMINE #A FOR ' ' GIVING LENGTH IN #LEN-A
    DIVIDE 10 INTO #K REMAINDER #R
    DECIDE ON FIRST VALUE OF #R
      VALUE 0
        DECIDE FOR EVERY CONDITION
          WHEN #DIGITS > 4
            #DIGITS := 4
            #L      := #I - 3
            #LEN-A  := #LEN-A - 3
            #A      := SUBSTR(#A,#LEN-A)
          WHEN #DIGITS < 5
            #L      := #I - #DIGITS + 1
          WHEN #L > 0
            MOVE #A TO SUBSTR(#RULER,#L,#DIGITS)
          WHEN NONE
            IGNORE
        END-DECIDE
      VALUE 5
        MOVE '5' TO SUBSTR(#RULER,#I,1)
      NONE
        IGNORE
    END-DECIDE
  END-FOR
  REDUCE DYNAMIC RULER TO 0
  RULER := #RULER
END-IF
DECIDE FOR EVERY CONDITION
  WHEN PRINTABLE SPECIFIED AND PRINTABLE = TRUE
    FOR #J = 1 TO *LENGTH(STRING-PORTION)
      IF SUBSTR(STRING-PORTION,#J,1) NE MASK(P)
        MOVE '°' TO SUBSTR(STRING-PORTION,#J,1)
      END-IF
    END-FOR
  WHEN INPUT-STRING SPECIFIED
    RULER-OFFSET := RULER-OFFSET + #STRING-LEN
    IF RULER-OFFSET > *LENGTH(INPUT-STRING)
      RULER-OFFSET := -1
    END-IF
  WHEN NONE
    IGNORE
END-DECIDE
*                                                                       ********
END-SUBROUTINE /* XXHEXPRT
*                                                                       ********
END
