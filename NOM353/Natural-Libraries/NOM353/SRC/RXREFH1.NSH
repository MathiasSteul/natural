* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RXREFH1
* Function  General help routine for map fields (english)
*           for the map RXREFM11
* Version   2.1.1
*
* Maintenance
* uuu yy-mm-dd s(999999) ...
* sju 00-10-12 p(191368) created
* SU1   2021-02-01 NOMALL-2444 Help
* GGS01 2021-08-05 NOMALL-2453 Update Object Prefix/Name
* ----------------------------------------------------------------------
*
DEFINE DATA
PARAMETER
1 #FIELD-NAME (A65)
************************************************************************
LOCAL
1 #L          (A65/16)  /* help text lines
1 #T          (A32)     /* help window title
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
DECIDE ON FIRST #FIELD-NAME
  VALUE 'L-OBJECT-TYPE'
    #T    :='Objects Using Separator'
    #L(1) :='Specify the type of objects to  '
    #L(2) :='be searched for this Separator. '
    #L(3) :='<R> for Reports. '
    #L(4) :='<B> for Bundles.'
  VALUE 'L-OBJECT-PREFIX'
    #T    :='Object Name'                        /* GGS01 >
    #L(1) :='Used to restrict cross-references'
    #L(2) :='to objects whose name matches this'
    #L(3) :='name. ''*'' or ''?'' are possible.'
    #L(4) :='E.g. <ABC*> for objects names'
    #L(5) :='beginning with ABC.'                /* < GGS01
  VALUE 'L-EXIT-TYPE'
    #T    :='Exit Type'
    #L(1) :='Specify which type of exit is '
    #L(2) :='to be cross-referenced.'
    #L(3) :='<S> for Separation Exits. '
    #L(4) :='<P> for Printer Exits. '
  VALUE 'L-EXIT-LIBRARY'
    #T    :='Library Containing Exit'
    #L(1) :='Specify the library or libraries'
    #L(2) :='to be cross-referenced. For example:'
    #L(3) :='<NOMEXITS> only exits in NOMEXITS.'
    #L(4) :='<NOM*> exits in any library beginning NOM.'
  VALUE 'L-EXIT-MEMBER'
    #T    :='Exit Member Name'
    #L(1) :='Specify the member or members'
    #L(2) :='to be cross-referenced. For example:'
    #L(3) :='<UEX-SEP1> only UEX-SEP1.'
    #L(4) :='<UEX*> all exits beginning UEX.'
  VALUE 'L-SEPARATOR-NAME'
    #T    :='Start or End Separator'
    #L(1) :='Specify the Separator name '
    #L(2) :='to be cross-referenced. For example'
    #L(3) :='<RS-START> only RS-START.'
    #L(4) :='<RS-*> all Separators beginning RS-.'
  VALUE 'L-PRINT-OUTPUT'
    #T    :='Print Results'
    #L(1) :='Enter<Y>to print the results to'
    #L(2) :='Printer 1 or<N>to display the '
    #L(3) :='results on screen.'
  NONE /*invoke function help
    FETCH RETURN 'NRMHELP' 'HXREFM1'
    ESCAPE ROUTINE
/*SU1  VALUE 'RXREFM11'
/*SU1    COMPRESS 'Sorry (' *PROGRAM ')' TO #T LEAVING NO
/*SU1     #L(1):='No Help available for this field.'
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<YEI>)
 / #L(01) / #L(02) / #L(03) / #L(04) / #L(05) / #L(06) / #L(07) / #L(08)
 / #L(09) / #L(10) / #L(11) / #L(12) / #L(13) / #L(14) / #L(15) / #L(16)
*
END
