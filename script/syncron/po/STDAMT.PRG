#include "kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION STDFunc(c,n,a) &&______________Discount PERSENTASE(%) Untuk SUB TOTAL
LOCAL cA:=ALIAS(),nPersen:=VAL(c),cDesc:='',nPrice:=0,nItem:=0
SELECT TOMBOL ;GO TOP
LOCATE FOR ASCII=LASTKEY()
IF !FOUND()
   RETURN .T.
ENDIF
cDESC:=ASGNNM
SELECT TEMP ;GO BOTT
DO CASE
CASE Val(c)=0
     Warning(' Discount masih nol ... ! ') ;RETURN .T.
CASE FLAG='PLU' .AND. PRICE=0
     Warning(' Harga Belum Ada, Salah Tombol ... ! ') ;RETURN .T.
CASE PRICE#0.AND.ASCAN({'PLU','VOD','RTN','D%1','D%2','D%3','DS1','DS2','DS3'},ALLTRIM(FLAG))>0
     nPRICE:=0
     nItem:=0
     DO WHILE !BOF().AND.FLAG#'STD'
        IF ASCAN({'CRC','PCG','NEW'},ALLTRIM(FLAG))=0
           nPRICE+=(PRICE*QTY)
           nItem=nItem+IF(ASCAN({'D%1','D%2','D%3','DS1','DS2','DS3'},ALLTRIM(FLAG))=0,1,0)
	ENDIF
        SKIP -1
     ENDDO
     nPRICE:=(nPRICE-nPersen)*(-1)
     ?nPRICE
     ?inkey(0)
     AddRec()
     FIELD->FLAG :='STD'
     FIELD->CODE :=STR(nItem,2)
     FIELD->DESC :=LTrim(Trans(nPersen,'99% '))+cDESC
     FIELD->QTY  :=1
     FIELD->PRICE:=nPRICE
     FIELD->NORCP:=SATELITE->NORCP
     FIELD->ETYPE:='K'
OTHERWISE
     Warning(' Salah Tombol ... ! ') ;RETURN .T.
ENDCASE
nGStl+=PRICE ;ViewTrn(1) ;c:='' ;CLSFunc()
RETURN .T.
*-----------------------------------------------------------------------------
