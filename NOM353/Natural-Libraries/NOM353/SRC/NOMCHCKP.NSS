* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* NOMCHCKP - Check if a Natural program can be accessed.
* Description: avoid NAT0082 if a module is to be called.
*                                                                       ********
* Maintenance
* User ID   yyyy-mm-dd Issue         Remark
* --------------------------------------------------------------------- -------
* fhi       2010-11-24 NOMALL-905    Created for NOM 3.2 as XXCHCKPR
* fhi       2010-11-24 NOMALL-905    Adapted for NOM 3.3
* fhi       2011-08-10 NOMALL-1049   Return library of found module
* raya      2012-02-15 NOMALL-98     return module in ERT
* SU1     2013-01-31 unused      Deactivate unused data areas
********************************************************************************
DEFINE DATA
PARAMETER
1 MODULE     (A8) BY VALUE             /** in: Natural member name
1 ERC        (N4)                      /** out: 0=ok, 1079=not found
*                                      /*       (=NOM error message)
1 ERT        (A250) BY VALUE RESULT OPTIONAL   /** out: Error Message
1 LIBR       (A8) OPTIONAL             /** out: Natural library
************************************************************************
LOCAL
1 NAT-FCT    (A1)
1 NAT-MEM    (A8)
1 NAT-LIB    (A8)
1 NAT-DBID   (B2)
1 NAT-FNR    (B2)
1 NAT-PSW    (A8)
1 NAT-CIPH   (N8)
1 RSP-CODE   (I2)
1 RSP-FIELDS (A100)
*
1 PARM-NAT23003
  2 INDEX       (I4)
  2 PATH-LIB    (A32)
  2 LFILE-NR    (I4) INIT<219>
  2 ERROR-NR    (I4)
  2 RESERVE     (A1/1:3)
  2 REDEFINE RESERVE
    3 PDA-VERSION          (I1) /* Version number
    3 V1-PDA-MODE          (A1) /* Version 1: T=utility, S=system
      /*            U=User
    3 V1-PDA-AFTERSTEP-LIB (A1) /* Version 1: internal, do not change
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
********************************************************************************
DEFINE SUBROUTINE NOMCHCKP-CHECK-PROG
********************************************************************************
RESET ERC
IF ERT SPECIFIED
  RESET ERT
END-IF
FINDLOOP. REPEAT
  CALLNAT 'NAT23003' PARM-NAT23003 /*get steplibs
  DECIDE ON EVERY VALUE OF ERROR-NR
    VALUE 0, 1
      NAT-FCT := 'O'
      NAT-MEM := MODULE
      NAT-LIB := PATH-LIB
      CALLNAT 'NAT31053' NAT-FCT NAT-MEM NAT-LIB NAT-DBID NAT-FNR
        NAT-PSW NAT-CIPH RSP-CODE RSP-FIELDS
      IF RSP-CODE = 0
        ESCAPE BOTTOM (FINDLOOP.)
      END-IF
    VALUE 1
      ERC := 1079 /* not found
      ESCAPE BOTTOM (FINDLOOP.)
    NONE VALUE
      ERC := 1079 /* not found
      ESCAPE BOTTOM (FINDLOOP.)
  END-DECIDE
END-REPEAT
IF ERC NE 0
  IF ERT SPECIFIED
    ERT := MODULE
  END-IF
ELSE
  IF LIBR SPECIFIED
    LIBR := NAT-LIB
  END-IF
END-IF
*
END-SUBROUTINE /* NOMCHCKP-CHECK-PROG
*
END
