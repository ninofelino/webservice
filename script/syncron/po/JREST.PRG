cScramble:='�t��!�7�MW-����Kھv9睕YC��-пa@WS5u'
cUnScramb:='123456789'
//cScramble:='�t��!�7�MW-����KڧaJ��"0��3��i-\'
//cScramble:='�p��Q�8�J6.�ƪ�NѤJ>.'
//cUnScramb:='96123458267373277865'
cGet:=Space(Len(cScramble))
//cGet:=Space(33)
Clear
@ 1,1 SAY 'Judul :' Get cGet
Read
//cGet:=Alltrim(cGet)
nH:=FOpen('WINREST.EXE',2)   &&ReadWrite...
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


