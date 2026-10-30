* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RDEFEMH1 - Help routine for map fields (English)
*           for mask RDEFEMM1 (Email Defaults)
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
    #T    :='Email check period'
    #L(1) :='All ... minutes the monitor will check'
    #L(2) :='if an email has to be sent.'
  VALUE '#EVENT'
    #T    :=' Event Name'
    #L(1) :=' Short descriptive name of event which'
    #L(2) :=' will write an email.'
  VALUE 'EM-EMAIL-SUBJECT' /*SU1 'EMAIL-EVENTS.M-EMAIL-SUBJECT'
    #T    :=' Email Subject Line'
    #L(1) :=' The subject line which will be used'
    #L(2) :=' to send emails. Variable &LAST will be'
    #L(3) :=' replaced with the last time the emails'
    #L(4) :=' have been checked.'
  VALUE '#X'
    #T    :=' Email Addresses'
    #L(1) :=' Press enter to edit the email field.'
    #L(2) :=' Enter the email recipients who get emails'
    #L(3) :=' directly, as a copy (cc) or blind copy (bcc)'
    #L(4) :=' Separate addresses with '';''.'
    #L(5) :=' The ''From'' address indicates the sender,'
    #L(6) :=' the ''Reply'' address will be used if'
    #L(7) :=' a reply to the email will be initiated.'
    #L(8) :=' If a Mainframe node will send the email,'
    #L(9) :=' ''§'' will be converted to ''(a)''.'
  VALUE 'EM-EMAIL-LIBRARY','EM-EMAIL-MEMBER'
    #T    := 'Email Text'
    #L(1) :=' Enter the Natural library and the Natural member'
    #L(2) :=' which contains the text of the email message.'
    #L(3) :=' A variable &MESSAGES is mandatory which will be'
    #L(4) :=' replaced with the log messages.'
    #L(5) :=' Variable &LAST will be replaced with the last'
    #L(6) :=' email check time.'
  VALUE 'EMAIL-EVENTS.M-EMAIL-EVENTS'
    #T    := 'Email Events'
    #L(1) :=' Enter log events which will cause the monitor'
    #L(2) :=' to send emails. The following items are valid:'
    #L(3) :=' NOMnnnn - The Monitor Log will be scanned for'
    #L(4) :='           this message. No ''*'' is possible.'
    #L(5) :=' NATnnnn - The Monitor Log will be scanned for'
    #L(6) :='           Natural messages.'
    #L(7) :='           You can enter a group of messages by'
    #L(8) :='           using ''*''. E.g. NAT3* scans all NAT'
    #L(9) :='           messages from NAT3000 to NAT3999.'
    #L(10):=' Separate the events with '';''. You can enter a'
    #L(11):=' string as last entry which will ristrict the search.'
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
