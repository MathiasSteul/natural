* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RDEFMOH2 - General help routine for map fields (german)
*            for masks RDEFMOM2 (Monitor Defaults) /*SU4 RDEFMOB2,
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* mwi 96-06-24 s(999999) new texts
* gw  96-06-16 s(999999) created
* jwo 97-03-10 p(161209) copy   bs2000 files y/n
* sju 02-10-29 NOM221    long record container file dbid/fnr
* fhi 03-06-17 p(240461) help for new fields missing
* xsetggr 2011-03-02 NOMALL-937 online hhelp for BS2 specific values
* raya    2012-08-20 NOMALL-78 disable long records
* SU1     2012-12-28 NOMALL-82  new class error+Temporary -> Internal
* fhi     2016-09-09 NOMALL-1620 Add help for node and codepage fields
* fhi     2016-11-01 NOMALL-1620 same
* SU2     2018-02-13 NOMALL-1823 NOM 3.5: remove CONNECT
* SU3     2020-11-10 NOMALL-2440 split DDM -> NRM-MF-NODES
* SU4     2024-07-04 ES-34613    NOM 3.6 Remove BS2
* ----------------------------------------------------------------------
*
DEFINE DATA PARAMETER 1  #FIELD-NAME       (A65)
LOCAL
1 #L      (A65/18)  /* help text lines
1 #T      (A32)     /* help window title
1 #TAB    (A65/3)
1 #FIELD  (A65)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
SEPARATE #FIELD-NAME INTO #TAB (1:2) REMAINDER #TAB(3)/*SU3 ->
  WITH DELIMITER '.'
IF #TAB(1)= ' ' OR #TAB(3) NE ' ' /*'.aaa' / 'a.b.c'
  #FIELD := #FIELD-NAME
ELSE
  #FIELD := #TAB(2)
END-IF
IF #TAB(1) ='MF-NODE' OR='MF-NODES' OR='NRM-MF-NODES'
AND SUBSTR(#FIELD,1,3) = 'MF-'                                        /*
  EXAMINE #FIELD FOR 'MF-' REPLACE FIRST 'M-'
END-IF /*SU3 <-
DECIDE ON FIRST #FIELD /*SU3 was #FIELD-NAME
  VALUE 'RDEFMOM2'
    FETCH RETURN 'NRMHELP' 'HSYSDFM1'
/*SU4  VALUE 'RDEFMOB2' FETCH RETURN 'NRMHELP' 'HSYSDFM5'
  VALUE 'M-MONITOR-NODE'
    #T    :='Monitor Knotennummer'
    #L(1) :='Die Nummer des<NATURAL PROCESS>Knotens,'
    #L(2) :='von dem der<NATURAL OUTPUT>Monitor auf-'
    #L(3) :='gerufen werden soll.'
  VALUE 'M-XCOM-JOBNAME'
    #T    :=' ENTIRE SYSTEM SERVER Job-Name'
    #L(1) :=' Wenn<NATURAL SECURITY>installiert'
    #L(2) :=' ist, muss in diesem Feld eine'
    #L(3) :=' Angabe gemacht werden.'
    #L(4) :=' '
    #L(5) :=' Geben Sie bitte den Namen der'
    #L(6) :='<ENTIRE SYSTEM SERVER>Started Task ein.'
  VALUE 'M-CLASSES'
    /* hint:
    /*   for spool type JES3 the helptext HMOPCLI& is used
    /*   a better solution: using a 2nd parameter
    #T    :='Sysout-Klassen'
    #L(1) :=' Geben Sie eine Liste von Sysout-'
    #L(2) :=' Klassen ein, die von<NOM>bearbeitet'
    #L(3) :=' werden sollen.'
    #L(4) :='<NOM>wird nur die Jobs bearbeiten,'
    #L(5) :=' deren Sysout-Dateien in diesen'
    #L(6) :=' Klassen enthalten sind.'
    #L(7) :=' '
    #L(8) :=' Diese Klassen sollten vom Betriebs-'
    #L(9) :=' system ignoriert werden, und werden'
    #L(10):=' nur von<NOM>bearbeitet.'
  VALUE 'M-BATCH-MODULE'
    #T    :='NATURAL Batch Modul'
    #L(1) :='Geben Sie den Namen des<NATURAL>Moduls'
    #L(2) :='ein, der vom Monitor verwendet werden'
    #L(3) :='soll.'
    #L(4) :=' '
    #L(5) :='Der Modul muss in der<NATURAL PROCESS>'
    #L(6) :='Steplib-Verkettung enthalten sein.'
    #L(7) :=' '
    #L(8) :='Der Modul muss so erstellt worden sein,'
    #L(9) :='wie es in dem<NATURAL OUTPUT MANAGEMENT>'
    #L(10):='Installationshandbuch beschrieben ist.'
  VALUE 'M-PRT-TASK-NO'
    #T   :='Drucker Tasks'
    #L(1):='Geben Sie bitte die Anzahl der Tasks an'
    #L(2):='die fuer das Drucken der Reports und'
    #L(3):='Buendel in <VTAM>zu-' /*SU2 und <CON-NECT>zu-'
    #L(4):='staendig sind.'
    #L(5):=' '
    #L(6):='Wird in<BS2000>ignoriert.'
  VALUE '#NODE'
    #T    :=' Knotenname'
    #L(1) :=' Kurzer beschreibender Name des Knotens'
  VALUE 'M-MONITOR-DESCRIPTION'
    #T    :=' Knotenbeschreibung'
    #L(1) :=' Beschreibung des Remote-Knotens, der'
    #L(2) :=' definiert wird. Wenn eine neue'
    #L(3) :=' Definition eingegeben wird, ist die'
    #L(4) :=' ESY Beschreibung Standard (ESY NODE-ID).'
  VALUE 'M-NPR-USERID'
    #T    :=' ESY Benutzerkennung'
    #L(1) :=' Der Benutzer, der sich an ESY anmeldet.'
  VALUE 'M-REMOTE-CODEPAGE'
    #T    :=' Remote Codepage'
    #L(1) :=' Der Name der Codepage, die benutzt'
    #L(2) :=' wird, um die Report-Daten in die lokale'
    #L(3) :=' Codepage zu konvertieren. Dies ist die'
    #L(4) :=' Standard-Codepage. wenn dieses Feld'
    #L(5) :=' der Report-Definition leer ist.'
    #L(7) :=' Falls dieses Feld leer ist, wird eine'
    #L(8) :=' Standard Codeumwandlung durchgefuert.'
  VALUE 'L-STATUS'
    #T    :=' Knoten-Status'
    #L(1) :=' A = Der Knoten ist aktiv und wird benutzt.'
    #L(2) :=' D = Der Knoten ist deaktiviert.'
    #L(4) :=' Bedeutung des Status-Textes:'
    #L(5) :=' aktiv:      Der Knoten ist aktiv und'
    #L(6) :='             kann benutzt werden.'
    #L(7) :=' deaktiv.:   Der Knoten wurde deaktiviert.'
    #L(8) :=' Fehler:     Der Knoten ist im Fehlerzustand.'
    #L(9) :=' inaktiv:    Der Knoten wurde nicht gefunden'
    #L(10):='             oder heruntergefahren.'
    #L(11):=' suspend.:   Knoten wurde durch den Monitor'
    #L(12):='             wegen schwerem Fehler suspendiert.'
  VALUE 'M-WAIT-MINIMUM'
    #T    :='Wartezeiten >Minimum'
    #L(1) :='Geben Sie die Anzahl<Sekunden>ein, die'
    #L(2) :='der Monitor zwischen zwei aufeinander-'
    #L(3) :='folgenden Bearbeitungszyklen<mindestens>'
    #L(4) :='warten soll.'
    #L(5) :=' '
    #L(6) :='In jedem Zyklus wird der Monitor alle'
    #L(7) :='Taetigkeiten ausfuehren, die sich bis'
    #L(8) :='zu diesem Zeitpunkt angesammelt haben.'
  VALUE 'M-WAIT-MAXIMUM'
    #T    :='Wartezeiten >Maximum'
    #L(1) :='Geben Sie die Anzahl<Sekunden>ein, die'
    #L(2) :='der Monitor zwischen zwei aufeinander-'
    #L(3) :='folgenden Bearbeitungszyklen<hoechstens>'
    #L(4) :='warten soll.'
    #L(5) :=' '
    #L(6) :='In jedem Zyklus wird der Monitor alle'
    #L(7) :='Taetigkeiten ausfuehren, die sich bis'
    #L(8) :='zu diesem Zeitpunkt angesammelt haben.'
  VALUE 'M-WAIT-INCREMENT'
    #T   :='Wartezeiten >Schrittweite'
    #L(1):='Geben Sie die Schrittweite in Sekunden an,'
    #L(2):='um die die Wartezeit<erhoeht>werden soll.'
    #L(3):=' '
    #L(4):='Wenn waehrend der Mindestwartezeit keine'
    #L(5):='Aufgaben anfallen, wird die Wartezeit um die'
    #L(6):='hier angegebene Schrittweite erhoeht, bis'
    #L(7):='die Hoechstwartezeit erreicht ist.'
    #L(8):='Sobald Aufgaben anstehen, wird die Wartezeit'
    #L(9):='wieder auf die Mindestwartezeit reduziert.'
  VALUE '#BS2-COPY'
    #T   :='Dateien kopieren'
    #L(1):='Geben Sie<Y>(yes) oder <N>(no) ein um NOM das Kopieren'
    #L(2):='von Druckdateien in ein Containerfile zu erlauben.'
    #L(4):='<Warnung!>Die Option<''Y''>darf nur verwendet werden, wenn'
    #L(5):='die Dateien nicht umbenannt werden.'
    #L(07):='Die Originaldruckdateien werden dann durch NOM weder'
    #L(08):='umbenannt noch geloescht. Sie koennen nach Verarbeitung'
    #L(09):='durch NOM wieder ueberschrieben werden.'
  VALUE '#BS2-RENAME'
    #T   :='Dateien umbenennen'
    #L(1):='Geben Sie<Y>(yes) oder <N>(no) ein um NOM das Umbenennen'
    #L(2):='von Druckdateien zu erlauben. NOM fuegt dabei eine'
    #L(3):='Erweiterung hinzu, um die Dateien eindeutig zu machen.'
    #L(5):='<Warnung!>Die Option<''N''>darf nur verwendet werden, wenn'
    #L(6):='sichergestellt ist, dass die zu verarbeitenden Datei-'
    #L(7):='namen eindeutig sind. Ansonsten koennen unvorhersehbare'
    #L(8):='Ergebnisse die Folge sein.'
    #L(10):='Wird z.B. eine bereits durch NOM verarbeitete Datei'
    #L(11):='ueberschrieben und mit einem neuen Druckauftrag versehen,'
    #L(12):='werden dadurch aeltere Reports zu dieser Datei inkonsistent.'
  VALUE 'M-BS2-DEST'
    #T    :='Virtuelle Drucker fuer BS2000'
    #L(1) :='<Neues Verfahren>(ab BS2000 Spool<3.0B>):'
    #L(2) :=' Nur im<1.>Feld (recform)<*V>eingeben.'
    #L(3) :=' Die Druckauftraege fuer virtuelle Drucker'
    #L(4) :=' werden bearbeitet.'
    #L(5) :=' '
    #L(6) :='<Altes Verfahren:>'
    #L(7) :=' Die dem SPACE-Param. entsprechenden'
    #L(8) :=' Dummy-RSO-Drucker eintragen, beim<1.>Feld'
    #L(9) :=' ist das Kontrollfeld im RECFORM-Feld des'
    #L(10):=' Katalogeintrags beschrieben.'
    #L(11):=' Bsp.: Ein Auftrag mit /PRINT xxx,DEV=NOME'
    #L(12):=' wird vom NOM als SPACE=E interpretiert,'
    #L(13):=' wenn im 2. Feld ''NOME'' eingetragen ist.'
  VALUE 'M-TEMP-CLASS'
    #T    :='Klassen >Intern'
    #L(1) :=' Eine Sysout-Klasse muss definiert'
    #L(2) :=' werden, um die internen Sysout-'
    #L(3) :=' Dateien zu halten.'
    #L(4) :=' Diese Klasse darf nicht in dem Feld'
    #L(5) :='<Sysout-Klassen> definiert sein.'
    #L(6) :=' '
    #L(7) :=' Diese Klasse sollte vom Betriebs-'
    #L(8) :=' system ignoriert werden, und wird'
    #L(9) :=' nur von<NOM>bearbeitet.'
  VALUE 'M-ERR-CLASS'
    #T    :='Klassen >Fehler'
    #L(1) :='Geben Sie hier die Sysout-Klasse an, in die ein'
    #L(2) :='Report im Falle eines Fehlers geaendert werden soll.'
    #L(3) :='Diese Klasse darf nicht in dem Feld'
    #L(4) :='<Sysout-Klassen>definiert sein.'
  VALUE 'M-JES3-OUTPUT-CLASSES'
    #T    :='Sysout-Klassen'
    #L(1) :='Geben Sie eine Liste von Sysout-Klassen ein, die'
    #L(2) :='von<NOM>verarbeitet werden sollen.'
    #L(3) :='Diese Klassen sollten vom Betriebssystem ignoriert werden'
    #L(4) :='und duerfen nur von<NOM>verarbeitet werden.'
    #L(5) :=' '
    #L(6) :='Falls angegeben, werden nur Ausgabedateien in diesen'
    #L(7) :='Klassen von<NOM>verarbeitet.'
    #L(8) :=' '
    #L(9) :='Wenn keine Sysout-Klassen angegeben werden, duerfen alle'
    #L(10):='Ausgabedateien von Jobs in den angegebenen Ausfuehrungs-'
    #L(11):='klassen verarbeitet werden. Es entfaellt jedoch dann die'
    #L(12):='Moeglichkeit<Standard Definitionen>fuer Reports zu nutzen.'
    #L(13):='Ausgabedateien ohne eine passende Reportdefinition werden'
    #L(14):='also nicht verarbeitet.'
    #L(15):='Beachten Sie bitte, dass ein erheblicher Mehrverbrauch an'
    #L(16):='Resourcen entstehen kann, wenn keine Sysout-Klassen'
    #L(17):='angegeben werden.'
  VALUE 'M-PRINT-CLASS'
    #T    :='Klassen >Druck'
    #L(1) :='Geben Sie hier die Sysout-Klasse an, in der'
    #L(2) :='Reports und Buendel gedruckt werden sollen.'
  VALUE 'M-JOBCARD'
    #T   :='Jobkarten'
    #L(1):='Geben Sie hier die Jobkarten ein, die als Standard'
    #L(2):='benutzt werden soll.'
    #L(3):='Dabei wird der Ausdruck <&USER> durch die User ID'
    #L(4):='ersetzt,<&REPORT>und<&BUNDLE>durch den Reportnamen'
    #L(5):='bzw. durch den Buendelnamen>.'
    #L(6):='(<&>= Escape-Symbol im physischem Drucker.)'
  VALUE 'M-MAX-RETRIES'
    #T    :='Maximale Anzahl Wiederholungen'
    #L(1) :=' Maximale Anzahl Wiederholungen fuer eine'
    #L(2) :=' abgebrochene Monitor Operation. Jeder'
    #L(3) :=' Versuch wird aufgesetzt nach der in dem Intervall-'
    #L(4) :=' feld angegebenen Anzahl Sekunden.'
  VALUE 'M-RETRY-INTERVAL'
    #T    := 'Wiederholungs-Intervall'
    #L(1) :=' Anzahl der Sekunden, die der Monitor wartet,'
    #L(2) :=' bevor eine abgebrochene Operation'
    #L(3) :=' wiederholt wird. '
  VALUE 'M-EMAIL-RECIPIENTS'
    #T    := 'Notfall-E-Mails'
    #L(1) :=' Geben Sie die E-Mail-Empfaenger an, falls'
    #L(2) :=' schwere Fehler im aktuellen Knoten auftreten.'
    #L(3) :=' Trennen Sie die Empfaenger mit '';''.'
    #L(4) :=' E-Mails werden gesendet, wenn nicht '
    #L(5) :=' behebbare Fehler auftreten oder Adabas'
    #L(6) :=' Fehler gemeldet werden.'
  NONE VALUE
    COMPRESS 'Sorry (' *PROGRAM ')' TO #T LEAVING NO
    #L(1):='Keine Hilfe fuer dieses Feld vorhanden.'
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<I>)
 / #L(01) / #L(02) / #L(03) / #L(04) / #L(05) / #L(06) / #L(07) / #L(08)
 / #L(09) / #L(10) / #L(11) / #L(12) / #L(13) / #L(14) / #L(15) / #L(16)
*
END
