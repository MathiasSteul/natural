* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member       RDEFCMAH
* Function     NOM CMASPOOL Interface Help Stub
* Version      1.3
*
* Maintenance
* UUU YY-MM-DD Sagsis Desciption
* --- -------- ------ --------------------------------------------------
* gw  95-01-03        created
*
* ----------------------------------------------------------------------
DEFINE DATA PARAMETER
*
01  #FIELD-NAME                        (A65)
*
END-DEFINE
*
CALLNAT 'RDEFCMAN' #FIELD-NAME (AD=O)
*
END
