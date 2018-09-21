#include "hmg.ch"
#include "Kassa.ch"
#include "Box.ch"

*-----------------------------------------------------------------------------
FUNCTION VIPFunc(c,n,a)
LOCAL nX:=0,nChoice:=0
LOCAL nFile:=0,cFileHold:='',cFileTemp:=''
PRIVATE cKeyy,nGK:=0

SELECT TEMP 
IF LASTREC()=0                             &&__Tidak ada data
   DispFile()
   IF LastKey()=27.OR.nGK=28
   RETURN .T. ;ENDIF
ENDIF
c:=''
CLSFunc()
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION ConfirmMess()
LOCAL cOld:=SETCOLOR(),cScr:=''
cScr:=SAVESCREEN(06,68,11,78)
@ 06,68 CLEAR TO 11,78
SETCOLOR('N/W')
@ 06,68 SAY 'ÚÄÄÄÄÄÄÄÄÄ¿'
@ 07,68 SAY '³ CONFIRM ³'
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
LOCAL cS:='',cOld:=SETCOLOR(),cD,lC
cS:=SAVESCREEN(19,00,21,52)
TONE(2800,2)
TONE(3000,4)
TONE(2800,2)
TONE(3000,4)
@ 19,2,21,52 BOX B_DOUBLE+' '
@ 19,03 SAY '[ESC]->Batal'           COLOR 'W+'
@ 20,3 SAY ' Scan BarCode : '
Com_Open(1)  ;Com_Init(1,19200,"N",8,1) ;Com_Dtr(1,.T.)
Com_Open(2)  ;Com_Init(2,19200,"N",8,1) ;Com_Dtr(2,.T.)
i:=0
DO WHILE i#27
   Com_Flush(1)
   Com_Flush(2)
   SetPos(20,19)
   i=Inkey(.5)
   IF !Empty(cD:=Com_Read(1)) .OR. !Empty(cD:=Com_Read(2))
      @ 20,19 SAY cD COLOR 'w+'
      cD:=AllTrim(StrTran(cD,Chr(0),''))
     *c=FilterNum(Left(cD,13))
      lC:=ConfirmMess()
      IF lC ;cGVipNo:=cD
      ENDIF
      c:=''
      EXIT
   ENDIF
ENDDO
Com_Close(2)
Com_Close(1)
IF ALLTRIM(cD)#'0'
   SET DEVICE TO PRINT
   @ PRow()   ,00 SAY _PINIT+_PALL
   @ PRow()+1 ,00 SAY 'Cus: '+cD
   @ PRow()   ,40 SAY 'Cus: '+cD
   @ PRow()   ,40 SAY CHR(13)
   SET DEVICE TO SCREEN
ENDIF
Set Key 28 TO Keluar
Set Key 19 TO Keluar
Set Key  4 TO Keluar
Set Key 28 TO
Set Key 19 TO
Set Key  4 TO
SETCOLOR(cOld)
RESTSCREEN(19,00,21,52,cS)
RETURN

*-----------------------------------------------------------------------------
STATIC PROCEDURE HoldMess(cHead)
SET DEVI TO PRINT
cGDFlag:='' ;cGDDesc:='' ;cGKey:=''
nGDisc:=0   ;nGStl:=0    ;nGPFlag:=0 ;cGRBON:=''
@ PROW()+02,00 SAY REPL('Ä',40)
@ PROW()   ,40 SAY REPL('Ä',40)
@ PROW()+01,00 SAY PDWidth(Left(cHead+space(19),19)+' '+cHead)
@ PROW()+01,03 SAY DTOC(DATE())+'þ'+TIME()
@ PROW()   ,42 SAY DTOC(DATE())+'þ'+TIME()
@ PROW()+01,00 SAY REPL('Ä',40)
@ PROW()   ,40 SAY REPL('Ä',40)
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
*-----------------------------------------------------------------------------
Static Function FilterNum(cS)
LOCAL  nI,nT:=Len(cS),cD,cT:=''
FOR nI:=1 TO nT
    cD:=SubS(cS,nI,1)
    IF IsDigit(cD)
       cT+=cD
    ENDIF
NEXT
RETURN cT
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

