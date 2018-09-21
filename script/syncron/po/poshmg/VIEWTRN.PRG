#include "hmg.ch"
#include "kassa.ch"
*-----------------------------------------------------------------------------
PROCEDURE ViewTrn(n,l)
LOCAL nD:=0,nT:=0,cD:=0,nDs:=0,nDp:=0,cDd:='',cDD1:=''
SELECT TEMP
DO CASE
CASE FLAG='NEW'
   RETURN .T.
CASE FLAG='STL'
   SET DEVI TO PRINT
   @ PRow()+1 ,00 SAY 'SUBTOTAL'
   @ PRow()   ,29 SAY nGStl PICT ' 99,999,999'
   JPrint(PRow()   ,40, 'SUBTOTAL')
   JPrint(PRow()   ,62, nGStl, ' 99,999,999')
   @ PRow(),0 SAY Chr(13)
   SET DEVICE TO SCREEN
   RETURN .T.
CASE FLAG='PCG'
   SET DEVICE TO PRINT
   @ PRow()+1,00 SAY QTY       PICT        '999'
   @ PRow()  ,04 SAY PRODUK->UNIT
   @ PRow()  ,08 SAY IF(lGCode,CODE,'')+' '+Left(DESC,13)  &&13
   JPrint(PRow()  ,40,IF(lGCode,CODE,'')+' '+Left(DESC,24))  &&13
   @ PRow()  ,00 SAY Replicate('-',40)
   JPrint(PRow()  ,40, Replicate('-',40))

   IF QTY>1
      nT:=PRICE*QTY
      @ PRow()+1,00 SAY QTY       PICT        '999x'
      @ PRow()  ,PCol() SAY PRICE PICT ' 99,999,999'
      @ PRow()  ,29 SAY nT        PICT ' 99,999,999'
      JPrint(PRow()  ,40,QTY, '999x')
      JPrint(PRow()  ,PCol(),PRICE, ' 99,999,999')
      JPrint(PRow()  ,69 ,nT, ' 99,999,999')
   ELSE
      @ PRow()  ,29 SAY PRICE     PICT ' 99,999,999'
      JPrint(PRow()  ,69,PRICE, ' 99,999,999')
   ENDIF
   @ PRow(),0 SAY Chr(13)
   SET DEVICE TO SCREEN
   RETURN .T.
CASE !lGStl .AND. (FLAG='D%' .OR. FLAG='DS' .OR. FLAG='TAX')
   cDd:=Left(DESC,20)
   nDs:=PRICE
   cD :=FLAG
   SKIP -1
   IF FLAG='STL'
      SET DEVICE TO PRINT
***      @ PRow()  ,00 SAY _PINIT+_PALL
      @ PRow()+1 ,00 SAY If(cD#'D%','',Trans(Abs(nDs/PRICE*100),'99% '))+Left(cDd,20)
      @ PRow()   ,29 SAY nDs PICT ' 99,999,999'
      JPrint(PRow()   ,40, If(cD#'D%','',Trans(Abs(nDs/PRICE*100),'99% '))+Left(cDd,20))
      JPrint(PRow()   ,69, nDs, ' 99,999,999')
      @ PRow()   ,PCol() SAY CHR(13)
      @ PRow(),0 SAY Chr(13)
      SET DEVICE TO SCREEN
      @ 22,60 SAY If(cD='D%',Trans(Abs(nDs/PRICE*100),'99%'),'   ')
      @ 22,66 SAY Trans(nDS  ,' 999,999,999')+If(lGStl,'*',' ')
      @ 23,66 SAY Trans(nGStl,' 999,999,999')
      cD:=AllTrim(Trans(nGStl,'999,999,999x'))
      Angka(03,1,(Space(13-Len(cD))+cD))
      RETURN .T.
   ENDIF
   IF cD='D%'
      nDp:=(nDs*-1)/(PRICE*QTY)
      nDp*=100
   ENDIF
   IF cD='TAX'
      nDp:=(nDs*1)/(PRICE*QTY)
      nDp*=100
   ENDIF
ENDCASE
DO CASE
CASE nGBrs>17 .AND. n#0
   SCroll(9,1,19,78,1)
   @ 19,02 SAY '   ³        ³                         ³   ³         ³  ³         ³          '
CASE nGBrs<8   ;nGBrs:=8
OTHERWISE      ;nGBrs+=n
ENDCASE
nT  :=PRICE*QTY+nDs
cD  :=AllTrim(Trans(nGStl,'999,999,999'))
cDD1:=AllTrim(Trans(PRICE,'999,999,999'))
nD  :=If(nGDisc>.99,nGDisc*If(nGStl>0,1,-1),Int(nGDisc*nGStl))*(-1)
@ nGbrs,02 SAY FLAG
@ nGbrs,06 SAY LEFT(CODE,8)
@ nGbrs,15 SAY If(FLAG='CRC','',Left(DESC,25))
IF FLAG='STD'
*  @ nGbrs,62 SAY QTY   PICT          '99'
   @ nGbrs,68 SAY PRICE PICT  '99,999,999'
ELSEIF FLAG#'CRC'
   @ nGbrs,41 SAY QTY   PICT         '999'
   @ nGbrs,45 SAY PRICE PICT   '99999,999'
   IF nDs#0
      @ nGbrs,55 SAY nDp PICT         '99'
      SKIP
   ENDIF
   @ nGbrs,58 SAY nDs   PICT   '99999,999'
   @ nGbrs,68 SAY nT    PICT  '99,999,999'
ELSE
   @ nGbrs,41 SAY 0 PICT         '999'
   @ nGbrs,45 SAY 0 PICT   '99999,999'
   @ nGbrs,62 SAY 0 PICT          '99'
   @ nGbrs,58 SAY 0 PICT   '99999,999'
   @ nGbrs,68 SAY 0 PICT  '99,999,999'
ENDIF
@ 21,66 SAY Trans(nGStl    ,' 999,999,999')
@ 22,60 SAY If(nGDisc>0 .AND. nGDisc<1,Str(nGDisc*100,2)+'%','   ')
@ 22,66 SAY Trans(nD       ,' 999,999,999')+If(lGStl,'*',' ')
@ 24,66 SAY Trans(nGStl+nD ,' 999,999,999')
Angka(03,1,'total '+(Space(13-Len(cD))+cD))
@ 21,01 CLEAR TO 24,52
Angka(22,1,right(Space(13)+ALLTRIM(cDD1),13))

IF !lCash                       && u/ tetap menampilkan kembalian
    cD:=Str(QTY,3)+'-->'+TransForm(PRICE,'Rp 999,999,999')
ELSE ;cD:='CHG';lCash:=.F.
ENDIF

CustDisp(Left(AllTrim(DESC),20),cD)

IF lGStl .AND. nDs#0.00
   GO BOTTOM
   RETURN
ENDIF
IF If(l=NIL,.T.,l) 
   SET DEVICE TO PRINT
  *@ PRow()  ,00 SAY _PINIT+_PALL
   IF RecNo()>1
      SKIP -1
      IF FLAG='PCG'
         @ PRow(),00 SAY Replicate('-',40)
         JPrint(PRow(),40,Replicate('-',40))
      ENDIF
      SKIP
   ENDIF
   IF FLAG='CRC' 
      @ PRow(),00 SAY Replicate('=',40)
      JPrint(PRow(),40, Replicate('=',40))
   ELSEIF nDs#0
      @ PRow()+1,00 SAY If(nDp#0,Trans(nDp,'99% '),'')+cDd
      @ PRow()  ,29 SAY nDs   PICT '999,999,999'
      JPrint(PRow()  ,40, If(nDp#0,Trans(nDp,'99% '),'')+cDd)
      JPrint(PRow()  ,52, nDs, '999,999,999')
   ELSEIF PRICE#0
      IF FLAG='STD'
         @ PRow()+1,00 SAY DESC
         JPrint(PRow()  ,40, DESC)
      ELSEIF FLAG='VOD'
         @ PRow()+1,00 SAY QTY   PICT        '999'
         IF nGPRC=0
            @ PRow()  ,04 SAY PRODUK->UNIT
         ELSEIF nGPRC=1
            @ PRow()  ,04 SAY PRODUK->UNIT1
         ELSEIF nGPRC=2
            @ PRow()  ,04 SAY PRODUK->UNIT2
         ENDIF
         @ PRow()  ,08 SAY IF(lGCode,CODE+' '+Left(DESC,11),Left(DESC,11))+'(V)'
         JPrint(PRow(),40, IF(lGCode,CODE+' '+Left(DESC,15),Left(DESC,25))+"(V)")
      ELSEIF FLAG='RTN'
         @ PRow()+1,00 SAY QTY   PICT        '999'
         IF nGPRC=0
            @ PRow()  ,04 SAY PRODUK->UNIT
         ELSEIF nGPRC=1
            @ PRow()  ,04 SAY PRODUK->UNIT1
         ELSEIF nGPRC=2
            @ PRow()  ,04 SAY PRODUK->UNIT2
         ENDIF
         @ PRow()  ,08 SAY IF(lGCode,CODE+' '+Left(DESC,11),Left(DESC,11))+'(R)'
         JPrint(PRow(),40, IF(lGCode,CODE+' '+Left(DESC,15),Left(DESC,25))+"(R)")
      ELSE
         @ PRow()+1,00 SAY QTY   PICT        '999'
         IF nGPRC=0
            @ PRow()  ,04 SAY PRODUK->UNIT
         ELSEIF nGPRC=1
            @ PRow()  ,04 SAY PRODUK->UNIT1
         ELSEIF nGPRC=2
            @ PRow()  ,04 SAY PRODUK->UNIT2
         ENDIF
         @ PRow()  ,08 SAY IF(lGCode,CODE+' '+Left(DESC,13),Left(DESC,13))
         JPrint(PRow(),40, IF(lGCode,CODE+' '+Left(DESC,20),Left(DESC,28)))
      ENDIF
         @ PRow()      ,21     SAY PRICE PICT ' 9999999'
         @ PRow()      ,29     SAY nT    PICT ' 99,999,999'
   ENDIF
   @ PRow(),0 SAY Chr(13)
   SET DEVICE TO SCREEN
ENDIF
GO BOTTOM
RETURN
*-----------------------------------------------------------------------------

