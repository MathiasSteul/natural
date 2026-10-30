* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RDFLRPH1
* Function  General help routine for map fields
* Version   1.3.5
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* mwi 96-06-21 s(999999) input statement corrected
* gw  96-06-16 s(999999) window with auto size and title
* mwi 96-06-13 s(999999) created
* SJU 98-11-24 s(284191) immediate archiving
* SJU 00-07-24 CER 7465  create report definition
* SJU 00-08-24 s(999999) fix intensified help - replace #..§ with <..>
* SU1     2015-12-07 NOMALL-1789 Adapt help for Separator Page
* ----------------------------------------------------------------------
*
DEFINE DATA PARAMETER 1  #FIELD-NAME       (A65)
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
  VALUE 'RDFLRPM1'
    FETCH RETURN 'NRMHELP' 'HSYSDFR1'
    ESCAPE ROUTINE
  VALUE 'REPORT-DEFAULTS.R-STORE-NATRPT'
    #T   :='Store in NOM DB'
    #L(1):='Enter<Y>to take Report contents from JES-SPOOL and store'
    #L(2):='them in NOM Database for later viewing or archiving.'
  VALUE 'REPORT-DEFAULTS.R-ARCHIVE'
    #T   :='Archive directly'
    #L(1):='Enter<Y>to automatically mark Reports for archiving when'
    #L(2):='created. Report is archived when processing is completed.'
    #L(3):='Enter<N>, if you do not want Reports automatically archived.'
    #L(4):='Enter<I>, if you want Reports automatically archived when'
    #L(5):='created but still available for on-line viewing.'
  VALUE 'REPORT-DEFAULTS.R-CREATE-DEFINITION'
    #T   :='Create Definition'
    #L(1):='Enter<Y>to have definitions automatically created for'
    #L(2):='reports produced as a result of separation.'
    #L(3):='Enter<N>, if you do not want definitions to be created.'
  VALUE 'REPORT-DEFAULTS.R-RETENTION-NUM'
    #T   :='Report Retention >Number'
    #L(1):='Enter number of working days, absolute days, weeks or months'
    #L(2):='Report should be stored in NOM Database.'
  VALUE 'REPORT-DEFAULTS.R-RETENTION-UNIT'
    #T   :='Report Retention >Unit'
    #L(1):='Enter<W>(working days),<A>(absolute days),<V>(weeks)'
    #L(2):='or<M>(months)'
  VALUE 'REPORT-DEFAULTS.R-RETENTION-CALENDAR'
    #T   :='Report Retention >Calendar'
    #L(1):='If you select<W>(working days), enter a Calendar name.'
  VALUE 'REPORT-DEFAULTS.R-RETENTION-ACTION'
    #T   :='Report Retention >Action'
    #L(1):='Enter<A>to archive Report or<P>to purge Report when Retention'
    #L(2):='Period expires.'
  VALUE 'REPORT-DEFAULTS.R-SEPSTART' /*SU1
    #T   :='Separator Pages >Start'
    #L(1):='Enter the name of the separator page to be printed at the'
    #L(2):='<beginning>of the report. If this field is<omitted>then the'
    #L(3):='<standard>separator page will be used.<None>means no separator'
    #L(4):='page.'
  VALUE 'REPORT-DEFAULTS.R-SEPEND' /*SU1
    #T   :='Separator Pages >End'
    #L(1):='Enter the name of the separator page to be printed at the'
    #L(2):='<end>of the report. If this field is<omitted>then the'
    #L(3):='<standard>separator page will be used.<None>means no separator'
    #L(4):='page.'
  VALUE 'REPORT-DEFAULTS.R-SEPNO'
    #T   :='Separator Pages >Copies'
    #L(1):='Enter number of times Separator Page is printed at beginning'
    #L(2):='and end of Report.'
  VALUE 'REPORT-DEFAULTS.R-PRINT-JOBCARD'
    #T   :='Job Cards'
    #L(1):='Enter job cards used for'
    #L(2):='printing on system printers.'
  NONE VALUE
    COMPRESS 'Sorry (' *PROGRAM ')' TO #T LEAVING NO
    #L(1):='No Help available for this field'
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
*
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<YEI>) / #L(01) / #L(02) / #L(03)
  / #L(04) / #L(05) / #L(06) / #L(07) / #L(08) / #L(09) / #L(10)
*
END
