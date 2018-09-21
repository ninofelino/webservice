#include "hmg.ch"
#include "kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION AMTFunc(c,n,a) &&______For Replacing Zero(0) Price, If Not '0' Reject
LOCAL nPRICE:=INT(VAL(c))
LOCAL cA:=ALIAS()
LOCAL aF:={}, i
SELECT TEMP ;GO BOTT
nQTY:=TEMP->QTY
IF nPRICE=0
   IF PRICE # 0 .AND. ASCAN({"PLU","RTN","VOD"},FLAG) > 0
      FOR i:=1 TO FCOUNT()
          AADD(aF,FIELDGET(I))
      NEXT
      nGStl+=PRICE*QTY
      APPEND BLANK
      i:=0
      AEVAL(aF,{|c|i++ ,FIELDPUT(i,c) })
      IF _ICS#1
         IF PRODUK->(DBSEEK(TEMP->CODE))
            IF (nQTY > PRODUK->STOCK       .AND. PRODUK->CHK=.T.) .OR. ;
               (PRODUK->STOCK <= nGStockC  .AND. PRODUK->CHK=.T.)
               Warning(' QTY Produk mencapai MINIMUM ... !')
            ENDIF
            IF PRODUK->(Reclock())
               PRODUK->STOCK-=nQTY
               PRODUK->(DBUnLock())
            ENDIF
         ENDIF
      ENDIF
      ViewTrn(1)
   ENDIF
ELSEIF nPRICE*QTY>99999999
   Warning(' Total Harga Max. 8 Digit, Salah Tombol ... ! ')
ELSEIF AScan({'PLU','VOD','RTN'},FLAG)>0.AND.PRICE=0
   IF !lGVOD
      IF !lGRTN
         PLU(@c,@n,@a)
      ELSE
         RTN(@c,@n,@a)
      ENDIF
   ELSE
      VOD(@c,@n,@a) 
   ENDIF
ELSE 
   Warning(' Salah Tombol ... ! ')
ENDIF
c:=''
CLSFunc()
RETURN .T.

*-----------------------------------------------------------------------------
STATIC PROCEDURE PLU(c,n,a)
LOCAL  nPRICE:=INT(VAL(c))
FIELD->PRICE:=nPRICE
nGStl+=PRICE*QTY
IF lGHpHr .AND. PRODUK->HAPPY>0
   nHH:=PRODUK->HAPPY
   cTm :=Left(Time(),5)+':00'
   cTm1:=SATELITE->TIME1
   cTm2:=SATELITE->TIME2
   IF TimeToSec(cTm)>=TimeToSec(cTm1) .AND. TimeToSec(cTm)<=TimeToSec(cTm2)
       nPct:=50      //HAPPY->PCT
       nPRICE:=PRODUK->(IF(nPct<=0,PRICE2,PRICE-(PRICE*nPct/100)))
   ENDIF
ENDIF
IF _ICS#1
   IF PRODUK->(DBSEEK(TEMP->CODE))
      IF (nQTY > PRODUK->STOCK       .AND. PRODUK->CHK=.T.) .OR. ;
         (PRODUK->STOCK <= nGStockC  .AND. PRODUK->CHK=.T.)
         Warning(' QTY Produk mencapai MINIMUM ... !')
      ENDIF
      IF PRODUK->(Reclock())
         PRODUK->STOCK-=nQTY
         PRODUK->(DBUnLock())
      ENDIF
   ENDIF
ENDIF
*FIELD->TAX   :=Round(IF(PRODUK->FNB='1',(nPRICE*QTY)*nPajak,0),0)
*FIELD->FNB   :=IF(PRODUK->FNB='1',.T.,.F.)
ViewTrn(0)
RETURN

*-----------------------------------------------------------------------------
STATIC PROCEDURE VOD(c,n,a)
LOCAL nD,cD:=CODE,nX:=0,nI:=0,nPRICE:=INT(VAL(c))
LOCAL aDSC:={'STD','D%1','D%2','D%3','DS1','DS2','DS3'}
FOR nD:=1 TO LastRec()-1
    GO nD
    DO CASE
    CASE AScan(aDSC,FLAG)>0 .AND. CODE=cD ;nX+=PRICE
    CASE AScan({'PLU','VOD','RTN','P/O','R/A'},FLAG)>0 
       IF CODE=cD ;nI+=QTY*(Abs(PRICE)/PRICE) ;ENDIF
//        IF CODE=cD ;nI+=PRICE/PRICE ;ENDIF
          nX+=(PRICE*QTY) &&  *If(lGRTN,-1,1)     &&__Penting...!
    ENDCASE 
NEXT
GO BOTTOM
IF nPRICE*QTY>nX .OR. QTY>nI*If(lGRTN,-1,1)  &&__Penting...!
   Warning(' Nilai / Qty Kurang, Tidak Bisa Di VOID ... ! ')
   @ nGBrs+1,2 SAY '   ' ;c:=''
   RETURN .T.
ENDIF
FIELD->PRICE:=nPRICE*-1*If(lGRTN,-1,1)
nGStl+=PRICE*QTY
IF _ICS#1
   IF PRODUK->(DBSEEK(TEMP->CODE))
      IF PRODUK->(Reclock())
         PRODUK->STOCK+=nQTY
         PRODUK->(DBUnLock())
      ENDIF
   ENDIF
ENDIF
ViewTrn(0)
lGVOD:=.f.
RETURN

*-----------------------------------------------------------------------------
STATIC PROCEDURE RTN(c,n,a)
LOCAL  nPRICE:=INT(VAL(c))
FIELD->PRICE:=nPRICE*-1
nGStl+=PRICE*QTY
IF _ICS#1
   IF PRODUK->(DBSEEK(TEMP->CODE))
      IF PRODUK->(Reclock())
         PRODUK->STOCK+=nQTY
         PRODUK->(DBUnLock())
      ENDIF
   ENDIF
ENDIF
ViewTrn(0)
RETURN

*-----------------------------------------------------------------------------
