#include "hmg.ch"
#Include 'KASSA.CH'
FUNCTION VODFunc(c,n)
LOCAL cD:=''
IF LastRec()>1 .AND. PRICE#0
   lGVOD:=!lGVOD
   cD:=Left(SATELITE->CPNO,4)
   SAVE TO (DDATA+cD+'TEMP.MEM') ALL LIKE ?G*
   cD :=If(lGVOD,'VOD','   ')
   IF nGBrs>19;nGBrs--
      SCroll(9,1,20,78,1)
      @ 20,02 SAY '   ³        ³                         ³   ³         ³  ³         ³          '
   ENDIF
   @ nGBrs+1,2 SAY cD COLOR 'w*'
ELSE;Wrong('Salah Tombol...')
ENDIF
RETURN .T.
