* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* RMLOGDEL - Subroutine to log online deleted records                              >
* Logs an online deletion in logfile and in job output. NOM error 75 is
* created. The log contains the user id that initiated the deletion.
*
* Maintenance
* uuuuuuuu yyyy-mm-dd Issue
* fhi      2011-05-02 NOMALL-901  Created
* fhi      2011-09-01 NOMALL-901  Too many logs, reduced to online users
* fhi      2011-09-06 NOMALL-901  Too many logs, reduced to online users
* xsetggr 2011-09-12 NOMALL-1058  Log delete from NOM API online users
* fhi      2011-09-14 NOMALL-901  Add reasonable parameters
* fhi      2016-04-15 NOMALL-1837 Introduce +DEVICE for testing
* fhi      2016-11-14 NOMALL-1961 Duplicate monitor copy task
* BLI      2020-01-24 NOMALL-2337 Show logs from user TASKnn
* ----------------------------------------------------------------------
DEFINE DATA
GLOBAL USING NRM-GL
PARAMETER
1 #OBJECT-NAME         (A100) BY VALUE
1 #OBJECT-TYPE         (A16)  BY VALUE
1 #USER                (A8)   BY VALUE OPTIONAL
1 #APPL                (A8)   BY VALUE OPTIONAL
************************************************************************
INDEPENDENT
1 +DEVICE              (A8)
************************************************************************
LOCAL
1 #TRACE-MSG           (A250)
1 #P-USER              (A8)
1 #P-APPL              (A8)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE RMLOGDEL
************************************************************************
IF #USER SPECIFIED
  #P-USER := #USER
ELSE
  #P-USER := G-USERID
END-IF
IF #P-USER = "MAIN" OR +DEVICE = 'BATCH'  /* NOMALL-1837 +DEVICE
**  OR #P-USER = MASK ('NOM'NN) /* BLI NOMALL-2337 out, below in
OR #P-USER = MASK('TASK'NN)                                           /*
OR #OBJECT-TYPE = 'MAIL' /* don't log dependent obj types             /*
OR='RP-CONTENTS' OR='GRANT' OR='REPORT-LAYOUT' OR='BUNDLE-CONTENTS'   /*
OR='BUNDLE-REPORT' OR='TEXT'                                          /*
  ESCAPE ROUTINE /* don't log anything, no online user
END-IF
COMPRESS '75' #OBJECT-NAME #OBJECT-TYPE TO #TRACE-MSG
IF #APPL SPECIFIED
  #P-APPL := #APPL
  PERFORM XXRLOG-WRITE-LOG 'W' #TRACE-MSG #P-USER #P-APPL
ELSE
  PERFORM XXRLOG-WRITE-LOG 'W' #TRACE-MSG #P-USER
END-IF
*
END-SUBROUTINE /* RMLOGDEL
*
END
