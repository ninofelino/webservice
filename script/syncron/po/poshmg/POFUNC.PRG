#include "hmg.ch"
#include "kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION POFunc(c,n,a) &&_____________________________________________Paid Out
LOCAL cA:=ALIAS(),nPayOut:=INT(VAL(c)),cKet:=Space(30),cSCr:=SaveScreen(15,00,24,79)
SELECT TOMBOL ;GO TOP
LOCATE FOR ASCII=LASTKEY()
cFLAG:='P/O'
cDESC:=ASGNNM

SELECT TEMP ;GO TOP ;SKIP
DO CASE
CASE nPayOut=0
     Warning(' Nominal Kosong, Salah Tombol ... ! ') ;RETURN .T.
CASE !EOF().AND.FLAG#'P/O'
     Warning(' Pay Out, Salah Tombol...! ') ;RETURN .T.
CASE LEN(c)>7
     Warning(' Pay Out Max. 7 Digit, Salah Tombol ... ! ') ;RETURN .T.
CASE FLAG='P/O'.OR.EOF()
     cScr:=SaveScreen(15,00,24,79)
     @ 16,23 CLEAR TO 18,57
     @ 16,23 TO 18,57
     @ 16,26 SAY 'Keterangan Pengambilan (P/O)'
     @ 17,25 GET cKet PICT '@!'
     READ
     IF Lastkey()=27
        RestScreen(15,00,24,79,cScr)
        c:='' ;Clsfunc()
        RETURN .T.
     ENDIF
     cGKey:=CHR(200-_PO)+CHR(200-_B_SPC)+CHR(200-_CLEAR)+CHR(200-_HLD)+;
            CHR(200-_CRC)+CHR(200-_T01)+CHR(200-_T02)+CHR(200-_T03)+;
            CHR(200-_T04)+CHR(200-_T05)+CHR(200-_T06)+CHR(200-_T07)+;
            CHR(200-_T08)+CHR(200-_T09)+CHR(200-_T10)+CHR(200-_T11)+;
            CHR(200-_T12)+CHR(200-_T13)+CHR(200-_T14)
     a:=GetPosKey(cGKey)
     New()
     AddRec()
     FIELD->FLAG :=cFLAG
     FIELD->CODE :=Time()
     FIELD->DESC :=cKet //cDESC
     FIELD->QTY  :=1
     FIELD->PRICE:=nPayOut*(-1)
     FIELD->NORCP:=SATELITE->NORCP
     FIELD->ETYPE:='K'
     nGStl+=PRICE
OTHERWISE
     Warning(' Salah Tombol ... ! ') ;RETURN .T.
ENDCASE
RestScreen(15,00,24,79,cScr)
ViewTrn(1) ;c:='' ;CLSFunc()
RETURN .T.
