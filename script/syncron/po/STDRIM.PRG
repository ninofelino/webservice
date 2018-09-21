#include "kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION STDRim(c,n,a) &&______________Discount PERSENTASE(%) Untuk SUB TOTAL khusus rimo
LOCAL cA:=ALIAS(),nPersen:=INT(VAL(c)),cDesc:='',nPrice:=0,nItem:=0,nSTR:=0
SELECT TOMBOL ;GO TOP
LOCATE FOR ASCII=LASTKEY()
IF !FOUND()
   RETURN .T.
ENDIF
cDESC:=ASGNNM
SELECT TEMP ;GO BOTT
GnPrice:=0             // 20
DO CASE
 CASE VAL(c)#0
     Warning(' Tidak Perlu Memasukkan Nilai Discount  ... ! ') ;RETURN .T.
// CASE FLAG='PLU' .AND. PRICE=0
//      Warning(' Harga Belum Ada, Salah Tombol ... ! ') ;RETURN .T.
CASE PRICE#0.AND.ASCAN({'PLU','VOD','RTN','D%1','D%2','D%3','STD','STL','DS1','DS2','DS3'},ALLTRIM(FLAG))>0
     nPRICE:=0
     nItem:=0
     DO WHILE !BOF() .and. temp->flag='STR'
        IF ASCAN({'CRC','PCG','NEW','STL','STR'},ALLTRIM(FLAG))=0
           nItem=nItem+IF(ASCAN({'D%1','D%2','D%3','DS1','DS2','DS3','STR','STD'},ALLTRIM(FLAG))=0,QTY,0)
           nPRICE+=(PRICE*QTY)
//           IF FLAG='STL'
//              nPRICE-=(PRICE*QTY)
//           ENDI
        ENDIF
        SKIP -1
        IF FLAG='STD'     // 20
           EXIT
        ENDI
     ENDDO
     GnPrice=nPrice   // 20      untuk percent....
     nPRICE:=ROUND(nPRICE*(nPersen/100)*(-1),0)
     AddRec()
     FIELD->FLAG :='STR'
     FIELD->CODE :=STR(nItem,2)
// 20
     If (nPersen#0,FIELD->DESC :=LTrim(Trans(nPersen,'99% '))+cDESC,FIELD->DESC :=cDESC)
// 20
     FIELD->QTY  :=0
     FIELD->PRICE:=0           // nPRICE
     FIELD->NORCP:=SATELITE->NORCP
     FIELD->ETYPE:='K'
OTHERWISE
     Warning(' Salah Tombol ........ ! ') ;RETURN .T.
ENDCASE
nGStl+=PRICE;ViewTrn(1) ;c:='' ;CLSFunc()
VldKeys(@c,@n,@a)   // tidak perlu menekan tombol Validasi lagi 20
RETURN .T.
*-----------------------------------------------------------------------------
