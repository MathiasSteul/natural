* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* XXSTACK
*
* Stack dynamic variable
*
* Function 'PUSH'  Pushes data into stack
*          'POP'   Retrieves the last stacked data and deletes this
*                  occurrence
*          'CLEAR' Resets the whole slot
*          'FIND'  Returns the occurrence of the value or 0 in #SLOT
*
* Always a dynamic variable is pushed or poped to and from the stack.
* The slot number enables more than one stack in parallel. Only the
* data belonging to the given stack number will be regarded. Up to 10
* slots are possible (over all programs). So the usage should be
* documented here :-)
*
* Address space   Slot  Usage
* ---------------------------------------------------------------------
* Monitor tasks     1   All printers that are currently busy
*
*
* MODIFICATIONS
* User Id yyyy-mm-dd Mark       Comment
* fhi     2011-03-17 NOMALL-947 Created from XXUXST-N
* SU1     2016-08-30 NOMALL-1518 NOM3.5 deactivate opt.Compiler
* ---------------------------------------------------------------------
/*SU1 OPTIONS MCG=(INDX=ON,OVFLW=ON,DIGTCHCK=ON)
DEFINE DATA
PARAMETER
1 #FUNCTION      (A)   DYNAMIC BY VALUE  /* PUSH, POP, CLEAR
1 #DATA          (A)   DYNAMIC BY VALUE RESULT
1 #SLOT          (I4)  BY VALUE RESULT   /* slot number of stack
1 #RC            (N4)                    /* 0 = sucess,
*                                        /* 1 = More POPs than PUSHs
*                                        /* 2 = wrong function
************************************************************************
INDEPENDENT
1 +XXSTACK-IX    (N10/10)                /* stack depth,
1 +XXSTACK-DATA  (A/*,10) DYNAMIC
************************************************************************
LOCAL
1 #I             (I4)
1 #INDEX         (I4)
1 #SL            (I1)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE XXSTACK
************************************************************************
#SL := #SLOT
IF #SL < 1 OR #SL > 10
  #SL := 1
END-IF
DECIDE ON FIRST VALUE OF #FUNCTION
  VALUE 'PUSH'
    IF +XXSTACK-IX (#SL) GE *OCC (+XXSTACK-DATA)
      #I := *OCC (+XXSTACK-DATA) + 5
      EXPAND ARRAY +XXSTACK-DATA TO (1:#I,1:10)
    END-IF
    ADD 1 TO +XXSTACK-IX (#SL)
    #INDEX := +XXSTACK-IX (#SL)
    MOVE #DATA TO +XXSTACK-DATA (#INDEX,#SL)
    RESET #RC
  VALUE 'POP'
    IF +XXSTACK-IX (#SL) > 0
      #INDEX := +XXSTACK-IX (#SL)
      MOVE +XXSTACK-DATA(#INDEX,#SL) TO #DATA
      REDUCE DYNAMIC +XXSTACK-DATA (#INDEX,#SL) TO 0
      SUBTRACT 1 FROM +XXSTACK-IX (#SL)
      RESET #RC
    ELSE
      RESET #DATA
      #RC := 1                                /* More POPs than PUSHs
    END-IF
  VALUE 'CLEAR'
    IF +XXSTACK-IX (#SL) GE *OCC (+XXSTACK-DATA)
      #I := *OCC (+XXSTACK-DATA) + 5
      EXPAND ARRAY +XXSTACK-DATA TO (1:#I,1:10)
    END-IF
    REDUCE DYNAMIC +XXSTACK-DATA (*,#SL) TO 0
    RESET #RC +XXSTACK-IX (#SL)
  VALUE 'FIND'
    IF *OCC (+XXSTACK-DATA) > 0
      EXAMINE +XXSTACK-DATA (*,#SL) FOR #DATA
        GIVING INDEX IN #SLOT #SL
    ELSE
      RESET #SLOT
    END-IF
  NONE
    RESET #DATA
    #RC := 2                                  /* Wrong function
END-DECIDE
*
END-SUBROUTINE /* XXSTACK
*
END
