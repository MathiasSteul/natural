* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
/** XXLASTMS  - Get all messages like utility LASTMSG
/** version: NOM 3.4
/** TEMPLATE:
/** <h3>NOP Business API - (HELPER)
/** Natural Message Collector.</h3>
/*
/*  Subroutine YUERRC0S
/*
/** <p>Call Natural Message collecter and concatinate all stacked
/** Errors</p>
/*
/** <p><b>For internal use only</b></p>
/*
/** :author esi
/*
/** :since <table border="1" cellspacing="0">
/** <tr><th>Date<th>iTrack<th>Comment<th>Mark</tr>
/** <tr><td>10.12.14<td>
/** <:link https://iTrac.eur.ad.sag/browse/NOPALL-2000 N2000>
/** <td>created<td>ESI542</tr>
/** </table>
/**
/** fhi: Taken from EOR542 on 24/06/2015. Adapted to sort the msgs
/**      from newest to oldest introducing #ERROR-TEXT-ARRAY
/**      Message delimiter is ';'
/*
* MODIFICATIONS
* fhi      2015-06-24 NOMALL-1573 Created.                              8
* SU1     2015-12-04 NOMALL-1779 switch to avoid lastmsg
* ------ PARAMETER -----------------------------------------------
DEFINE DATA
PARAMETER
1 P-COLLECTED-MESSAGES (A)  DYNAMIC BY VALUE RESULT
1 P-ERC                (N4) OPTIONAL
1 P-LASTMSG            (L)  OPTIONAL /*true=all/false=last msg SU1
* *****
LOCAL
1 #EMC                 (A156)
1 REDEFINE #EMC
  2 #EMC-FCT           (I4)   /*FUNCTION CODE
  2 #EMC-MESSAGES      (I4)   /*NUMBER OF MESSAGES
  2 #EMC-SLOTS         (I4)   /*NUMBER OF AVAILABLE SLOTS
  2 #EMC-RSP           (I4)   /*RESPONSE CODE
  2 #EMC-DYN           (A1)   /*'Y' RETURN ONLY DYNAMIC ST
  2 #EMC-BYTE3         (A1)   /*FOR LATER USE
  2 #EMC-BYTE2         (A1)   /*FOR LATER USE
  2 #EMC-BYTE1         (A1)   /*FOR LATER USE
  2 #EMC-FREE3         (I4)   /*FOR LATER USE
  2 #EMC-FREE4         (I4)   /*FOR LATER USE
  2 #EMC-FREE5         (I4)   /*FOR LATER USE
  2 #ERROR             (B124) /*ERROR MESSAGE
  2 REDEFINE #ERROR
    3 #E-NUMBER        (I4)   /*ERROR NUMBER
    3 #E-LINE          (I4)   /*PROGRAM LINE NUMBER
    3 #E-PGM           (A32)  /*PROGRAM NAME
    3 #E-LIB           (A32)  /*LIBRARY NAME
    3 #E-DBID          (I4)   /*DB-ID
    3 #E-FNR           (I4)   /*FILE NUMBER
    3 #E-TIME          (B8)   /*TIME STAMP
    3 REDEFINE #E-TIME
      4 #E-TIMX        (T)    /*TIME OF ERROR
    3 #E-OBJTYPE       (A1)   /*OBJECT TYPE
    3 #E-F3            (B1)   /*FILLER 3
    3 #E-F2            (B1)   /*FILLER 2
    3 #E-F1            (B1)   /*FILLER 1
    3 #E-LANG          (I4)   /*LANGUAGE CODE
    3 #E-LEVEL         (I4)   /*LEVEL
    3 #E-F4            (B1)   /*FILLER 4
    3 #E-MC            (B1)   /*MESSAGE CLASS
    3 #E-EC            (B1)   /*ERROR CLASS
    3 #E-ET            (B1)   /*ERROR TYPE
    3 #E-LEN           (I4)   /*ERROR TEXT LENGTH
    3 #E-RESERVED      (B16)  /*SOME SPACE FOR LATER USE
*
1 #ERROR-TEXT          (A253) /*ERROR TEXT
1 REDEFINE #ERROR-TEXT
  2 #ERROR-NAT   (A3)
  2 #ERROR-NR    (N4)
  2 FILLER       1X
  2 #ERROR-TX    (A245)
1 REDEFINE #ERROR-TEXT
  2 #ERROR2-PROG (A8)
  2 FILLER       1X
  2 #ERROR2-LINE (N4)
  2 FILLER       1X
  2 #ERROR2-NAT  (A3)
  2 #ERROR2-NR   (N4)
  2 FILLER       1X
  2 #ERROR2-TX   (A231)
1 #ERROR-TEXT-ARRAY        (A/1:*) DYNAMIC
1 #INDEX         (I4)
1 #I             (I4)
1 #POS           (I4)
1 #LEN           (I4)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE XXLASTMS
************************************************************************
#EMC-FCT := 6 /*READ CLEARED MESSAGES BY INDEX
REPEAT
  ADD 1 TO #INDEX
  IF #INDEX GE *OCC (#ERROR-TEXT-ARRAY)
    #I := *OCC (#ERROR-TEXT-ARRAY) + 5
    EXPAND ARRAY #ERROR-TEXT-ARRAY TO (1:#I)
  END-IF
  RESET #ERROR-TEXT
  #EMC-MESSAGES := #INDEX
  CALLNAT 'NAT23006' #EMC #ERROR-TEXT
  IF #EMC-RSP EQ 0
    #ERROR-TEXT-ARRAY(#INDEX) := #ERROR-TEXT
  ELSE
    SUBTRACT 1 FROM #INDEX
  END-IF
  UNTIL #EMC-RSP NE 0 OR #ERROR-TEXT = " "
END-REPEAT
FOR #I = #INDEX TO 1 STEP -1
  EXAMINE #ERROR-TEXT-ARRAY(#I) FOR ' NAT'
    GIVING POSITION #POS LENGTH #LEN
  DECIDE FOR EVERY CONDITION
    WHEN #I = #INDEX
      IF #POS NE 0 AND #POS + 9 LE #LEN
        ADD 9 TO #POS
        #ERROR-TEXT-ARRAY(#I) := SUBSTR(#ERROR-TEXT-ARRAY(#I),#POS)
      END-IF
    WHEN #I NE #INDEX
      IF #POS NE 0
        #ERROR-TEXT-ARRAY(#I) := SUBSTR(#ERROR-TEXT-ARRAY(#I),#POS)
      END-IF
    WHEN #I = 1
      COMPRESS P-COLLECTED-MESSAGES #ERROR-TEXT-ARRAY(#I)
        TO P-COLLECTED-MESSAGES LEAVING NO
    WHEN #I NE 1
      COMPRESS P-COLLECTED-MESSAGES #ERROR-TEXT-ARRAY(#I) ';'
        TO P-COLLECTED-MESSAGES LEAVING NO
    WHEN NONE
      IGNORE
  END-DECIDE
  IF (P-LASTMSG SPECIFIED AND NOT P-LASTMSG ) /*SU1
    ESCAPE BOTTOM /*only last msg
  END-IF
END-FOR
*
END-SUBROUTINE /* XXLASTMS
*
END
