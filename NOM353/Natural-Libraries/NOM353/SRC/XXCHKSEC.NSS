* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* S-CHKSEC  security check of call of modules RDEFxx/RCOPxx
*           include check of user profile values and user grants for
*           non-administrator users
*
* Maintenance:
* xsetggr 2012-09-20 NOMALL-89 created
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #CHK-PROG    (A8)
1 #CHK-NAME    (A25)
1 #CHK-ALLOW   (L)
************************************************************************
LOCAL
1 #PROG        (A8)
1 REDEFINE #PROG
  2 #NAME     (A4)
  2 #OBJ-TYPE (A2)
1 #PROF-FUNC   (A3)
1 #GR-FUNC     (A1)
1 #GR-T        (A1)
1 #GR-N        (A25)
1 #OPTIONS     (A1/1,1:6)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE XXSECURITY-CHECK
************************************************************************
#CHK-ALLOW := TRUE
IF G-USER-TYPE = 'A'
  ESCAPE ROUTINE
END-IF
* profile check
#PROG := #CHK-PROG
IF #OBJ-TYPE NE 'FO'
  IF #NAME = 'RCOP' OR = 'RREN' OR G-C-FUNC = 'A'
    COMPRESS 'M' #OBJ-TYPE TO #PROF-FUNC LEAVING NO
  ELSE
    IF #NAME = 'RLIA'
      #PROF-FUNC := 'DAC'
    ELSE
      COMPRESS G-C-FUNC #OBJ-TYPE TO #PROF-FUNC LEAVING NO
    END-IF
  END-IF
  CALLNAT 'NARPSEC' G-USER-PROFILE #PROF-FUNC #CHK-ALLOW
END-IF
*
* authorization check
IF #CHK-ALLOW AND G-C-FUNC NE 'A'
  DECIDE ON FIRST VALUE OF #OBJ-TYPE
    VALUE 'DL'
      #GR-T := 'L'
    VALUE 'AB'
      #GR-T := 'B'
    VALUE 'CF'
      #GR-T := 'F'
    NONE VALUE
      #GR-T := SUBSTR(#OBJ-TYPE,1,1)
  END-DECIDE
  #GR-N := #CHK-NAME
  DECIDE FOR FIRST CONDITION
    WHEN #NAME = 'RLIA'                    /* RLIACF
      #GR-FUNC := 'D'
    WHEN #NAME  = 'RCOP' OR = 'RREN'       /* RCOPxx
      #GR-FUNC := 'M'
    WHEN #NAME = 'RDEF'
      #GR-FUNC := G-C-FUNC
    WHEN NONE IGNORE
  END-DECIDE
  CALLNAT 'RCHKGRT' #GR-FUNC G-USERID #GR-T #GR-N #OPTIONS (1,*)
    #CHK-ALLOW
END-IF
*
END-SUBROUTINE /* XXSECURITY-CHECK
*
END
