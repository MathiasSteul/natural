* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRSELUS   USERS SELECTION LIST DISPLAY
*
* MAINTENANCE:
*
* GW  91-07-31  callnat 'rselus-n' which was rewritten to
*               sort by user-id and allow selection by user-id
*
* ----------------------------------------------------------------------
DEFINE DATA
PARAMETER
1 #USERID(A8)
END-DEFINE
*
CALLNAT 'RSELUS-N' #USERID
*
END
