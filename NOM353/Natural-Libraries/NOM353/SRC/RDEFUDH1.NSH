* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RDEFUDH1 - General help routine for map fields (english)
*            for the map RDEFUDA1
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* sju 02-03-13 p(191368) created
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
  VALUE 'RDEFUDM1'
    FETCH RETURN 'NRMHELP' 'HUDADEF1'
    ESCAPE ROUTINE
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-NAME'
    #T    :='Archive Name (Required)'
    #L(1) :='Enter the name to be assigned to'
    #L(2) :='this <User Defined Archive> '
    #L(3) :=' '
    #L(5) :='The name must not be assigned'
    #L(6) :='to any other archive type. '
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-DESCRIPTION'
    #T    :='Archive Description (Optional)'
    #L(1) :='Enter a short description of this'
    #L(2) :='archive type. This description is'
    #L(3) :='only for documentation purposes.'
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-PREFIX'
    #T    :='DSN Prefix (Optional)'
    #L(1) :='Enter a dataset name prefix for '
    #L(2) :='archive datasets of this type.'
    #L(3) :=' '
    #L(4) :='This prefix is concatenated with'
    #L(5) :='NOMnnnn where nnnn is a unique '
    #L(6) :='number, to form the dataset name.'
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-ARCHIVE-SKEL'
    #T    :='Archive Job Skeleton (Required)'
    #L(1) :='Enter the name of the job skeleton'
    #L(2) :='to be used when submitting an'
    #L(3) :='archive job.'
    #L(4) :=' '
    #L(5) :='This skeleton must exist in<SYSNOMU>'
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-CONDENSE-SKEL'
    #T    :='Condense Job Skeleton (Required)'
    #L(1) :='Enter the name of the job skeleton'
    #L(2) :='to be used when submitting a'
    #L(3) :='condense job.'
    #L(4) :=' '
    #L(5) :='This skeleton must exist in<SYSNOMU>'
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-EXITLIB',
      'NRM-USER-DEFINED-ARCHIVE.M-USERARC-EXITMEM'
    #T    :='Archive User Routine (Optional)'
    #L(1) :='Enter the library and member name of a '
    #L(2) :='Natural subprogram to be used for'
    #L(3) :='accessing the archive data set. If not'
    #L(4) :='specified the data set is handled as a '
    #L(5) :='standard batch workfile.'
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-REVIVE-SKEL'
    #T    :='Revive Job Skeleton (Required)'
    #L(1) :='Enter the name of the job skeleton'
    #L(2) :='to be used when submitting a'
    #L(3) :='revive job.'
    #L(4) :=' '
    #L(5) :='This skeleton must exist in<SYSNOMU>'
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-ARCHIVE-JOBCARDS'
    #T    :='Archive Jobcards (Optional)'
    #L(1) :='Enter up to 3 jobcards to be used for '
    #L(2) :='archive jobs of this type.'
  VALUE 'NRM-USER-DEFINED-ARCHIVE.M-USERARC-REVIVE-JOBCARDS'
    #T    :='Revive Jobcards (Optional)'
    #L(1) :='Enter up to 3 jobcards to be used for '
    #L(2) :='revive jobs of this type.'
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
