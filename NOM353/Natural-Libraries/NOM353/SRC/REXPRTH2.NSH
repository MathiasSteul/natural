* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* REXPRTH2 - General help routine for map fields (German)-map REXPRTM1
*
* Maintenance
* uuu   yyyy-mm-dd iTrac        Comment
* fhi   2013-06-21 NOMALL-86    Created.
* SU1   2021-02-01 NOMALL-2444 Help:add node
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
    #T    :='Objekt Typ fuer den Export'
    #L(01) :='Geben Sie den Objekttyp an fuer die '
    #L(02) :='zu exportierenden Objekte  '
    #L(03) :='<BU>- Buendel Definitionen'
    #L(04) :='<CA>- Kalender'
    #L(05) :='<DL>- Verteilerlisten'
    #L(06) :='<NO>- Grossrechner-Knoten' /*SU1
    #L(07) :='<PH>- Physikalische Druckerdefinitionen'
    #L(08) :='<PR>- Logische Druckerdefinitionen'
    #L(09) :='<RP>- Report Definitionen'
    #L(10) :='<US>- Benutzerprofile'
    #L(11) :='<UX>- Unix Knoten'
  VALUE 'L-OBJECT-PREFIX'
    #T    :='Objektname '
    #L(1) :='Alle Objects des angegebenen Typs'
    #L(2) :='werden exportiert.'
    #L(3) :='Die Eingabe der Wildcard Zeichen'
    #L(4) :='''*'' oder ''?'' sind m?glich.'
    #L(5) :='Z.B. mit Eingabe von<ABC*>werden'
    #L(6) :='alle Objekte exportiert, deren'
    #L(7) :='Name mit ABC* beginnt.'
  VALUE 'L-OBJECT-MASK'
    #T    :='Auswahlmaske Objektname'
    #L(1) :='Exportieren von Objekten mit '
    #L(2) :='aehnlichen Namen. Z. B.'
    #L(3) :='Objekt-Name:      <ABC-12XX>'
    #L(4) :='Maske:            <    ??  >'
    #L(5) :='Alle Objekte mit Name ABC-..XX'
    #L(6) :='werden exportiert, das 5. und 6.'
    #L(7) :='Zeichen kann jedes sein.'
  VALUE 'L-WILDCARD'
    #T    :='Wildcard Character'
    #L(1) :='Geben Sie ein Zeichen als Wildcard '
    #L(2) :='anstelle von ''*'' an. '
  VALUE 'L-MASK-CHAR'
    #T    :='Zeichen fuer die Maske'
    #L(1) :='Geben Sie ein Zeichen als Maskenzeichen '
    #L(2) :='anstelle von ''?'' an.'
  VALUE 'L-LOG'
    #T    :='Loggen exportierter Objekte?'
    #L(1) :='Geben Sie<Y>ein, wenn jedes'
    #L(2) :='exportierte Objekt in das Logging'
    #L(3) :='geschrieben werden soll. Standard:<N>'
  VALUE 'L-CONTENTS'
    #T    :='Exportieren mit Reportinhalt?'
    #L(1) :='Geben Sie<Y>ein, wenn Sie Reports mit ihren'
    #L(2) :='Inhalten exportieren wollen. Standard:<N>'
    #L(3) :='<Y>ist nur fuer Aktive Reports erlaubt.'
  VALUES 'L-DATE-SCHEDULED','L-TIME-SCHEDULED'
    #T    :='Zeitpunkt der Ausfuehrung'
    #L(1) :='Geben Sie das Datum und die Zeit fuer'
    #L(2) :='die Ausfuehrung ein. Datumsformat TT.MM.JJ,'
    #L(3) :='Zeitformat SS:MM:SS. Leeres Datum ist morgen,'
    #L(4) :='leere Zeit ist 00:00 Uhr.'
  VALUE 'L-TASKS'
    #T    :='Liste der erfassten Aufgaben'
    #L(1) :='Diese Liste zeigt die bereits erfassten'
    #L(2) :='Aufgaben fuer den Export der NOM Objekte.'
    #L(3) :='Es werden die ersten 15 Aufgaben angezeigt.'
  VALUE 'L-NODE'
    #T    :='NPR Knoten fuer den Export'
    #L(1) :='Geben Sie die Mainframe NPR Knoten Nummer'
    #L(2) :='(nur auf Mainframes) oder den Knotennamen'
    #L(3) :='(fuer Unix Knoten) desjenigen Knoten an,'
    #L(4) :='der die Export Datei empfangen soll.'
  VALUE 'L-file'
    #T    :='Dateiname fuer den Export'
    #L(1) :='Geben Sie den Dateinamen der Datei an, die'
    #L(2) :='auf den Zielknoten geschrieben werden soll.'
    #L(3) :='Environment Variablen sind erlaubt.'
  NONE
    FETCH RETURN 'NRMHELP' 'HEXPRTM1' /*SU1 was 1
    ESCAPE ROUTINE
/*SU1  VALUE 'REXPRTM2'
/*SU1    COMPRESS 'Keine Hilfe (' *PROGRAM ')' TO #T LEAVING NO
/*SU1    #L(1) := 'Fuer dieses Feld ist leider keine Hilfe verfuegbar.'
/*SU1    COMPRESS 'Feld:' #FIELD-NAME TO #L(2)
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<YEI>) / #L(01) / #L(02)
  / #L(03) / #L(04) / #L(05) / #L(06) / #L(07) / #L(08) / #L(09)
  / #L(10) / #L(11) / #L(12) / #L(13) / #L(14) / #L(15) / #L(16)
*
END
