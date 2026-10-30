* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RDEFMTH2
* Function  General help routine for map fields (German)
*           for the map RDEFMTM2
* Version   2.1.1
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* sju 00-03-02 p(191368) created
* ----------------------------------------------------------------------
*
DEFINE DATA PARAMETER 1  #FIELD-NAME       (A65)
LOCAL
1 #L                 (A65/16)  /* help text lines
1 #T                 (A32)     /* help window title
END-DEFINE
*
DECIDE ON FIRST #FIELD-NAME
  VALUE 'RDEFMTM2'
    FETCH RETURN 'NRMHELP' 'HTSKDFM1'
    ESCAPE ROUTINE
  VALUE '#WAIT-MIN'
    #T    :='Wait Factor >Minimum'
    #L(1) :='Enter the number of<seconds>this'
    #L(2) :='task will wait<at least>between '
    #L(3) :='two consecutive processing cycles.'
    #L(4) :=' '
    #L(5) :='If no value is entered the task'
    #L(6) :='will use the same minimum wait '
    #L(7) :='time as task 1.'
  VALUE '#WAIT-MAX'
    #L(1) :='Enter the number of<seconds>this'
    #L(2) :='task will wait<at most>between '
    #L(3) :='two consecutive processing cycles.'
    #L(4) :=' '
    #L(5) :='If no value is entered the task'
    #L(6) :='will use the same maximum wait '
    #L(7) :='time as task 1.'
  VALUE '#WAIT-INCREMENT'
    #T    :='Wait Factor >Increment'
    #L(1) :=' Enter number of seconds wait time'
    #L(2) :='<increases>when there is<no>activity.'
    #L(3) :=' Increases to maximum and is then'
    #L(4) :=' reset to minimum.'
  VALUE '#PRINT-TASK'
    #T    :='Print Management'
    #L(1) :='Mark with a non-blank character which '
    #L(2) :='task is to perform<Printout Management>'
    #L(3) :='Only select one task.'
    #L(5) :='If no task is selected, Printout'
    #L(6) :='Management will be done by task 1.'
  VALUE '#QUEUE-TASK'
    #T    :='Source Queue Scan'
    #L(1) :='Mark with a non-blank character which '
    #L(2) :='task is to perform<Source Queue Scanning>'
    #L(3) :='Only select one task.'
    #L(5) :='If no task is selected, Source Queue'
    #L(6) :='Scanning will be done by task 1.'
  VALUE '#REPORTS-TASK'
    #T    :='Report Creation'
    #L(1) :='Mark with a non-blank character which '
    #L(2) :='task is to perform<Report and Bundle Creation>'
    #L(3) :='Only select one task.'
    #L(5) :='If no task is selected, Report and'
    #L(6) :='Bundle Creation will be done by task 1.'
  VALUE '#SOURCE-TASK'
    #T    :='Source Loading'
    #L(1) :='Mark with a non-blank character which '
    #L(2) :='task is to perform<Source Loading>'
    #L(3) :='Only select one task.'
    #L(5) :='If no task is selected, Source Loading'
    #L(6) :='will be done by task 1.'
  NONE VALUE
    COMPRESS 'Sorry (' *PROGRAM ')' TO #T LEAVING NO
    #L(1):='No Help available for this field.'
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<I>)
 / #L(01) / #L(02) / #L(03) / #L(04) / #L(05) / #L(06) / #L(07) / #L(08)
 / #L(09) / #L(10) / #L(11) / #L(12) / #L(13) / #L(14) / #L(15) / #L(16)
*
END
