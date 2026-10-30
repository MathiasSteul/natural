* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXNATDIR - Gets the directory data of the calling program or a specif ied one */
*  If P-LIBRARY and P-MODULE are specified, the routine returns
*  Natural directory data of the specified module, if they are not
*  specified, it returns the values of the calling program.
*
*  Maintenance
*  User ID   yyyy-mm-dd Issue         Remark
* -----------------------------------------------------------------------------
*  fhi       2010-09-23 NOMALL-800    Created.
*  fhi       2012-06-20 NOMALL-1067   Added error handling for NOM 3.4
*  fhi       2012-10-18 FHI281        Avoid NATF01* on Unix. Not ported
*                                     for UnixÜ Rewritten. No tags.
*  fhi       2012-06-20 NOMALL-1214   Add timestamps for comparison
*  raya      2012-11-29 NOMALL-1214   reset p-erc
*  fhi       2017-03-16 NOMALL-2008   Get object type
************************************* data ************************************
*
DEFINE DATA
PARAMETER
1 XXNATDIR
  2 P-LIBRARY                (A8)    BY VALUE
  2 P-MODULE                 (A8)    BY VALUE
  2 P-LEVEL                  (N2)    BY VALUE RESULT
  2 P-DIRECTORY
    3 M-SA-DATE              (A10)   BY VALUE RESULT
    3 M-SA-TIME              (A8)    BY VALUE RESULT
    3 M-SA-TIMESTAMP         (T)
    3 M-SA-SIZE              (A6)    BY VALUE RESULT
    3 M-CA-DATE              (A10)   BY VALUE RESULT
    3 M-CA-TIME              (A8)    BY VALUE RESULT
    3 M-CA-TIMESTAMP         (T)
    3 M-CA-BP-SIZE           (A6)    BY VALUE RESULT
  2 P-ERC                    (N4)
  2 P-TYPE                   (A1)    OPTIONAL
************************************************************************
LOCAL
1 PARM-NAT00001
  2 KEYWORD                  (A11)
  2 INT-OBJ-TYPE             (A1)
  2 EXT-OBJ-TYPE             (A1)
  2 TYPE-TEXT                (A11)
1 PARM-NAT00028
  2 LFILE                    (N05)
  2 PHYSICAL-DBID            (N05)
  2 PHYSICAL-FNR             (N05)
  2 DB-TYPE                  (A01)
  2 RESPONSE                 (N04)
1 #CBDIR               (B126) /* Parms for NAT23015
1 REDEFINE #CBDIR
  2 #CBDIR-OPT1        (A1)
  2 #CBDIR-OPT2        (A1)
  2 #CBDIR-RSP1        (I2)
  2 #CBDIR-RSP2        (I2)
  2 #CBDIR-TYPES       (A1/4)
  2 #CBDIR-FIELDS      (I1/16)
  2 #CBDIR-NAME        (A96)
  2 REDEFINE #CBDIR-NAME
    3 #CBDIR-NLIB      (A8)
    3 #CBDIR-NNAM      (A8)
  2 #CBDIR-DBID        (B2)
  2 #CBDIR-FNR         (B2)
/*
1 #DIR-OB1             (B100/1:4)        /*  saved object directory
1 REDEFINE #DIR-OB1
  2 NATVERSM           (A4)
  2 NATVER             (A4)
  2 NATSM              (A4)
  2 REDEFINE NATSM
    3 NATSMN           (N4)
  2 USERID             (A8)
  2 TID                (A8)
  2 TIME               (A8)
  2 DATE               (A8)
  2 OBJ-TYPE           (A1)
  2 OBJ-LONGNAME       (A11)
  2 DIR-STATE          (A12)
  2 CREATE-LIB         (A8)
  2 CREATE-OBJ-NAME    (A8)
  2 TERM-USER          (A8)
  2 SA-SIZE            (I4)
  2 REC-SIZE           (I2)
  2 DEV-MODE           (A15)
  2 SAV-CAT-DATE-TIME  (T)
  2 OP-SYSTEM          (A8)
  2 TP-SYSTEM          (A8)
  2 TA-NAME            (A8)
  2 VCS-IAPPLID        (A8)
  2 REDEFINE VCS-IAPPLID
    3 APPL-ID          (B2)
    3 APPL-VER         (B2)
    3 CNTL-VER         (B2)
    3 OBJ-VER          (B2)
  2 AIV-LENGTH         (I4)
  2 BP-SIZE            (I4)
  2 U-SIZE             (I4)
  2 INV-SUBTAB         (I4)
  2 DEF-SUBTAB         (I4)
  2 TURBO-CODE         (A3)
  2 RECAT-POSS         (A3)
  2 OBJ-RELINKED       (A3)
  2 TIME-STAMP         (B8)
  2 TURBO-CODE-LEN     (I4)
  2 GDA-SIZE           (I4)
  2 NUM-SUBR           (I4)
  2 NUM-GDA            (I4)
  2 NUM-REP            (I4)
  2 NUM-WFILE          (I4)
  2 DUMMY              (A20)
  2 GDA-NAME           (A32)
  2 DUMMY2             (A8)
  2 MCG-STRING         (A80)
  2 MODE               (A3)
  2 CODEPAGE           (A32)
/*
1 #DIR-OB2             (B100/1:4)        /* CATALOGED OBJECT DIRECTORY
1 REDEFINE #DIR-OB2
  2 NATVERSM           (A4)
  2 NATVER             (A4)
  2 NATSM              (A4)
  2 REDEFINE NATSM
    3 NATSMN           (N4)
  2 USERID             (A8)
  2 TID                (A8)
  2 TIME               (A8)
  2 DATE               (A8)
  2 OBJ-TYPE           (A1)
  2 OBJ-LONGNAME       (A11)
  2 DIR-STATE          (A12)
  2 CREATE-LIB         (A8)
  2 CREATE-OBJ-NAME    (A8)
  2 TERM-USER          (A8)
  2 SA-SIZE            (I4)
  2 REC-SIZE           (I2)
  2 DEV-MODE           (A15)
  2 SAV-CAT-DATE-TIME  (T)
  2 OP-SYSTEM          (A8)
  2 TP-SYSTEM          (A8)
  2 TA-NAME            (A8)
  2 VCS-IAPPLID        (A8)
  2 REDEFINE VCS-IAPPLID
    3 APPL-ID          (B2)
    3 APPL-VER         (B2)
    3 CNTL-VER         (B2)
    3 OBJ-VER          (B2)
  2 AIV-LENGTH         (I4)
  2 BP-SIZE            (I4)
  2 U-SIZE             (I4)
  2 INV-SUBTAB         (I4)
  2 DEF-SUBTAB         (I4)
  2 TURBO-CODE         (A3)
  2 RECAT-POSS         (A3)
  2 OBJ-RELINKED       (A3)
  2 TIME-STAMP         (B8)
  2 TURBO-CODE-LEN     (I4)
  2 GDA-SIZE           (I4)
  2 NUM-SUBR           (I4)
  2 NUM-GDA            (I4)
  2 NUM-REP            (I4)
  2 NUM-WFILE          (I4)
  2 DUMMY              (A20)
  2 GDA-NAME           (A32)
  2 DUMMY2             (A8)
  2 MCG-STRING         (A80)
  2 MODE               (A3)
  2 CODEPAGE           (A32)
*
1 #LASTPROG                  (A8)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
********************************************************************************
DEFINE SUBROUTINE XXNATDIR-GETDIR
********************************************************************************
RESET P-DIRECTORY P-ERC
IF P-LIBRARY = ' '
  CALLNAT 'RGETLIB' P-LIBRARY
END-IF
IF P-MODULE = ' '
  PERFORM XXLSLEVL-GET-LAST-LEVEL #LASTPROG P-LEVEL
  P-MODULE  := #LASTPROG
END-IF
IF P-LIBRARY = MASK('SYS')
  LFILE := 255
ELSE
  LFILE := 0
END-IF
CALLNAT 'NAT00028' PARM-NAT00028
IF RESPONSE NE 0
  P-ERC := RESPONSE
  RESET P-DIRECTORY
  ESCAPE ROUTINE
END-IF
#CBDIR-NNAM      := P-MODULE
#CBDIR-NLIB      := P-LIBRARY
#CBDIR-OPT1      := 'N' /* read source & object
#CBDIR-OPT2      := 'E' /* read exactly specified object
#CBDIR-FIELDS(1) := -1  /* return all fields
CALLNAT 'NAT23015' #CBDIR #DIR-OB1 (*) #DIR-OB2 (*)
DECIDE FOR EVERY CONDITION
  WHEN #CBDIR-RSP1 NE 0 AND #CBDIR-RSP2 NE 0
    P-ERC := #CBDIR-RSP1
    RESET P-DIRECTORY
    ESCAPE ROUTINE
  WHEN #CBDIR-RSP1 = 0
    MOVE EDITED #DIR-OB1.SAV-CAT-DATE-TIME (EM=YYYY'-'MM'-'DD)
      TO M-SA-DATE
    MOVE EDITED #DIR-OB1.SAV-CAT-DATE-TIME (EM=HH':'II':'SS)
      TO M-SA-TIME
    M-SA-TIMESTAMP := #DIR-OB1.SAV-CAT-DATE-TIME
    M-SA-SIZE := #DIR-OB1.SA-SIZE
    IF P-TYPE SPECIFIED
      INT-OBJ-TYPE := #DIR-OB1.OBJ-TYPE
      CALLNAT 'NAT00001' PARM-NAT00001
      P-TYPE := EXT-OBJ-TYPE
    END-IF
  WHEN #CBDIR-RSP2 = 0
    MOVE EDITED #DIR-OB2.SAV-CAT-DATE-TIME (EM=YYYY'-'MM'-'DD)
      TO M-CA-DATE
    MOVE EDITED #DIR-OB2.SAV-CAT-DATE-TIME (EM=HH':'II':'SS)
      TO M-CA-TIME
    M-CA-TIMESTAMP := #DIR-OB2.SAV-CAT-DATE-TIME
    M-CA-BP-SIZE := #DIR-OB2.BP-SIZE
  WHEN NONE
    IGNORE
END-DECIDE
*
END-SUBROUTINE /* XXNATDIR-GETDIR
*
END
