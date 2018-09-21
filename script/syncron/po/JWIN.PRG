//cScramble:='Õt£Û!‡7úMW-Ë∆€–K⁄æv9ÁùïYC˙ﬂ-–øa@WS5u'
//cUnScramb:='123456789'
//cScramble:='Õt£Û!‡7úMW-Ë∆€–K⁄ßaJïÚï"0˝√3§æi-\'
//cScramble:='Ÿp¢áQ‡8ÚJ6.Î∆™∆N—§JÓÅí>.'
//cUnScramb:='96123458267373277865'
cScramble:='ŒVÄœäu†—KSªMZÏ6O˘=j-”9'
//cUnScramb:='567890123'
//cScramble:='ÿRùœäu›æR5TªQeøkÿXÁ≥Ã≤‰äÙœ'
cUnScramb:='567890123'

cGet:=Space(Len(cScramble))
//cGet:=Space(33)
Clear
@ 1,1 SAY 'Judul :' Get cGet
Read
//cGet:=Alltrim(cGet)
nH:=FOpen('POS.EXE',2)   &&ReadWrite...
IF LastKey()=27 .OR. nH=-1 &&Batal/Gagal Open
   ?'Batal/gagal open file...'
   QUIT
ENDIF
cBuffer=Space(1024);nCounter:=0;nD:=0
DO WHILE (nT:=Fread(nH,@cBuffer,1024))=1024
   IF (nD:=At(cScramble,cBuffer))#0 
      EXIT
   ENDIF
   nCounter++
   nD:=0
ENDDO
IF nD#0;cGet:=Crypt(cGet,cUnScramb)
   FSeek( nH,nCounter*1024+nD-1,0)
/*
   cBuffer:=Space(Len(cScramble))
   Fread(nH,@cBuffer,Len(cScramble))
   ?cScramble
   ?cBuffer
   inkey(0)
*/
   FWrite(nH,cGet,Len(cGet))
   ?'Proses OK...'
ENDIF
FClose(nH)


