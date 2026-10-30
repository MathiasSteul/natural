* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RDFLRPH2
* Function  General help routine for map fields
* Version   1.3.5
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* mwi 96-06-21 s(999999) input statement corrected
* gw  96-06-16 s(999999) window with auto size and title
* mwi 96-06-13 s(999999) created
* SJU 98-11-24 s(284191) immediate archiving
* fhi 08-07-04 P304912   Field help missing
* SU1     2015-12-07 NOMALL-1789 Adapt help for Separator Page
* ----------------------------------------------------------------------
*
DEFINE DATA PARAMETER
1  #FIELD-NAME       (A65)
LOCAL
1 #L                 (A65/10)  /* help text lines
1 #T                 (A36)     /* help window title
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
DECIDE ON FIRST #FIELD-NAME
  VALUE 'RDFLRPM2'
    FETCH RETURN 'NRMHELP' 'HSYSDFR1'
    ESCAPE ROUTINE
  VALUE 'REPORT-DEFAULTS.R-STORE-NATRPT'
    #T   :='In NOM-DB kopieren'
    #L(1):='Geben Sie<Y>ein, um den Inhalt des Reports aus dem SPOOL'
    #L(2):='zu nehmen und ihn in der NOM-Datenbank zu speichern, damit er'
    #L(3):='spaeter eingesehen oder archiviert werden kann'
  VALUE 'REPORT-DEFAULTS.R-ARCHIVE'
    #T   :='Archivierung direkt'
    #L(1):='Geben Sie<Y>ein, wenn Reports bei ihrer Erstellung automatisch'
    #L(2):='fuer die Archivierung markiert werden sollen. Der Report wird'
    #L(3):='archiviert, wenn die Verarbeitung beendet ist. Geben Sie<N>ein,'
    #L(4):='falls Sie Reports nicht automatisch archivieren moechten.'
    #L(5):='Geben Sie<I>ein, wenn Reports bei ihrer Erstellung automatisch'
    #L(6):='erstellt werden aber noch on-line gelesen werden sollen.'
  VALUE 'REPORT-DEFAULTS.R-CREATE-DEFINITION'
    #T   :='Definitionen erzeugen'
    #L(1):='<Y>bewirkt, dass Definitionen automatisch fuer'
    #L(2):='Reports erzeugt werden, die aus einer Separation'
    #L(3):='kommen.<N>erzeugt keine Reportdefinitionen.'
  VALUE 'REPORT-DEFAULTS.R-RETENTION-NUM'
    #T   :='Report-Aufbewahrungszeit >Anzahl'
    #L(1):='Geben Sie die Anzahl Werktage, absolute Tage, Wochen oder Monate'
    #L(2):='ein, die der Report in der NOM Datenbank gespeichert werden soll.'
  VALUE 'REPORT-DEFAULTS.R-RETENTION-UNIT'
    #T   :='Report-Aufbewahrungszeit >Einheit'
    #L(1):='Geben Sie<W>fuer Werktage,<A>fuer absolute Tage,<V>fuer Wochen'
    #L(2):='oder<M>fuer Monate ein.'
  VALUE 'REPORT-DEFAULTS.R-RETENTION-CALENDAR'
    #T   :='Report-Aufbewahrungszeit >Kalender'
    #L(1):='Geben Sie den Kalendernamen ein, falls die "Einheit"<W>ist.'
  VALUE 'REPORT-DEFAULTS.R-RETENTION-ACTION'
    #T   :='Report-Aufbewahrungszeit >Aktion'
    #L(1):='Geben Sie<A>ein, um den Report zu archivieren oder<P>um ihn'
    #L(2):='zu loeschen, nachdem die Aufbewahrungsfrist abgelaufen ist.'
  VALUE 'REPORT-DEFAULTS.R-SEPSTART' /*SU1
    #T   :='Trennblaetter >Start'
    #L(1):='Geben Sie den Namen des Trennblattes ein, das am <Anfang>'
    #L(2):='des Reports gedruckt werden soll. Wenn hier<keine Angabe>gemacht'
    #L(3):='wird, wird das<Standardtrennblatt>verwendet.<KEIN(NONE)>bedeuted'
    #L(4):='kein Trennblatt.'
  VALUE 'REPORT-DEFAULTS.R-SEPEND' /*SU1
    #T   :='Trennblaetter >Ende'
    #L(1):='Geben Sie den Namen des Trennblattes ein, das am <Ende>'
    #L(2):='des Reports gedruckt werden soll. Wenn hier<keine Angabe>gemacht'
    #L(3):='wird, wird das<Standardtrennblatt>verwendet.<KEIN(NONE)>bedeuted'
    #L(4):='kein Trennblatt.'
  VALUE 'REPORT-DEFAULTS.R-SEPNO'
    #T   :='Trennblaetter >Exemplare'
    #L(1):='Geben Sie an, wie oft das Trennblatt am Anfang und am Ende des'
    #L(2):='Reports gedruckt werden soll.'
  VALUE 'REPORT-DEFAULTS.R-PRINT-JOBCARD'
    #T   :='Jobkarten'
    #L(1):='Die Jobkarten, die fuer Ausdrucke auf Systemdrucker verwendet'
    #L(2):='werden sollen.'
  NONE VALUE
    #T   :='Keine Hilfe'
    #L(1):='Leider keine Hilfe fuer dieses Feld vorhanden.'
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
*
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<YEI>) / #L(01) / #L(02) / #L(03)
  / #L(04) / #L(05) / #L(06) / #L(07) / #L(08) / #L(09) / #L(10)
*
END
