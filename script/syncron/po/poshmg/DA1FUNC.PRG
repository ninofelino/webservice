#include "hmg.ch"
#include "kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION DA1Func(c,n,a) &&_______________Discount Dengan Input NOMINAL(Amount)
SELECT TOMBOL ;GO TOP
LOCATE FOR ASCII=LASTKEY()
IF ASSIGN#_DA1  ;GO _DA1
   cDESC:=INTERN;ELSE
   cDESC:=ASGNNM
ENDIF
RETURN DA(@c,@n,@a,'DS1',cDESC)
*-----------------------------------------------------------------------------
FUNCTION DA2Func(c,n,a) &&_______________Discount Dengan Input NOMINAL(Amount)
SELECT TOMBOL ;GO TOP
LOCATE FOR ASCII=LASTKEY()
IF ASSIGN#_DA2  ;GO _DA2
   cDESC:=INTERN;ELSE
   cDESC:=ASGNNM
ENDIF
RETURN DA(@c,@n,@a,'DS2',cDESC)
*-----------------------------------------------------------------------------

FUNCTION DA3Func(c,n,a) &&_______________Discount Dengan Input NOMINAL(Amount)
SELECT TOMBOL ;GO TOP
LOCATE FOR ASCII=LASTKEY()
IF ASSIGN#_DA3  ;GO _DA3
   cDESC:=INTERN;ELSE
   cDESC:=ASGNNM
ENDIF
RETURN DA(@c,@n,@a,'DS3',cDESC)
*-----------------------------------------------------------------------------
FUNCTION DA(c,n,a,cFLAG,cDESC) &&_______________Discount Dengan Input NOMINAL(Amount)
LOCAL cA:=ALIAS(),nAmount:=INT(VAL(c)),nD:=0
SELECT TEMP
GO BOTT
DO CASE
CASE TEMP->PRICE=0
     Wrong(' Harga Belum Ada, Salah Tombol - tekan [CLEAR] ... ! ')
     c:=' '
     RETURN .T.
CASE nAmount=0
     Wrong(' Nilai Kosong, Salah Tombol - tekan [CLEAR] ... ! ') 
     c:=''
     RETURN .T.
CASE lGStl           &&______________________________________Var Memory Global
     IF nAmount>=Abs(nGStl) &&___________________________Add 28 Nov 95, Widi...
	Wrong(' Discount tidak boleh lebih besar dari Harga - tekan [CLEAR] ... ! ')
	lVld:= .F.
	RETURN .T.
     ENDIF
     nGDisc:=nAmount &&____Global Variable Diisi dengan NOMINAL(Tanpa Desimal)
     cGDFlag:=cFLAG  &&_______Isi Variable Global Agar Bisa Dipakai Oleh 'STL'
     cGDDesc:=cDESC  &&_______Isi Variable Global Agar Bisa Dipakai Oleh 'STL'

     IF lVld         &&_________Kembalikan Togle Global Flag Menjadi .F.
	lVld:=.F. 
	VldSub()
     ENDIF
     lGStl:=.F.      &&_______________Kembalikan Togle Global Flag Menjadi .F.
//   ViewTrn(0,.F.)
     nD:=If(nGDisc>.99,nGDisc*If(nGStl>=0,1,-1),Int(nGDisc*nGStl))*(-1)
     @ 21,66 SAY Trans(nGStl    ,' 999,999,999')
     @ 22,60 SAY If(nGDisc>0 .AND. nGDisc<1,Str(nGDisc*100,2)+'%','   ')
     @ 22,66 SAY Trans(nD       ,' 999,999,999')+If(lGStl,'*',' ')
     @ 24,66 SAY Trans(nGStl+nD ,' 999,999,999')

     nD:=If(nGDisc>.99,nGDisc*If(nGStl>0,1,-1),Int(nGDisc*nGStl))*(-1)

     AddRec()
     FIELD->FLAG  := 'STL'
     FIELD->DESC  := 'SUBTOTAL'
     FIELD->QTY   := 1
     FIELD->PRICE := nGStl
     FIELD->NORCP := SATELITE->NORCP
     FIELD->ETYPE := 'A'
//   ViewTrn(0)
     SET DEVI TO PRINT
     @ PRow()+1 ,00 SAY 'SUBTOTAL'
     @ PRow()   ,29 SAY nGStl PICT ' 99,999,999'
     JPrint(PRow(),40,'SUBTOTAL')
     JPrint(PRow()   ,69,nGStl,' 99,999,999')
     @ PRow()   ,PCol() SAY CHR(13)

     IF !cGDFlag==""
	nGStl+=nD
	AddRec()
	FIELD->FLAG  := cGDFlag
	FIELD->DESC  := cGDDesc
	FIELD->QTY   := 1         //If(nGDisc>.99,0,nGDisc*100)
//      FIELD->PRICE := If(nGDisc>.99,nGDisc,(nGDisc*nGStl))*(-1) //Dar 15/11
	FIELD->PRICE := nGDisc*IF(nGStl>=0,(-1),1)
	FIELD->NORCP := SATELITE->NORCP
	FIELD->ETYPE := 'A'
	@ PRow()+1 ,00 SAY if(nGDisc>.99,'',Trans(nGDisc*100,'99% '))+Left(cGDDesc,20)
        @ PRow()   ,29 SAY nD    PICT ' 99,999,999'
        JPrint(PRow(),40,if(nGDisc>.99,'',Trans(nGDisc*100,'99% '))+Left(cGDDesc,20))
        JPrint(PRow(),69,nD,' 99,999,999')
	@ PRow()   ,PCol() SAY CHR(13)
     ENDIF
     SET DEVI TO SCREEN

     nGDisc:=0
     cGDFlag:=''
     cGDDesc:=''
CASE FLAG='PLU'.AND.PRICE=0
     Wrong(' Harga Belum Ada, tekan [CLEAR] ... ! ') ;RETURN .T.
CASE PRICE#0.AND.ASCAN({'PLU','VOD','RTN'},ALLTRIM(FLAG))>0
//___IF nAmount>PRICE.AND.!lGRTN_____________________Perbaikan di bawah ini...
//   IF nAmount>Abs(PRICE) &&___________________________Cor 28 Nov 95, Widi...
     IF nAmount>=Abs(QTY*PRICE) &&_______________________Cor 29 Des 95, Dar....
	Wrong(' Discount tidak boleh lebih besar dari Harga - tekan [CLEAR] ... ! ')
	c:=''
	RETURN .T.
     ENDIF
     nPRICE:=(nAmount)*IF(FLAG='PLU',-1,1)
     nQTY:=QTY;cCODE:=CODE
     AddRec()
     FIELD->FLAG :=cFLAG
     FIELD->CODE :=cCODE
     FIELD->DESC :=cDESC
     FIELD->QTY  :=1
     FIELD->PRICE:=nPRICE                          //*nQTY_Dar 13/11
     FIELD->NORCP:=SATELITE->NORCP
     FIELD->ETYPE:='K'
     nGStl+=PRICE
     ViewTrn(0)
OTHERWISE
     Wrong(' Salah Tombol - tekan [CLEAR] ... ! ') 
     c:=''
     RETURN .T.
ENDCASE
c:=''
CLSFunc()
RETURN .T.
*-----------------------------------------------------------------------------
