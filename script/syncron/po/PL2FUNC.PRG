#include 'kassa.ch'
*-----------------------------------------------------------------------------
FUNCTION PL2Func(c,n,a)
IF Empty(c)
   c:=Repli(Chr(255),8)
ENDIF
SELECT TEMP
IF !lGVOD
   IF !lGRTN ;PL1(@c,@n,@a)
      ELSE   ;RTN(@c,@n,@a)
   ENDIF
ELSE         ;VOD(@c,@n,@a) 
ENDIF
RETURN .T.

*-----------------------------------------------------------------------------
STATIC PROCEDURE PL1(c,n,a)
LOCAL nD,nE
LOCAL cFLAG   :='' ;
     ,cCODE   :='' ;
     ,cDESC   :='' ;
     ,cUNIT   :='' ;
     ,nCPRICE :=0  ;
     ,nPRICE  :=0  ;
     ,nNORCP  :=0  ;
     ,cETYPE  :='K';
     ,cGROUP  :='' ;
     ,cDEPT   :='' ;
     ,nTJQTY   :=0  ;
     ,cA:=Alias()

IF AScan({'RTN','VOD','PLU'},FLAG)>0 .AND. PRICE=0 ;c:=''
   Wrong(' Harga Belum Ada - Tekan [CLEAR] ... ! ')
   RETURN .t.
ENDIF

IF lBarCode .AND. SeekProduk(@c,@n,@a)
   c      :=PRODUK->CODE
   cDEPT  :=PRODUK->(Left(CODE,2))
   cDESC  :=PRODUK->DESC
   cUNIT  :=PRODUK->UNIT2
   nTQYT  :=nQTY*PRODUK->QTYJ2
   nPRICE :=PRODUK->PRICE2
   nCPRICE:=PRODUK->CPRICE
   cETYPE :='A'
ELSEIF SeekProduk(@c,@n,@a)                        &&Select('PRODUK')#0 .AND. PRODUK->(DBSeek(c+Space(8-Len(c))))
   IF Len(c)=1.OR.Len(c)=2.OR.Len(c)=4             //Dar 6/11
      c:=RIGHT('00000000'+ALLTRIM(c),8)            //Dar 6/11
   ENDIF
   c      :=PRODUK->CODE                                         //Dar 6/11
   cDEPT  :=PRODUK->(Left(CODE,2))
   cDESC  :=PRODUK->DESC
   cUNIT  :=PRODUK->UNIT2
   nPRICE :=PRODUK->PRICE2
   nTJQTY  :=nQTY*PRODUK->QTYJ2
   nCPRICE:=PRODUK->CPRICE
   cETYPE :=IF(PRODUK->PRICE2=0,'?','A')
ELSEIF Len(c)=3
   IF CLASS->(DBSeek(c)) .AND. TCode(c)=='Class'
      cDESC:=CLASS->DESC
   ELSE
      c:=''                                            //Dar20/11
//    cDESC:='CLASS '+c                                //Dar 5/11
      Wrong(' Class Tidak Ada - Tekan [CLEAR] ... ! ') //Dar 5/11
      SELECT TEMP
      RETURN .T.                                       //Dar 5/11
   ENDIF
ELSEIF Len(c)=8 .AND. ChkPLU(c)
   IF CLASS->(DBSeek('0'+Left(c,2)))
      cDESC:=CLASS->DESC
   ELSE
//    cDESC:='DEPT   '+c                           // Dar 5/11
      cDESC:='MERCHANDISE'                         // Dar 5/11
   ENDIF
   cETYPE:=If(lGBarCode,'B','K')
ELSE;c:=''
   Wrong(' Data Salah - Tekan [CLEAR] ... ! ')
   SELECT TEMP
   RETURN .T.
ENDIF
IF _ICS#1
   IF (nQTY > PRODUK->STOCK       .AND. PRODUK->CHK=.T.) .OR. ;
      (PRODUK->STOCK <= nGStockC  .AND. PRODUK->CHK=.T.)
//      Warning(' QTY Produk mencapai MINIMUM ... !')
   ENDIF
   IF PRODUK->(Reclock())
      PRODUK->STOCK-=nQTY * PRODUK->QTYJ2
      PRODUK->LASTSELL:=DATE()
      PRODUK->QTYSELL+=nQTY
      PRODUK->(DBUnLock())
   ENDIF
ENDIF
SELECT TEMP
New()
AddRec()
cCODE:=c
cFLAG:='PLU'
nNORCP:=SATELITE->NORCP
FIELD->FLAG  :=cFLAG
FIELD->CODE  :=cCODE
FIELD->DEPT  :=cDEPT
FIELD->DESC  :=cDESC
FIELD->UNIT  :=cUNIT
FIELD->QTY   :=nQTY
FIELD->PRICE :=nPRICE
FIELD->CPRICE:=nCPRICE
FIELD->FLPRC :='W'
FIELD->NORCP :=nNORCP
FIELD->ETYPE :=cETYPE
FIELD->SALES :=cGSALES
FIELD->TJQTY  :=nTJQTY
nGStl+=QTY*PRICE
ViewTrn(1);c:=''
CLSFunc()
RETURN .t.

*-----------------------------------------------------------------------------
STATIC PROCEDURE VOD(c,n,a)
LOCAL cA:=Alias(),nX:=1,nD:=0,nI:=0
LOCAL aDSC:={'STD','D%1','D%2','D%3','DS1','DS2','DS3'}
LOCAL cFLAG   :='' ;
     ,cCODE   :='' ;
     ,cDEPT   :='' ;
     ,cDESC   :='' ;
     ,cUNIT   :='' ;
     ,nCPRICE :=0  ;
     ,nPRICE  :=0  ;
     ,nNORCP  :=0  ;
     ,nTJQTY   :=0  ;
     ,cETYPE  :='K'
IF AScan({'RTN','VOD','PLU'},FLAG)>0 .AND. PRICE=0
   Wrong(' Harga Belum Ada - Tekan [CLEAR] ... ! ')
   @ nGBrs+1,2 SAY '   '
   lGVOD:=.f.;c:=''
   SELECT TEMP
   RETURN .t.
ENDIF

nE:=AT(CHR(13),c)
c:=LEFT(c,IF(nE>0,nE-1,Len(c)))

IF lBarCode .AND. SeekProduk(@c,@n,@a)
   c      :=PRODUK->CODE
   cDEPT  :=PRODUK->(Left(CODE,2))
   cDESC  :=PRODUK->DESC
   cUNIT  :=PRODUK->UNIT2
   nTJQTY  :=nQTY*PRODUK->QTYJ2
   nPRICE :=PRODUK->PRICE2
   nCPRICE:=PRODUK->CPRICE
   cETYPE :='A'
ELSEIF SeekProduk(@c,@n,@a)                            &&Select('PRODUK')#0 .AND. PRODUK->(DBSeek(c+Space(8-Len(c))))
   IF Len(c)=1.OR.Len(c)=2.OR.Len(c)=4             //Dar 6/11
      c:=RIGHT('00000000'+ALLTRIM(c),8)            //Dar 6/11
   ENDIF                                           //Dar 6/11
   c      :=PRODUK->CODE
   cDEPT  :=PRODUK->(Left(CODE,2))
   cDESC  :=PRODUK->DESC
   cUNIT  :=PRODUK->UNIT2
   nQTY   :=nQTY*PRODUK->QTYJ2
   nPRICE :=PRODUK->PRICE2
   nCPRICE:=PRODUK->CPRICE
   cETYPE :=IF(PRODUK->PRICE2=0,'?','A')
ELSEIF Len(c)=3
   IF CLASS->(DBSeek(c)) .AND. TCode(c)=='Class'
      cDESC:=CLASS->DESC
   ELSE
//    cDESC:='CLASS '+c                            // Dar 5/11
      Wrong(' Class Tidak Ada - Tekan [CLEAR] ... ! ')           // Dar 5/11
      SELECT TEMP
      RETURN .T.                                   // Dar 5/11
   ENDIF
ELSEIF Len(c)=8 .AND. ChkPLU(c)
   IF CLASS->(DBSeek('0'+Left(c,2)))
      cDESC:=CLASS->DESC
   ELSE
//    cDESC:='DEPT   '+c                           // Dar 5/11
      cDESC:='MERCHANDISE'                         // Dar 5/11
   ENDIF
   cETYPE:=If(lGBarCode,'B','K')
ELSE
   Wrong(' Data Salah - Tekan [CLEAR] ... ! ')
   @ nGBrs+1,2 SAY '   '
   lGVOD:=.f.;c:=''
   SELECT TEMP
   RETURN .T.
ENDIF
IF LastRec()=0
   Wrong(' Data Salah - Tekan [CLEAR] ... ! ')
   @ nGBrs+1,2 SAY '   '
   lGVOD:=.f.;c:=''
   SELECT TEMP
   RETURN .T.
ENDIF
SELECT TEMP
nX:=0;nI:=0
FOR nD:=1 TO LastRec()
    GO nD
    DO CASE
    CASE AScan(aDSC,FLAG)>0 .AND. CODE=cCODE ;nX+=PRICE
    CASE AScan({'PLU','VOD','RTN','P/O','R/A'},FLAG)>0 
       IF CODE=c ;nI+=QTY*(Abs(PRICE)/PRICE) ;ENDIF
//     IF CODE=c ;nI+=PRICE/PRICE ;ENDIF
       nX+=(PRICE1*QTY)   *If(lGRTN,-1,1)         &&__Penting...!
    ENDCASE 
NEXT
*------CEK
DO CASE
CASE nPRICE*nQTY>nX .OR. nQTY>nI*If(lGRTN,-1,1)  &&__Penting...!
   Warning(' Nilai / Qty Kurang, Tidak Bisa Di VOID ... ! ')
   @ nGBrs+1,2 SAY '   ' ;lGVOD:=.f.;c:='' ;RETURN .T.
CASE nPRICE#0
   lGVOD:=.f.
ENDCASE
SELECT TEMP
cCODE:=c

IF _ICS#1
   //IF nQTY > PRODUK->STOCK
   //   Warning(' QTY Produk tidak cukup untuk transaksi... ')
   //ENDIF
   IF PRODUK->(Reclock())
      PRODUK->STOCK+=nQTY*PRODUK->QTYJ2
      PRODUK->QTYSELL-=nQTY
      PRODUK->(DBUnLock())
   ENDIF
ENDIF

AddRec()
cFLAG='VOD'
nNORCP:=SATELITE->NORCP
FIELD->FLAG  :=cFLAG
FIELD->CODE  :=cCODE
FIELD->DEPT  :=cDEPT
FIELD->DESC  :=cDESC
FIELD->UNIT  :=cUNIT
FIELD->QTY   :=nQTY
FIELD->PRICE :=nPRICE*-1*If(lGRTN,-1,1)
FIELD->CPRICE:=nCPRICE*-1*If(lGRTN,-1,1)
FIELD->FLPRC :='W'
FIELD->NORCP :=nNORCP
FIELD->ETYPE :=cETYPE
FIELD->SALES :=cGSALES
FIELD->TJQTY  :=nTJQTY
nGStl+=QTY*PRICE
ViewTrn(1);c:=''
CLSFunc()
RETURN .t.

*-----------------------------------------------------------------------------
STATIC PROCEDURE RTN(c,n,a)
LOCAL cFLAG   :='' ;
     ,cCODE   :='' ;
     ,cDEPT   :='' ;
     ,cDESC   :='' ;
     ,cUNIT   :='' ;
     ,nPRICE  :=0  ;
     ,nCPRICE :=0  ;
     ,nNORCP  :=0  ;
     ,nTJQTYP  :=0  ;
     ,cETYPE  :='K';
     ,cA:=Alias()
IF AScan({'RTN','VOD','PLU'},FLAG)>0 .AND. PRICE=0;c:=''
   Wrong(' Harga Belum Ada - Tekan [CLEAR] ... ! ')
   SELECT TEMP
   RETURN .t.
ENDIF

nE:=AT(CHR(13),c)
c:=LEFT(c,IF(nE>0,nE-1,Len(c)))

IF lBarCode .AND. SeekProduk(@c,@n,@a)
   c      :=PRODUK->CODE
   cDEPT  :=PRODUK->(Left(CODE,2))
   cDESC  :=PRODUK->DESC
   cUNIT  :=PRODUK->UNIT2
   nTJQTY  :=nQTY*PRODUK->QTYJ2
   nPRICE :=PRODUK->PRICE2
   nCPRICE:=PRODUK->CPRICE
   cETYPE :='A'
ELSEIF SeekProduk(@c,@n,@a)                            &&Select('PRODUK')#0 .AND. PRODUK->(DBSeek(c+Space(8-Len(c))))
   IF Len(c)=1.OR.Len(c)=2.OR.Len(c)=4             //Dar 6/11
      c:=RIGHT('00000000'+ALLTRIM(c),8)            //Dar 6/11
   ENDIF                                           //Dar 6/11
   c      :=PRODUK->CODE
   cDEPT  :=PRODUK->(Left(CODE,2))
   cDESC  :=PRODUK->DESC
   cUNIT  :=PRODUK->UNIT2
   nTJQTY  :=nQTY*PRODUK->QTYJ2
   nPRICE :=PRODUK->PRICE2                                  //Dar 5/11
   nCPRICE:=PRODUK->CPRICE                                  //Dar 5/11
   cETYPE :=IF(PRODUK->PRICE2=0,'?','A')
ELSEIF Len(c)=3
   IF CLASS->(DBSeek(c)) .AND. TCode(c)=='Class'
      cDESC:=CLASS->DESC
   ELSE
//    cDESC:='CLASS '+c                            //Dar 5/11
      Wrong(' Class Tidak Ada - Tekan [CLEAR] ... ! ')           //Dar 5/11
      SELECT TEMP
      RETURN .T.                                   //Dar 5/11
   ENDIF
ELSEIF Len(c)=8 .AND. ChkPLU(c)
   IF CLASS->(DBSeek('0'+Left(c,2)))
      cDESC:=CLASS->DESC
   ELSE
//    cDESC:='DEPT   '+c                           //Dar 5/11
      cDESC:='MERCHANDISE'                         //Dar 5/11
   ENDIF
   cETYPE:=If(lGBarCode,'B','K')
ELSE;c:=''
   Wrong(' Data Salah - Tekan [CLEAR] ... ! ')
   SELECT TEMP
   RETURN .T.
ENDIF

IF _ICS#1
   //IF nQTY > PRODUK->STOCK
   //   Warning(' QTY Produk tidak cukup untuk transaksi... ')
   //ENDIF
   IF PRODUK->(Reclock())
      PRODUK->STOCK+=nQTY*PRODUK->QTYJ2
      PRODUK->QTYSELL-=nQTY
      PRODUK->(DBUnLock())
   ENDIF
ENDIF

SELECT TEMP
New()
AddRec()
cCODE:=c
cFLAG:='RTN'
nNORCP:=SATELITE->NORCP
FIELD->FLAG  :=cFLAG
FIELD->CODE  :=cCODE
FIELD->DEPT  :=cDEPT
FIELD->DESC  :=cDESC
FIELD->UNIT  :=cUNIT
FIELD->QTY   :=nQTY
FIELD->PRICE :=nPRICE*-1
FIELD->CPRICE:=nCPRICE*-1
FIELD->FLPRC :='W'
FIELD->NORCP :=nNORCP
FIELD->ETYPE :=cETYPE
FIELD->SALES :=cGSALES
FIELD->TJQTY  :=nTJQTY
nGStl+=QTY*PRICE
ViewTrn(1);c:=''
CLSFunc()
RETURN .t.

*-----------------------------------------------------------------------------
STATIC FUNCTION SeekProduk(c,n,a)
IF Select('PRODUK')#0
   PRODUK->(DBSetOrder(3))
   IF PRODUK->(DBSeek(c+Space(13-Len(c))))
      c:=PRODUK->CODE;PRODUK->(DBSetorder(1))
      RETURN .T.
   ENDIF 
   PRODUK->(DBSetOrder(1))
   IF PRODUK->(DBSeek(c+Space(08-Len(c))))
      c:=PRODUK->CODE
      RETURN .T.
   ENDIF
ENDIF
RETURN .F.

*-----------------------------------------------------------------------------
Static Function TCode(c)
c:=Left(c,1)
DO CASE
CASE c$'123456789' ;c:='Class'
CASE c='0'         ;c:='Dept '
OTHERWISE          ;c:='     '
ENDCASE
RETURN c

*-----------------------------------------------------------------------------

