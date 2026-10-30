* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RMPRSTCS - Write statistics for printing
*
*  Maintenance
*  User ID   yyyy-mm-dd Issue         Remark
* --------------------------------------------------------------------- --------
*  fhi       2010-09-01 NOMALL-93     Created.
*  fhi       2010-09-10 NOMALL-93     Statistics data for Optimize
*                                     Work around for NATMF-16454
*  raya      2012-06-27 NOMALL-1172   reset last msg
*  fhi       2012-08-29 NOMALL-1195   Avoid too many Adabas calls
*  bli       2017-04-25 NOMALL-1871   NAT1257 if error in NOMSTCS
*  fhi       2018-04-25 NOM 3.5       NOSTATISTICS -> STATISTICS=ON
*  fhi       2018-12-14 NOMALL-1905   Use variable +O4I
* SU1     2024-09-02 ES-35716    deactivate O4I
********************************************************************************
DEFINE DATA
PARAMETER
1 PO
  2 PO-LOGICAL            (A8)
  2 PO-LAST-PRINTED-RECNO (P9)
  2 PO-STATUS             (A1)
  2 PO-MSG                (A60)
  2 FLUSH-CC-TYPE         (I2)
************************************************************************
INDEPENDENT
/*SU1 1 +O4I                    (L)
************************************************************************
LOCAL USING NOMSTCSP
LOCAL USING RCCTYP-E
LOCAL
1 PR VIEW OF NRM-PRINTERS
  2 P-ID
1 PRINTOUTS VIEW OF NRM-PRINTOUTS
  2 PO-STATUS
1 #TXT                    (A70) /* only if zap Nat427/NA76130 missing,
/*                                 work around for NATMF-16454
1 #I                      (I2)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE RMPRSTCS-WRITE-STATISTICS
*                 -------------------------
ESCAPE ROUTINE /*SU1
/*SU1 IF NOT +O4I ESCAPE ROUTINE END-IF
RESET NOMSTCSP
REDUCE ARRAY SS-VALUE TO 0
EXPAND ARRAY SS-VALUE TO (1:7)
REDUCE ARRAY SS-TITLE TO 0
EXPAND ARRAY SS-TITLE TO (1:7)
NOMSTCSP.FUNCTION      := 'A' /* cumulate it (add function)
COMPRESS 'PRINTER-' PO.PO-LOGICAL TO NOMSTCSP.SS-ITEM LEAVING NO
IF PO.FLUSH-CC-TYPE NE BINARY
  SS-TITLE (1)         := '4311' /* lines of text reports
  SS-VALUE (1)         := PO.PO-LAST-PRINTED-RECNO
  IF PO.PO-STATUS = 'D'
    SS-TITLE (5)       := '4315' /* number of text reports
    SS-VALUE (5)       := 1
  END-IF
ELSE
  SS-TITLE (2)         := '4312' /* Total bytes of binary reports
  SS-VALUE (2)         := PO.PO-LAST-PRINTED-RECNO
END-IF
IF PO.PO-STATUS = 'D'
  SS-TITLE (3)         := '4313' /* number of printed reports
  SS-VALUE (3)         := 1
ELSE
  SS-TITLE (4)         := '4314' /* number of failed reports
  SS-VALUE (4)         := 1
END-IF
FOR #I = 1 TO 5
  #TXT := SS-TITLE (#I)
  CALLNAT 'RSUBMSGN' #TXT
  SS-TITLE (#I) := #TXT
END-FOR
CALLNAT 'NOMSTCS' NOMSTCSP
* bli 2017-04-25 NOMALL-1871 start insertion
IF NOMSTCSP.ERC NE 0
  ESCAPE ROUTINE
END-IF
* bli 2017-04-25 NOMALL-1871 end insertion
RESET NOMSTCSP SS-VALUE (*) SS-TITLE (*)
NOMSTCSP.FUNCTION      := 'W' /* Write it
COMPRESS 'PRINTER-' PO.PO-LOGICAL TO
  NOMSTCSP.SS-ITEM LEAVING NO
IF PO.PO-STATUS = 'D'
  SS-VALUE (6)         := 'D'
ELSE
  SS-VALUE (6)         := 'E'
END-IF
SS-TITLE (6)           := '4316' /* Last printout state
SS-TITLE (7)           := '4317' /* Last printout message
IF PO.PO-STATUS = 'D'
  RESET SS-VALUE (7)
ELSE
  SS-VALUE (7) := PO.PO-MSG
END-IF
FOR #I = 6 TO 7
  #TXT := SS-TITLE (#I)
  CALLNAT 'RSUBMSGN' #TXT
  SS-TITLE (#I) := #TXT
END-FOR
CALLNAT 'NOMSTCS' NOMSTCSP
* bli 2017-04-25 NOMALL-1871 start insertion
IF NOMSTCSP.ERC NE 0
  ESCAPE ROUTINE
END-IF
* bli 2017-04-25 NOMALL-1871 end insertion
RESET NOMSTCSP
REDUCE ARRAY SS-VALUE TO 0
EXPAND ARRAY SS-VALUE TO (1:8)
REDUCE ARRAY SS-TITLE TO 0
EXPAND ARRAY SS-TITLE TO (1:8)
NOMSTCSP.FUNCTION      := 'A' /* cumulate it (add function)
NOMSTCSP.SS-ITEM       := 'TOTALS-GENERAL'
IF FLUSH-CC-TYPE NE BINARY
  SS-TITLE (1)         := '4301' /* Total lines of text reports
  SS-VALUE (1)         := PO.PO-LAST-PRINTED-RECNO
  IF PO.PO-STATUS = 'D'
    SS-TITLE (5)       := '4305' /* Total number of text reports
    SS-VALUE (5)       := 1
  END-IF
ELSE
  SS-TITLE (2)         := '4302' /* Total bytes of binary reports
  SS-VALUE (2)         := PO.PO-LAST-PRINTED-RECNO
END-IF
IF PO.PO-STATUS = 'D'
  SS-TITLE (3)         := '4303' /* Total number of printed reports
  SS-VALUE (3)         := 1
ELSE
  SS-TITLE (4)         := '4304' /* Total number of failed reports
  SS-VALUE (4)         := 1
END-IF
FOR #I = 1 TO 5
  #TXT := SS-TITLE (#I)
  CALLNAT 'RSUBMSGN' #TXT
  SS-TITLE (#I) := #TXT
END-FOR
CALLNAT 'NOMSTCS' NOMSTCSP
* bli 2017-04-25 NOMALL-1871 start insertion
IF NOMSTCSP.ERC NE 0
  ESCAPE ROUTINE
END-IF
* bli 2017-04-25 NOMALL-1871 end insertion
RESET SS-VALUE (*) SS-TITLE (*)
NOMSTCSP.FUNCTION      := 'W'
NOMSTCSP.SS-ITEM       := 'TOTALS-GENERAL'
NO-PR. FIND NUMBER PR WITH P-ID > ' '
SS-TITLE (6)         := '4306' /* total number of printers
SS-VALUE (6)         := *NUMBER (NO-PR.)
NO-PO. FIND NUMBER PRINTOUTS WITH PO-STATUS = 'R'
SS-TITLE (8)         := '4308' /* waiting printouts
SS-VALUE (8)         := *NUMBER (NO-PO.)
FOR #I = 6 TO 8
  #TXT := SS-TITLE (#I)
  CALLNAT 'RSUBMSGN' #TXT
  SS-TITLE (#I) := #TXT
END-FOR
CALLNAT 'NOMSTCS' NOMSTCSP
* bli 2017-04-25 NOMALL-1871 start insertion
IF NOMSTCSP.ERC NE 0
  ESCAPE ROUTINE
END-IF
* bli 2017-04-25 NOMALL-1871 end insertion
END TRANSACTION
*
END-SUBROUTINE /* RMPRSTCS-WRITE-STATISTICS
*
END
