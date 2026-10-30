* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member       XXCATAL
* Version      3.4
* Function     Return catalog date and time of calling module
*
* Maintenance
* uuu     yyyy-mm-dd iTrac       Action
* ----------------------------------------------------------------------
* fhi     2014-03-03 NOMALL-1363 Created
DEFINE DATA
PARAMETER
1 #CATDATE                            (A19) BY VALUE RESULT
LOCAL
1 XXNATDIR
  2 P-LIBRARY                         (A8)
  2 P-MODULE                          (A8)
  2 P-LEVEL                           (N2)
  2 P-DIRECTORY
    3 M-SA-DATE                       (A10)
    3 M-SA-TIME                       (A8)
    3 M-SA-TIMESTAMP                  (T)
    3 M-SA-SIZE                       (A6)
    3 M-CA-DATE                       (A10)
    3 M-CA-TIME                       (A8)
    3 M-CA-TIMESTAMP                  (T)
    3 M-CA-BP-SIZE                    (A6)
  2 XXNATDIR-ERC                      (N4)
END-DEFINE
* ----------------------------------------------------------------------
DEFINE SUBROUTINE XXCATAL-GET-CATDATE
CALLNAT 'RGETLIB' P-LIBRARY
PERFORM  XXLSLEVL-GET-LAST-LEVEL P-MODULE
PERFORM XXNATDIR-GETDIR XXNATDIR
COMPRESS
  SUBSTR(M-CA-DATE,1,4) '-'
  SUBSTR(M-CA-DATE,6,2) '-'
  SUBSTR(M-CA-DATE,9,2) '-'
  M-CA-TIME
  TO #CATDATE LEAVING NO
END-SUBROUTINE
END
