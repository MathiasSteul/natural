* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* REXPRTH1 - General help routine for map fields (english) -map REXPRTM1
*
* Maintenance
* uuu     yy-mm-dd s(999999) ...
* fhi     13-06-21 NOMALL-86 created
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
    #T     :='Export Object Type'
    #L(01) :='Specify the type of objects to  '
    #L(02) :='be exported.'
    #L(03) :='<BU>- Bundle Definitions'
    #L(04) :='<CA>- Calendars'
    #L(05) :='<DL>- Distribution Lists'
    #L(06) :='<NO>- Mainframe Nodes' /*SU1
    #L(07) :='<PH>- Physical Printer Definitions'
    #L(08) :='<PR>- Logical Printer Definitions'
    #L(09) :='<RP>- Report Definitions'
    #L(10) :='<US>- User Profiles'
    #L(11) :='<UX>- Unix Nodes'
  VALUE 'L-OBJECT-PREFIX'
    #T    :='Object Name'
    #L(1) :='All objects of the given type  '
    #L(2) :='will be exported.'
    #L(3) :='Entering the wildcard characters'
    #L(4) :='''*'' or ''?'' are possible.'
    #L(5) :='For example,<ABC*>will export'
    #L(6) :='all objects which names begin'
    #L(7) :='with ABC.'
  VALUE 'L-OBJECT-MASK'
    #T    :='Object Name Selection Mask'
    #L(1) :='Export a subset of objects with '
    #L(2) :='similar names. For example, with'
    #L(3) :='an object name of<ABC-12XX>'
    #L(4) :='and a mask of <    ??  >'
    #L(5) :='all objects with name ABC-..XX'
    #L(6) :='will be exported, regardless of'
    #L(7) :='the 5th and 6th characters.'
  VALUE 'L-WILDCARD'
    #T    :='Wildcard Character'
    #L(1) :='Specify a character to be used '
    #L(2) :='as wildcard, instead of *.     '
  VALUE 'L-MASK-CHAR'
    #T    :='Mask Character'
    #L(1) :='Specify a character to be used '
    #L(2) :='as mask character, instead of ?.'
  VALUE 'L-LOG'
    #T    :='Log exported objects'
    #L(1) :='Enter<Y>to write a record to the'
    #L(2) :='user log, recording each object'
    #L(3) :='exported. The default is<N>'
  VALUE 'L-CONTENTS'
    #T    :='Contents of Reports?'
    #L(1) :='Enter<Y>to export reports including'
    #L(2) :='their contents.<Y>is only valid for'
    #L(3) :='Active Reports.'
    #L(5) :='The default is<N>'
  VALUES 'L-DATE-SCHEDULED','L-TIME-SCHEDULED'
    #T    :='Time Scheduled'
    #L(1) :='Enter date and time for execution.'
    #L(2) :='Date format yy-mm-dd, time format hh:mm:ss'
    #L(3) :='Empty date means tomorrow,'
    #L(4) :='empty time means at midnight.'
  VALUE 'L-TASKS'
    #T    :='List of Scheduled Tasks'
    #L(1) :='This list shows the tasks already'
    #L(2) :='scheduled for export NOM objects.'
    #L(3) :='The first 15 tasks will be listed.'
  VALUE 'L-NODE'
    #T    :='NPR node for export'
    #L(1) :='Enter the mainframe NPR node number'
    #L(2) :='(on mainframes only) or the node name'
    #L(3) :='(for Unix nodes) of the node which'
    #L(4) :='will receive the export file'
  VALUE 'L-file'
    #T    :='File name for export'
    #L(1) :='Enter the file name of the file'
    #L(2) :='the receiving NPR node will write.'
    #L(3) :='Environment variables are allowed.'
  NONE
    FETCH RETURN 'NRMHELP' 'HEXPRTM1' /*SU1
    ESCAPE ROUTINE
/*SU1  VALUE 'REXPRTM1'
/*SU1    COMPRESS 'Sorry (' *PROGRAM ')' TO #T LEAVING NO
/*SU1    #L(1):='No Help available for this field.'
/*SU1    COMPRESS 'Field:' #FIELD-NAME TO #L(2)
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<YEI>)
 / #L(01) / #L(02) / #L(03) / #L(04) / #L(05) / #L(06) / #L(07) / #L(08)
 / #L(09) / #L(10) / #L(11) / #L(12) / #L(13) / #L(14) / #L(15) / #L(16)
*
END
