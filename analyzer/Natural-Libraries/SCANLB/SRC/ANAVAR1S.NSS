* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
define data
*
global using anamod0g
parameter using anavar1p
*
local using anadataa
local
1 i (i2)
1 #lineout (a5)
1 #line2out (a5)
1 redef-start-level (i4)
1 #workbuf (a100)
*
end-define
*
define subroutine Anavar1s

* --------------------------------------  A N A V A R 1 S ---------------------------------------
move edited #lineno1 (em=99999) to #lineout
move edited #lineno2 (em=99999) to #line2out
*
if #format <> 'R'
  move cnt to i
  add 1 to i
  move i to cnt
  expand array var to (1:i)
  expand array format to (1:i)
  move #variable to var(i)
  move #format to format(i)
end-if
*
decide for first condition
  when #format = scan 'R' /* redefinition
    #redef := true
    base-level := val(#level)
    base-var := #variable
    perform Find-base-format
  when val(#level) = base-level
    #redef := false
    resize array var to (1:*)
    resize array format to (1:*)
  when #redef and (base-format = scan 'I4' or = scan 'I2')
    if #objmodul = objname
      compress 'BLE' #lineout base-var base-format 'REDEFINED BY' #variable #format into COMMENT
    else
      compress 'BLE' #lineout 'IN' #objmodul 'LINE' #line2out '->' base-var base-format 'REDEFINED BY' #variable #format into COMMENT
    end-if
    add 1 to COUNTBLE
    perform anaouts
  when #redef and ( #format = scan 'P' or #format = scan 'B' /* or #format = scan 'C'
      or base-format = scan 'B' and ( #format = scan 'A' or #format = scan 'N' ) )
    if not unixonly
      if #objmodul = objname
        compress 'RED' #lineout base-var base-format 'REDEFINED BY' #variable #format into COMMENT
      else
        compress 'RED' #lineout 'IN' #objmodul 'LINE' #line2out '->' base-var base-format 'REDEFINED BY' #variable #format into COMMENT
      end-if
      add 1 to COUNTRED
      perform anaouts
    end-if
  when none
    ignore
end-decide
* ----------------------------------------- E N D -------------------------------------------------

define subroutine Find-Base-Format
* ---------------------------- F I N D - B A S E - F O R M A T ------------------------------------
move 'NOTFND' to base-format
for i = cnt to 1 step -1
  if var(i) = base-var
    move format(i) to base-format
    escape bottom
  end-if
end-for
* ----------------------------------------- E N D -------------------------------------------------
end-subroutine
*
end-subroutine
*
end
