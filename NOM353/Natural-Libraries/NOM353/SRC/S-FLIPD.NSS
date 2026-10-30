* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    S-FLIPD
* Version   1.3
* Function  Flip line display
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* mrs 93-12-07 s(999999) support of model 5 screens
* mrs 94-03-08 s(999999) support screens with 27 lines or more
* GGS01 2020-07-15       For NAT ONE: DEFINE DATA in more than one line
* ----------------------------------------------------------------------
DEFINE DATA
GLOBAL USING NRM-GL            /* GGS01
END-DEFINE
*
************************************************************************
DEFINE SUBROUTINE FLIP-DISPLAY
************************************************************************
DECIDE FOR FIRST CONDITION
  WHEN *PAGESIZE >= 27 AND G-FLIP-STATUS = 'P'
    G-FLIP-STATUS := 'C'
  WHEN *PAGESIZE >= 27 AND G-FLIP-STATUS = 'F'
    G-FLIP-STATUS := 'B'
  WHEN NONE IGNORE
END-DECIDE
*
IF G-LINECOM (1) = ' '
  SET CONTROL 'M21'
  SET CONTROL 'YB'
  IF G-FLIP-STATUS ='F' OR='B'
    SET CONTROL 'YL'
  ELSE /* 'P','C'
    SET CONTROL 'YF'
  END-IF
ELSE
  DECIDE ON FIRST VALUE OF G-FLIP-STATUS
    VALUE 'F'
      SET CONTROL 'YB'
      SET CONTROL 'YL'
    VALUE 'L'
      G-FLIPLINES(*) := G-LINECOM(*)
      SET CONTROL 'Y40'
    VALUE 'C'
      G-FLIPLINES(*) := G-LINECOM(*)
      SET CONTROL 'YB'
      SET CONTROL 'YF'
    VALUE 'B'
      G-FLIPLINES(*) := G-LINECOM(*)
      SET CONTROL 'YB'
      SET CONTROL 'YL'
    NONE /* 'P'
      SET CONTROL 'YB'
      SET CONTROL 'YF'
  END-DECIDE
END-IF
*
END-SUBROUTINE /* FLIP-DISPLAY
*
END
