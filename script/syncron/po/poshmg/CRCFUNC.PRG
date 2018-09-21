#include "hmg.ch"
#include "kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION CRCFunc(c,n,a)
LOCAL cA:=ALIAS()
LOCAL nD:=0,cD:=0
SELECT TEMP
GO BOTT

DO CASE
CASE FLAG = "CRC"
     Wrong(' Record Sudah Di CRC - tekan [CLEAR] ... ! ')
     c:=''
     RETURN .T.
CASE PRICE=0
     Wrong(' Harga Belum Ada, Salah Tombol - tekan [CLEAR] ... ! ')
     c:=''
     RETURN .T.
CASE ASCAN({'D%1','D%2','D%3','DS1','DS2','DS1',},ALLTRIM(FLAG))>0
     Reclock()
     FIELD->FLAG := 'CRC'
     nGStl-=PRICE
     SET DEVICE TO PRINT
     @ PRow(),00 SAY _PINIT+_PALL
     @ PRow(),00 SAY Replicate('=',40)
     JPrint(PRow(),40,Replicate('=',40))
     @ PRow(),00 SAY Chr(13)

     SKIP -1

     IF FIELD->FLAG # 'STL'
        Reclock()
        FIELD->FLAG := 'CRC'
        nGStl-=PRICE*QTY
        @ PRow()+1,00 SAY 'CRC# '
        @ PRow()  ,29 SAY (PRICE)*(QTY)*(-1)  PICT ' 99,999,999'
        JPrint(PRow()  ,40,'CRC#')
        JPrint(PRow()  ,69,(PRICE)*(QTY)*(-1) ,' 99,999,999')
        @ PRow()  ,00 SAY Chr(13)
        DBUnLock()
     ENDIF

     SET DEVICE TO SCREEN

     cD:=AllTrim(Trans(nGStl,'999,999,999'))
     nD:=If(nGDisc>.99,nGDisc,nGDisc*nGStl)

     IF FIELD->FLAG # 'STL'
        @ nGbrs,02 SAY FLAG
        @ nGbrs,41 SAY 0 PICT         '999'
        @ nGbrs,45 SAY 0 PICT   '99999,999'
        @ nGbrs,55 SAY 0 PICT          '99'
        @ nGbrs,58 SAY 0 PICT   '99999,999'
        @ nGbrs,68 SAY 0 PICT  '99,999,999'
     ENDIF

     @ 22,13 SAY Trans(nGStl   ,' 999,999,999')
     @ 22,39 SAY Trans(nD      ,' 999,999,999')
     @ 23,13 SAY Trans(nGStl-nD,' 999,999,999')

     Angka(19,1,(Space(13-Len(cD))+cD))
     //Com_Open(3) ;Com_Init(3,09600,'O',8,1)
     //cD:=Str(QTY,3)+'-->'+TransForm(PRICE,'Rp 999,999,999')
     //Com_Send(3,Chr(27)+'[1;1H'+'CRC#') &&___________________Line_1
     //Com_Send(3,Chr(27)+'[2;1H'+cD) &&_______________________________________Line_2
     //Com_Close(3)

OTHERWISE
     cC:=CODE ;nQ:=QTY
     Reclock()
     FIELD->FLAG := 'CRC'
     nGStl-=PRICE*QTY
     GO BOTT
     ViewTrn(0)
     DBUnLock()
     IF PRODUK->(DBSeek(cC)) .AND. PRODUK->(Reclock())
        PRODUK->STOCK+=nQ
        DBUnLock()
     ENDIF
ENDCASE
GO BOTT
c:=''
RETURN .T.
*-----------------------------------------------------------------------------
