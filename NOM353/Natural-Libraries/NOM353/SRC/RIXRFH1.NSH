* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RIXRFH1
* Function  General help routine for map fields (english)
*           for the map RIXRFM11
* Version   3.1.1
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* sju 04-12-10 NOM31     created
* ----------------------------------------------------------------------
*
DEFINE DATA PARAMETER 1  #FIELD-NAME       (A65)
LOCAL
1 #L                 (A65/16)  /* help text lines
1 #T                 (A32)     /* help window title
END-DEFINE
************************************************************************
DECIDE ON FIRST #FIELD-NAME
  VALUE 'RIXRFM11'
    FETCH RETURN 'NRMHELP' 'HIXRFM1'
    ESCAPE ROUTINE
  VALUE 'L-XREF-TYPE'
    #T    :='Identification Type'
    #L(1) :='Enter one of the numbers shown to '
    #L(2) :='specify which identification type '
    #L(3) :='is to be cross-referenced. '
    #L(4) :='For example     '
    #L(5) :='<1> to cross-reference Jes job name.'
  VALUE 'L-REPORT-NAME'
    #T    :='Report Name Prefix'
    #L(1) :='Used to restrict cross-reference'
    #L(2) :='to reports whose name begins with'
    #L(3) :='this prefix. For example '
    #L(4) :='<ABC*> for reports with names'
    #L(5) :='beginning ABC.'
  VALUE 'L-XREF-MATCH'
    #T    :='Identification Value Prefix'
    #L(1) :='Used to restrict cross-reference'
    #L(2) :='to reports which use the given'
    #L(3) :='identification value prefix. '
    #L(4) :='For example            '
    #L(5) :='<D49*> to limit the results to '
    #L(6) :='reports that specify a value   '
    #L(7) :='beginning with D49.            '
  VALUE 'L-PRINT-OUTPUT'
    #T    :='Print Results'
    #L(1) :='Enter<Y>to print the results to'
    #L(2) :='Printer 1 or<N>to display the '
    #L(3) :='results on screen.'
  NONE VALUE
    COMPRESS 'Sorry (' *PROGRAM ')' TO #T LEAVING NO
    #L(1):='No Help available for this field.'
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<YEI>)
 / #L(01) / #L(02) / #L(03) / #L(04) / #L(05) / #L(06) / #L(07) / #L(08)
 / #L(09) / #L(10) / #L(11) / #L(12) / #L(13) / #L(14) / #L(15) / #L(16)
*
END
