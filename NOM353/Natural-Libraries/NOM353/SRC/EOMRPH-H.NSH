* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member       EOMRPH-H
* Function     Report Field Help STUB
* Version      1.3
*
* Maintenance
* UUU YY-MM-DD Sagsis Desciption
* --- -------- ------ --------------------------------------------------
* mrs 93-06-09        created
*
* ----------------------------------------------------------------------
DEFINE DATA PARAMETER
*
01  #FIELD-NAME                        (A65)
*
END-DEFINE
*
CALLNAT 'EOMRPH-N' #FIELD-NAME (AD=O)
*
END
