* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
/*******************************************************************************
/*  Software AG - Entire Output Management
/*  Group:    Monitor
/*  Module:   RMGTRACE
/*  Template:
/*
/*  Function:
/** Returns the current trace settings to G-TRACE and G-TRACE-SET */
/*
/** Last :author fhi
/*
/*******************************************************************************
/*  Maintenance
/*******************************************************************************
/*  User ID   yyyy-mm-dd Issue         Remark
/* -----------------------------------------------------------------------------
/*  fhi       2010-10-20 NOMALL-97     Created.
/*  fhi       2011-06-07 NOMALL-77     Add wrap around buffer
/*  fhi       2011-07-29 NOMALL-1034   Use correct library-id
/* raya       2011-08-28 NOMALL-77     Add wrap around buffer +
/*  fhi       2012-04-23 FHI279        Allow TRACE:VALUE and TRACE=VALUE
/*  fhi       2015-05-06 NOMALL-1585   Allow PROG=xxxxxxxx for one prg
/*                                     Functions moved to RMGTRACX
/*  fhi       2019-08-15 NOMALL-2294   Introduce TRACE-ORDER in jobcards
/*
/************************************* data ************************************
DEFINE DATA
GLOBAL USING MONIT-GL   /* for monitor purposes only.
PARAMETER
1 #TRACING                (L) OPTIONAL
************************************************************************
INDEPENDENT
1 +TRACE-WRAP             (I2)
1 +TRACE-PROG             (A8)    /* NOMALL-1585 fhi in
1 +TRACE-ORDER            (A1)    /* NOMALL-2294 fhi in
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
************************************************************************
DEFINE SUBROUTINE RMGTRACE-GET-SETTINGS
************************************************************************
IF #TRACING SPECIFIED
  PERFORM RMGTRACX-GET-VALUES G-NATRP-ERC G-NATRP-ERT #TRACING
    G-TRACE G-TRACE-SET
ELSE
  PERFORM RMGTRACX-GET-VALUES G-NATRP-ERC G-NATRP-ERT 1X
    G-TRACE G-TRACE-SET
END-IF
*
END-SUBROUTINE /* RMGTRACE-GET-SETTINGS
*
END
