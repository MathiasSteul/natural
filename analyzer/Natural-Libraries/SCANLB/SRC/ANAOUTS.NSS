* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
define data
global using anamod0g
local using nscanewl
local
1 #out (a200)
1 redefine #out
  2 #out-lib (a8)
  2 filler 1x
  2 #out-obj (a8)
  2 filler 1x
  2 #out-type (a1)
  2 filler 1x
  2 #out-mode (a1)
  2 filler 1x
  2 #out-comment (a132)
end-define
define subroutine ANAOUTS
format ls=201 ps=55
reset #out
#out-lib := OBJLIBRARY
#out-obj := objname
#out-type := OBJTYPE
#out-mode := OBJPROGMODE
#out-comment := COMMENT
if SHOWMAP
  if not DBACCESS
    write work 1 #out
  end-if
else
  write #out
end-if
if DBACCESS
/* write to file
  reset NSCANEW
  nscanew.modul := objname
  nscanew.library := OBJLIBRARY
  nscanew.type := OBJTYPE
  nscanew.mode := OBJPROGMODE
  nscanew.line := val(comment.line)
  nscanew.comment := comment.remark
  nscanew.code := comment.code
  store NSCANEW
  end transaction
end-if
end-subroutine
end
