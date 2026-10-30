* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member       HDEFNO
* Function     Active Help: show defined Nodes
*              Select all nodes:  HE= 'HDEFNO',=
*              Select unix nodes: HE= 'HDEFNO',=,'U'
* Version      3.5
*
* Maintenance
* UUU yyyy-mm-dd itrac   ...
* SU  2018-01-05         NOM35 created
************************************************************************
DEFINE DATA
PARAMETER
1 #FIELD-NAME      (A65)
1 #NODE-TYPE       (A1) OPTIONAL
1 #NODE-NAME       (A) DYNAMIC BY VALUE RESULT /*(A16)
************************************************************************
LOCAL
1 #NODE-NAME1      (A16)
1 #NODE-TYPE1      (A1)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
IF #NODE-TYPE SPECIFIED
  #NODE-TYPE1 := #NODE-TYPE
END-IF
#NODE-NAME1 := #NODE-NAME
CALLNAT 'HRSELUXN' #NODE-TYPE1 #NODE-NAME1
#NODE-NAME := #NODE-NAME1
*
END
