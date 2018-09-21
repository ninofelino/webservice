#include "hmg.ch"
#include "kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION EODFunc(c,n,a)
LOCAL cP:=SATELITE->(CPNO),cD
LOCAL cT:=SubS(DTos(SATELITE->(CPDT)),5)
LOCAL aF:={},nYn:=1,lLcl:=.F.,lNet:=.F.
PRIVATE cSccr:=SaveScreen(17,10,19,64)
Box(17,10,19,64,'w+/w')
@ 18,15 Say 'Lakukan Proses Reset / EOD... ? [0]Tidak, [1]Ya ' COLOR 'n/w' //Dar 5/13
DO WHILE .T.                                                              //Dar 5/13
   i:=InKey(0)                                                            //Dar 5/13
   IF UPPER(CHR(i))$'01'                                                  //Dar 5/13
      EXIT                                                                //Dar 5/13
   ENDIF                                                                  //Dar 5/13
ENDDO                                                                     //Dar 5/13
RestScreen(17,10,19,64,cSccr)
IF UPPER(CHR(i))$'0'                                                      //Dar 5/13
   RETURN .T.                                                             //Dar 5/13
ENDIF                                                                     //Dar 5/13
IF CP->(LastRec())=0 .OR. TEMP->(LastRec())#0 .Or. c#'1'
   Warning(' Proses EOD tidak diperkenankan... ! ')
   RETURN .T.
ENDIF
LogHold()

IF NNETLOGGED()                                           // EOD.........
// DLL->(DBGoto(Val(SubS(SATELITE->CPNO,3,2))))
// IF !Empty(Directory(DHST+'????'+cT+'.DBF'))  .AND. !DLL->EOD
//    Warning('sudah pernah, RESET Batal....')
//    RETURN .T.
// ENDIF
ELSE
// IF !Empty(Directory(DHST+'????'+cT+'.DBF'))  .AND. !SATELITE->EOD
//    Warning('sudah pernah, RESET Batal....')
//    RETURN .T.
// ENDIF
ENDIF
IF !Empty(Directory(DHST+'????'+cT+'.DBF'))
   Warning('EOD sudah pernah dilakukan/sudah ada ...')
   Box(17,00,19,79,'w+/w')
   @ 18,04 SAY 'Hapus dan Backup Data EOD Tahun lalu ... ? [1]-Ya [0]-Tidak ? ' COLOR 'n/w'
   DO WHILE .T.                                                              //Dar 5/13
      nYn:=InKey(0)                                                            //Dar 5/13
      IF UPPER(CHR(nYn))$'01'                                                  //Dar 5/13
         EXIT                                                                //Dar 5/13
      ENDIF                                                                  //Dar 5/13
   ENDDO                                                                     //Dar 5/13
   IF Chr(nYn)='0'
      RETURN .T.
   ENDIF
   Box(18,05,20,75,'w+/w')
   @ 19,12 SAY 'TUNGGU !! SEDANG MELAKUKAN BACKUP FILE RESET/EOD....' COLOR 'n*/w'
   nYear:=SATELITE->(Year(CPDT))-1
   nMont:=Val(Left(cT,2))
   nDay :=Val(Right(cT,2))
   aDirL:=Directory(DHST+'????'+Left(cT,2)+'??.DBF')
   aDirN:=Directory(NHST+'????'+Left(cT,2)+'??.DBF')
   DHST2:='C:\KASIR\HST'+AllTrim(Str(nYear))
   DEOD2:='C:\KASIR\EOD'+AllTrim(Str(nYear))
   lLcl :=Abs(DirChange('C:\KASIR\HST'+Alltrim(Str(nYear)))) == 0
   IF NnetLogged()
      NHST2:='F:\WPI\HST'+AllTrim(Str(nYear))
      NEOD2:='F:\WPI\EOD'+Alltrim(Str(nYear))
      lNet :=Abs(DirChange('F:\WPI\HST'+Str(nYear))) == 0
   ENDIF

   IF !lLcl
      DirMake(DHST2) ;DirMake(DEOD2)
   ENDIF
   IF NnetLogged() .AND. !lNet
      DirMake(NHST2) ;DirMake(NEOD2)
   ENDIF
   DHST2+='\'
   DEOD2+='\'
   IF NNetLogged()
      NHST2+='\'
      NEOD2+='\'
   ENDIF
   DirChange('C:\KASIR')
   FOR nI=1 TO Len(aDirL)
      cF:=aDirL[nI][1]
      IF Year(aDirL[nI][3])=nYear .AND. Month(aDirL[nI][3])=nMont
         FileMove(DHST+cF,DHST2+cF)
         FileMove(DEOD+cF,DEOD2+cF)
      ENDIF
   NEXT
   IF NNetLogged()
      FOR nI=1 TO Len(aDirN)
         cF:=aDirN[nI][1]
         IF Year(aDirN[nI][3])=nYear .AND. Month(aDirN[nI][3])=nMont
            FileMove(NHST+cF,NHST2+cF)
            FileMove(NEOD+cF,NEOD2+cF)
         ENDIF
      NEXT
   ENDIF
ENDIF

Box(18,05,20,75,'w+/w')
@ 19,12 SAY 'TUNGGU !! SYSTEM SEDANG MELAKUKAN PROSES RESET/EOD...' COLOR 'n*/w'

aF:=Directory(DHST+'??????'+Right(cT,2)+'.DBF')
AEval(aF,{|a|FErase(a[1])})
SELECT CP
CP->(AddRec())
CP->QTY  :=0
CP->ETYPE:='A'
CP->FLAG :='EOD'
CP->CODE :=Time()
CP->DDATE:=DATE()
CP->NORCP:=SATELITE->NORCP
CP->PRICE:=SATELITE->MCHNID
CP->DESC :=CASHIER->CODE+'þ'+CASHIER->DESC
CP->CHKDT:=CP->(L2BIN(RecNo()))
DBCommitAll()
cD:=Left(cP,4)+cT
SATELITE->TRESET+=1
//Copy To (DEOD+cP)
Copy To (DHST+cD)
Copy To (DEOD+cD)
IF lGLan
   Copy To (NEOD+cD)
   Copy To (NHST+cD)
   // FErase(NDLL+cP+'.DBF')
   DLL->(DBGoto(Val(SubS(SATELITE->CPNO,3,2))))
   IF DLL->(RecLock())
      DLL->STATUS  :=2
      DLL->WAKTU   :=''
      DLL->TGLCLOSE:=SATELITE->(DTOC(CPDT))
      DLL->TRESET  :=SATELITE->TRESET
      DLL->EOD     :=.F.
      DLL->(DBUNLOCK())
      DLL->(DBCOMMIT())
   ENDIF
ELSE   
   IF SATELITE->(RecLock())
      SATELITE->TGLCLOSE:=SATELITE->(DTOC(CPDT))
      SATELITE->EOD:=.F.
      SATELITE->(DBUNLOCK())
      SATELITE->(DBCOMMIT())
   ENDIF
ENDIF
SATELITE->NORCP:=1
SATELITE->EOD:=.F.
SET DEVICE TO PRINT;PHeader()
@ PRow()+1,00 SAY PDWidth('Z-30'+Repl('.',16)+IF(lGJour,'Z-30'+Repl('.',16),''))
PCutter() ;JRFFunc() ;JRFFunc()
SET DEVICE TO SCREEN
SELECT CP ;ZAP
SELECT MARIMAR ;ZAP
TOMBOL->(__DBLocate({||ASCII==_SGN_ON},,,,.f.))
KEYBOARD Chr(TOMBOL->ASCII)
IF lGLan
   //--1
   cD:='SATELITE'
   USE (NDATA+cD+'.DBF') NEW SHARED ALIAS ST
   SATELITE->CODE :=ST->CODE
   SATELITE->DESC :=ST->DESC
   SATELITE->ADD1 :=ST->ADD1
   SATELITE->ADD2 :=ST->ADD2
   SATELITE->TELP :=ST->TELP
   SATELITE->FACS :=ST->FACS
   SATELITE->COM1 :=ST->COM1
   SATELITE->COM2 :=ST->COM2
   SATELITE->COM3 :=ST->COM3
   SATELITE->COM4 :=ST->COM4
   SATELITE->COM5 :=ST->COM5
   SATELITE->STO1 :=ST->STO1
   SATELITE->STO2 :=ST->STO2
   SATELITE->STO3 :=ST->STO3
   SATELITE->STO4 :=ST->STO4
   SATELITE->KEYM0:=ST->KEYM0
   SATELITE->KEYM1:=ST->KEYM1
   SATELITE->KEYM2:=ST->KEYM2
   SATELITE->KEYM3:=ST->KEYM3
   SATELITE->KEYM4:=ST->KEYM4
   SATELITE->KEYM5:=ST->KEYM5
   SATELITE->KEYM6:=ST->KEYM6
   SATELITE->KEYM7:=ST->KEYM7
   SATELITE->KEYM8:=ST->KEYM8
   ST->(DBCLOSEAREA())
   //--2
   cD:='PROMOSI'
   SELECT (cD) ;USE
   COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
   USE (DDATA+cD)  ALIAS (cD)
   //--3
   cD:='CASHIER'
   SELECT (cD) ;USE
   COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
   USE (DDATA+cD)  ALIAS (cD)
   CASHIER->(__DBLocate({||CODE==cGLCd},,,,.f.))
   //--4
   cD:='TOMBOL'
   SELECT (cD) ;USE
   COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
   USE (DDATA+cD)  ALIAS (cD)  ;ResetKey(@a)
   //--5
   cD:='CLASS'
   SELECT (cD) ;USE
   COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
   USE (DDATA+cD)  ALIAS (cD)
   INDEX ON CODE TO (DDATA+'CLASS__1.NTX')
   INDEX ON Left(CODE,10) TO (DDATA+'CLASS__2.NTX')
   SET INDEX TO  (DDATA+'CLASS__1.NTX'),(DDATA+'CLASS__2.NTX')
   SELECT TEMP
   //--6
/*
   cD:='PRODUK'
   SELECT (cD) ;USE
   COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
   USE (DDATA+cD)  ALIAS (cD)
   INDEX ON REF           TO (DDATA+'PRODUK_3.NTX')
   INDEX ON Left(DESC,28) TO (DDATA+'PRODUK_2.NTX')
   INDEX ON CODE          TO (DDATA+'PRODUK_1.NTX')
   SET INDEX TO  (DDATA+'PRODUK_1.NTX'),(DDATA+'PRODUK_2.NTX'),(DDATA+'PRODUK_3.NTX')
   SELECT TEMP
*/
ENDIF
RETURN .F.
 
*-----------------------------------------------------------------------------
STATIC FUNCTION LogHold()
LOCAL  cLG:=DHST+"LG"+SATELITE->(SubS(CPNO,3,2))+"0000"
LOCAL  nI,nH,cLF,cBuf,aDir,aDirk,aS:={}
LOCAL cScrlog2:=savescreen(0,0,maxrow(),maxcol())
aDir:=DIRECTORY(DDATA+"???_HOLD.DBF")
IF Empty(aDir)
   RETURN .T.
ELSE
   FOR nI:=1 TO Len(aDir)               // 20
      RENAMEFILE(DDATA+aDir[nI][1],DDATA+'K'+aDir[nI][1])
   NEXT                                // 20
ENDIF
aDirk:=DIRECTORY(DDATA+"K?_HOLD.DBF")   // 20
//@ 23,01 Say 'Ada Hold Transaksi, [.]Biarkan, [sembarang tombol]Hapus ' //Dar 5/11
//Inkey(0);DO WHILE InKey(.1)#0;ENDDO;@ 23,01 CLEAR TO 23,53             //Dar 5/11
//IF LastKey()=Asc('.')                                                  //Dar 5/11
//   RETURN .T.                                                          //Dar 5/11
//ENDIF                                                                  //Dar 5/11
cScrlog:=savescreen(0,0,maxrow(),maxcol())
Box(17,10,19,60,'w')
@ 18,15 Say 'Ada Transaksi Hold..., [0] Biarkan, [1] Hapus ' COLOR 'n/w' //Dar 5/11
DO WHILE .T.                                                             //Dar 5/11
   i:=InKey(0)                                                           //Dar 5/11
   IF UPPER(CHR(i))$'01'                                                 //Dar 5/11
      EXIT                                                               //Dar 5/11
   ENDIF                                                                 //Dar 5/11
ENDDO
RestScreen(0,0,maxrow(),maxcol(),cScrlog)
IF UPPER(CHR(i))$'0'                                                     //Dar 5/11
   RETURN .T.                                                            //Dar 5/11
ENDIF                                                                    //Dar 5/11
nH:=0
aS:={}
cBuf:=''
IF (nH:=FOpen(cLG,2))=-1
   IF (nH:=FCreate(cLG))=-1
      RETURN .F.
   ENDIF
ENDIF
FSeek(nH,0,2)
cLF:=Chr(13)+Chr(10)
FOR nI:=1 TO Len(aDirk)
   USE (DDATA+aDirk[nI][1]) NEW
   aS:=DBStruct()
   FWrite(nH,cLF+cLF+cLF+cBuf+cLF)
   DO WHILE !Eof() ;cBuf:='³'+Str(RecNo(),4)+'³'
      AEval(aS,{|a|cBuf+=Trans(Eval(FieldBlock(a[1])),'')+'³'})
      FWrite(nH,cBuf+cLF)
      SKIP
   ENDDO
   USE
   FErase(DDATA+aDirk[nI][1])
NEXT
FClose(nH)
RestScreen(0,0,maxrow(),maxcol(),cScrlog2)
RETURN .T.

