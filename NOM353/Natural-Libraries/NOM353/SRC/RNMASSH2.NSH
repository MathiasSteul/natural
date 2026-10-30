* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RNMASSH2 replaces RMASSDH2
* Function  General help routine for map fields (German)
*           for the map RNASSM1
* Version   3.5.2
*
* Maintenance
* sju    2000-08-21 p(179982) created
* fhi    2000-11-09 p(179982) translated into German
* XSETHZ 2003-10-04 s(202763) confirm deletion of archived reports
* SU1    2021-02-01 NOMALL-2444 Help:use correct name
* GGS01  2021-08-05 NOMALL-2491 Update Object Prefix/Name
* BLI1   2024-02-09 NOMALL-2661 Adapt field descriptions and help
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
    #T    :='Objekttyp fuer Loeschen'
    #L(1) :='Geben Sie den Objekttyp an fuer die '
    #L(2) :='zu loeschenden Objekte    '
    #L(3) :='<AB> fuer Aktive Buendel. '
    #L(4) :='<AR> fuer Aktive Reports.'
    #L(5) :='<BU> fuer Buendel.'
    #L(6) :='<RP> fuer Reports.'
  VALUE 'L-OBJECT-PREFIX'
    #T    :='Objektname'
    #L(1) :='Alle Objekte des gegebenen Typs  '
    #L(2) :='werden gel?scht, deren Name dem'
    #L(3) :='Objektnamen entspricht.'
    #L(4) :='''*'' oder ''?'' sind m?glich.'
    #L(5) :='Z.B.<ABC*>steht f?r Objekte'
    #L(6) :='die mit ABC beginnen.'
** VALUE 'L-OBJECT-MASK'     BLI1 deleted
  VALUE 'L-WILDCARD'
    #T    :='Beliebig viele Zeichen'
    #L(1) :='Geben Sie ein Zeichen als Wildcard'
    #L(2) :='f?r beliebig viele Zeichen an'
    #L(3) :='(Standard ''*'').'
  VALUE 'L-MASK-CHAR'
    #T    :='Genau ein Zeichen'
    #L(1) :='Geben Sie ein Zeichen als Wildcard'
    #L(2) :='f?r genau ein Zeichen an'
    #L(3) :='(Standard ''?'').'
  VALUE 'L-REFRESH-COUNT'
    #T    :='Zaehler Bildschirmaktualisierung'
    #L(1) :='Geben Sie die Anzahl Datensaetze an,'
    #L(2) :='nach denen eine Bildschirmaktualisierung'
    #L(3) :='erfolgen soll. Standard ist <1000>'
  VALUE 'L-LOG-DELETIONS'
    #T    :='Loeschen protokollieren'
    #L(1) :='Geben Sie <Y> ein, wenn jedes geloeschte'
    #L(2) :='Objekt in den Logs protokolliert'
    #L(3) :='werden soll. Standard: <N>'
  VALUE 'L-DEL-ARCHIVED'
    #T    :='Markiert oder schon archiviert'
    #L(1) :='Geben Sie <Y> ein, wenn auch archivierte'
    #L(2) :='und zum Archivieren markierte aktive'
    #L(3) :='Reports geloescht werden sollen.'
    #L(4) :='Standard: <N>'
  NONE /*invoke function help
/*SU1  VALUE 'RMASSDM2'
    FETCH RETURN 'NRMHELP' 'HNMASSD1' /*SU1 was 2
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
