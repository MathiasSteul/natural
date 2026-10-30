* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RNMASSH1 (replaces RMASSDH1)
* Function  General help routine for map fields (english)
*           for the map RNMASSM1
* Version   3.5.2
*
* Maintenance
* sju    2000-08-21 p(179982) created
* XSETHZ 2003-10-04 s(202763) confirm deletion of archived reports
* SU1    2021-02-01 NOMALL-2444 Help
* GGS01  2021-08-05 NOMALL-2491 Update Object Prefix/Name
* BLI1   2024-02-09 NOMALL-2661 Adapt field descriptions and help
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
    #T    :='Mass Delete Object Type'
    #L(1) :='Specify the type of objects to  '
    #L(2) :='be deleted.      '
    #L(3) :='<AB> for Active Bundles. '
    #L(4) :='<AR> for Active Reports.'
    #L(5) :='<BU> for Bundles.'
    #L(6) :='<RP> for Reports.'
  VALUE 'L-OBJECT-PREFIX'
    #T    :='Object Name'                        /* GGS01 >
    #L(1) :='All objects of the given type will'
    #L(2) :='be deleted, whose name matches this'
    #L(3) :='name.'
    #L(4) :='''*'' or ''?'' are possible.'
    #L(5) :='E.g.<ABC*>for objects names'
    #L(6) :='beginning with ABC.'
** VALUE 'L-OBJECT-MASK'    BLI1 deleted
  VALUE 'L-WILDCARD'
    #T    :='Any Number Wildcard'
    #L(1) :='Specify a character to be used '
    #L(2) :='as ''any number wildcard'''
    #L(3) :='(default ''*'').'
  VALUE 'L-MASK-CHAR'
    #T    :='Single Char Wildcard'
    #L(1) :='Specify a character to be used '
    #L(2) :='as ''single character wildcard'''
    #L(3) :='(default ''?'').'                   /* < GGS01
  VALUE 'L-REFRESH-COUNT'
    #T    :='Screen Refresh Count'
    #L(1) :='Enter the number of records to '
    #L(2) :='be deleted between screen writes.'
    #L(3) :='The default is<1000>'
  VALUE 'L-LOG-DELETIONS'
    #T    :='Log deleted objects'
    #L(1) :='Enter<Y>to write a record to the'
    #L(2) :='monitor and user log, recording'
    #L(3) :='each object deleted.'
    #L(4) :='The default is<N>'
  VALUE 'L-DEL-ARCHIVED'
    #T    :='Delete (to be) archived Reports'
    #L(1) :='Enter <Y> to delete also active Reports'
    #L(2) :='to be archived and already archived'
    #L(3) :='active Reports. The default is <N>'
  NONE /*invoke function help
    FETCH RETURN 'NRMHELP' 'HNMASSD1'
    ESCAPE ROUTINE
/*SU1  VALUE 'RMASSDM1'
/*SU1    COMPRESS 'Sorry (' *PROGRAM ')' TO #T LEAVING NO
/*SU1    #L(1):='No Help available for this field.'
*
END-DECIDE
*
DEFINE WINDOW HELP TITLE #T
INPUT WINDOW = 'HELP' (IP=OFF AD=O DY=<YEI>)
 / #L(01) / #L(02) / #L(03) / #L(04) / #L(05) / #L(06) / #L(07) / #L(08)
 / #L(09) / #L(10) / #L(11) / #L(12) / #L(13) / #L(14) / #L(15) / #L(16)
*
END
