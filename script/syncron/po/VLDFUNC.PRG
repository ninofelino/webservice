#include 'kassa.ch'
*--------------------------------------------------------------------------------
FUNCTION VldKeys(c,n,a) &&__________Add 28 Nov 95, Widi, Corr in GetPosKey()...
IF lGStl;VldSbt(@c,@n,@a)
   ELSE ;VldFunc(@c,@n,@a)   
ENDIF
RETURN .T.
*--------------------------------------------------------------------------------
FUNCTION VldFunc(c,n,a)
LOCAL cS:=SaveScreen(23,1,23,28),c1,c2,cR
LOCAL cD:=CASHIER->(AllTrim(CODE))+' ',nD:=0
LOCAL cX:=Left(Time(),5)+' '+DToC(Date())
IF c=NIL
   Msg(' Tekan Sembarang Tombol Untuk Validasi... ')
   Do While inkey(.1)=0;TONE(3000,2);TONE(2800,4);enddo
   Do While inkey(.1)#0;enddo;RestScreen(23,1,23,28,cS)
ENDIF
Warning(' Masukkan Kertas Validasi ............ ')
SET DEVICE TO PRINT
@ Prow(),PCol() SAY _PINIT+_PVLDS+_PVBCK
IF TEMP->(LastRec())>0
   nD:=TEMP->(QTY*PRICE)
   c1:=TEMP->(AllTrim(CODE+' '+DESC))
   cR:=TEMP->(AllTrim(Str(NORCP)))
ELSE;c1:=CP->(AllTrim(CODE+' '+DESC))
   cR:=CP->(AllTrim(Str(NORCP)))
   nD:=CP->(QTY*PRICE)
ENDIF

DO CASE
   CASE nD#0
        c2:=' Rp '+AllTrim(Trans(nD,'999,999,999'))
   CASE nD=0
        c2:=' Rp '+AllTrim(Trans(GnPRICE,'999,999,999'))
ENDC

@ Prow()  ,00 SAY cD+cX+' '+SATELITE->(SubS(CPNO,3,2))+" #"+cR+' '+ c1+PDWidth(c2)+Chr(12)+Chr(13)

@ Prow(),PCol() SAY _PINIT+_PALL
SET DEVICE TO SCREEN
RETURN .T.

*--------------------------------------------------------------------------------
FUNCTION VldSub(c,n,a)
LOCAL cD:=CASHIER->(AllTrim(CODE))+' '
LOCAL nD:=If(nGDisc>.99,nGDisc,Int(nGDisc*nGStl)),c1,c2,cR
LOCAL cX:=Left(Time(),5)+' '+DToC(Date())
IF c=NIL
   Msg(' Tekan Sembarang Tombol Untuk Validasi...! ')
   Do While inkey(.1)=0;TONE(3000,2);TONE(2800,4);enddo
   Do While inkey(.1)#0;enddo;RestScreen(23,1,23,28,cS)
ENDIF
c1:=cGDDESC
c2:=' Rp '+AllTrim(Trans(nD*(-1)*If(lGRTN,-1,1),'999,999,999'))
cR:=TEMP->(AllTrim(Str(NORCP)))
Warning(' Masukkan Kertas Validasi ............ ')
SET DEVICE TO PRINT
@ Prow(),PCol() SAY _PINIT+_PVLDS+_PVBCK
@ Prow()  ,00 SAY cD+cX+' '+SATELITE->(SubS(CPNO,3,2))+" #"+cR+c1+PDWidth(c2)+Chr(12)+Chr(13)
@ Prow(),PCol() SAY _PINIT+_PALL
SET DEVICE TO SCREEN
RETURN .T.
*--------------------------------------------------------------------------------
FUNCTION VldSbt(c,n,a)
LOCAL cD:=CASHIER->(AllTrim(CODE))+' '
LOCAL nD:=If(nGDisc>.99,nGDisc,Int(nGDisc*nGStl)),c1,c2,cR
LOCAL cX:=Left(Time(),5)+' '+DToC(Date())
IF c=NIL
   Msg(' Tekan Sembarang Tombol Untuk Validasi...! ')
   Do While inkey(.1)=0;TONE(3000,2);TONE(2800,4);enddo
   Do While inkey(.1)#0;enddo;RestScreen(23,1,23,28,cS)
ENDIF
c1:=cGDDESC
c2:=' Rp '+AllTrim(Trans(nGStl-nD*(-1)*If(lGRTN,-1,1),'999,999,999'))
cR:=TEMP->(AllTrim(Str(NORCP)))
Warning(' Masukkan Kertas Validasi ............ ')
SET DEVICE TO PRINT
@ Prow(),PCol() SAY _PINIT+_PVLDS+_PVBCK
@ Prow()  ,00 SAY cD+cX+' '+SATELITE->(SubS(CPNO,3,2))+" #"+cR+c1+PDWidth(c2)+Chr(12)+Chr(13)
@ Prow(),PCol() SAY _PINIT+_PALL
SET DEVICE TO SCREEN
RETURN .T.

