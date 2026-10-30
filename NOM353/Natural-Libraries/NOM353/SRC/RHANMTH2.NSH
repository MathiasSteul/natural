* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RHANMTH2
* Function  General help routine for map fields (German)
*           for the map RHANMTM2
* Version   2.1.1
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* sju 00-03-20 p(191368) created
* sju 05-03-29 NOM31     add help for +, - line commands
* ----------------------------------------------------------------------
*
DEFINE DATA PARAMETER
1  #FIELD-NAME       (A65)
LOCAL
1 #L                 (A65/16)  /* help text lines
1 #T                 (A32)     /* help window title
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
DECIDE ON FIRST #FIELD-NAME
  VALUE 'RHANMTM2'
    FETCH RETURN 'NRMHELP' 'HTSKHAM1'
    ESCAPE ROUTINE
  VALUE 'L-WAIT-MIN'
    #T    :='Wait Factor >Minimum'
    #L(1) :='Enter the number of<seconds>this'
    #L(2) :='task will wait<at least>between '
    #L(3) :='two consecutive processing cycles.'
  VALUE 'L-WAIT-MAX'
    #L(1) :='Enter the number of<seconds>this'
    #L(2) :='task will wait<at most>between '
    #L(3) :='two consecutive processing cycles.'
  VALUE 'L-WAIT-INCR'
    #T    :='Wait Factor >Increment'
    #L(1) :=' Enter number of seconds wait time'
    #L(2) :='<increases>when there is<no>activity.'
    #L(3) :=' Increases to maximum and is then'
    #L(4) :=' reset to minimum.'
  VALUE 'L-MARK'
    #T    :='Line Commands'
    #L(1) :='Valid line commands are:              '
    #L(2) :=' '
    #L(3) :='<C> Close this task (Task 1 will take over its functions)'
    #L(4) :='<W> Wake this task to perform its processing cycle'
    #L(5) :='<P> Purge all entries in this task''s Natural Buffer Pool'
    #L(6) :='<E> Purge one entry in this task''s Natural Buffer Pool'
    #L(7) :='<L> Display this task''s log entries'
    #L(8) :='<+> Activate monitor trace for this task'
    #L(9) :='<-> Deactivate monitor trace for this task'
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
