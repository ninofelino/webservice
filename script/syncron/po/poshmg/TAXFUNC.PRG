#include "hmg.ch"
#include "kassa.ch"
*-----------------------------------------------------------------------------

FUNCTION TAXFunc(c,n,a)                    &&___TAX Dengan Input PERSENTASE(%)
SELECT TOMBOL ;GO TOP                      &&___4500
LOCATE FOR ASCII=LASTKEY()
IF ASSIGN#_TAX  ;GO _TAX
   cDESC:=INTERN;ELSE
   cDESC:=ASGNNM
ENDIF
RETURN TX(@c,@n,@a,'TAX',cDESC)

*-----------------------------------------------------------------------------

FUNCTION TX(c,n,a,cFLAG,cDESC)
LOCAL cA:=ALIAS(),nPersen:=INT(VAL(c)),cDisc:='',nD:=0
SELECT TEMP ;GO BOTT
DO CASE
CASE nPersen=0
     Wrong(' Persentase Kosong - tekan [CLEAR] ... ! ')
     c:=''
     RETURN .T.
CASE LEN(c)>2
     Wrong(' Max. 2 Digit - tekan [CLEAR] ... ! ')
     lVld:=.F. 
     c:=''
     RETURN .T.
CASE lGStl               &&________________________________Var Memory Global
     nGDisc:=nPersen/100 &&_____________Global Variable Diisi dengan DESIMAL
     cGDFlag:=cFLAG      &&_Isi Variable Global Agar Bisa Dipakai Oleh 'STL'
     cGDDesc:=cDESC      &&_Isi Variable Global Agar Bisa Dipakai Oleh 'STL'
     IF lVld             &&_________Kembalikan Togle Global Flag Menjadi .F.
        lVld:=.F. 
        VldSub()
     ENDIF
     lGStl:=.F.          &&_________Kembalikan Togle Global Flag Menjadi .F.
//   ViewTrn(0,.F.)
//   nD:=If(nGDisc>.99,nGDisc*If(nGStl>0,1,-1),Int(nGDisc*nGStl))*(-1)
     nD:=If(nGDisc>.99,nGDisc*If(nGStl>0,-1,1),Int(nGDisc*nGStl))*(1)
     @ 22,13 SAY Trans(nGStl    ,' 999,999,999')
     @ 22,59 SAY If(nGDisc>0 .AND. nGDisc<1,Str(nGDisc*100,2)+'%','   ')
     @ 22,65 SAY Trans(nD       ,' 999,999,999')+If(lGStl,'*',' ')
     @ 23,13 SAY Trans(nGStl+nD ,' 999,999,999')

//   nD:=If(nGDisc>.99,nGDisc*If(nGStl>0,1,-1),Int(nGDisc*nGStl))*(-1)
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
     JPrint(PRow()   ,40, 'SUBTOTAL')
     JPrint(PRow()   ,62, nGStl, ' 99,999,999')
     @ PRow()   ,PCol() SAY CHR(13)

     IF !cGDFlag==""
        nGStl+=nD
        AddRec()
        FIELD->FLAG  := cGDFlag
        FIELD->DESC  := cGDDesc
        FIELD->QTY   := 1           //If(nGDisc>.99,0,nGDisc*100)
        FIELD->PRICE := ROUND(nD,0) //If(nGDisc>.99,nGDisc,(nGDisc*nGStl))*(-1)
        FIELD->NORCP := SATELITE->NORCP
        FIELD->ETYPE := 'A'
        @ PRow()+1 ,00 SAY if(nGDisc>.99,'',Trans(nGDisc*100,'99% '))+Left(cGDDesc,20)
        @ PRow()   ,29 SAY PRICE PICT ' 99,999,999'
        JPrint(PRow()   ,40, if(nGDisc>.99,'',Trans(nGDisc*100,'99% '))+Left(cGDDesc,20))
        JPrint(PRow()   ,62, PRICE, ' 99,999,999')
        @ PRow()   ,PCol() SAY CHR(13)
     ENDIF
     SET DEVI TO SCREEN

     nGDisc:=0
     cGDFlag:=''
     cGDDesc:=''

CASE FLAG='PLU' .AND. PRICE=0
     Wrong(' Harga Belum Ada, Salah Tombol - tekan [CLEAR] ...! ')
     c:=''
     RETURN .T.
CASE PRICE#0.AND.ASCAN({'PLU','VOD','RTN'},ALLTRIM(FLAG))>0
     nPRICE:=PRICE*(nPersen/100)*(1)
     cCODE:=CODE
     nQTY:=QTY
     AddRec()
     FIELD->FLAG :=cFLAG
     FIELD->CODE :=cCODE
     FIELD->DESC :=cDESC
     FIELD->QTY  :=1
     FIELD->PRICE:=ROUND(nPRICE*nQTY,0)
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
