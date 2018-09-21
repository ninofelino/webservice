#include "hmg.ch"
*-----------------------------------------------------------------------------
FUNCTION QTYFunc(c,n)
LOCAL  nD:=Val(c),;
lD:=(TEMP->PRICE#0 .OR. LastRec()<2 .OR. TEMP->FLAG='STR' .OR. TEMP->FLAG='REF')
IF nD>0 .And. nD<1000 .AND. lD
   nQTY:=nD ;c:=''
   IF nGBrs>19;nGBrs:=19
      SCroll(9,1,20,78,1)
      @ 20,02 SAY '   ³        ³                         ³   ³         ³  ³         ³          '
   ENDIF
   @ nGBrs+1,41 SAY nD PICT '999'
ELSE
   Tone(3000,2)
   Tone(2800,4)
ENDIF
RETURN .t.
