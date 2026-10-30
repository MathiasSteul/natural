* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member       HXXAUS
* Function     Select User
* Version      1.3
*
* Maintenance
* UUU YY-MM-DD Sagsis Desciption
* --- -------- ------ --------------------------------------------------
* gw  93-10-07        created
*
* ----------------------------------------------------------------------
*
DEFINE DATA PARAMETER
*
01  #FIELD-NAME                        (A65)
01  #USER-ID                           (A8)
*
*
END-DEFINE
*
CALLNAT 'RSELUS-N' #USER-ID
*
END
