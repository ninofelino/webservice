#include "hmg.ch"
FUNCTION NOSFunc(c,n)

IF !EMPTY(c)
   IF TEMP->(LASTREC())=0
      NEW()
   ENDIF
   AddRec()
   FIELD->FLAG:='REF'
   FIELD->CODE:=c
   UNLOCK
   SET DEVICE TO PRINTER
   @ PRow()+2 ,00 SAY PDWidth(LEFT('NO BON -> '+SPACE(20),20)+IF(lGJour,'NO BON -> ',''))
   @ PRow()   ,20 SAY PDWidth(RIGHT('          '+c,10))
   JPrint(PRow()   ,97,PDWidth(RIGHT('          '+c,10)))
   SET DEVICE TO SCREEN
ELSEIF EMPTY(c) .AND. TEMP->(LASTREC())=0
   OpenDrw()
ELSEIF EMPTY(c) .AND. TEMP->(LASTREC())#0
   temp->(dbgobottom())
   if TEMP->FLAG='REF'
      TEMP->(RecLock())
      TEMP->(DBDelete())
      TEMP->(__DBPack())
      TEMP->(DBUnLock())
      SET DEVICE TO PRINTER
      @PROW(), 0 SAY  REPLI('X',40)
      JPrint(PROW(),40,REPLI('X',40))
      SET DEVICE TO SCREEN
   endif
ELSE
ENDIF
c:=''
RETURN .T.
