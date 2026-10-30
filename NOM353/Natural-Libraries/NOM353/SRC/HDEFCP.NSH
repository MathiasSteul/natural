* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member       HDEFCP
* Function     Active Help: show defined Default Codepages (8.1.11)
* Version      3.5
*
* Maintenance
* UUU yyyy-mm-dd itrac   ...
* SU  2017-08-03         NOM35 created
************************************************************************
DEFINE DATA
PARAMETER
1 #FIELD-NAME      (A65)
1 CP-NAME          (A) DYNAMIC BY VALUE RESULT /*(A60)
************************************************************************
LOCAL
1 CP-DESC1         (A) DYNAMIC
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
CALLNAT 'N-CP-HLP' 'D' CP-NAME CP-DESC1
*
END
