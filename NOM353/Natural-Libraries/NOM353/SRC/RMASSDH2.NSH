* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RMASSDH2
* Function  General help routine for map fields (German)
*           for the map RMASSDM1
* Version   2.1.1
*
* Note: Since NOMALL-2491 RMASSDH2 and related modules are replaced by
* adapted RNMASSH2 (and more)Ü The old modules will be kept for QE with
* *USER NATQA5 (compare NRMCPR). Especailly maps MUST NOT be changed for
* compatibility with a lot of test recordingsÜ
*
* Maintenance
* sju    2000-08-21 p(179982) created
* fhi    2000-11-09 p(179982) translated into German
* XSETHZ 2003-10-04 s(202763) confirm deletion of archived reports
* SU1    2021-02-01 NOMALL-2444 Help:use correct name
* BLI1   2024-02-05 NOMALL-2661 Info about usage of MASSDEL modules
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
    #T    :='Objekt Typ fuer Loeschen'
    #L(1) :='Geben Sie den Objekttyp an fuer die '
    #L(2) :='zu loeschenden Objekte    '
    #L(3) :='<AB> fuer Aktive Buendel. '
    #L(4) :='<AR> fuer Aktive Reports.'
    #L(5) :='<BU> fuer Buendel.'
    #L(6) :='<RP> fuer Reports.'
  VALUE 'L-OBJECT-PREFIX'
    #T    :='Praefix Objektname '
    #L(1) :='Alle Objects des gegebenen Typs  '
    #L(2) :='dessen NAme mit diesem Praefix '
    #L(3) :='beginnt, wird geloescht. Bitte '
    #L(4) :='das Wildcard Zeichen nur angeben,'
    #L(5) :='falls es Teil des Namens ist. Z. B.'
    #L(6) :='<ABC*> wird alle Objekte mit dem'
    #L(7) :='Namen beginnend mit ABC* loeschen.'
  VALUE 'L-OBJECT-MASK'
    #T    :='Auswahlmaske Objektname'
    #L(1) :='Loeschen von Objects mit '
    #L(2) :='aehnlichen Namen. Z. B.'
    #L(3) :='Objekt-Name:      <ABC-12XX> '
    #L(4) :='Maske:            <    ??  >'
    #L(5) :='Alle Objekte mit Name ABC-..XX'
    #L(6) :='werden geloescht, das 5. und 6.'
    #L(7) :='Zeichen kann jedes sein.'
  VALUE 'L-WILDCARD'
    #T    :='Wildcard Character'
    #L(1) :='Geben Sie ein Zeichen als Wildcard '
    #L(2) :='anstelle von ''*'' an. '
  VALUE 'L-MASK-CHAR'
    #T    :='Zeichen fuer die Maske'
    #L(1) :='Geben Sie ein Zeichen als Maskenzeichen '
    #L(2) :='anstelle von ''?'' an.'
  VALUE 'L-REFRESH-COUNT'
    #T    :='Zaehler fuer Bildschirmausgabe'
    #L(1) :='Geben Sie die Anzahl Datensaetze an'
    #L(2) :='nach welchen eine Bildschirmausgabe erfolgt.'
    #L(3) :='Standard ist <1000>'
  VALUE 'L-LOG-DELETIONS'
    #T    :='Logging geloeschte Objekte?'
    #L(1) :='Geben Sie <Y> ein, wenn jedes'
    #L(2) :='geloeschte Objekt in das Logging'
    #L(3) :='geschrieben werden soll. Standard: <N>'
  VALUE 'L-DEL-ARCHIVED'
    #T    :='Loeschen archivierte Reports?'
    #L(1) :='Geben Sie <Y> ein, wenn archivierte Reports'
    #L(2) :='geloescht werden sollen. Standard: <N>'
  NONE /*invoke function help
/*SU1  VALUE 'RMASSDM2'
    FETCH RETURN 'NRMHELP' 'HMASSDM1' /*SU1 was 2
    ESCAPE ROUTINE
/*SU1  #T   :='Keine Hilfe'
/*SU1  #L(1):='Fuer dieses Feld ist leider keine Hilfe verfuegbar.'
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<YEI>) / #L(01) / #L(02)
  / #L(03) / #L(04) / #L(05) / #L(06) / #L(07) / #L(08) / #L(09)
  / #L(10) / #L(11) / #L(12) / #L(13) / #L(14) / #L(15) / #L(16         )
*
END
