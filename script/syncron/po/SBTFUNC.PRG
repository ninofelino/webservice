*-----------------------------------------------------------------------------
FUNCTION SBTFunc(c,n)
LOCAL cD:='',nD:=0,nQ:=0,nA:=0,cDs,lPromo:=.F.,lQ:=.F.,nDisc:=0,lDisc:=.F.
LOCAL aF:={'PLU','RTN','VOD','DS1','DS2','DS3','D%1','D%2','D%3'}
LOCAL aP:={'PLU','RTN','VOD'}
LOCAL aD:={'DS1','DS2','DS3','D%1','D%2','D%3'}
PRIVATE nQtyD1,nQtyD2,nQtyD3,nQtyD4,nQtyD5,aDisc:={}

IF TEMP->PRICE=0
   Wrong(' Harga Belum Ada, Salah Tombol - tekan [CLEAR] ... ! ')
   c:=''
   RETURN .T.
ENDIF
lGStl:=!lGStl
@ 21,78 SAY If(lGStl,'*',' ') COLOR 'w+'
IF nGDisc>.9
     nD:=nGDisc
     cD:=Tran(nGDisc    ,'Rp 999,999')
ELSE
     cD:=Tran(nGDisc*100,' 999 %')
     nD:=nGStl * nGDisc
ENDIF

IF lGStl .AND. nSwGs=0
   nSwGs:=1
   nQ:=0 ;nA:=0 ;lPromo:=.F. ;lQ:=.F.
   GO TOP
   DO WHILE !Eof()
      IF FLAG='PLU' .OR. FLAG='RTN' .OR. FLAG='VOD'
         cCODE:=CODE
         IF PRODUK->(DBSeek(cCODE))
            lPromo:=.F.
            IF PRODUK->PROMO#0
               PROMO->(__dbLocate( {|| CODE=PRODUK->PROMO},,,, .F. ))
               IF PROMO->(Found())
                  nPct:=PROMO->PCT         ;cTm :=Left(Time(),5)+':00'
                  cTm1:=PROMO->TIME1+':00' ;cTm2:=PROMO->TIME2+':00'
                  IF Date()>=PROMO->DATE1 .AND. Date()<=PROMO->DATE2 .AND. ;
                   TimeToSec(cTm)>=TimeToSec(cTm1) .AND. TimeToSec(cTm)<=TimeToSec(cTm2)
                      lPromo:=.T.
                  ENDIF
               ENDIF
            ENDIF
            IF (!Empty(cGCCN) .AND. CUS->DISCOUNT>0)
               lQ:=.T.
               nQ+=(QTY)  //*IF(FLAG='PLU',1,-1))
               nA+=(QTY*PRICE)
            ENDIF
         ENDIF
      ENDIF
      SKIP
   ENDDO
   GO BOTT
   IF lQ .OR. nQ#0 .OR. CUS->DISCOUNT>0
      cA :=Str(Abs(nA)*nDisc/100)
      cDs:=nDisc
      aA:={nQ,Str(cDs,5,2)+'% '}
      IF !Empty(cGCCN) .AND. CUS->DISCOUNT>=cDs
         cA :=Str(Abs(nA)*(CUS->DISCOUNT/100))
         cDs:=CUS->DISCOUNT
         aA :={nQ,Str(cDs,5,2)+'% '}
      ENDIF
      IF Val(cA)>0
         DA1Func(@cA,,@aA)
      ENDIF
   ENDIF
ENDIF

CustDisp('SUBTOTAL:           ',Tran(nGStl-nD,'Rp  999,999,999')+Space(5))
@ 03,30 CLEAR TO 05,78
Angka(03,25,TRAN(nGStl-nD,'  999,999,999'),"W*/N")
RETURN .T.

*-----------------------------------------------------------------------------
FUNCTION GetDisc(nQ)
LOCAL nDisc:=0,nDisc1,nDisc2,nDisc3,nDisc4,nDisc5,lRet:=.F.
*-----------------------------------------------------------------------------

