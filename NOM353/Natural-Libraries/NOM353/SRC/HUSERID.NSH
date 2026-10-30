* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member       HUSERID
* Function     Help for user field in header of maps
* Version      3.2
*
* Maintenance
* UUU YY-MM-DD s(999999) ...
* fhi 07-12-13           created
* SU1     2013-01-31 unused      Deactivate unused data areas
* ----------------------------------------------------------------------
DEFINE DATA /*GLOBAL USING NRM-GL /*SU1 out
LOCAL
01  #T                                 (A32)     /* help window title
END-DEFINE
DEFINE WINDOW HELP TITLE #T
IF *LANGUAGE = 2
  #T := 'Feld ''Benutzer'''
  INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<I>) / 'Benutzer, der bei NOM angemeldet ist'
ELSE
  #T := 'Field ''User'''
  INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<I>) / 'User who is logged on to NOM'
END-IF
*
END
