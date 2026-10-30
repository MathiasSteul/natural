* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member       EOMPRH-H
* Function     Logical Printer Field Help STUB
* Version      1.3
*
* Maintenance
* UUU YY-MM-DD Sagsis Desciption
* --- -------- ------ --------------------------------------------------
* gw  93-06-17        created
*
* ----------------------------------------------------------------------
DEFINE DATA PARAMETER
*
01  #FIELD-NAME                        (A65)
*
END-DEFINE
*
CALLNAT 'EOMPRH-N' #FIELD-NAME (AD=O)
*
END
