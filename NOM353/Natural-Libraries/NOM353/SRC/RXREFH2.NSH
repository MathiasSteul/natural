* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RXREFH2
* Function  General help routine for map fields (German)
*           for map RXREFM12
* Version   2.1.1
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* sju 00-10-12 p(191368) created
* SU1   2021-02-01 NOMALL-2444 Help
* GGS01 2021-08-05 NOMALL-2453 Update Object Prefix/Name
* ----------------------------------------------------------------------
*
DEFINE DATA
PARAMETER
1 #FIELD-NAME (A65)
************************************************************************
LOCAL
1 #L          (A65/16)  /* help text lines
1 #T          (A32)     /* help window title
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
DECIDE ON FIRST #FIELD-NAME
  VALUE 'L-OBJECT-TYPE'
    #T    :='Objekte mit Trennblatt'
    #L(1) :='Bitte den Typ der Objekte angeben, '
    #L(2) :='die mit diesem Trennblatt gesucht werden '
    #L(3) :='<R> fuer Reports. '
    #L(4) :='<B> fuer Buendel.'
  VALUE 'L-OBJECT-PREFIX'
    #T    :='Objektname'                               /* GGS01 >
    #L(1) :='Einschraenken der Cross-Referenzen'
    #L(2) :='durch den Objektnamen. ''*'' oder ''?'''
    #L(3) :='sind m?glich. Z. B. <ABC*> fuer'
    #L(4) :='Objekte, deren Name mit ABC beginnt.'     /* < GGS01
  VALUE 'L-EXIT-TYPE'
    #T    :='Exit Typ'
    #L(1) :='Geben Sie an, fuer welchen Exit Typ'
    #L(2) :='die Cross-Referenz erstellt wird.'
    #L(3) :='<S> fuer Separations-Exits. '
    #L(4) :='<P> fuer Drucker-Exits. '
  VALUE 'L-EXIT-LIBRARY'
    #T    :='Bibliothek des Exits'
    #L(1) :='Geben Sie die Bibliothek an, fuer'
    #L(2) :='die eine Cross-Referenz erstellt wird. Z.B.'
    #L(3) :='<NOMEXITS> existiert nur in  NOMEXITS.'
    #L(4) :='<NOM*> ist in Bibliotheken, die mit NOM beginnen.'
  VALUE 'L-EXIT-MEMBER'
    #T    :='Exit Member Name'
    #L(1) :='Geben Sie die Member an, fuer die eine'
    #L(2) :='Cross-Referenz erstellt wird. Z. B.'
    #L(3) :='<UEX-SEP1> nur UEX-SEP1.'
    #L(4) :='<UEX*> alle Exits, die mit UEX beginnen.'
  VALUE 'L-SEPARATOR-NAME'
    #T    :='Start or Ende Trennblatt'
    #L(1) :='Geben Sie den Namen des Trennblatts'
    #L(2) :='fuer die Cross-Referenz ein. Z. B. '
    #L(3) :='<RS-START> nur RS-START.'
    #L(4) :='<RS-*> alle Trennblaetter beginnend mit RS-.'
  VALUE 'L-PRINT-OUTPUT'
    #T    :='Druck-Ergebnisse'
    #L(1) :='Mit <Y> drucken Sie die Ergebnisse'
    #L(2) :='zu Drucker 1, <N> zeigt sie '
    #L(3) :='auf dem Bildschirm an.'
  NONE /*invoke function help
    FETCH RETURN 'NRMHELP' 'HXREFM1' /*SU1 was 2
    ESCAPE ROUTINE
/*SU1   VALUE 'RXREFM12'
/*SU1     #T   :='Keine Hilfe'
/*SU1     #L(1):='Es ist leider keine Hilfe verfuegbar.'
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<YEI>) / #L(01) / #L(02)
  / #L(03) / #L(04) / #L(05) / #L(06) / #L(07) / #L(08) / #L(09)
  / #L(10) / #L(11) / #L(12) / #L(13) / #L(14) / #L(15) / #L(16)
*
END
