* >Natural Source Header 000000
* :Mode S
* :CP
* :LineIncrement 10
* <Natural Source Header
* Member    RARCVOH1
* Function  General help routine for map fields (english)
*           for the map RARCVOM1
* Version   3.2
*
* Maintenance
* uuu     yyyy-mm-dd s(999999) ...
* xsetggr 2007-12-06 NRT2884   created
* SU1     2021-04-07 NOMALL-2444 was NOMALL-2314: correct help
* ----------------------------------------------------------------------
*
DEFINE DATA PARAMETER
1  #FIELD-NAME       (A65)
************************************************************************
LOCAL
1 #L                 (A65/16)  /* help text lines
1 #T                 (A32)     /* help window title
*
END-DEFINE
*
************************************************************************
* Main line
************************************************************************
*
DECIDE ON FIRST #FIELD-NAME
  VALUE 'L-ARC'
    #T    :='NOM Archive dsname'
    #L(1) :='Specify the name of archive data'
    #L(2) :='set (old).      '
  VALUE 'L-NEW-VOL'
    #T    :='New volser'
    #L(1) :='Specify the new volume serial  '
  VALUE 'L-LOG'
    #T    :='Log modified reports'
    #L(1) :='Enter<Y>to write a record to the'
    #L(2) :='user log, recording each report'
    #L(3) :='modified. The default is<N>'
  VALUE 'L-REFRESH-COUNT'
    #T    :='Screen Refresh Count'
    #L(1) :='Enter the number of records to '
    #L(2) :='be updated between screen writes.'
    #L(3) :='The default is<1000>'
  VALUE 'L-ET-COUNT'
    #T    :='End Transaction Count'
    #L(1) :='Enter the number of records to '
    #L(2) :='be updated between ET commands.'
    #L(3) :='The default is<30>'
  NONE
    FETCH RETURN 'NRMHELP' 'HARCVOM1'
    ESCAPE ROUTINE
/*SU1  VALUE 'RARCVOM1'
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
