#include "hmg.ch"
*-----------------------------------------------------------------------------
FUNCTION CLSFunc(c,n,a)
IF c <> NIL
  SELE TEMP
  TEMP->(DBGOBOTTOM())
  IF TEMP->PRICE = 0 .AND. INT(VAL(c)) = 0 .AND. !TEMP->(BOF()) ;
     .AND. !EMPTY(TEMP->DESC)
     TEMP->(DBDELETE())
     IF TEMP->(LastRec())<3
        TEMP->(DBGoto(1))
        TEMP->(DBDELETE())
     ENDIF
     PACK
     @ nGbrs,02 SAY '   ³        ³                         ³   ³         ³  ³         ³          '
     IF !(nGBrs>18)
        @ nGBrs+1,41 SAY '   '
     ENDIF
     nGbrs--
     TEMP->(DBGOBOTTOM())
  ENDIF
  @ 21,01 CLEAR TO 24,52
ENDIF

nQTY:=1;c:=''
IF !(nGBrs>18)
   @ nGBrs+1,41 SAY nQTY PICT '999'
ENDIF
RETURN .t.



