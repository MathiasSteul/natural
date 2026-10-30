* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RDEFEMH2 - Help routine for map fields (german)
*           for mask RDEFEMM2 (Email Defaults)
*
* Maintenance
* uuuuuuuu yyyy-mm-dd iTrac       Remark
* fhi      2016-11-01 NOMALL-1620 Created from RDEFMOH*
* fhi      2018-11-07 NOMALL-1620 No usage of code page / node
* SU1    2019-08-26 NOMALL-2314 correct help
* ----------------------------------------------------------------------
*
DEFINE DATA PARAMETER
1  #FIELD-NAME       (A65)
************************************************************************
LOCAL
1 #L                 (A65/16)  /* help text lines
1 #T                 (A32)     /* help window title
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
DECIDE ON FIRST #FIELD-NAME
  VALUE 'EM-CHECK-PERIOD' /*SU1 'EMAIL-EVENTS.M-CHECK-PERIOD'
    #T    :='E-Mail-Pruefintervall'
    #L(1) :='Der Monitor wird alle ... Minuten pruefen,'
    #L(2) :='ob eine E-Mail gesendet werden muss.'
  VALUE '#EVENT'
    #T    :=' Name des Ereignisses'
    #L(1) :=' Kurzer beschreibender Name des Ereignisses,'
    #L(2) :=' wann eine E-Mail geschrieben werden soll.'
  VALUE 'EM-EMAIL-SUBJECT' /*SU1 'EMAIL-EVENTS.M-EMAIL-SUBJECT'
    #T    :=' Betreffzeile'
    #L(1) :=' Die Betreffzeile der E-Mail, die'
    #L(2) :=' der Knoten senden wird. Die Variable'
    #L(3) :=' &LAST wird durch den letzten geprueften'
    #L(4) :=' Zeitpunkt ersetzt.'
  VALUE '#X'
    #T    :=' E-Mail Adressen'
    #L(1) :=' Geben Sie die E-Mail-Empfaenger an, die'
    #L(2) :=' direct, in Kopie (cc) oder Blindkopie (bcc)'
    #L(3) :=' angeschrieben werden.'
    #L(4) :=' Trennen Sie die Empfaenger mit '';''.'
    #L(5) :=' Die ''Von'' Adresse bezeichnet den Absender,'
    #L(6) :=' die ''Antwortadresse'' wird benutzt, wenn'
    #L(7) :=' die E-Mail beantwortet wird.'
    #L(8) :=' Fuer Mainframe Knoten wird ''§'' in ''(a)'''
    #L(9) :=' umgewandelt.'
  VALUE 'EM-EMAIL-LIBRARY','EM-EMAIL-MEMBER'
    #T    := 'E-Mail Text'
    #L(1) :=' Hier werden die Natural Bibliothek und das Member'
    #L(2) :=' eingegeben, das den Text der E-Mail-Nachricht'
    #L(3) :=' enthaelt. Die Variable &MESSAGES muss enthalten sein.'
    #L(4) :=' Sie wird durch die Log-Meldungen ersetzt.'
    #L(5) :=' Variable &LAST wird durch den letzten geprueften'
    #L(6) :=' Zeitpunkt ersetzt.'
  VALUE 'EMAIL-EVENTS.M-EMAIL-EVENTS'
    #T    := 'E-Mail Ereignisse'
    #L(1) :=' Geben Sie die Ereignisse ein, die das Senden'
    #L(2) :=' einer E-Mail ausloesen. Moeglich sind folgende'
    #L(3) :=' Eingaben:'
    #L(4) :=' NOMnnnn - Das Monitor Log wird nach NOM-Meldungen'
    #L(5) :='           durchsucht. Es ist kein ''*'' moeglich.'
    #L(6) :=' NATnnnn - Das Monitor Log wird nach Natural'
    #L(7) :='           Meldungen durchsucht.'
    #L(8) :='           Es kann eine Gruppe von Meldungen ange-'
    #L(9) :='           geben werden, z.B. NAT3* sucht alle NAT'
    #L(10):='           Meldungen zwischen NAT3000 und NAT3999.'
    #L(11):=' Trennen Sie die Ereignisse mit '';''. Der letzte'
    #L(12):=' Eintrag kann die Suche mit einem String eingrenzen.'
  NONE
    FETCH RETURN 'NRMHELP' 'HSYSDFE1'
    ESCAPE ROUTINE
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<I>)
 / #L(01) / #L(02) / #L(03) / #L(04) / #L(05) / #L(06) / #L(07) / #L(08)
 / #L(09) / #L(10) / #L(11) / #L(12) / #L(13) / #L(14) / #L(15) / #L(16)
*
END
