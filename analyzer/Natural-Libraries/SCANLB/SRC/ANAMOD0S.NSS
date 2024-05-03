* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
**************************************************
* 10.8.2011 -> change because error by incore
*              reset whole line after found incore
**************************************************
define data global using anamod0g
local using anadataa
local using findoba
local
1 #i (i4)
1 #i1 (i4)
1 #i2 (i4)
1 #i3 (i4)
1 #i4 (i4)
1 #i5 (i4)
1 #i6 (i4)
1 #i7 (i4)
1 #i8 (i4)
1 #pos-nat(i4)
1 #nat (a94)
1 redefine #nat
  2 #nat-array(a1/1:94)
1 #natline (a94)
1 redefine #natline
  2 #natline-array(a1/1:94)
1 #StringOpen (l)
1 #Found (l)
1 #flip (l)
1 #numeric (l)
1 #END-DEFINE-POS (i4)
1 #BEGIN-DEFINE-POS (i4)
1 #da (a8)
1 #op-b (i4)
1 #op-e (i4)
1 #before (a50)
1 redefine #before
  2 #before-array (a1/1:50)
1 #after (a50)
1 redefine #after
  2 #after-array (a1/1:50)
1 #afteronly (l)
1 #viewonly (l)
1 #temp (a93)
1 #lineout (a5)
end-define
define subroutine ANAMOD0S
/* found Position of first Statments -> Line after END-DEFINE
examine text(*) for 'END-DEFINE' with delimiters ' ' giving index #END-DEFINE-POS
/*
if #END-DEFINE-POS = 0
/* no END-DEFINE -> no DEFINE DATA
  #END-DEFINE-POS := 1
  #BEGIN-DEFINE-POS := 0
else
  #BEGIN-DEFINE-POS := 1
  /* examine variables and build table for numeric variables
  perform ANAVAR0S #BEGIN-DEFINE-POS #END-DEFINE-POS
end-if
/*
/*
for #i = #END-DEFINE-POS to maxlines
/* Examine for special Statements
  move edited lineno(#i) (em=99999) to #lineout
  #nat := text(#i)
  #natline := #nat
  perform remove-not-nat
  #natline := #nat
/* INCORE DB
  examine #natline pattern 'IDENTIFIER*=' giving position #i1
  if #i1 = 0
    examine #natline pattern 'CALLNAT*INCORE' giving position #i1
    if #i1 = 0
      examine #natline pattern 'CALLNAT*CONTAINER' giving position #i1
      if #i1 = 0
        examine #natline pattern 'OUTPUT*''INCORE''' giving position #i1
      end-if
    end-if
  end-if
  if #i1 <> 0
    #i3 := 93-#i1
    if not unixonly
      compress 'INC' #lineout substr (text(#i),1,#i3) into COMMENT
      add 1 to COUNTINCORE
      perform anaouts#
    end-if
*   reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
    reset #natline-array(1:93)   reset textarray(#i,1:93) /* CORINC
  end-if
/* CALLNAT without Subprogram -> Find CALLNAT to Subprogram not given
/* CALLNAT with Variable -> Find CALLNAT with Subprogram as Variable
  examine #natline for 'CALLNAT' giving position #i1
  if #i1 <> 0
    #i3 := 93-#i1
    compress substr (text(#i),1,#i3) into #nat
    examine #nat for 'CALLNAT' delete first
    separate #nat into #temp #nat ignore with delimiters ' '
    if #nat <> ' '
      if #nat-array(1) = '''' or = '"'
        #p-lib := ' '
        examine #nat for '''' delete
        examine #nat for '"' delete
        #p-object := #nat
        #p-lib := OBJLIBRARY
        callnat 'findobn' #p-findob
        if not #p-found
          if not unixonly
            compress 'CWO' #lineout substr (text(#i),1,#i3) into COMMENT
            add 1 to COUNTCWO
            perform anaouts
          end-if
          reset #natline-array(1:93)   reset textarray(#i,1:93)
        end-if
      else
        if not unixonly
          compress 'CWV' #lineout substr (text(#i),1,#i3) into COMMENT
          add 1 to COUNTCWV
          perform anaouts
        end-if
        reset #natline-array(1:93)   reset textarray(#i,1:93)
      end-if
    end-if
  end-if
/* CALL
  examine #natline for 'CALL' with delimiters ' ' giving number #i1
  if #i1 <> 0
    for #i2 = 1 to #i1
      examine direction backward #natline for 'CALL' with delimiters ' ' giving position #i3
      #i4 := #i3+5
      #i5 := 93 -#i4
      compress 'CAL' #lineout 'CALL' substr(text(#i),#i4,#i5) into COMMENT
      add 1 to COUNTCALL
      perform anaouts
      reset #natline-array(#i3:93) reset textarray(#i,#i3:93)
    end-for
  end-if
/* WORKFILE
  examine #natline for 'READ WORK' with delimiters ' ' giving position #i1
  if #i1 = 0
    examine #natline for 'WRITE WORK' with delimiters ' ' giving position #i1
  end-if
  if #i1 = 0
    examine #natline for 'DEFINE WORK' with delimiters ' ' giving position #i1
  end-if
  if #i1 = 0
    examine #natline for 'CLOSE WORK' with delimiters ' ' giving position #i1
  end-if
/*
  if #i1 <> 0
    #i3 := 93-#i1
    compress 'WRK' #lineout substr (text(#i),#i1,#i3) into COMMENT
    add 1 to COUNTWORK
    perform anaouts
    reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
  end-if
/* DOWNLOAD / UPLOAD PC
  examine #natline for 'DOWNLOAD PC' with delimiters ' ' giving position #i1
  if #i1 = 0
    examine #natline for 'UPLOAD PC' with delimiters ' ' giving position #i1
  end-if
/*
  if #i1 <> 0
    #i3 := 93-#i1
    compress 'CPD' #lineout substr (text(#i),#i1,#i3) into COMMENT
    add 1 to COUNTPC
    perform anaouts
    reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
  end-if
/* FIND THRU or IF THRU or READ THRU
  examine #natline for 'THRU' with delimiters ' ' giving position #i1
  if #i1 <> 0
    #pos-nat := #i1
    reset #afteronly
/* OP = THRU
    #op-b := #i1
    #op-e := #i1 +3
    perform before-after-evaluation
    if not (#before = ' ' or = '*' and #after = ' ' or = '*')
/* IF
      examine #natline for 'IF' with delimiters ' ' giving position #i2
      if #i2 <> 0 and #i2 < #i1
/* IF before THRU -> IF THRU
        #i3 := 93-#i2
        if not unixonly
          compress 'IFR' #lineout substr (text(#i),#i2,#i3) into COMMENT
          add 1 to COUNTIF
          perform anaouts
        end-if
        reset #natline-array(#i2:93) reset textarray(#i,#i2:93)
        escape top
      end-if
/* FIND
      examine #natline for 'FIND' with delimiters ' ' giving position #i2
      if #i2 <> 0 and #i2 < #i1
/* FIND before THRU -> FIND THRU
        #i3 := 93-#i2
        if not unixonly
          compress 'DBA' #lineout substr (text(#i),#i2,#i3) into COMMENT
          add 1 to COUNTDB
          perform anaouts
        end-if
        reset #natline-array(#i2:93) reset textarray(#i,#i2:93)
        escape top
      end-if
/* READ, BROSWE
      examine #natline for 'READ' with delimiters ' ' giving position #i2
      if #i2 = 0
        examine #natline for 'BROWSE' with delimiters ' ' giving position #i2
      end-if
      if #i2 <> 0 and #i2 < #i1
/* READ before THRU -> READ THRU
        #i3 := 93-#i2
        if not unixonly
          compress 'DBA' #lineout substr (text(#i),#i2,#i3) into COMMENT
          add 1 to COUNTDB
          perform anaouts
        end-if
        reset #natline-array(#i2:93) reset textarray(#i,#i2:93)
        escape top
      end-if
/* unkown THRU
      #i3 := 93-#i1
      if not unixonly
        compress '???' #lineout text(#i) into COMMENT
        add 1 to COUNTASK
        perform anaouts
      end-if
      escape top
    end-if
  end-if
/* READ, BROWSE
  examine #natline for 'READ' with delimiters ' ' giving position #i1
  if #i1 = 0
    examine #natline for 'BROWSE' with delimiters ' ' giving position #i1
  end-if
  if #i1 <> 0
    examine direction backward #natline for 'BY ISN' with delimiters ' ' giving position #i2
    if #i2 <> 0
/* by isn -> no problem
      escape top
    end-if
    examine direction backward #natline for 'PHYSICAL' with delimiters ' ' giving position #i2
    if #i2 <> 0
/* physical -> no problem
      escape top
    end-if
    examine direction backward #natline for 'BY' with delimiters ' ' giving position #i2
    if #i2 = 0
      examine direction backward #natline for 'WITH' with delimiters ' ' giving position #i2
/* OP = WITH
      #op-b := #i2
      #op-e := #i2 +3
    else
/* OP = BY
      #op-b := #i2
      #op-e := #i2 +1
    end-if
/* FIND BY/WITH <DESC>
    if #i2 <> 0
/* find with, find by
      #pos-nat := #i2
      #afteronly := true
      #viewonly := true
      perform before-after-evaluation
      if not #after = '*'
        #i3 := 93-#i1
        if not unixonly
          if #after = ' '
            compress '???' #lineout substr (text(#i),#i1,#i3) into COMMENT
          else
            compress 'DBA' #lineout substr (text(#i),#i1,#i3) into COMMENT
          end-if
          add 1 to COUNTDB
          perform anaouts
        end-if
        reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
      end-if
    else
      #i3 := 93-#i1
      if not unixonly
        compress 'DBA' #lineout substr (text(#i),#i1,#i3) into COMMENT
        add 1 to COUNTDB
        perform anaouts
      end-if
      reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
    end-if
    escape top
  end-if
/* HISTOGRAM
  examine #natline for 'HISTOGRAM' with delimiters ' ' giving position #i1
  if #i1 <> 0
/* is view-variable used from module in histogram statement
*    reset #found
*    for #i2 = 1 to VARCOUNT
*      if VIEW(VARCOUNT) = 'V'
/* only view
*        examine #natline for VARNAME(VARCOUNT) with delimiters ' ' giving position #i3
*        if #i3= 0
*          examine #natline for FVARNAME(VARCOUNT) with delimiters ' ' giving position #i3
*        end-if
*        if #i3 <> 0
/* field is in table -> is numeric
*          #found := true
*          escape bottom
*        end-if
*      end-if
*    end-for
*    if not #found
/* field not numeric
    #i3 := 93-#i1
    if not unixonly
      compress 'DBA' #lineout substr (text(#i),#i1,#i3) into COMMENT
      add 1 to COUNTDB
      perform anaouts
    end-if
    reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
*    end-if
    escape top
  end-if
/* Hex-Values
  examine text(#i) pattern 'H''*''' with delimiters ' ' giving position #i1
  if #i1 = 0
    examine text(#i) pattern '=H''*''' giving position #i1
  end-if
  if #i1 <> 0
    reset #temp
    for #i6 = #i1 to 93
      compress #temp textarray(#i,#i6) into #temp leaving no
    end-for
    examine #temp pattern 'H''FF''' giving position #i6
    examine #temp pattern 'H''00''' giving position #i7
    if #i6 = 0 and #i7 = 0
      #i3 := 93-#i1
      compress 'HEX' #lineout text(#i) into COMMENT
      add 1 to COUNTHEX
      perform anaouts
      reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
    end-if
  end-if
/* Printer
  examine #natline pattern 'DEFINE PRINTER*(*)' giving position #i1
  if #i1 = 0
    examine #natline pattern 'WRITE*(*)' giving position #i1
  end-if
  if #i1 = 0
    examine #natline pattern 'DISPLAY*(*)' giving position #i1
  end-if
  if #i1 = 0
    examine #natline pattern 'PRINT*(*)' giving position #i1
  end-if
  if #i1 <> 0
    reset #found #temp
    f3. for #i3 = #i1 to 93
      compress #temp #natline-array(#i3) into #temp leaving no
      if #temp = 'DEFINEPRINTER' or = 'WRITE' or = 'DISPLAY' or = 'PRINT'
        add 1 to #i3
        for #i4 = #i3 to 93
          if #natline-array(#i4) <> ' '
            if #natline-array(#i4) = '('
              #found := true
              /* perform isReport /* #found = true if reportelse #found = false
/* Begin of Report Assignment
            end-if
            escape bottom (f3.)
          end-if
        end-for
      end-if
    end-for
    if #found
      #i3 := 93-#i1
      compress 'PRT' #lineout text(#i) into COMMENT
      add 1 to COUNTPRT
      perform anaouts
      reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
    end-if
  end-if
/* Find SORTED
  examine #natline for 'SORTED' with delimiters ' ' giving position #i1
  if #i1 <> 0
    #i3 := 93-#i1
    if not unixonly
      compress 'DBA' #lineout text(#i) into COMMENT
      add 1 to COUNTDB
      perform anaouts
    end-if
    reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
  end-if
/* NATURAL Sort
  examine #natline for 'SORT' with delimiters ' ' giving position #i1
  if #i1 <> 0
    #i3 := 93-#i1
    if not unixonly
      compress 'SOR' #lineout text(#i) into COMMENT
      add 1 to COUNTSORT
      perform anaouts
    end-if
    reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
  end-if
/* NATURAL Process
  examine #natline for 'PROCESS' with delimiters ' ' giving position #i1
/*
  if #i1 <> 0
    #i3 := 93-#i1
    if not unixonly
      compress 'PRO' #lineout substr (text(#i),#i1,#i3) into COMMENT
      add 1 to COUNTPROCESS
      perform anaouts
    end-if
    reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
  end-if
/* MASK(JJJ)
  examine #natline pattern 'MASK*(JJJ)' giving position #i1
/*
  if #i1 <> 0
    #i3 := 93-#i1
    if not unixonly
      compress 'JUL' #lineout substr (text(#i),#i1,#i3) into COMMENT
      add 1 to COUNTJULIAN
      perform anaouts
    end-if
    reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
  end-if
/* *ISN
  examine #natline for '*ISN' with delimiters ' ' giving position #i1
/*
  if #i1 <> 0
    #i3 := 93-#i1
    if not unixonly
      compress 'ISN' #lineout substr (text(#i),#i1,#i3) into COMMENT
      add 1 to COUNTISN
      perform anaouts
    end-if
    reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
  end-if
/* Logical Ranges
  examine #natline for 'LE' with delimiters ' ' giving position #i1
  if #i1 = 0
    examine #natline for 'GE' with delimiters ' ' giving position #i1
  end-if
  if #i1 = 0
    examine #natline for 'LT' with delimiters ' ' giving position #i1
  end-if
  if #i1 = 0
    examine #natline for 'GT' with delimiters ' ' giving position #i1
  end-if
  if #i1 = 0
    examine #natline for '>' position #i1
    if #i1 <> 0
      if #i1 > 1 and (#natline-array(#i1 -1) = '<' or #natline = scan 'DY=') /* dynamic input parameter
        #i1 := 0
      else
        perform InString
        if #i1 <> 0
          if #natline-array(#i1 +1) = '='
/* OP = <=
            #op-b := #i1
            #op-e := #i1 +1
          else
/* OP = <
            #op-b := #i1
            #op-e := #i1
          end-if
        end-if
      end-if
      if #i1 <> 0
        examine #natline for 'INDEXED' with delimiters ' ' giving position #i2
        if #i2 <> 0
/* with MOVE INDEX in Report Mode <> will be used as Index
          #i1 := 0
        end-if
      end-if
    end-if
  else
/* OP = LE, GE, LT or GT
    #op-b := #i1
    #op-e := #i1 +1
  end-if
  if #i1 = 0
    examine #natline for '<' position #i1
    if #i1 <> 0
      if #i1 < 93 and (#natline-array(#i1 +1) = '>' or #natline = scan 'DY=') /* dynamic input parameter
        #i1 := 0
      else
        perform InString
        if #i1 <> 0
          if #natline-array(#i1 +1) = '='
/* OP = >=
            #op-b := #i1
            #op-e := #i1 +1
          else
/* OP = >
            #op-b := #i1
            #op-e := #i1
          end-if
        end-if
      end-if
      if #i1 <> 0
        examine #natline for 'INDEXED' with delimiters ' ' giving position #i2
        if #i2 <> 0
/* with MOVE INDEX in Report Mode <> will be used as Index
          #i1 := 0
        end-if
      end-if
    end-if
  end-if
  if #i1 <> 0
    examine #natline for 'INDEXED' with delimiters giving position #i2
    #pos-nat := #i1
    reset #afteronly
    perform before-after-evaluation
    if not (#before = '*' and #after = '*')
      #i3 := 93-#i1
      if not unixonly
        compress 'IFR' #lineout text(#i) into COMMENT
        add 1 to COUNTIF
        perform anaouts
      end-if
      reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
    end-if
  end-if
  /*
  /* REDEFINE in Reportmode Modulen
  /*
  if objprogmode = 'R'
    /*
    examine #natline pattern 'REDEFINE' giving position #i1
/*
    if #i1 <> 0
      #i3 := 93-#i1
      if not unixonly
        compress 'RER' #lineout substr (text(#i),#i1,#i3) into COMMENT
        add 1 to COUNTRER
        perform anaouts
      end-if
      reset #natline-array(#i1:93) reset textarray(#i,#i1:93)
    end-if
    /*
  end-if /* if objprogmode = 'R'
  /*
end-for
/*
**for #i = #BEGIN-DEFINE-POS to #END-DEFINE-POS
**   /* Loop variables
**end-for
/*
define subroutine remove-not-nat
/* remove not Natural Statements from line
/* Search for Strings
examine #nat for '"' replace with ''''
examine #nat for '''' giving position in #i6 /* first
examine direction backward #nat for '''' giving position in #i7 /* last
if #i6 <> 0 and #i6 <> #i7 then
  reset #StringOpen
/* Line contain Strings -> eliminate all String Values
  for #i8 = #i6 to #i7
    if #nat-array(#i8) = ''''
/* String Open/Close found
      reset #nat-array(#i8)
      if not #StringOpen
        #StringOpen := true
      else
        reset #StringOpen
      end-if
    else
      if #StringOpen
        reset #nat-array(#i8)
      end-if
    end-if
  end-for
end-if
end-subroutine
/*
define subroutine before-after-evaluation
/* get Token before and after act. NAT-Statement (#pos-nat) if both Tokens are Strings
/* AFTER
reset #after #found
#nat := text(#i)
** examine #nat for '(' delete
** examine #nat for ')'  delete
/*
if #op-e <> 0
  #i4 := #op-e +1
  reset #found
  for #i5 = #i4 to 93
/* loop from start position of after token to end of line
    if #nat-array(#i5) = ' ' or = ')'
      if #found
        escape bottom
      end-if
    else
      #found := true
      compress #after #nat-array(#i5) into #after leaving no
    end-if
  end-for
/* eliminate Array Indexes
  examine #after for '(' giving position #i4
  if #i4 <> 0
    reset #after-array(#i4:50)
  end-if
else
/* no after token found
  escape routine
end-if
/* BEFORE
reset #found #before
if not #afteronly
  if #op-b <> 0
    #i4 := #op-b -1
    reset #found
    for #i5 = #i4 to 1 step -1
/* loop from start position of before token to start of line
      if #nat-array(#i5) = ' '
        if #found
          escape bottom
        end-if
      else
        #found := true
        compress #nat-array(#i5) #before into #before leaving no
      end-if
    end-for
/* eliminate Array Indexes
    examine #before for '(' giving position #i4
    if #i4 <> 0
      reset #before-array(#i4:50)
    end-if
  else
/* no before token found
    escape routine
  end-if
end-if
if (#before is (n15) or #after is (n15)) or
    (#before = '''A''' thru '''Z''' and #after = '''A''' thru '''Z''') or
    (#before = '''0''' thru '''9''' and #after = '''0''' thru '''9''')
/* Numeric or no Problem -> ignore
  #before := '*'
  #after := '*'
  escape routine
end-if

if #before = mask('''') or #before = mask('"') or
    #after = mask('''') or #after = mask('"')
  if #after = '''' or #before = ''''
    /* literal is empty string
    #after := '*'
    #before := '*'
  end-if
/* one of before or after is string
  escape routine
end-if
/*
#nat := #after
perform is-numeric
if #numeric
  #before := '*'
  #after := '*'
else
  if not #afteronly
    #nat := #before
    perform is-numeric
    if #numeric
      #before := '*'
      #after := '*'
    end-if
  end-if
end-if
/*
end-subroutine
/*
define subroutine is-numeric
* Check of Nat Variable is Numeric
reset #numeric
if VARCOUNT = 0
/* no variables found
  escape routine
end-if
if not #viewonly
  if #nat = '.'
    examine FVARNAME(1:VARCOUNT) for #nat with delimiters ' ' giving index #i4
  else
    examine VARNAME(1:VARCOUNT) for #nat with delimiters ' ' giving index #i4
  end-if
else
/* only view fields
  reset #viewonly
  if #nat = scan '.'
    examine FVARNAME(1:VARCOUNT) for #nat with delimiters ' ' giving index #i4
  else
/* search with View Flag
    compress 'V' #nat into #nat leaving no
    examine VIEWVARNAME(1:VARCOUNT) for #nat with delimiters ' ' giving index #i4
  end-if
end-if
if #i4 <> 0
  #numeric := true
end-if
end-subroutine
/*
define subroutine InString
/* Check If Position on #I1 is in String Text
if not #natline = scan ''''
/* no String in this Line
  escape routine
end-if
/* look for number of ' Signes before Position
reset #i3
for #i2 = 1 to #i1
  if #natline-array(#i2) = ''''
    add 1 to #i3
  end-if
end-for
DIVIDE 2 INTO #i3 REMAINDER #i2
if #i2 <> 0
/* ODD number of ' Signes before #I1 -> #I1 is withon String
  reset #i1
end-if
end-subroutine
/*
define subroutine isReport
#found := false
#temp := ' '
#i6 := #i4 +1
for #i5 = #i6 to 93
  if #natline-array(#i5) = ')'
    escape bottom
  else
    compress #temp #natline-array(#i5) into #temp leaving no
  end-if
end-for
if #temp is (n10)
  #i7 := val(#temp)
  if #i7 > 0
    #found := true
  end-if
end-if
end-subroutine
end-subroutine
/*
end
