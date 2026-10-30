* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
/*******************************************************************************
/*  Software AG - Entire Output Management
/*  Group:    Monitor
/*  Module:   RMGTRACP
/*  Template: RMGTRACE
/*
/*  Function:
/** Returns the current trace settings to G-TRACE and G-TRACE-SET */
/*  For printer tasks
/*
/** Last :author fhi
/*
/*******************************************************************************
/*  Maintenance
/*******************************************************************************
/*  User ID   yyyy-mm-dd Issue         Remark
/* -----------------------------------------------------------------------------
/*  fhi       2015-05-06 NOMALL-1585   Rewritten to perform RMGTRACX
/*  fhi       2017-07-20 NOMALL-2011   Add trace entries, rewritten
/************************************* data ************************************
DEFINE DATA
GLOBAL USING PRINT-GL   /* for printer task purposes only.
PARAMETER
1 #TRACING                (L)          OPTIONAL
1 L-TRACE                 (I2)         OPTIONAL
1 L-TRACE-SET             (A200)       OPTIONAL
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
********************************************************************************
DEFINE SUBROUTINE RMGTRACP-GET-SETTINGS
************************************************************************
DECIDE FOR FIRST CONDITION
  WHEN #TRACING SPECIFIED AND L-TRACE SPECIFIED
  AND L-TRACE-SET SPECIFIED                                           /*
    PERFORM RMGTRACX-GET-VALUES G-NATRP-ERC G-NATRP-ERT #TRACING
      L-TRACE L-TRACE-SET
  WHEN #TRACING SPECIFIED AND L-TRACE SPECIFIED
  AND L-TRACE-SET NOT SPECIFIED                                       /*
    PERFORM RMGTRACX-GET-VALUES G-NATRP-ERC G-NATRP-ERT #TRACING
      L-TRACE G-TRACE-SET
  WHEN #TRACING SPECIFIED
  AND L-TRACE NOT SPECIFIED AND L-TRACE-SET NOT SPECIFIED             /*
    PERFORM RMGTRACX-GET-VALUES G-NATRP-ERC G-NATRP-ERT #TRACING
      G-TRACE G-TRACE-SET
  WHEN NONE
    PERFORM RMGTRACX-GET-VALUES G-NATRP-ERC G-NATRP-ERT 1X
      G-TRACE G-TRACE-SET
END-DECIDE
*
END-SUBROUTINE /* RMGTRACP-GET-SETTINGS
*
END
