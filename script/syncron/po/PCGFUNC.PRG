#include "kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION PCGFunc(c,n,a) &&___For Replacing The Price that Exist, If '0' Reject
LOCAL cA:=ALIAS(),nPRICE:=INT(VAL(c)) ,cFlag:=''
SELECT TEMP ;GO BOTT
IF PRICE=0.OR.nPRICE=0
   Warning(' Harga Tidak Boleh Nol, Salah Tombol ... ! '); RETURN .T.
ENDIF
IF ASCAN({'PLU','VOD','RTN'},FLAG)>0
   cFlag:=FLAG
   FIELD->FLAG :='PCG'
   cCODE :=FIELD->CODE
   cDESC :=FIELD->DESC
   nQTY  :=FIELD->QTY
   cNORCP:=FIELD->NORCP
   cETYPE:=FIELD->ETYPE
// nGStl-=PRICE                                    // Dar 4/11
   nGStl-=QTY*PRICE                                // Dar 4/11
   AddRec()
   FIELD->FLAG :=cFlag
   FIELD->CODE :=cCODE
   FIELD->DESC :=cDESC
   FIELD->QTY  :=nQTY
   FIELD->PRICE:=nPRICE*IF(ASCAN({'VOD','RTN'},FLAG)=0,1,-1)
   FIELD->NORCP:=cNORCP
   FIELD->ETYPE:='K'
// nGStl+=PRICE                                    // Dar 4/11
   nGStl+=QTY*PRICE                                // Dar 4/11
   ViewTrn(0)
ELSE 
   Warning(' Salah Tombol ... ! '); RETURN .T.
ENDIF
c:='' ;CLSFunc()
RETURN .T.
*-----------------------------------------------------------------------------
