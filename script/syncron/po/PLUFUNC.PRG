#include 'kassa.ch'
*-----------------------------------------------------------------------------
FUNCTION PLUFunc(c,n,a)
PRIVATE lOutSt:=.F.
IF Empty(c)  ;c:=Repli(Chr(255),8)
ENDIF
SELECT TEMP
IF !lGVOD
   IF !lGRTN ;PLU(@c,@n,@a)
      ELSE   ;RTN(@c,@n,@a)
   ENDIF
ELSE         ;VOD(@c,@n,@a) 
ENDIF
RETURN .T.

*-----------------------------------------------------------------------------
STATIC PROCEDURE PLU(c,n,a)
LOCAL nD,nE
LOCAL cFLAG   :='' ;
     ,cCODE   :='' ;
     ,cDESC   :='' ;
     ,cUNIT   :='' ;
     ,nPRICE  :=0  ;
     ,nCPRICE :=0  ;
     ,nNORCP  :=0  ;
     ,cETYPE  :='K';
     ,cGROUP  :='' ;
     ,cDEPT   :='' ;
     ,nTJQTY   :=0  ;
     ,cA:=Alias()
IF AScan({'RTN','VOD','PLU'},FLAG)>0 .AND. PRICE=0 ;c:=''
   Wrong(' Harga Belum Ada, Salah Tombol - tekan [CLEAR] ... ! ')
   RETURN .t.
ENDIF

IF lGSTL
   lGStl:=!lGStl
   @ 22,51 SAY If(lGStl,'*',' ') COLOR 'w*+'
ENDIF

IF lBarCode .AND. c='2' .AND. SeekProduk(SubS(c,3,5),@n,@a)
   nD:=Val('1'+Left('000000000',Val(SubS(c,2,1))))
   nPRICE :=Val(SubS(c,8,5))*nD
   cDESC  :=PRODUK->DESC
   c      :=PRODUK->CODE
   cGROUP :=PRODUK->GROUP
   cDEPT  :=PRODUK->DEPT
   cETYPE :='A'
ELSEIF SeekProduk(@c,@n,@a)
   cDESC  :=PRODUK->DESC
   //nPRICE :=IF(lGPrc,PRODUK->PRICE,PRODUK->PRICE1)
   IF nGPrc=0
      nPRICE:=PRODUK->PRICE
      cUNIT :=PRODUK->UNIT
   ELSEIF nGPrc=1
      nPRICE:=PRODUK->PRICE1
      cUNIT :=PRODUK->UNIT1
   ELSEIF nGPrc=2
      nPRICE:=PRODUK->PRICE2
      cUNIT :=PRODUK->UNIT2
   ENDIF
   IF nGPrc=0
      nTJQTY:=nQTY*PRODUK->QTYJ
   ELSEIF nGPrc=1
      nTJQTY:=nQTY*PRODUK->QTYJ1
   ELSEIF nGPrc=2
      nTJQTY:=nQTY*PRODUK->QTYJ2
   ENDIF
   nCPRICE:=PRODUK->CPRICE
   cGROUP :=PRODUK->GROUP
   cDEPT  :=PRODUK->DEPT
   cETYPE :=IF(PRODUK->PRICE=0,'?','A')
ELSE ;c:=''
   Wrong(' Data Salah - tekan [CLEAR] ... ! ')
   RETURN .T.
ENDIF

IF _ICS#1
   IF nPRICE>0
      IF (nQTY > PRODUK->STOCK       .AND. PRODUK->CHK=.T.) .OR. ;
         (PRODUK->STOCK <= nGStockC  .AND. PRODUK->CHK=.T.)
//         Warning(' QTY Produk mencapai MINIMUM ... !')
      ENDIF
      IF PRODUK->(Reclock())
         IF nGPrc=0
            PRODUK->STOCK-=nQTY * PRODUK->QTYJ
         ELSEIF nGPrc=1
            PRODUK->STOCK-=nQTY * PRODUK->QTYJ1
         ELSEIF nGPrc=2
            PRODUK->STOCK-=nQTY * PRODUK->QTYJ2
         ENDIF
         PRODUK->LASTSELL:=DATE()
         PRODUK->QTYSELL+=nQTY
         PRODUK->(DBUnLock())
      ENDIF
   ENDIF
ENDIF

New()
AddRec()
cCODE:=c
cFLAG:='PLU'
nNORCP:=SATELITE->NORCP
FIELD->FLAG  :=cFLAG
FIELD->CODE  :=cCODE
FIELD->DESC  :=cDESC
FIELD->UNIT  :=cUNIT
FIELD->QTY   :=nQTY
FIELD->PRICE :=nPRICE
FIELD->CPRICE:=nCPRICE
FIELD->NORCP :=nNORCP
FIELD->ETYPE :=cETYPE
FIELD->GROUP :=cGROUP
FIELD->DEPT  :=cDEPT
FIELD->SALES :=cGSALES
FIELD->TJQTY  :=nTJQTY
*FIELD->HPHR :=lGHpHr
nGStl+=QTY*PRICE
ViewTrn(1);c:=''
CLSFunc()
lGNew:=.F.
RETURN .t.

*-----------------------------------------------------------------------------
STATIC PROCEDURE VOD(c,n,a)
LOCAL cA:=Alias(),nX:=1,nD:=0,nI:=0
LOCAL aDSC:={'STD','D%1','D%2','D%3','DS1','DS2','DS3'}
LOCAL cFLAG   :='' ;
     ,cCODE   :='' ;
     ,cDESC   :='' ;
     ,cUNIT   :='' ;
     ,nPRICE  :=0  ;
     ,nCPRICE :=0  ;
     ,nNORCP  :=0  ;
     ,cGROUP  :='' ;
     ,cDEPT   :='' ;
     ,nTJQTY   :=0  ;
     ,cETYPE  :='K'
IF AScan({'RTN','VOD','PLU'},FLAG)>0 .AND. PRICE=0
   Wrong(' Harga Belum Ada, Salah Tombol - tekan [CLEAR] ... ! ')
   @ nGBrs+1,2 SAY '   '
   lGVOD:=.f.;c:=''
   RETURN .t.
ENDIF
IF lBarCode .AND. c='2' .AND. PRODUK->(DBSeek(SubS(c,3,5)+Space(3)))
   nD:=Val('1'+Left('000000000',Val(SubS(c,2,1))))
   nPRICE :=Val(SubS(c,8,5))*nD
   cDESC  :=PRODUK->DESC
   cGROUP :=PRODUK->GROUP
   cDEPT  :=PRODUK->DEPT
   cETYPE :='A'
   c:=SubS(c,3,5)
ELSEIF SeekProduk(@c,@n,@a)                            
   cDESC  :=PRODUK->DESC
   //nPRICE :=IF(lGPrc,PRODUK->PRICE,PRODUK->PRICE1)
   IF nGPrc=0
      nPRICE:=PRODUK->PRICE
      cUNIT :=PRODUK->UNIT
   ELSEIF nGPrc=1
      nPRICE:=PRODUK->PRICE1
      cUNIT :=PRODUK->UNIT1
   ELSEIF nGPrc=2
      nPRICE:=PRODUK->PRICE2
      cUNIT :=PRODUK->UNIT2
   ENDIF
   IF nGPrc=0
      nTJQTY:=nQTY*PRODUK->QTYJ
   ELSEIF nGPrc=1
      nTJQTY:=nQTY*PRODUK->QTYJ1
   ELSEIF nGPrc=2
      nTJQTY:=nQTY*PRODUK->QTYJ2
   ENDIF
   nCPRICE:=PRODUK->CPRICE
   cGROUP :=PRODUK->GROUP
   cDEPT  :=PRODUK->DEPT
   cETYPE :=IF(PRODUK->PRICE=0,'?','A')
ELSE ;c:=''
   Wrong(' Data Salah - tekan [CLEAR] ... ! ')
   RETURN .T.
ENDIF
IF LastRec()=0
   Wrong(' Data Salah - tekan [CLEAR] ... ! ')
   @ nGBrs+1,2 SAY '   '
   lGVOD:=.f.;c:=''
   RETURN .T.
ENDIF
nX:=0;nI:=0
FOR nD:=1 TO LastRec()
    GO nD
    DO CASE
    CASE AScan(aDSC,FLAG)>0 .AND. CODE=cCODE ;nX+=PRICE
    CASE AScan({'PLU','VOD','RTN','P/O','R/A'},FLAG)>0 
       IF CODE=c  ;nI+=QTY*(Abs(PRICE)/PRICE) ;ENDIF
//     IF CODE=c ;nI+=PRICE/PRICE ;ENDIF
       nX+=(PRICE*QTY)   *If(lGRTN,-1,1)         &&__Penting...!
    ENDCASE 
NEXT
*------CEK
DO CASE
CASE nPRICE*nQTY>nX .OR. nQTY>nI*If(lGRTN,-1,1)  &&__Penting...!
   Wrong(' Nilai / Qty Kurang, Tidak Bisa Di VOID - tekan [CLEAR] ... ! ')
   @ nGBrs+1,2 SAY '   ' ;lGVOD:=.f.;c:='' ;RETURN .T.
CASE nPRICE#0
   lGVOD:=.f.
ENDCASE
cCODE:=c

IF _ICS#1
   IF nPRICE>0
      IF PRODUK->(Reclock())
         IF nGPrc=0
            PRODUK->STOCK+=nQTY * PRODUK->QTYJ
         ELSEIF nGPrc=1
            PRODUK->STOCK+=nQTY * PRODUK->QTYJ1
         ELSEIF nGPrc=2
            PRODUK->STOCK+=nQTY * PRODUK->QTYJ2
         ENDIF
         PRODUK->QTYSELL-=nQTY
         PRODUK->(DBUnLock())
      ENDIF
   ENDIF
ENDIF

AddRec()
cFLAG='VOD'
nNORCP:=SATELITE->NORCP
FIELD->FLAG  :=cFLAG
FIELD->CODE  :=cCODE
FIELD->DESC  :=cDESC
FIELD->UNIT  :=cUNIT
FIELD->QTY   :=nQTY
FIELD->PRICE :=nPRICE*-1*If(lGRTN,-1,1)
FIELD->CPRICE:=nCPRICE*-1*If(lGRTN,-1,1)
FIELD->NORCP :=nNORCP
FIELD->ETYPE :=cETYPE
FIELD->GROUP :=cGROUP
FIELD->DEPT  :=cDEPT
FIELD->SALES :=cGSALES
FIELD->TJQTY  :=nTJQTY
*FIELD->HPHR  :=lGHpHr
nGStl+=QTY*PRICE
ViewTrn(1);c:=''
CLSFunc()
lGNew:=.F.
RETURN .t.

*-----------------------------------------------------------------------------
STATIC PROCEDURE RTN(c,n,a)
LOCAL cFLAG   :='' ;
     ,cCODE   :='' ;
     ,cDESC   :='' ;
     ,cUNIT   :='' ;
     ,nPRICE  :=0  ;
     ,nCPRICE :=0  ;
     ,nNORCP  :=0  ;
     ,cETYPE  :='K';
     ,cGROUP  :='' ;
     ,cDEPT   :='' ;
     ,nTJQTY   :=0  ;
     ,cA:=Alias()
IF AScan({'RTN','VOD','PLU'},FLAG)>0 .AND. PRICE=0;c:=''
   Wrong(' Harga Belum Ada, Salah Tombol - tekan [CLEAR] ... ! ')
   RETURN .t.
ENDIF
IF lBarCode .AND. c='2' .AND. PRODUK->(DBSeek(SubS(c,3,5)+Space(3)))
   nD:=Val('1'+Left('000000000',Val(SubS(c,2,1))))
   nPRICE :=Val(SubS(c,8,5))*nD
   cDESC  :=PRODUK->DESC
   cGROUP :=PRODUK->GROUP
   cDEPT  :=PRODUK->DEPT
   cETYPE :='A'
   c:=SubS(c,3,5)
ELSEIF SeekProduk(@c,@n,@a)                            
   cDESC  :=PRODUK->DESC
   IF nGPrc=0
      nPRICE:=PRODUK->PRICE
      cUNIT :=PRODUK->UNIT
   ELSEIF nGPrc=1
      nPRICE:=PRODUK->PRICE1
      cUNIT :=PRODUK->UNIT1
   ELSEIF nGPrc=2
      nPRICE:=PRODUK->PRICE2
      cUNIT :=PRODUK->UNIT2
   ENDIF
   IF nGPrc=0
      nTJQTY:=nQTY*PRODUK->QTYJ
   ELSEIF nGPrc=1
      nTJQTY:=nQTY*PRODUK->QTYJ1
   ELSEIF nGPrc=2
      nTJQTY:=nQTY*PRODUK->QTYJ2
   ENDIF
   nCPRICE:=PRODUK->CPRICE
   cGROUP :=PRODUK->GROUP
   cDEPT  :=PRODUK->DEPT
   cETYPE :=IF(PRODUK->PRICE=0,'?','A')
ELSE ;c:=''
   Wrong(' Data Salah - tekan [CLEAR] ... ! ')
   RETURN .T.
ENDIF

IF _ICS#1
   IF nPRICE>0
      IF PRODUK->(Reclock())
         IF nGPrc=0
            PRODUK->STOCK+=nQTY * PRODUK->QTYJ
         ELSEIF nGPrc=1
            PRODUK->STOCK+=nQTY * PRODUK->QTYJ1
         ELSEIF nGPrc=2
            PRODUK->STOCK+=nQTY * PRODUK->QTYJ2
         ENDIF
         PRODUK->QTYSELL-=nQTY
         PRODUK->(DBUnLock())
      ENDIF
   ENDIF
ENDIF

New()
AddRec()
cCODE:=c
cFLAG:='RTN'
nNORCP:=SATELITE->NORCP
FIELD->FLAG  :=cFLAG
FIELD->CODE  :=cCODE
FIELD->DESC  :=cDESC
FIELD->UNIT  :=cUNIT
FIELD->QTY   :=nQTY
FIELD->PRICE :=nPRICE*-1
FIELD->CPRICE:=nCPRICE*-1
FIELD->NORCP :=nNORCP
FIELD->ETYPE :=cETYPE
FIELD->GROUP :=cGROUP
FIELD->DEPT  :=cDEPT
FIELD->SALES :=cGSALES
FIELD->TJQTY  :=nTJQTY
*FIELD->HPHR  :=lGHpHr
nGStl+=QTY*PRICE
ViewTrn(1);c:=''
CLSFunc()
lGNew:=.F.
RETURN .t.

*-----------------------------------------------------------------------------
STATIC FUNCTION SeekProduk(c,n,a)
IF Select('PRODUK')#0
   PRODUK->(DBSetOrder(3))
   IF PRODUK->(DBSeek(Upper(c)+Space(13-Len(c))))
      c:=PRODUK->CODE;PRODUK->(DBSetorder(1))
      RETURN .T.
   ENDIF 
   PRODUK->(DBSetOrder(1))
   IF PRODUK->(DBSeek(Upper(c)+Space(08-Len(c))))
      c:=PRODUK->CODE
      RETURN .T.
   ENDIF
ENDIF
RETURN .F.

*-----------------------------------------------------------------------------
STATIC FUNCTION CekOutStd()
LOCAL cD1:=SATELITE->OutMsg1+' ',cD2:=SATELITE->OutMsg2,c1,c2,nK:=0
LOCAL cScr:=SaveScreen(5,0,15,79), nTRec:=TEMP->(RecNo())
IF PRODUK->Chk .AND. cGFlag
   Tone(2800,5);Tone(2000,3);Tone(2500,4)
   lGFOut:=.T.
   IF TEMP->(LastRec())=0
      lGFOut:=.F.
      SET DEVICE TO PRINT
      PHeader()
      @ PRow()+1,00 SAY 'OUTSTANDING'
      @ PRow()  ,29 SAY nGOut     PICT ' 99,999,999'
      @ PRow()  ,40 SAY 'OUTSTANDING'
      @ PRow()  ,62 SAY nGOut     PICT ' 99,999,999'
      @ Prow()+2,00 SAY Repl('*',40)
      @ Prow()  ,40 SAY Repl('*',40)
      @ PRow()+1,00 SAY Left(SATELITE->OutMsg1,40)
      @ PRow()  ,40 SAY Left(SATELITE->OutMsg1,40)
      @ PRow()+1,00 SAY SATELITE->OutMsg2
      @ PRow()  ,40 SAY SATELITE->OutMsg2
      @ Prow()+1,00 SAY Repl('*',40)
      @ Prow()  ,40 SAY Repl('*',40)
      PCutter()
      SET DEVICE TO SCREEN
   ENDIF
   TEMP->(DBGoTo(nTRec))
   Box(11,13,13,67,'W')
   /*
   Com_Open(3)  ;Com_Init(3,09600,'O',8,1) ;Com_Dtr(3,.T.)
   nQ:=0
   DO WHILE nK=0
      cD1:=SubS(cD1,2)+Left(cD1,1)
      c1:=Left(cD1,20)  ;c2:=Left(cD2,20)
      Com_Send(3,Chr(27)+'[1;1H'+c1)
      IF nQ<10       ;nQ++ ;Com_Send(3,Chr(27)+'[2;1H'+c2)
      ELSEIF nQ<20   ;nQ++ ;nQ:=0 ;Com_Send(3,Chr(27)+'[2J')
      ENDIF
      @ 12,14 SAY '   '+c1+'    '+c2 COLOR 'N/W'
      nK:=Inkey() ;FOR nn=1 TO 05000 ;NEXT
   ENDDO
   lOutSt:=.T.
   Com_Send(3,Chr(27)+'[2J')  &&______________________Clear Customer Display
   Com_Close(3)
   */
   c:=''
   RestScreen(5,0,15,79,cScr)
   RETURN .F.
ENDIF
RETURN .T.

*-----------------------------------------------------------------------------

