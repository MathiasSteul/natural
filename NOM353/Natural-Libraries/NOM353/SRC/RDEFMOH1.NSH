* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RDEFMOH1 - General help routine for map fields (english)
*            for the maps RDEFMOM1 /*SU4 RDEFMOB1
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* gw  96-06-16 s(999999) created
* jwo 97-03-10 p(161209) copy   bs2000 files y/n
* sju 02-10-29 NOM221    long record container file dbid/fnr
* sju 03-06-05 p(240461) retries/interval
* xsetggr 2011-03-02 NOMALL-937 online help for BS2 specific values
* raya    2012-08-20 NOMALL-78  disable long records
* SU1     2012-12-28 NOMALL-82  new class error+Temporary -> Internal
* fhi     2016-09-09 NOMALL-1620 Add help for node and codepage fields
* fhi     2016-11-01 NOMALL-1620 same
* SU2     2018-02-13 NOMALL-1823 NOM 3.5: remove CONNECT
* SU3     2020-11-10 NOMALL-2440 split DDM -> NRM-MF-NODES
* SU4     2024-07-04 ES-34613    NOM 3.6 Remove BS2
* ----------------------------------------------------------------------
*
DEFINE DATA PARAMETER 1  #FIELD-NAME       (A65)
LOCAL
1 #L      (A65/16)  /* help text lines
1 #T      (A32)     /* help window title
1 #TAB    (A65/3)
1 #FIELD  (A65)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
SEPARATE #FIELD-NAME INTO #TAB (1:2) REMAINDER #TAB(3)/*SU3 ->
  WITH DELIMITER '.'
IF #TAB(1)= ' ' OR #TAB(3) NE ' ' /*'.aaa' / 'a.b.c'
  #FIELD := #FIELD-NAME
ELSE
  #FIELD := #TAB(2)
END-IF
IF #TAB(1) ='MF-NODE' OR='MF-NODES' OR='NRM-MF-NODES'
AND SUBSTR(#FIELD,1,3) = 'MF-'                                        /*
  EXAMINE #FIELD FOR 'MF-' REPLACE FIRST 'M-'
END-IF /*SU3 <-
DECIDE ON FIRST #FIELD /*SU3 was #FIELD-NAME
  VALUE 'RDEFMOM1'
    FETCH RETURN 'NRMHELP' 'HSYSDFM1'
/*SU4  VALUE 'RDEFMOB1' FETCH RETURN 'NRMHELP' 'HSYSDFM5'
  VALUE 'M-MONITOR-NODE'
    #T    :='Monitor Node Number'
    #L(1) :='Enter the<NATURAL PROCESS>node number,'
    #L(2) :='on which the <NATURAL OUTPUT>monitor'
    #L(3) :='is to be invoked.'
  VALUE 'M-XCOM-JOBNAME'
    #T    :=' ENTIRE SYSTEM SERVER Jobname'
    #L(1) :=' If<NATURAL SECURITY>is installed,'
    #L(2) :=' this field must be entered.'
    #L(3) :=' '
    #L(4) :=' Please enter the '
    #L(5) :='<ENTIRE SYSTEM SERVER>started task name.'
    #L(6) :=' A<USER ID>, with<ID>and<password>'
    #L(7) :=' identical to this field must be'
    #L(8) :=' defined in<NATURAL SECURITY.>'
  VALUE 'M-CLASSES'
    /* hint:
    /*   for spool type JES3 the helptext HMOPCLI& is used
    /*   a better solution: using a 2nd parameter
    #T    :='Sysout Classes'
    #L(1) :='Enter a list of SYSOUT classes'
    #L(2) :='to be processed by <NOM.>'
    #L(3) :='Only those jobs having sysout'
    #L(4) :='datasets residing in these classes'
    #L(5) :='will be processed by<NOM.>'
    #L(6) :=' '
    #L(7) :='These classes should be ignored by'
    #L(8) :='the operating system, and may be'
    #L(9) :='processed only by<NOM.>'
  VALUE 'M-BATCH-MODULE'
    #T    :=' Natural Batch Module'
    #L(1) :=' Enter the<NATURAL>module name'
    #L(2) :=' which will be used by the monitor.'
    #L(3) :=' '
    #L(4) :=' The module must reside on the'
    #L(5) :='<NATURAL PROCESS>steplib concatenation.'
    #L(6) :=' '
    #L(7) :=' The module must be created as explained'
    #L(8) :=' in the<NATURAL OUTPUT MANAGEMENT>'
    #L(9) :=' installation manual.'
  VALUE 'M-PRT-TASK-NO'
    #T    :=' Printer Tasks'
    #L(1) :=' Enter the number of<tasks>attached to'
    #L(2) :=' print<Reports>and<Bundles>in<VTAM>'
    #L(3) :=' '
    #L(4) :=' '
    #L(5) :=' Will be ignored in<BS2000.>'
  VALUE '#NODE'
    #T    :=' Node Name'
    #L(1) :=' Short descriptive name of the node'
  VALUE 'M-MONITOR-DESCRIPTION'
    #T    :=' Node Description'
    #L(1) :=' Description of the remote node to be'
    #L(2) :=' defined. If a new node is entered, the'
    #L(3) :=' description of the ESY node is default'
    #L(4) :=' (the ESY NODE-ID).'
  VALUE 'M-NPR-USERID'
    #T    :=' ESY UserID'
    #L(1) :=' The user which will logon to the ESY node.'
  VALUE 'M-REMOTE-CODEPAGE'
    #T    :=' Remote Codepage'
    #L(1) :=' The name of the codepage which will be'
    #L(2) :=' used to convert report data to the'
    #L(3) :=' local codepage. This is the default'
    #L(4) :=' codepage if the corresponding field'
    #L(5) :=' if the report definition is empty.'
    #L(7) :=' If this field is empty, a default'
    #L(8) :=' codepage conversion will be used.'
  VALUE 'L-STATUS'
    #T    :=' Node Status'
    #L(1) :=' A = Node is active and will be used.'
    #L(2) :=' D = Node is deactivated.'
    #L(4) :=' The status text means:'
    #L(5) :=' active:   Node is active and accessible.'
    #L(6) :=' deactiv.: Node has been deactivated.'
    #L(7) :=' error:    Node is in error.'
    #L(8) :=' down:     Node was not found or'
    #L(9) :='           a shutdown occurred.'
    #L(10):=' suspended:Node suspended by Monitor.'
  VALUE 'M-WAIT-MINIMUM'
    #T    :='Wait Factor >Minimum'
    #L(1) :='Enter the number of<seconds>the'
    #L(2) :='monitor will wait<at least>between '
    #L(3) :='two consecutive processing cycles.'
    #L(4) :=' '
    #L(5) :='In each cycle the monitor will'
    #L(6) :='perform all the work accumulated'
    #L(7) :='up to that time.'
  VALUE 'M-WAIT-MAXIMUM'
    #T    :='Wait Factor >Maximum'
    #L(1) :='Enter the number of<seconds>the'
    #L(2) :='monitor will wait<at most>between '
    #L(3) :='two consecutive processing cycles.'
    #L(4) :=' '
    #L(5) :='In each cycle the monitor will'
    #L(6) :='perform all the work accumulated'
    #L(7) :='up to that time.'
  VALUE 'M-WAIT-INCREMENT'
    #T    :='Wait Factor >Increment'
    #L(1) :=' Enter number of seconds wait time'
    #L(2) :='<increases>when there is<no>activity.'
    #L(3) :=' Increases to maximum and is then'
    #L(4) :=' reset to minimum.'
  VALUE '#BS2-COPY'
    #T    :='Copy files'
    #L(1) :='Enter<Y>(yes) or <N>(no) to allow or disallow<NOM>'
    #L(2) :='to copy print files into the container file before'
    #L(3) :='processing'
    #L(5) :='<Warning!>Option<''Y''>may only be used without renaming'
    #L(6) :='the datasets.'
    #L(7) :='The original datasets will neither be renamed nor deleted'
    #L(8) :='by NOM.'
  VALUE '#BS2-RENAME'
    #T    :='Rename files'
    #L(1) :='Enter<Y>(yes) or <N>(no) to allow or disallow<NOM>'
    #L(2) :='to rename print files in order to keep them unique.'
    #L(3) :='(A suffix will be appended)'
    #L(5) :='<Warning!>Option<''N''>may only be used when all data sets'
    #L(6) :='to be processed by NOM are unique. Otherwise the results'
    #L(7) :='will be unpredictable.'
    #L(9) :='I.e. if a data set which has already been processed by NOM'
    #L(10):='is overwritten and printed to NOM again, older reports'
    #L(11):='pointing to this data sets will become inconsistent.'
  VALUE 'M-BS2-DEST'
    #T    :='Virtual Printer for BS2000'
    #L(1) :='<New procedure>(as of BS2000 Spool<3.0B>):'
    #L(2) :=' Just enter<*V>in<1st>field (RECFORM).'
    #L(3) :=' Printjobs for virtual printers will be processed.'
    #L(4) :=' '
    #L(5) :='<Old Procedure:>'
    #L(6) :=' Enter the name of the Dummy-RSO-printer'
    #L(7) :=' corresponding to the carriage control byte.'
    #L(7) :=' An entry in the<1st>field implies, that'
    #L(8) :=' the carriage control byte is described by the'
    #L(9) :=' RECFORM parameter of the catalog entry.'
    #L(10):=' Example: A job with /PRINT xxx,DEV=NOME'
    #L(11):=' will be interpreted by NOM as SPACE=E if the'
    #L(12):=' 2nd field contains ''NOME''.'
  VALUE 'M-JES3-OUTPUT-CLASSES'
    #T    :='Sysout Classes'
    #L(1) :='Enter a list of sysout classes to be processed by<NOM.>'
    #L(2) :=' '
    #L(3) :='These classes should be ignored by the operating system'
    #L(4) :='and may be processed only by<NOM.>'
    #L(5) :=' '
    #L(6) :='If specified, only sysout datasets residing in these'
    #L(7) :='classes will be processed by<NOM.>'
    #L(8) :=' '
    #L(9) :='If no output classes are specified, then all datasets of'
    #L(10):='jobs in NOM execution classes may be processed. However,'
    #L(11):='in this case the<Default Report>feature is not available.'
    #L(12):='Sysout data sets without a suitible report definition are'
    #L(13):='not processed.'
    #L(14):=' '
    #L(15):='Please also note, that omitting output classes may result'
    #L(16):='in a substantial performance overhead.'
  VALUE 'M-TEMP-CLASS'
    #T    :='Classes >Internal'
    #L(1) :=' One sysout class must be defined'
    #L(2) :=' to hold internal sysout datasets.'
    #L(3) :=' This class<must not>be one of the'
    #L(4) :=' classes defined on the'
    #L(5) :='<Sysout Classes>fields.'
    #L(6) :=' '
    #L(7) :=' This class should be ignored by'
    #L(8) :=' the operating system and may be'
    #L(9) :=' processed only by<NOM.>'
  VALUE 'M-ERR-CLASS'
    #T    :='Classes >Error'
    #L(1) :='Enter class to which Reports will be changed'
    #L(2) :='in case of an error.'
    #L(3) :='This class<must not>be one of the classes'
    #L(4) :='defined on the <Sysout Classes>fields.'
  VALUE 'M-PRINT-CLASS'
    #T    :='Classes  >Print'
    #L(1) :='Enter class in which Reports and Bundles'
    #L(2) :='are to be printed'
  VALUE 'M-JOBCARD'
    #T   :='Jobcards'
    #L(1) :='Enter job card to be used as default when '
    #L(2) :='no other job card is specified.'
    #L(3) :='The variable<&USER>will be replaced by'
    #L(4) :='the User ID,<&REPORT>and<&BUNDLE> by'
    #L(5) :='the Report name and the Bundle name, resp.'
    #L(6) :='(<&>= escape character for Physical Printer)'
  VALUE 'M-MAX-RETRIES'
    #T    :='Maximum Number of Error Retries'
    #L(1) :=' Specify the maximum number of retries for'
    #L(2) :=' a failed monitor operation. Each retry  '
    #L(3) :=' will be attempted after the number of seconds   '
    #L(4) :=' specified in the Interval field. '
  VALUE 'M-RETRY-INTERVAL'
    #T    := 'Error Retry Interval'
    #L(1) :=' Specify the number of seconds the monitor'
    #L(2) :=' is to wait before retrying a failed   '
    #L(3) :=' operation. '
  VALUE 'M-EMAIL-RECIPIENTS'
    #T    := 'Emergency Emails'
    #L(1) :=' Specify the email recipients in case of'
    #L(2) :=' emergency errors in the current node.'
    #L(3) :=' Separate them with '';''.'
    #L(4) :=' An email will be sent if unrecoverable'
    #L(5) :=' errors occur or if Adabas response codes'
    #L(6) :=' are returned.'
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
