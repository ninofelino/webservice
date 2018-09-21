PROCEDURE R1()
CLEA
@ 08,20 TO 16,63 DOUBLE
CP1='00'
DO WHILE .T.
   @ 10,27 SAY "RESET SETELAH LATIHAN CASHIER"
   @ 12,27 SAY " MASUKKAN NO INLINE     : "
   @ 14,29 SAY "[SIGN ON] -> BATAL/KELUAR"
   @ 12,53 GET CP1 PICT '99'
   READ
   IF LASTKEY()=27
      EXIT
   ENDI
   IF !FILE('C:\KASIR\DAT\CP'+CP1+'0000.DBF')
      WARNING('SALAH MEMASUKKAN NOMOR INLINENYA')
      LOOP
   ENDI
   @ 16,29 SAY 'Reset File : '+'C:\KASIR\DAT\CP'+CP1+'0000'
   USE ('C:\KASIR\DAT\CP'+CP1+'0000')
   ZAP
   USE
   USE ('C:\KASIR\DAT\CP'+CP1+'TEMP')
   ZAP
   USE
   USE ('C:\KASIR\DAT\SATELITE')
   GO TOP
   REPL CPDT WITH DATE()
   REPL NORCP WITH 1
   REPL TRESET WITH 0
   USE
   FILEDELETE('C:\KASIR\EOD\*.*')
   INKEY(3)
   FILEDELETE('C:\KASIR\HST\*.*')
   INKEY(3)
   FILEDELETE('C:\KASIR\TXT\*.*')
   INKEY(3)
   FILEDELETE('C:\KASIR\DAT\CP'+CP1+'TEMP.MEM')
   IF NNETLOGGED()
      FILEDELETE('F:\WPI\EOD\*.*')
      INKEY(3)
      FILEDELETE('F:\WPI\HST\*.*')
      INKEY(3)
      FILEDELETE('F:\WPI\TXT\*.*')
      INKEY(3)
      USE
      USE ('F:\WPI\DAT\DLL')
      REPL ALL NORCP  WITH 0
      REPL ALL TRESET WITH 0
   ENDI
   WARNING('MESIN SIAP DI OPERASIKAN')
   CP1='00'
ENDDO
CLEA 
@ 10,23 SAY "MESIN SIAP UNTUK DIGUNAKAN..... OK"
RETURN

*------------------------------------------------------------------------------
PROCEDURE Warning(cPesan)  &&____________Beep 3 times & Print messages Windows in 3 Second
LOCAL cScrn,nPanjang,nCa;
,nCb,cOldColr:=SetColor(),aBox
SETCOLOR('gr+/r')
nPanjang:=LEN(cPesan)
nCA  :=(79-nPanjang)/2
nCB  :=nCA+nPanjang+1
cScrn:=SAVESCREEN(11,nCa,14,nCb+2)
aBox:=Box(11,nCa,13,nCb,'r')    // BOX "ÉÍ»º¼ÍÈº " COLOR 'w+/r'
SetPos(12,nCa+1);DispOut(cPesan)
TONE(3000,3)
TONE(2500,2)
TONE(2800,4)
SETCOLOR(cOldColr)
DO WHILE INKEY(1)#0
ENDDO
BoxPush(aBox) ;BoxClose(aBox)
RESTSCREEN(11,nCa,14,nCb+2,cScrn)
RETURN

*------------------------------------------------------------------------------
FUNCTION Box(nTop,nLeft,nBot,nRight,cColor)
LOCAL cOldColor, aBox
 cOldColor:=SetColor()
 cColor:=IF(cColor=NIL,cOldColor,cColor)
// SetColor(cColor)
 aBox:=BoxOpen(nTop,nLeft,nBot,nRight,cColor,.3)
 SetColor(cOldColor)
RETURN aBox

*------------------------------------------------------------------------------
FUNCTION NNetLogged()
LOCAL lRet:=.T.,cCurDir:=DiskName()+':'+DirName()
cNDRV:='F:'
PUBLIC NDATA := cNDrv+"\WPI\DAT\"
PUBLIC NDLL  := cNDrv+"\WPI\DLL\"
PUBLIC NEOD  := cNDrv+"\WPI\EOD\"
PUBLIC NHST  := cNDrv+"\WPI\HST\"
PUBLIC NTXT  := cNDrv+"\WPI\TXT\"
PUBLIC DDATA := "\KASIR\DAT\"
PUBLIC DEOD  := "\KASIR\EOD\"
PUBLIC DHST  := "\KASIR\HST\"
PUBLIC DTXT  := "\KASIR\TXT\"
IF Abs(DirChange(cNDrv+'\WPI\DLL'))==3
   DirChange(cCurDir)
   RETURN .F.
ENDIF
DirChange(cCurDir)
RETURN lRet

*------------------------------------------------------------------------------
FUNCTION BoxOpen(nR,nC,nR2,nC2,cC,nD)
LOCAL cCol:=SetColor()
cC:=IF(cC=NIL,SetColor(),cC)
SetColor('N/'+cC)
@ nR,nC CLEA TO nR2,nC2 ;@ nR,nC TO nR2,nC2
SetColor(cC+'+/'+cC) //'w+/w'
@ nR ,nC TO nR,nC2
@ nR ,nC2 SAY '¿' COLOR 'N/'+cC
@ nR ,nC TO nR2-1,nC
@ nR ,nC  SAY 'Ú' ;@ nR2,nC  SAY 'À'
SetColor(cCol)
RETURN {nR,nC,nR2,nC2,cC,nD}

FUNCTION BoxClose(a)
RETURN

FUNCTION BoxPush(a)
RETURN

*-----------------------------------------------------------------------------

