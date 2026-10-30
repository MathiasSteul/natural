* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    NRMHLP
* Version   1.3
* Function  Help main routine as help routine - used only from NRM
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* mrs 93-06-15           clean up
* wcd 00-04-01 CE 7267   New PFkey for additional printers in RPFK---L
* fhi 02-10-30 fhi101    switch on optimizer compiler
* sju 03-06-04 p(240461) work in development environment
* HH 04-12-09 use callnat NATA1100 instead of SYSTEM-FNAT/SYSTEM-FUSER
* fhi 06-03-29 p(265450) Make help available in test environment
* xsetggr 2008-01-24 NOm32 make as helproutine to work for nrmlog maps
* SU1     2014-12-23 NOMALL-1548 invoke NRMHELP instead identical coding
* ----------------------------------------------------------------------
*
FETCH RETURN 'NRMHELP'
*
END
