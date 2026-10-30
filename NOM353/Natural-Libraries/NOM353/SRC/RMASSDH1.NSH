* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RMASSDH1
* Function  General help routine for map fields (english)
*           for the map RMASSDM1
* Version   2.1.1
*
* Note: Since NOMALL-2491 RMASSDH1 and related modules are replaced by
* adapted RNMASSH1 (and more)Ü The old modules will be kept for QE with
* *USER NATQA5 (compare NRMCPR). Especailly maps MUST NOT be changed for
* compatibility with a lot of test recordingsÜ
*
* Maintenance
* sju    2000-08-21 p(179982) created
* XSETHZ 2003-10-04 s(202763) confirm deletion of archived reports
* SU1    2021-02-01 NOMALL-2444 Help
* BLI1   2024-02-05 NOMALL-2661 Info about usage of MASSDEL modules
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
    #T    :='Object Name Prefix'
    #L(1) :='All objects of the given type  '
    #L(2) :='whose name begins with this prefix'
    #L(3) :='will be deleted. Do not specify '
    #L(4) :='the wildcard character unless it'
    #L(5) :='forms part of the name. For example'
    #L(6) :='<ABC*> will delete all objects with'
    #L(7) :='names beginning ABC*, not ABC.'
  VALUE 'L-OBJECT-MASK'
    #T    :='Object Name Selection Mask'
    #L(1) :='Delete a subset of objects with '
    #L(2) :='similar names. For example, with'
    #L(3) :='an object name of <ABC-12XX> '
    #L(4) :='and a mask of     <    ??  >'
    #L(5) :='all objects with name ABC-..XX'
    #L(6) :='will be deleted, regardless of'
    #L(7) :='the 5th and 6th characters.'
  VALUE 'L-WILDCARD'
    #T    :='Wildcard Character'
    #L(1) :='Specify a character to be used '
    #L(2) :='as wildcard, instead of *.     '
  VALUE 'L-MASK-CHAR'
    #T    :='Mask Character'
    #L(1) :='Specify a character to be used '
    #L(2) :='as mask character, instead of ?.'
  VALUE 'L-REFRESH-COUNT'
    #T    :='Screen Refresh Count'
    #L(1) :='Enter the number of records to '
    #L(2) :='be deleted between screen writes.'
    #L(3) :='The default is<1000>'
  VALUE 'L-LOG-DELETIONS'
    #T    :='Log deleted objects'
    #L(1) :='Enter<Y>to write a record to the'
    #L(2) :='user log, recording each object'
    #L(3) :='deleted. The default is<N>'
  VALUE 'L-DEL-ARCHIVED'
    #T    :='Delete archived Reports?'
    #L(1) :='Enter <Y> to delete archived Reports'
    #L(3) :='The default is <N>'
  NONE /*invoke function help
    FETCH RETURN 'NRMHELP' 'HMASSDM1'
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
