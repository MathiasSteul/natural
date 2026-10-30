* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    S-FLIPH
* Version   1.3
* Function  Handle Flip line
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* mrs 93-12-07 s(999999) support of model 5 screens
* GGS01 2020-07-15       For NAT ONE: DEFINE DATA in more than one line
* ----------------------------------------------------------------------
DEFINE DATA
GLOBAL USING NRM-GL                     /* GGS01
END-DEFINE
*
************************************************************************
DEFINE SUBROUTINE FLIP-HANDLE
************************************************************************
IF G-LINECOM(1) NE ' '
  DECIDE ON FIRST VALUE OF G-FLIP-STATUS
    VALUE 'C' G-FLIP-STATUS := 'B'
    VALUE 'B' G-FLIP-STATUS := 'C'
    VALUE 'P' G-FLIP-STATUS := 'L'
    VALUE 'L' G-FLIP-STATUS := 'F'
    NONE      G-FLIP-STATUS := 'P' /*'F','B'
  END-DECIDE
ELSE
  DECIDE ON FIRST VALUE OF G-FLIP-STATUS
    VALUE 'C' G-FLIP-STATUS := 'B'
    VALUE 'B' G-FLIP-STATUS := 'C'
    VALUE 'P' G-FLIP-STATUS := 'F'
    NONE      G-FLIP-STATUS := 'P'  /*'F'
  END-DECIDE
END-IF
*
END-SUBROUTINE /* FLIP-HANDLE
*
END
