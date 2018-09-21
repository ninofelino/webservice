#include "Kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION HLDFunc(c,n,a)
LOCAL nX:=0,nChoice:=0
LOCAL nFile:=0,cFileHold:='',cFileTemp:=''
PRIVATE cKeyy,nGK:=0

SELECT TEMP 
IF LASTREC()=0                             &&___Akan RECALL
   DispFile()
   IF LastKey()=27.OR.nGK=28
   RETURN .T. ;ENDIF
   IF VAL(cKeyy)>0 .AND. VAL(cKeyy)<999    &&___LASTKEY()>=49.AND.LASTKEY()<=57
      cNo:=cKeyy                           &&___CHR(LASTKEY())
      cFileHold:=DDATA+cNo+"_HOLD.DBF"
      IF !FILE(cFileHold)
         Warning(' Tidak Ada PENDING '+cNo+', Salah Tombol ... ! '); RETURN .T.
      ENDIF
      cFileTemp:=DDATA+LEFT(SATELITE->CPNO,4)+"TEMP.DBF"
      New();nX:=NORCP;APPEND FROM (cFileHold)
      TEMP->(DBGoto(2))
      DO WHILE !TEMP->(Eof())
	 TEMP->NORCP:=nX
	 TEMP->(DBSkip())
      ENDDO
      DELE FILE (cFileHold)
      AllView()
   ELSE ;RETURN .T.
   ENDIF
ELSE                                       &&___Akan HOLD/PENDING
   FOR nX:=1 TO 999
       cFileHold:=DDATA+RIGHT('000'+Alltrim(STR(nX,3)),3)+"_HOLD.DBF"
       IF !FILE(cFileHold)
          IF !ConfirmMess()
             RETURN .T.
          ENDIF
          cNo:=RIGHT('000'+Alltrim(STR(nX,3)),3)
          cFileHold:=DDATA+RIGHT('000'+Alltrim(STR(nX,3)),3)+"_HOLD.DBF"
          SELECT TEMP
          GO 2
          COPY TO (cFileHold) While .t.
          SELECT TEMP ;ZAP
          lGBarCode:=.F.
          nGKeyLock:=0
          lGVod:=.F.
          lGRtn:=.F.
          lGStl:=.F.
          cGDFlag:=''
          cGDDesc:=''
          cGSales:=''
          cNobonK:=space(10)
          nGDisc:=0
          nGStl:=0
          ViewTrn(0)
          ClearEntry()
          nGBrs:=8 ;c:='' ;CLSFunc()
          HoldMess("** PENDING KE "+cNo+' **')
          ResetKey(@a)
// utk nolkan semua total/subtotal/ kembali
          @ 22,66 SAY Trans(0,' 999,999,999')
          @ 22,66 SAY Trans(0,' 999,999,999')+' '
          @ 22,66 SAY Trans(0,' 999,999,999')+' '
          @ 23,66 SAY Trans(0,' 999,999,999')
          @ 23,66 SAY Trans(0,' 999,999,999')+' '
          @ 23,66 SAY Trans(0,' 999,999,999')+' '
          RETURN .T.
       ELSE ;nFile++
       ENDIF
    NEXT nX
    IF nFile>=999
       Warning(' HOLD Sudah Penuh, Max. 999 Transaksi, Salah Tombol ... ! ') ;RETURN .T.
    ENDIF
ENDIF
c:=''
CLSFunc()
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION ConfirmMess()
LOCAL cOld:=SETCOLOR(),cScr:=''
//LOCAL cScrCM:=savescreen(0,0,maxrow(),maxcol())
cScr:=SAVESCREEN(06,68,11,78)
@ 06,68 CLEAR TO 11,78
SETCOLOR('N/W')
@ 06,68 SAY 'ÚÄÄÄÄÄÄÄÄÄ¿'
@ 07,68 SAY '³ H O L D ³'
@ 08,68 SAY 'ÃÄÄÄÄÄÄÄÄÄ´'
@ 09,68 SAY '³[0] Tidak³'
@ 10,68 SAY '³[1] Ya   ³'
@ 11,68 SAY 'ÀÄÄÄÄÄÄÄÄÄÙ'
@ 09,70 SAY '0' COLOR 'N*/W'
@ 10,70 SAY '1' COLOR 'N*/W'
SETCOLOR(cOld)
ScanKey()
RESTSCREEN(06,68,11,78,cScr)
RETURN IF(LASTKEY()=49,.T.,.F.)

*-----------------------------------------------------------------------------
STATIC PROCEDURE Keluar()
nGK:=28
DO CASE
   CASE LastKey()=19 ;KeyBoard CHR(5)
   CASE LastKey()= 4 ;KeyBoard CHR(24)
   OTHERWISE         ;KeyBoard CHR(27)
ENDCASE
//KEYBOARD Chr(27)
RETURN

*-----------------------------------------------------------------------------
STATIC PROCEDURE DispFile()
LOCAL aDir:=DIRECTORY(DDATA+"???_HOLD.DBF")
LOCAL aFile:={},aPilih:={},nX:=0,cS:='',cOld:=SETCOLOR(),nD
FOR nX:=1 TO LEN(aDir)
    AADD(aFile,aDir[nX][1])
NEXT nX
nBanyak:=LEN(aFile)
cS:=SAVESCREEN(06,65,18,78)
SETCOLOR('W/N')                            &&___('N/W')
@ 06,65 CLEAR TO 18,78
@ 06,65 TO 18,78
@ 07,65 SAY '³PENDING LIST³'
@ 08,65 SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄ´'
IF LEN(aFile)<1
   RESTSCREEN(06,65,18,78,cS)
   nGK:=28
   RETURN
ENDIF
nD    :=AT('.',aFile[1])
FOR nX:=1 TO LEN(aDir)
    AADD(aPilih,LEFT(aDir[nX][1],nD-1))
NEXT nX
nGK:=0
Set Key 28 TO Keluar
Set Key 19 TO Keluar
Set Key  4 TO Keluar
nPilih:=aChoice(09,66,17,77,aPilih)
Set Key 28 TO
Set Key 19 TO
Set Key  4 TO
IF LastKey()=27 .OR. nGK=28
   RESTSCREEN(06,65,18,78,cS)
   RETURN
ENDIF
SETCOLOR(cOld)
cKeyy:=LEFT(aPilih[nPilih],3)
RESTSCREEN(06,65,18,78,cS)
RETURN

*-----------------------------------------------------------------------------
STATIC PROCEDURE HoldMess(cHead)
SET DEVI TO PRINT
cGDFlag:='' ;cGDDesc:='' ;cGKey:=''
nGDisc:=0   ;nGStl:=0    ;nGPFlag:=0 ;cGRBON:=''
@ PROW()+02,00 SAY REPL('Ä',40)
JPrint(PROW()   ,40,REPL('Ä',40))
@ PROW()+01,00 SAY PDWidth(Left(cHead+space(19),19)+' '+cHead)
@ PROW()+01,03 SAY DTOC(DATE())+'þ'+TIME()
JPrint(PROW()   ,42,DTOC(DATE())+'þ'+TIME())
@ PROW()+01,00 SAY REPL('Ä',40)
JPrint(PROW()   ,40,REPL('Ä',40))
PCutter()
SET DEVI TO SCREEN
RETURN

*-----------------------------------------------------------------------------
STATIC PROCEDURE AllView()
lGStl:=.F. ;nGStl:=0 ;nGBrs:=8
aDSC:={'STD','D%1','D%2','D%3','DS1','DS2','DS3'}
SELECT TEMP
//teMP->(DBGOTO(2))
//cBB:=TEMP->RBON
//S_Print('NOMOR BON ==> '+SPACE(20)+RIGHT('      '+cBB,6))
FOR nD:=1 TO LastRec()
    GO nD
//    IF cBB#TEMP->RBON .AND. TEMP->(!EMPTY(RBON)) .AND. nD>=2 .AND. ;
//       TEMP->FLAG#'BON'    // KARENA nD=1 new flagnya
//       cBB:=TEMP->RBON
//       S_Print('NOMOR BON ==> '+SPACE(20)+RIGHT('      '+cBB,6))
//    ENDIF
    DO CASE
//       CASE FLAG='BON'
//         S_Print(REPLI('-',40))
//         S_Print('JUMLAH BON '+CODE+SPACE(10)+TRAN(PRICE,'999,999,999'))
//         S_PRINT(REPLI(' ',40))
       CASE FLAG='STL'
            ViewTrn(0)
            nD++
            GO nD
            IF FLAG='D%' .OR. FLAG='DS'
               nGStl+=PRICE
               ViewTrn(0)
            ENDIF
       CASE FLAG='STD'
            nGStl+=PRICE
            ViewTrn(1)
       CASE FLAG='PCG'
            ViewTrn(0)
       CASE AScan(aDSC,FLAG)>0
            nGStl+=PRICE
            ViewTrn(0)
       CASE AScan({'PLU','VOD','RTN','P/O','R/A'},FLAG)>0
            nGStl+=PRICE*QTY
            ViewTrn(1)
    ENDCASE
NEXT
RETURN 

