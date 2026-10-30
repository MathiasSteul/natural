* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* HRSELPR - Select a logical Printer
*
* mrs 91-08-27   completly new (sorted and with read instead of find)
* mrs 92-05-22   s(150306) restrict printer selection
* ----------------------------------------------------------------------
DEFINE DATA GLOBAL USING NRM-GL
PARAMETER
1 #PRINTER             (A8)
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
CALLNAT 'HRSELPRN' #PRINTER G-USERID G-USER-TYPE
*
END
