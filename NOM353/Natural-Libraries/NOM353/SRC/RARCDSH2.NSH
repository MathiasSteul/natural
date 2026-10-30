* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RARCDSH2
* Function  General help routine for map fields (German)
*           for the map RARCDSM2
* Version   3.2
*
* Maintenance
* uuu     yyyy-mm-dd s(999999) ...
* xsetggr 2007-12-06 NRT2884   created
* SU1     2021-04-07 NOMALL-2444 was NOMALL-2314: correct help
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
  VALUE 'L-ARC'
    #T    :='NOM Archiv Dsname'
    #L(1) :='Geben Sie den Namen des Archivs an.'
    #L(2) :='set (alt).      '
  VALUE 'L-NEW-ARC'
    #T    :='Neuer Dataset Name'
    #L(1) :='Geben Sie den neuen Namen des Datasets an.'
  VALUE 'L-LOG'
    #T    :='Aenderungen an Reports loggen.'
    #L(1) :='<Y> schreibt pro veraendertem Report'
    #L(2) :='einen Satz ins Benutzerlog.'
    #L(3) :='Der Standard ist <N>'
  VALUE 'L-REFRESH-COUNT'
    #T    :='Bildschirm Refresh'
    #L(1) :='Geben Sie die Anzahl der Operationen'
    #L(2) :='zwischen zwei Bildschirm I/Os an.'
    #L(3) :='Standard ist <1000>.'
  VALUE 'L-ET-COUNT'
    #T    :='Laenge der Transaktion'
    #L(1) :='Geben Sie die Anzahl der Operationen '
    #L(2) :='an, bevor ein ET Kommando abge-'
    #L(3) :='setzt wird. Standard ist <30>.'
  NONE
    FETCH RETURN 'NRMHELP' 'HARCDSM1' /*SU1 was 2
    ESCAPE ROUTINE
/*SU1  VALUE 'RARCDSM2'
/*SU1     #T   :='Keine Hilfe'
/*SU1     #L(1):='Fuer dieses Feld keine Hilfe verfuegbar.'
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<YEI>) / #L(01) / #L(02)
  / #L(03) / #L(04) / #L(05) / #L(06) / #L(07) / #L(08) / #L(09)
  / #L(10) / #L(11) / #L(12) / #L(13) / #L(14) / #L(15) / #L(16)
*
END
