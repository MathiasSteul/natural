* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RDEFUDH1
* Function  General help routine for map fields (english)
*           for the map RDEFUDA1
* Version   2.2.1
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* sju 02-03-13 p(191368) created
* ----------------------------------------------------------------------
*
DEFINE DATA PARAMETER 1  #FIELD-NAME       (A65)
LOCAL
1 #L                 (A65/16)  /* help text lines
1 #T                 (A32)     /* help window title
END-DEFINE
************************************************************************
DECIDE ON FIRST #FIELD-NAME
  VALUE 'RDEFUDM1'
    FETCH RETURN 'NRMHELP' 'HUDADEF1'
    ESCAPE ROUTINE
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-NAME'
    #T    :='Archivtyp Name'
    #L(1) :='Geben Sie den Namen des Benutzer definierten'
    #L(2) :='Archivtyps an. '
    #L(3) :=' '
    #L(5) :='Der Name muss eindeutig sein. '
    #L(6) :=' '
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-DESCRIPTION'
    #T    :='Archivtyp Beschreibung'
    #L(1) :='Geben Sie eine Kurzbeschreibung des'
    #L(2) :='Archivtyps ein. Diese dient nur zur'
    #L(3) :='Dokumentation. '
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-PREFIX'
    #T    :='Dateipraefix '
    #L(1) :='Geben Sie einen Dateipraefix fuer'
    #L(2) :='Archivdateien dieses Archivtyps an.'
    #L(3) :=' '
    #L(4) :='Aus dem Praefix und NOMnnnn wobei'
    #L(5) :='nnnn eine eindeutige Zahl ist, wird'
    #L(6) :='der Dateiname gebildet. '
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-ARCHIVE-SKEL'
    #T    :='Archivtyp Skelett '
    #L(1) :='Geben Sie den Namen des Jobskeletts'
    #L(2) :='ein, dass beim Starten des Archivierungsjobs'
    #L(3) :='verwendet werden soll.'
    #L(4) :=' '
    #L(5) :='Das Skelett muss in <SYSNOMU> vorhanden sein.'
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-CONDENSE-SKEL'
    #T    :='Verdichtungsjob Skelett '
    #L(1) :='Geben Sie den Namen des Jobskeletts'
    #L(2) :='ein, dass beim Starten des Verdichtungsjobs'
    #L(3) :='verwendet werden soll.'
    #L(4) :=' '
    #L(5) :='Das Skelett muss in <SYSNOMU> vorhanden sein.'
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-EXITLIB',
      'NRM-USER-DEFINED-ARCHIVE.M-USERARC-EXITMEM'
    #T    :='Archiv Benutzerroutine '
    #L(1) :='Geben Sie die Bibliothek und den Namen'
    #L(2) :='eines Natural subprograms an, dass beim'
    #L(3) :='Zugriff auf die Archivierungsdatei verwendet'
    #L(4) :='werden soll. '
    #L(5) :='Ist hier nichts angegeben, so wird die '
    #L(6) :='Datei wie eine Standarddatei verarbeitet.'
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-REVIVE-SKEL'
    #T    :='Reaktivierungsjob Skelett '
    #L(1) :='Geben Sie den Namen des Jobskeletts'
    #L(2) :='ein, dass beim Starten des Reaktivierungsjobs'
    #L(3) :='verwendet werden soll.'
    #L(4) :=' '
    #L(5) :='Das Skelett muss in <SYSNOMU> vorhanden sein.'
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-ARCHIVE-JOBCARDS'
    #T    :='Archivierungs Jobkarten '
    #L(1) :='Geben Sie bis zu 3 Jobkarten fuer '
    #L(2) :='Archivierungsjobs dieses Typs an. '
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-REVIVE-JOBCARDS'
    #T    :='Reaktivierungs Jobkarten '
    #L(1) :='Geben Sie bis zu 3 Jobkarten fuer '
    #L(2) :='Reaktivierungsjobs dieses Typs an. '
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
