* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXHASH - Convert short names (A50) to long names (A250) and vice versa
* NOM can handle file names only up to 50 char in length. This routine
* handles a table of short names and their original names:
* If a name exceeds 50 char in length, the first 38 chars will be
* taken as body, then a '?' sign will follow as indicator that a name
* has been hashed,then a number of 11 digits will follow as run number
*
* A maximum length of the names can be specified optional. Default is
* 50 char. A max length > 50 will be limited to 50.
*
* Functions:
*  S: Convert long-name to short-name
*  L: Convert short-name to long-name
*  U: Update  HA-REPRNB in record
*  D: Delete FILE-NAMES entry of long-name or short name, depending
*     what field is filled. Recommended: Use short name for deletion.
*
*  If function 'S'
*     o gets a long name up to 50 chars length it will
*       return the same short name without conversion.
*     o detects an overflow of the table, 2 is
*       returned in P-RC and the fields remain unchanged.
*     o gets out of runnumbers, the runnumber is reset to 1
*
*  If function 'L' does not find the corresponding long-name, error 1
*  is returned in P-RC and the fields remain unchanged.
*
*  END TRANSACTION has to be done by the caller for functions 'S',
*  'D', and 'U'
*
*  The filename is intended to consist of name.type but without path.
*
* Parameters:
* P-FUNCTION            (A1)    /* S: Convert long-name to short-name
*                               /* L: Convert short-name to long-name
*                               /* U: Update HA-REPRNB in record
*                               /* D: Delete table entry of long-name
* P-SHORT-PATH          (A70)
* P-SHORT-NAME          (A50)
* P-LONG-NAME           (A250)
* P-RC                  (N4)
* P-NAME-MAX            (I2)  OPTIONAL /* Default: 50 bytes
*                             NOT used for functions: U, L
* P-REPRNB              (A37) OPTIONAL /* <repname>/<runnumber>
*
*  Maintenance
*  User ID   yyyy-mm-dd Issue         Remark
* -----------------------------------------------------------------------------
*  fhi       2014-10-13 NOMALL-79   Created.
*  SU1       2015-08-11 NOMALL-1690 restructure + comments + max.len.
*  fhi       2015-08-26 NOMALL-1690 Add trace statements
*  SU2       2015-09-18 NOMALL-1690 show more trace
*  SU3       2015-12-30 NOMALL-1722 XXHASH-P changed->recat
*  BLI       2019-11-15 NOMALL-2346 Use NOM343M version w/o 'F'
*                                   Reworked RMRCSTMP with 'L'
************************************* data ************************************
DEFINE DATA
PARAMETER USING XXHASH-P
* *****
LOCAL
1 FILE-NAMES VIEW OF NRM-FILE-NAMES
  2 HA-SHORT-FILENAME
  2 HA-LONG-FILENAME
  2 HA-REPRNB
1 #KEY                  (A50)
1 #POS-HASH             (I1)
1 #LEN                  (I4)
1 #BODY-LENGTH          (I2)
1 #NUMB-A               (A11)
1 REDEFINE #NUMB-A
  2 #NUMB               (N11)
1 #KEY-NUMB-A           (A11)
1 REDEFINE #KEY-NUMB-A
  2 #KEY-NUMB           (N11)
1 #TRACING              (L)
1 #TRACE-MSG            (A250)
1 #PROGRAM              (A8)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE XXHASH
************************************************************************
IF P-TRACE-HASH SPECIFIED
  #TRACING := P-TRACE-HASH
END-IF
RESET P-RC #NUMB #KEY-NUMB
IF P-NAME-MAX SPECIFIED AND P-NAME-MAX > 12 AND P-NAME-MAX < 51
  #BODY-LENGTH := P-NAME-MAX - 12
ELSE
  #BODY-LENGTH := 38
END-IF
#POS-HASH := #BODY-LENGTH + 2
IF #TRACING
  PERFORM XXLSLEVL-GET-LAST-LEVEL #PROGRAM
  COMPRESS 'Got function' P-FUNCTION 'from' #PROGRAM TO #TRACE-MSG
  IF P-FUNCTION = 'S' /*long->short
    COMPRESS #TRACE-MSG '- long:'  P-LONG-NAME TO #TRACE-MSG
  ELSE /* L/D/U
    COMPRESS #TRACE-MSG '- short:' P-SHORT-NAME TO #TRACE-MSG
  END-IF
  IF P-FUNCTION = 'S' OR='U' /*long->short
    COMPRESS #TRACE-MSG '- rep:' P-REPRNB TO #TRACE-MSG
    IF P-NAME-MAX SPECIFIED
      COMPRESS #TRACE-MSG '- max:'   P-NAME-MAX TO #TRACE-MSG
    END-IF
    PERFORM XXRLOG-WRITE-LOG 'T' #TRACE-MSG
  END-IF
END-IF
*
DECIDE ON FIRST VALUE OF P-FUNCTION
************************************************************************
  VALUE 'S' /* S: Convert long-name to short-name
    EXAMINE P-LONG-NAME FOR ' ' GIVING LENGTH #LEN
    IF #LEN LE #BODY-LENGTH + 12 /*SU1 +12 added
      P-SHORT-NAME := P-LONG-NAME
      ESCAPE ROUTINE
    END-IF
    RESET P-SHORT-NAME #NUMB
    COMPRESS SUBSTR(P-LONG-NAME,1,#BODY-LENGTH)
      '?99999999999' TO #KEY LEAVING NO
    READ (1) FILE-NAMES DESCENDING BY HA-SHORT-FILENAME = #KEY
      #NUMB-A := SUBSTR(HA-SHORT-FILENAME,#POS-HASH)
      IF NOT (#NUMB-A IS (N11))
        RESET #NUMB
      END-IF
    END-READ
    IF  SUBSTR(HA-SHORT-FILENAME,1,#BODY-LENGTH) NE
        SUBSTR(#KEY,1,#BODY-LENGTH) OR #NUMB > 99999999998
      #KEY-NUMB := 1
    ELSE
      #KEY-NUMB := #NUMB + 1
    END-IF
    REP1. REPEAT
      COMPRESS SUBSTR(P-LONG-NAME,1,#BODY-LENGTH)
        #KEY-NUMB-A TO #KEY LEAVING NO
      FIND (1) FILE-NAMES WITH HA-SHORT-FILENAME = #KEY
        IF NO RECORDS FOUND
          COMPRESS SUBSTR(P-LONG-NAME,1,#BODY-LENGTH)
            '?' #KEY-NUMB-A TO HA-SHORT-FILENAME LEAVING NO
          P-SHORT-NAME     := HA-SHORT-FILENAME
          HA-LONG-FILENAME := P-LONG-NAME
          IF P-REPRNB SPECIFIED
            HA-REPRNB := P-REPRNB
          END-IF
          STORE FILE-NAMES
/*    NOÜ END TRANSACTION, to be done by caller
          ESCAPE BOTTOM (REP1.)
        END-NOREC
        #NUMB-A := SUBSTR(HA-SHORT-FILENAME,#POS-HASH)
        IF NOT (#NUMB-A IS (N11))
          RESET #NUMB
        END-IF
        IF #NUMB > 99999999998
          P-RC := 2 /* No space left in table
          ESCAPE BOTTOM (REP1.)
        END-IF
        ADD 1 TO #KEY-NUMB
      END-FIND
    END-REPEAT /*(REP1.)
************************************************************************
  VALUE 'L' /* L: Convert short-name to long-name
    IF P-SHORT-NAME NE SCAN('?')
      P-LONG-NAME := P-SHORT-NAME
      ESCAPE ROUTINE
    END-IF
    #SHORT. FIND (1) FILE-NAMES WITH HA-SHORT-FILENAME = P-SHORT-NAME
      P-LONG-NAME := HA-LONG-FILENAME
      IF P-REPRNB SPECIFIED
        P-REPRNB := HA-REPRNB
      END-IF
    END-FIND
    IF *NUMBER (#SHORT.) = 0
      P-RC := 1 /* long name not found
    END-IF
************************************************************************
  VALUE 'U' /* U: Update HA-REPRNB in record
    IF P-REPRNB SPECIFIED AND P-REPRNB NE ' '
      #KEY := P-SHORT-NAME
      FIND FILE-NAMES WITH HA-SHORT-FILENAME = #KEY
        HA-REPRNB := P-REPRNB
        UPDATE
/*    NOÜ END TRANSACTION, to be done by caller
      END-FIND
    END-IF
************************************************************************
  VALUE 'D' /* D: Delete table entry of long-name
    IF P-SHORT-NAME NE ' '
      IF P-SHORT-NAME = SCAN('?')
        #KEY := P-SHORT-NAME
        FIND FILE-NAMES WITH HA-SHORT-FILENAME = #KEY
          DELETE
/*    NOÜ END TRANSACTION, to be done by caller
        END-FIND
      END-IF
    ELSE
/***********************************************************************
/*    ATTENTION: coding below may lead to data loss: delete without  SU1
/*    short name and without report data will delete all records     SU1
/*    with the specified long name.                                  SU1
/***********************************************************************
      #KEY-NUMB := 0
      COMPRESS SUBSTR(P-LONG-NAME,1,#BODY-LENGTH)
        '?' #KEY-NUMB-A TO #KEY LEAVING NO
      READ FILE-NAMES BY HA-SHORT-FILENAME STARTING FROM #KEY
        DECIDE FOR FIRST CONDITION
          WHEN SUBSTR(HA-SHORT-FILENAME,1,#BODY-LENGTH) NE
              SUBSTR(P-LONG-NAME,1,#BODY-LENGTH)
            ESCAPE BOTTOM
          WHEN HA-LONG-FILENAME NE P-LONG-NAME
            ESCAPE TOP
          WHEN P-REPRNB SPECIFIED AND P-REPRNB NE ' '
              AND P-REPRNB NE HA-REPRNB
            ESCAPE TOP
          WHEN NONE
            IGNORE
        END-DECIDE
        DELETE
/*  NOÜ END TRANSACTION, to be done by caller
        ESCAPE BOTTOM
      END-READ
    END-IF
  NONE
    IGNORE
END-DECIDE
IF #TRACING /*SU2 ->
  COMPRESS 'RC:' P-RC TO #TRACE-MSG
  IF P-FUNCTION = 'S' /*long->short
    COMPRESS #TRACE-MSG '- short:' P-SHORT-NAME TO #TRACE-MSG
  ELSE /* L/D/U
    COMPRESS #TRACE-MSG '- long:'  P-LONG-NAME TO #TRACE-MSG
  END-IF
  PERFORM XXRLOG-WRITE-LOG 'T' #TRACE-MSG
END-IF /*SU2 <-
*
* ---------------------------------------------------------------------
*
END-SUBROUTINE /* XXHASH
*
/************************************* end sub *********************************
END
/************************************* end *************************************
