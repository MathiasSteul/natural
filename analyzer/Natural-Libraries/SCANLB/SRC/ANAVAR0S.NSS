* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
/* build table of all numeric variables used in modul
define data global using anamod0g
parameter
1 #BEGIN-DEFINE-POS (i4)
1 #END-DEFINE-POS (i4)
local using anadataa
local using anavar1p
local
1 i (i2)
1 j (i2)
1 #i (i4)
1 #i2 (i4)
1 #i6 (i4)
1 #i7 (i4)
1 #found (l)
1 #structure (a50)
1 #viewmode (l) init <false>
1 #viewlevel (i2) init <0>
1 #viewname (a50)
1 #da (a8)
1 workbuf (a100)
1 text-array (a100)
1 redefine text-array
  2 text-byte (a1/1:100)
1 #state (a1)
end-define
*
define subroutine anavar0s
for #i = #BEGIN-DEFINE-POS to #END-DEFINE-POS
  /* all Variables
  examine text(#i) for 'USING' with delimiters ' ' giving position #i2
  if #i2 = 0
    /* direct variable
    move text(#i) to text-array
    perform Call-Anavar1s
*     text(#i) #structure #viewmode #viewname OBJNAME #i #i
  else
    /* Data Area
    /* get name of DataArea
    reset #found #da
    for #i6 = #i2 to 92
      /* loop from act. statement to End of Line -1
      if textarray(#i,#i6) = ' ' and textarray(#i,#i6 +1) <> ' '
        add 1 to #i6 /* start position of data area name found
        #found := true
        escape bottom
      end-if
    end-for
    if #found
      for #i7 = #i6 to 93
        /* loop from start position of after token to end of line
        if textarray(#i,#i7) = ' '
          escape bottom
        else
          compress #da textarray(#i,#i7) into #da leaving no
        end-if
      end-for
    end-if
    if #da <> ' '
      /* process data area
      #anadata.#dataobject := #da
      #anadata.#library := OBJLIBRARY
      #anadata.#lineno := #i
      perform anadatas #ANADATA
    end-if
  end-if
end-for
*
define subroutine Call-Anavar1s
* ------------------------------C A L L - A N A V A R 1 S ----------------------------------------
*
on error
  compress 'Error ' *ERROR-NR 'in Subroutine Call-Anavar1s of ANAVAR0S in line number ' *ERROR-LINE into workbuf
  write work 32 workbuf
  compress 'Object-name = ' OBJNAME '(' OBJLIBRARY ')' ', Line =' #i ':' text(#i) into workbuf
  write work 32 workbuf
  escape routine
end-error
*
j := 1
for i from 1 to 99
  move text-byte(i) to text-byte(j)
  j := j + 1
  repeat while text-byte(i) = ' ' and text-byte(i+1) = ' ' and i < 99
    i := i + 1
  end-repeat
end-for
for j from j to 100
  move ' ' to text-byte(j)
end-for

separate text-array into #level #variable #format remainder workbuf with delimiter ' '

if #level = 'DEFINE'
  escape routine
end-if

if #level = 'LOCAL'
  escape routine
end-if

if #level = 'END-DEFINE'
  escape routine
end-if

if not #level is (n9)
   escape routine
end-if

/* get level, variable and format
reset #level #variable #format
#state := 'L'
for #i2 = 1 to 100
  decide for every condition
    when #state = 'L' and not text-byte(#i2) is (n10)
      #state := 'V'
    when #state = 'V' and  text-byte(#i2) = '('
      #state := 'F'
    when #state = 'F' and #format = scan ')'
      escape bottom
    when #state = 'L' and text-byte(#i2) <> ' '
      compress #level text-byte(#i2) into #level leaving no
    when #state = 'V' and text-byte(#i2) <> ' '
      compress #variable text-byte(#i2) into #variable leaving no
    when #state = 'F' and text-byte(#i2) <> ' '
      compress #format text-byte(#i2) into #format leaving no
    when none
      ignore
  end-decide
end-for

/* special Case REDEFINE (no Format is given)
if #level <> ' ' and #varred = 'REDEFINE' and #format = ' '
  #format := #varrem
  #variable := #varred
end-if


if #variable = 'REDEFINE'
  #variable := #format
  #format := 'R'
end-if

/* View

if #format = scan 'VIEW'
  #viewmode := true
  #viewname := #variable
  #viewlevel := val(#level)
  escape top
end-if

/* if #viewmode = false
/*  escape top
/* end-if

/* Group

if #level is (n9) and val(#level) <= #viewlevel and #viewmode
  #viewmode := false
  #viewname := ' '
  #viewlevel := 0
  escape top
end-if
*
move OBJNAME to #objmodul
move #i to #lineno1
move #i to #lineno2
perform anavar1s anavar1s-parm-area
* ------------------------------C A L L - A N A V A R 1 S ---------------------------------- E N D
end-subroutine
*
end-subroutine
*
end
