* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
/****************************************************************************
/* This Modul is used for DATAAREA Processing
/* it depends of the NATURAL Version !!!
/****************************************************************************
define data
global using anamod0g
parameter using anadataa
LOCAL USING USR-MSG   /* Data for message exchange
LOCAL USING USR-FLD   /* Description of the field in error
local using anastepa
local using anavar1p
LOCAL
1 AMOUNT (i4) const <255> /* number of returning lines with one callnat
1 USR1057L
  2 OBJECT-KEY
    3 LIBRARY        (A08)
    3 OBJECT-NAME    (A32)
    3 OBJECT-TYPE    (A02)
    3 OPT-ACCESS     (A01)
    3 OPT-UNUSED-1   (L)
    3 OPT-UNUSED-2   (A01)
    3 OPT-LINE-NUM   (A01)
    3 OPT-UNUSED-3   (L)
    3 OPT-REDEF-DIR  (L)
    3 OPT-UNUSED-4   (A01)
    3 OPT-AMOUNT     (I02)
    3 OPT-LINESIZE   (I02)
/*
  2 INPUT-OUTPUTS
    3 INT-HANDLE     (I04)
    3 NEXT-SEQ       (I04)
    3 NEXT-NUM       (I02)
/*
  2 OUTPUTS
    3 RETURNED       (I02)
    3 SRC-NUM        (I02/1:amount)
    3 SRC-TEXT       (A01/1:amount,1:93)
    3 REDEFINE SRC-TEXT
      4 SRC-GROUP    (1:amount)
        5 SRC-LINE   (A93)
        5 REDEFINE SRC-LINE
          6 SRC-LINE-ARRAY (A1/1:93)
/* following redefine depends on NATURAL Version
        5 REDEFINE SRC-LINE
          6 SRC-LINE-KIND (a1)
          6 src-line-type (a2)
          6 filler 4x
          6 src-init-type (a1)
        5 REDEFINE SRC-LINE
          6 filler 18x
          6 src-format1 (a5)
          6 level-format1 (a2)
          6 var-format1 (a32)
        5 REDEFINE SRC-LINE
          6 filler 24x
          6 src-format2 (a11)
          6 level-format2 (a3)
          6 var-format2 (a32)
    3 REDEFINE SRC-TEXT
      4 DIR-OBJNAME      (A32)    /* Object Name
      4 DIR-LIBRARY      (A08)    /* Library ID
      4 DIR-OBJTYPE      (A02)    /* Object Type
      4 DIR-OBJKIND      (A01)    /* Source or Module
      4 DIR-DBID         (A05)    /* DBID of System File
      4 DIR-FNR          (A05)    /* FNR of System File
      4 DIR-DATN         (A08)    /* Date in Format (YYYYMMDD)
      4 DIR-TIMN         (A07)    /* Time in Format (HHIISST)
      4 DIR-USERID       (A08)    /* User ID
      4 DIR-PROGMODE     (A01)    /* Programming Mode
      4 DIR-SRCSIZE      (A10)    /* Source Area Size
      4 DIR-GPSIZE       (A10)    /* Size of Module
      4 DIR-UNIQUE-ID    (A32)    /* Unique ID
      4 DIR-DDM-DBID     (A05)    /* DBID the DDM is cataloged with
      4 DIR-DDM-FNR      (A05)    /* FNR the DDM is cataloged with
      4 DIR-NATVERS      (A04)    /* NATURAL Version
      4 DIR-NATSM        (A02)    /* NATURAL SM Level
      4 DIR-INIT-USER    (A08)    /* Init User ID
      4 DIR-TID          (A08)    /* Terminal ID
      4 DIR-TRANS-NAME   (A08)    /* TP Transcation Name
      4 DIR-OPSYS        (A08)    /* Operating System
      4 DIR-TPSYS        (A08)    /* TP System
      4 DIR-USED-GDA     (A08)    /* Used GDA
/* End of directory attributes
    3 SRC-SEQ        (I04/1:amount)
    3 SRC-LONG       (A01/1:amount)
/*
1 USR1057N
  2 VERSION          (I01)     INIT <2>
  2 V1-NSC-CKECK     (A01)
  2 V2-DBID          (N05)
  2 V2-FNR           (N04)
  2 V2-PSW           (A08)
  2 V2-CIP           (N08)
  2 V2-SYSFILE       (A01)
1 REDEFINE USR1057N
  2 EXTENDED-PARMS
    3 EXTENDED-DATA  (A01/1:28)
1 usr2011l
  2 inputs
    3 function (a1) init <'S'>
    3 work-num (i1) init <5>
  2 input-outputs
    3 work-file (a253)
    3 work-type (a1) init <'D'>
  2 outputs
    3 max-num (i1)
    3 response (i4)
*
1 #i3 (i4)
1 #i4 (i4)
1 #i5 (i4)
1 #i6 (i4)
1 i (i2)
1 #var (a50)
1 #numeric (l)
1 #found (l)
1 #varlen (i4)
1 #varpos (i4)
1 #natsrckind (i4)
1 #i (i4)
1 #structure (a50)
1 #text (a93)
1 #init (a50)
1 #init2 (a50)
1 #viewmode (l) init <false>
1 #viewname (a50)
1 #viewlevel (i2) init <0>
1 #init-toggle (a1)
1 #lineout (a5)
1 #line2out (a5)
1 workbuf (a100)
end-define
/*
define subroutine anadatas
OPT-LINE-NUM  := 'Y'
OPT-REDEF-DIR := TRUE
OPT-AMOUNT    := amount
OPT-LINESIZE  := 93
LIBRARY       := #library
OBJECT-NAME   := #dataobject
reset #isnumeric #varsfound
/*
OPT-ACCESS   := 'O' /* Open Source
CALLNAT 'USR1057N' USR1057L  USR1057N.EXTENDED-PARMS
  NAD-MSG   NAD-FLD
/*
reset #found anavar1s-parm-area
#redef := false
/*
if nad-msg.msg-nr ne 0 and nad-msg.msg-nr ne 100 /* End of data
   write work 31 variable #dataobject nad-msg.msg-nr nad-msg.msg
/* in Library not found look at steplibs
  callnat 'ANASTEPN' #anastep
  for #i = 1 to #anastep.#count
    LIBRARY  := #anastep.#steplib(#i)
    OPT-ACCESS   := 'O' /* Open Source
    CALLNAT 'USR1057N' USR1057L  USR1057N.EXTENDED-PARMS
      NAD-MSG   NAD-FLD
    if nad-msg.msg-nr = 0
/* object found
      #found := true
      #library := LIBRARY
      escape bottom
    end-if
  end-for
  if not #found

    escape routine
  end-if
end-if
/*
OPT-ACCESS := 'R' /* Read Source
/*
MAIN. REPEAT
/*
  CALLNAT 'USR1057N' USR1057L  USR1057N.EXTENDED-PARMS
    NAD-MSG   NAD-FLD
/*
  IF RETURNED = 0
/* end of source reached -> stop
    escape bottom
  end-if
/*

  FOR #i3 = 1 TO RETURNED
/* loop thru source lines

    perform delete-remarks
    examine src-line(#i3) translate into upper




    if src-line(#i3) = ' ' or src-line(#i3) = 'DEFINE DATA'
      escape top
    end-if

/* Lines has no Remarks
    decide on first value of #natsrckind
      value 1
        #format := src-format1(#i3)
        #level := level-format1(#i3)
        #variable := var-format1(#i3)
      value 2
        #format := src-format2(#i3)
        #level := level-format2(#i3)
        #variable := var-format2(#i3)
      none value
        ignore
    end-decide

    if #format <> ' '
      compress '(' #format ')' into #format leaving no
    end-if
    examine #format for ' ' delete
    examine #level for ' ' delete


/* View

    if #level = scan 'V'
      #viewmode := true
      #viewname := #variable
      examine #level for 'V' delete
*      escape top
    end-if
/*    if #viewmode = false
/*      escape top
/*    end-if
/* Group

    if #level = scan 'G'
      examine #level for 'G' delete
      if val(#level) = 1 and #viewmode
        #viewmode := false
        #viewname := ' '
        escape top
      end-if
    end-if

/* Redefinition

    if #level = scan 'R' then
      #format := 'R'
      examine #level for 'R' delete
    end-if

/* Multiple field definitions

    if #level = scan 'M' then
       examine #level for 'M' delete
    end-if

/* Periodical field definitions

    if #level = scan 'P' then
       examine #level for 'P' delete
    end-if

    if not #level is (n9)
       escape top
    end-if

    if #level is (n9) and val(#level) <= #viewlevel
      #viewmode := false
      #viewname := ' '
      #viewlevel := 0
    end-if

    if src-init-type(#i3) = 'F' or = 'S'
/* examine Init Values
      #init-toggle := src-init-type(#i3)
      reset #init
      #i5 := #i3 +1
      for #i4 = #i5 to RETURNED
        if src-line-type(#i4) = '*I'
          decide on first value of src-line-kind(#i4)
            value '*' /* old Format
              #init2 := var-format1(#i4)
            value '/' /* new Format
              #init2 := var-format2(#i4)
            any value
              examine #init2 translate into upper
            none value
              ignore
          end-decide
/*
          if #init-toggle = 'F'
            compress #init #init2 into #init
          end-if
/*
          if #init-toggle = 'S'
            compress #init 'INIT<' #init2 '>' into #init
          end-if
        end-if
        if src-line-type(#i4) = '*D'
/* new Variable
          escape bottom
        end-if
      end-for
    end-if
/*
    compress #level #variable #format #init into #text
    reset #init
    move OBJECT-NAME to #objmodul
    move #anadata.#lineno to #lineno1
    move #i3 to #lineno2
    perform Anavar1s anavar1s-parm-area
  END-FOR
/*
END-REPEAT
/*
define subroutine delete-remarks
/* delete all remarks from source-line
/* delete whole source-line if it contains remarks only
/* write src-line(#i3) (al=40)
if src-line-type(#i3) <> '*D'  /* depends on NATURAL Version
/* no variable Definition
  reset SRC-LINE(#i3)
  escape routine
else
  decide on first value of src-line-kind(#i3)
    value '*' /* depends on NATURAL Version
      #natsrckind := 1
    value '/' /* depends on NATURAL Version
      #natsrckind := 2
    none value
      reset #natsrckind
  end-decide
  reset src-line-type(#i3) reset src-line-kind(#i3)
end-if
examine src-line(#i3) for '*' giving position #i4
if #i4 <> 0
  reset SRC-LINE-ARRAY(#i3,#i4:93)
  escape routine
end-if
examine src-line(#i3) for '/*' giving position #i4
if #i4 <> 0
  reset SRC-LINE-ARRAY(#i3,#i4:93)
end-if
end-subroutine
/*
*
end-subroutine
end
