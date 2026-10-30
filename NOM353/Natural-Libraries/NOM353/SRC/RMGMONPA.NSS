* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
/*******************************************************************************
/*  Software AG - Entire Output Management
/*  Group:    Monitor
/*  Module:   RMGMONPA
/*  Template: RMGTRACE
/*
/*  Function:
/** Checks if a given string occurs in JOBCARDS of Monitor Defaults */
/*
/** Last :author fhi
/*
/*******************************************************************************
/*  Maintenance
/*******************************************************************************
/*  User ID   yyyy-mm-dd Issue         Remark
/* -----------------------------------------------------------------------------
/*  fhi       2012-09-03 NOMALL-1195   Created from template RMGTRACE
* fhi     2016-11-15 NOMALL-1961 Use new task IDs
* SU1     2018-05-03 ES-24536    NOM 3.5: avoid NAT0934 (GDA override)
* SU2     2018-10-30 NOMALL-2164 remove RLOG STACK
* SU3     2020-11-10 NOMALL-2440 recat for VMONIT-L
/************************************* data ************************************
DEFINE DATA /*SU1 GLOBAL USING MONIT-GL
PARAMETER
1 #STRING          (A250) BY VALUE       /* IN
1 #FOUND           (L)                   /* OUT
************************************************************************
/*SU3 LOCAL  USING VMONIT-L
LOCAL
1 NRM-MONITOR VIEW OF NRM-MONITOR /*SU3
  2 M-JOBCARD      (A72/1:3)
*
1 #PARAMS          (A250)
1 #SPEC-CHAR-TABLE (A2/16)
  INIT <', ','. ','; ',': ','* ','/ ','( ',
  'Ü ','" ','@ ','$ ','% ','& ','? ','§ ',':='>
1 #MONITOR-ID      (A20) /*SU3
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*                                                                       ********
************************************** sub *************************************
DEFINE SUBROUTINE RMGMONPA-GET-MONPARS
************************************************************************
#MONITOR-ID := F#MONITOR-TASK-ID1 (<>)
FIND-MONIT. FIND NRM-MONITOR WITH M-MONITOR-ID = #MONITOR-ID
  IF NO RECORDS FOUND
    *ERROR-NR := 999 /*SU2
/*SU1 G-NATRP-ERC   := 114
/*SU2 #G-NATRP-ERT   := #G-NATRP-ERC /*SU1
/*SU2 PERFORM XXRLOG-WRITE-LOG 'S' #G-NATRP-ERT /*114 Monitor notDefined
/*SU2    ESCAPE BOTTOM (FIND-MONIT.)
  END-NOREC
  COMPRESS M-JOBCARD (1:3) TO #PARAMS LEAVING NO
  EXAMINE #PARAMS TRANSLATE INTO UPPER
  EXAMINE #PARAMS TRANSLATE USING #SPEC-CHAR-TABLE (*)
  EXAMINE #STRING TRANSLATE INTO UPPER
  IF #PARAMS = SCAN (#STRING)
    #FOUND := TRUE
  ELSE
    #FOUND := FALSE
  END-IF
END-FIND
*
END-SUBROUTINE /* RMGMONPA-GET-MONPARS
*
END
