* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* S-COMMIT - ET LOGIC with confirmation window
* SU1     2017-01-19            (NOM3.5) new parm
************************************************************************
*
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #DATA-OK (L) OPTIONAL /*in/out SU1
1 #BACKOUT (L) OPTIONAL /*out SU1
************************************************************************
LOCAL
1 #ANS-COMMIT(A1)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE COMMIT-WORK
************************************************************************
SET KEY PF3
IF #BACKOUT SPECIFIED /*SU1
  RESET #BACKOUT
END-IF
IF G-COMMIT AND G-AUTOCOMMIT = 'E'
  RESET G-COMMIT
  SET CONTROL 'WC4L58B20/11F'
  INPUT WITH TEXT '  ' ALARM USING MAP 'COMMITM&'
  IF *PF-KEY = 'PF3'
    RESET #ANS-COMMIT
  END-IF
  IF #ANS-COMMIT='Y'
    IF #DATA-OK SPECIFIED AND NOT #DATA-OK /*SU1
      G-COMMIT := TRUE
      SET CONTROL 'WB'
      ESCAPE ROUTINE
    END-IF
    END TRANSACTION
  ELSE
    BACKOUT TRANSACTION
    IF #BACKOUT SPECIFIED /*SU1
      #BACKOUT := TRUE
      RESET G-NATRP-ERC
    END-IF
  END-IF
  RESET G-HOLD-TIME
ELSE
  IF #DATA-OK SPECIFIED /*SU1
    IF NOT G-COMMIT /*SU1
      #DATA-OK := TRUE
    END-IF
    IF NOT #DATA-OK
      SET CONTROL 'WB'
      ESCAPE ROUTINE
    END-IF
  END-IF
  END TRANSACTION
END-IF
SET CONTROL 'WB'
*
END-SUBROUTINE /* COMMIT-WORK
*
END /*COMMIT
