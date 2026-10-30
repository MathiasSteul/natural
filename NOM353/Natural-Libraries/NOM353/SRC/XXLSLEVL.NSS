* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXLSLEVL - Return the program name which called me.(Template:RM#LEVEL)
*  Description:
*  Investigates the module levels of Natural and returns the
*  program name of the last level, i.e. the program that called the
*  program that called this routine.
*
*  Maintenance
*  User ID   yyyy-mm-dd Issue         Remark
* -----------------------------------------------------------------------------
*  fhi       2010-03-16 NOM331        Created.
*  fhi       2010-09-29 NOMALL-853    Rewritten
************************************* data ************************************
DEFINE DATA
PARAMETER
1 P-LASTPROG  (A8)                    /**out: Returned module name
1 P-LEVEL     (N2) BY VALUE OPTIONAL  /**in:  inquired level:
************************************************************************
LOCAL                                 /*      0 = level of calling prg
1 #I          (I2)                    /*      1 = level before, ...
1 #PARM       (A240)
1 REDEFINE #PARM
  2 #ENTRY    (A12/20)
1 #ITEM       (A12)
1 REDEFINE #ITEM
  2 #PGM      (A8)
  2 #LEVEL    (B1)
  2 #TYPE     (A1)
  2 #PSW      (B2)
1 #INT-LEVEL  (N2)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
********************************************************************************
DEFINE SUBROUTINE XXLSLEVL-GET-LAST-LEVEL
********************************************************************************
RESET P-LASTPROG
IF P-LEVEL SPECIFIED
  #INT-LEVEL    := P-LEVEL + 2 /*'0' - last prog,'1' - level before,...
ELSE
  #INT-LEVEL    := 2           /* set level to calling program
END-IF
CALL 'CMMPP' 'CALL' #PARM
FOR.
FOR #I = 1 TO 20
  #ITEM := #ENTRY (#I)
  IF #PGM = *PROGRAM
    ESCAPE BOTTOM (FOR.)
  END-IF
END-FOR
#I := #I + #INT-LEVEL
DECIDE FOR FIRST CONDITION
  WHEN #I > 20
    #I := 20
  WHEN #I < 1
    #I := 1
  WHEN NONE
    IGNORE
END-DECIDE
#ITEM      := #ENTRY (#I)
P-LASTPROG := #PGM
*
END-SUBROUTINE /* XXLSLEVL-GET-LAST-LEVEL
*
END
