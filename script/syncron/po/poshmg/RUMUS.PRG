#include "hmg.ch"
#include "kassa.ch"
#include "inkey.ch"
#include "memoEDIT.ch"
#define MY_B_SINGLE ( chr(208)+chr(209)+chr(210)+chr(212)+chr(215)+chr(214)+chr(213)+chr(211) )

*-----------------------------------------------------------------------------
FUNCTION ChkPrice(c)
LOCAL nLen:=LEN(c),n1:=0,n2:=0,nPRC:=0
IF nLen#9
   RETURN .F.
ENDIF
FOR nX:=1 TO nLen-1 STEP 2
    n1+=VAL(SUBS(c,nX  ,1))
    n2+=VAL(SUBS(c,nX+1,1))
NEXT 
nPRC:=(10 - MOD( (n1+(n2*7)) , 10 ) )
RETURN RIGHT(STR(nPRC,9),1)=RIGHT(c,1)

*-----------------------------------------------------------------------------
FUNCTION ChkPlu(c)
LOCAL nLen:=LEN(c),n1:=0,n2:=0,nSKU:=0,nD:=0
IF nLen#8
   RETURN .F.
ENDIF
FOR nX:=1 TO nLen-1 STEP 2
    n1+=VAL(SUBS(c,nX  ,1))
    n2+=VAL(SUBS(c,nX+1,1))
NEXT 
n2=(n2-VAL(RIGHT(c,1)))*2 
nSKU:=(10-MOD(n1+n2,10))
RETURN RIGHT(STR(nSKU,9),1)=RIGHT(c,1)

*-----------------------------------------------------------------------------
FUNCTION ChkEan(c)
LOCAL nLen:=LEN(c),n1:=0,n2:=0,nEAN:=0
IF nLen#13
   RETURN .F.
ENDIF
FOR nX:=1 TO nLen-1 STEP 2
    n1+=VAL(SUBS(c,nX  ,1))
    n2+=VAL(SUBS(c,nX+1,1))
NEXT 
nEAN:=(10 - MOD( (n1+(n2*3)) , 10 ) )
RETURN RIGHT(STR(nEAN,9),1)=RIGHT(c,1)

*-----------------------------------------------------------------------------
FUNCTION PCutter()
LOCAL nF1:=IF(cPrint$'3cf' ,2,5)          //TM210PD
LOCAL nF2:=IF(cPrint$'3cf' ,0,2)
SET DEVICE TO PRINTER
IF cSto='1'
   IF cPrint='8' ;@ PRow()+3,0 SAY ' '     //LX300
   ENDIF
   DO CASE
   CASE cPrint$'3cf'
      @ PRow()+nF1,(41-Len(cJDL))/2 SAY cJDL ;@ PRow()+1,0 SAY SATELITE->STO2
      @ PRow()+1  ,0 SAY SATELITE->STO3 ;@ PRow()+1,0 SAY SATELITE->STO4
      IF cPrint='c' .OR. cPRINT='f'
         @ PRow()+1,0 SAY SATELITE->COM1;@ PRow()+1,0 SAY SATELITE->COM2
      ENDIF
      @ PRow()+2  ,0 SAY _PCUT
      @ PRow()+nF2,0 SAY _PINIT+_PALL
   CASE cPrint$'578'
      @ PRow()+nF1,(41-Len(cJDL))/2 SAY cJDL
      @ PRow()+1,0 SAY SATELITE->STO2
      @ PRow()+1,0 SAY SATELITE->STO3
      @ PRow()+1,0 SAY SATELITE->STO4
      @ PRow()+1  ,0 SAY _PCUT
//      IF SATELITE->COM1#SPACE(40)
//         @ PRow()+2,0 SAY SATELITE->COM1
//      ENDIF
//      IF SATELITE->COM2#SPACE(40)
//         @ PRow()+1,0 SAY SATELITE->COM2
//      ENDIF
      @ PRow()+nF1,0 SAY _PINIT+_PALL
   CASE cPrint='e'
      cTX:=SATELITE->STO1
      nLTX:=LEN(ALLTRIM(cTX))
      IF nLTX < 28
         @ PRow()+nF1,0 SAY CHR(27)+CHR(33)+CHR(33)
         @ PRow()+1  ,(28-nLTX)/2 SAY ALLTRIM(SATELITE->STO1)
         
         @ PRow()+1  ,0 SAY CHR(27)+CHR(33)+CHR(1)
         @ PRow()    ,0 SAY _PCUT
      ELSE
         @ PRow()+nF1,(41-Len(cJDL))/2 SAY cJDL
      ENDIF
      @ PRow()+1  ,0 SAY SATELITE->STO2
      @ PRow()+1  ,0 SAY SATELITE->STO3
      @ PRow()+1  ,0 SAY SATELITE->STO4
      IF nLTX > 28
         @ PRow()+1  ,0 SAY SATELITE->STO4
         @ PRow()+1  ,0 SAY _PCUT
      ELSE
         @ PRow()+1  ,0 SAY SATELITE->STO4
      ENDIF
      @ PRow()+nF2,0 SAY _PINIT+_PALL
   CASE cPrint='1'
      @ PRow()+5,(41-Len(cJDL))/2 SAY cJDL ;@ PRow()+1,0 SAY SATELITE->STO2
      @ PRow()+1,0 SAY SATELITE->STO3 ;@ PRow()+1,0 SAY SATELITE->STO4
      @ PRow()+1,0 SAY SATELITE->COM1 ;@ PRow()+1,0 SAY SATELITE->COM2
      @ PRow()+1,0 SAY ' '            ;@ PRow()  ,0 SAY _PCUT
   CASE cPrint='4'
      @ PRow()+nF1,(41-Len(cJDL))/2 SAY cJDL ;@ PRow()+1,0 SAY SATELITE->STO2
      @ PRow()+1,0 SAY SATELITE->STO3   ;@ PRow()+1,0 SAY SATELITE->STO4
      @ PRow()+1,0 SAY SATELITE->COM1   ;@ PRow()+1,0 SAY SATELITE->COM2
      @ PRow()+nF2,0 SAY _PINIT+_PALL
      @ PRow()  ,0 SAY _PCUT
   CASE cPrint='6'                      //__TM300 w/o CUTTER
      @ PRow()+3,(41-Len(cJDL))/2 SAY cJDL   ;@ PRow()+1,0 SAY SATELITE->STO2
      @ PRow()+1,0 SAY SATELITE->STO3   ;@ PRow()+1,0 SAY SATELITE->STO4
      @ PRow()+1,0 SAY SATELITE->COM1   ;@ PRow()+1,0 SAY SATELITE->COM2
      @ PRow()+0,0 SAY _PINIT+_PALL
      @ PRow()  ,0 SAY _PCUT
   CASE cPrint='2'                      //__TEC-DRJST51
      @ PRow()+5,(41-Len(cJDL))/2 SAY cJDL   ;@ PRow()+1,0 SAY SATELITE->STO2
      @ PRow()+1,0 SAY SATELITE->STO3   ;@ PRow()+1,0 SAY SATELITE->STO4
      @ PRow()  ,0 SAY _PCUT
      @ PRow()+1,0 SAY SATELITE->COM1   ;@ PRow()+1,0 SAY SATELITE->COM2
      @ PRow()+1,0 SAY _PINIT+_PALL
   CASE cPrint='9'                      //__IBM SUREONE
      @ PRow()+3,(41-Len(cJDL))/2 SAY cJDL   ;@ PRow()+1,0 SAY SATELITE->STO2
      @ PRow()+1,0 SAY SATELITE->STO3
      @ PRow()+1,0 SAY SATELITE->STO4 + CHR(27)+CHR(51)+CHR(1)
      @ PRow()  ,0 SAY Space(40) + CHR(27)+CHR(51)+CHR(34)
      @ PRow()+1,0 SAY SATELITE->COM1   ;@ PRow()+1,0 SAY SATELITE->COM2
   CASE cPrint='a'                      //__STAR
      @ PRow()+3,(41-Len(cJDL))/2 SAY cJDL   ;@ PRow()+1,0 SAY SATELITE->STO2
      @ PRow()+1,0 SAY SATELITE->STO3   ;@ PRow()+1,0 SAY SATELITE->STO4
      @ PRow()+0,0 SAY _PINIT+_PALL
      @ PRow()  ,0 SAY _PCUT
   CASE cPrint$'bg'                      //__CITIZEN
      @ PRow()+5,(41-Len(cJDL))/2 SAY cJDL   ;@ PRow()+1,0 SAY SATELITE->STO2
      @ PRow()+1,0 SAY SATELITE->STO3   ;@ PRow()+1,0 SAY SATELITE->STO4
      @ PRow()+0,0 SAY _PINIT+_PALL
      @ PRow()  ,0 SAY _PCUT
   OTHERWISE
      @ PRow()+5,(41-Len(cJDL))/2 SAY cJDL   ;@ PRow()+1,0 SAY SATELITE->STO2
      @ PRow()+1,0 SAY SATELITE->STO3   ;@ PRow()+1,0 SAY SATELITE->STO4
      @ PRow()+1,0 SAY SATELITE->COM1   ;@ PRow()+1,0 SAY SATELITE->COM2
      @ PRow()+1,0 SAY _PINIT+_PALL
      @ PRow()  ,0 SAY _PCUT
   ENDCASE
ELSEIF cSto='2'                         //__TEC-DRJST50
   @ PRow()+2,0 SAY _PCUT
ENDIF
SET DEVICE TO SCREEN
RETURN .T.

*-----------------------------------------------------------------------------
PROCEDURE PDWidth(cChar)
IF PCOUNT()>0 .AND. VALTYPE(cChar)#'L' .AND. (Val(cPrint)>=3 .AND. Val(cPrint)<=6) .OR.cPrint='d'
   cChar:=CHR(27)+CHR(33)+CHR(17)+cChar+CHR(27)+CHR(33)+CHR(1)
ENDIF
RETURN cChar

*-----------------------------------------------------------------------------
PROCEDURE PHeader()
LOCAL nF:=IF(cPrint$'459',2,1)
LOCAL cD:=CASHIER->(Left(DESC,6))+' '+DToC(Date())+'('+ Left(Time(),5)+')' +;
          ' T#:'+SATELITE->(SubS(CPNO,3,2))+' M#:'+RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)

IF cPrint='1'
   @ PRow()  ,00 SAY _PINIT+IF(lGJour,_PALL,_PRCPT)
ENDIF
IF cPRINT='d'
   @ PRow()  ,00 SAY _PINIT+_PRCPT
ENDIF

IF cSto='2'
      @ PRow()+1,(41-Len(cJDL))/2 SAY cJDL
      @ PRow()+1,0 SAY SATELITE->STO2
      @ PRow()+1,0 SAY SATELITE->STO3
      @ PRow()+1,0 SAY SATELITE->STO4
      @ PRow()+1,0 SAY ''
ENDIF
@ Prow()+nF,00 SAY cD
JPrint(Prow()  ,40, cD)
@ Prow()+1,00 SAY Chr(13)
   IF !Empty(cGSales)
      SELECT SALES
      LOCATE FOR CODE=cGSales
      cSales:='SALES  : '+cGSales+'þ'+SALES->DESC
      @ PRow()+1 ,00     SAY cSales
      JPrint(PRow()+1,40,cSales)
      SELECT TEMP
   ENDIF
   IF !Empty(cGCCN)
      @ PRow()+1,00 SAY 'MEMBER : '+AllTrim(cGCCN)+'þ'+Left(cGNm,20)
   ENDIF
@ Prow()+1,00 SAY Replicate('-',40)
@ Prow()+1,00 SAY 'Qty Unt Nama Barang     Harga      Total'
@ Prow()+1,00 SAY Replicate('-',40)
RETURN .T.
*-----------------------------------------------------------------------------
PROCEDURE ResetKey(a)
cGKey:=''
TOMBOL->(DBGoTop())
DO WHILE !TOMBOL->(Eof())
   IF TOMBOL->ASSIGN#0
      cGKey+=Chr(200-TOMBOL->ASSIGN)
   ENDIF
   TOMBOL->(DBSkip())
ENDDO
a:=GetPosKey(cGKey)
RETURN

*-----------------------------------------------------------------------------
PROCEDURE ClearEntry()
//@ 04,02 SAY 'Sts³Kode Brg³Keterangan               ³Qty³    Harga³ %³     Disc³     Total' //COLOR '/w'
//           2345678901234567890123456789012345678901234567890
@ 06,00 SAY 'ÃÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´'
@ 07,01 SAY  '    ³ Kode   ³ Nama Barang             ³Qty³    Harga³ %  Discount³     Total '
@ 08,00 SAY 'ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÂÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´'
@ 07,01 SAY  '    ³ Kode   ³ Nama Barang             ³Qty³    Harga³ %  Discount³     Total '
//            12345678901234567890123456789012345678901234567890123456789012345678901234567890
@ 07,06 say ' Kode'             COLOR 'w+'
@ 07,15 say ' Nama Barang'      COLOR 'w+'
@ 07,41 say 'Qty'               COLOR 'w+'
@ 07,49 say 'Harga'             COLOR 'w+'
@ 07,56 say '%  Discount'       COLOR 'w+'
@ 07,73 say 'Total'             COLOR 'w+'
DispBegin()
@ 20,02 SAY 'ÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÁÄÄÄÄÄÄÄÄÄÅÄÄÁÄÄÄÄÄÄÄÄÄÁ' //color 'w+/w'
//@ 9,01,19,78 Kotak '		 '
//@ 9,05,19,05 Kotak 'Â³ Â³Â³Â³ Â³Â³ '
//@ 9,14,19,40 Kotak 'Â³ Â³Â³Â³ Â³Â³ '
//@ 9,44,19,54 Kotak '³ ³³³ ³³ '
//@ 9,57,19,67 Kotak '³ ³³³ ³³ '
DispEnd()
RETURN

*-----------------------------------------------------------------------------
PROCEDURE ResetMem(a)
lGBarCode:=.F. && DATA STATUS FROM BAR CODE READING
nGKeyLock:=0   && KEY LOCK STATUS

lGStl:=.F.     && FlipFlop SubTotal Disc
lGEdit:=.F.    && Status Editing Entry...
cGDFlag:=''    && Discount Flag Sub Total
cGDDesc:=''    && Discount Desc Sub Total
nGDisc:=0      && Discount Sub total
nGStl:=0       && Sub Total
nGSales:=''    &&

lGRTN:=.F.     && STATUF RTN / PLU

lGVOD:=.F.     && STATUS VOD
//cGKey:=''    && Key Mapping.......
cGLCd:=''      && Login Cashier
cGLPs:=''      && Password Cashier
//lGLan:=.F.
nGBrs:=8
ResetKey(@a)
RETURN

*-----------------------------------------------------------------------------
FUNCTION ChkDrv(nFSize)
DO WHILE LASTKEY()#27
   IF !DiskReadyW('A')
      pesan(' Diskette Tidak Siap / Write Protec ... ! ')
   ELSEIF nFSize > DiskFree('A')
      pesan(' Diskette Sudah Penuh, Ganti Dengan Disket Kosong ... ! ')
   ELSE;RETURN .T.
   ENDIF
ENDDO
RETURN .F.
*-----------------------------------------------------------------------------
FUNCTION New()
IF LastRec()=0
   AddRec()
   FIELD->FLAG :='NEW'
   FIELD->CODE :=IF(lGTimePr='Y',Time(),SPACE(8))
   FIELD->DESC :=CASHIER->CODE+'þ'+CASHIER->DESC
   FIELD->QTY  :=0
   FIELD->PRICE:=SATELITE->MCHNID
   FIELD->NORCP:=SATELITE->NORCP
   FIELD->ETYPE:='A'
   * FIELD->VIP  :=cGVipNo
   SET DEVI TO PRINT
   PHeader()
   @ Prow(),1 Say ''
   SET DEVI TO SCREEN
   RETURN .T.
ENDIF
RETURN .F.

*-----------------------------------------------------------------------------
PROCEDURE CapTransfer(l)
LOCAL  cA:=ALIAS(),cF,cCPNO:=SATELITE->(SubS(CPNO,3,2))
LOCAL cTxt,cPTxt:="C:\WPI\POS\"
LOCAL nBelanja:=0,nTTL:=0,nCash:=0,cTender:='',cCusCode:=''
LOCAL cDt:=SATELITE->(DToS(CPDT)),cCP:=Left(SATELITE->CPNO,4)+Right(cDt,4)

IF l=NIL
   l=.f.
ENDIF

CP->(DBGOBOTTOM())
IF CP->(LastRec())=0
   SATELITE->CPDT:=Date()
ENDIF
SELECT TEMP
nBelanja:=TEMP->PRICE
sBelanja:=Substr(DTOS(DATE()),5,2)
IF CUS->(DBSEEK(LEFT(cCGCus,10))) .AND. !Empty(AllTrim(cCGCus))
   CUS->(RecLock())
   CUS->B&sBelanja+=nBelanja
   CUS->(DBUNLOCK())
ENDIF

TEMP->(DBGOTOP())
cNORCP:=Right('0000'+Alltrim(TEMP->(Str(NORCP))),4)
cTxt:=Right(DToS(Date()),4)+cNORCP+'.'+cCPNO
IF CP->NORCP==TEMP->NORCP .AND. !CP->(BOF())
   DO WHILE CP->NORCP==TEMP->NORCP .AND. !CP->(BOF())
      IF _ICS#1
      ENDIF
      CP->(DBDELETE())
      CP->(DBSKIP(-1))
   ENDDO
   CP->(__dbPack())
ENDIF
DO WHILE !TEMP->(EOF())
   CP->(AddRec())
   CP->FLAG    := TEMP->FLAG
   CP->CODE    := TEMP->CODE
   CP->DESC    := TEMP->DESC
   CP->UNIT    := TEMP->UNIT
   CP->QTY     := TEMP->QTY
   CP->PRICE   := TEMP->PRICE
   CP->CPRICE  := TEMP->CPRICE
   CP->NORCP   := TEMP->NORCP
   CP->ETYPE   := TEMP->ETYPE
   CP->DDATE   := DATE()
   CP->GROUP   := TEMP->GROUP
   CP->DEPT    := TEMP->DEPT
   CP->SALES   := TEMP->SALES
   CP->CUSCODE := cGCCN
   CP->TJQTY    := TEMP->TJQTY
*  CP->HPHR    := TEMP->HPHR
*  CP->VIP     := TEMP->VIP
   CP->(DBUNLOCK())
   IF !NNETLOGGED() .AND. TEMP->FLAG='TTL'
      MARIMAR->(ADDREC())
      MARIMAR->FLAG    :=  TEMP->FLAG
      MARIMAR->CODE    :=  TEMP->CODE
      MARIMAR->DESC    :=  TEMP->DESC
      MARIMAR->UNIT    :=  TEMP->UNIT
      MARIMAR->QTY     :=  TEMP->QTY
      MARIMAR->PRICE   :=  TEMP->PRICE
      MARIMAR->CPRICE  :=  TEMP->CPRICE
      MARIMAR->NORCP   :=  TEMP->NORCP
      MARIMAR->ETYPE   :=  TEMP->ETYPE
      MARIMAR->DDATE   :=  DATE()
      MARIMAR->GROUP   :=  TEMP->GROUP
      MARIMAR->DEPT    :=  TEMP->DEPT
      MARIMAR->SALES   :=  TEMP->SALES
      MARIMAR->TJQTY    :=  TEMP->TJQTY
      MARIMAR->CUSCODE :=  cGCCN
*     MARIMAR->HPHR    :=  TEMP->HPHR
*     MARIMAR->VIP     :=  TEMP->VIP
      MARIMAR->(DBUNLOCK())
   ENDIF
   IF lGLan 
      RCP->(AddRec())
      RCP->FLAG   := CP->FLAG
      RCP->CODE   := CP->CODE
      RCP->DESC   := CP->DESC
      RCP->UNIT   := CP->UNIT
      RCP->QTY    := CP->QTY
      RCP->PRICE  := CP->PRICE
      RCP->CPRICE := CP->CPRICE
      RCP->NORCP  := CP->NORCP
      RCP->ETYPE  := CP->ETYPE
      RCP->CHKDT  := CP->CHKDT
      RCP->GROUP  := CP->GROUP
      RCP->DEPT   := CP->DEPT
      RCP->SALES  := CP->SALES
      RCP->TJQTY   := CP->TJQTY
      RCP->CUSCODE:=cGCCN
*     RCP->HPHR  := CP->HPHR
*     RCP->VIP   := CP->VIP
      RCP->(DBUNLOCK())
   ENDIF
   IF FLAG='PLU'.OR.FLAG='VOD'.OR.FLAG='RTN'
      nQTY+=(QTY*IF(FLAG='RTN'.OR.FLAG='VOD',-1,1))
   ENDIF
   IF FLAG='TTL'
      nTTL:=PRICE
   ENDIF
   IF !Empty(cGCcn) .AND. FLAG#'TTL'.AND. Left(FLAG,1)='T' //.AND. FLAG#'T05'
      cTENDER:=AllTrim(DESC)
      nCash+=PRICE       //IF(FLAG#'T05',PRICE,0)
   ENDIF
   IF FLAG='T'  .AND. Val(Right(FLAG,2))>0 .AND. !Empty(cGCCn)  //'T05'
      cTENDER:=AllTrim(DESC)
      cCUSCODE:=cGCCn
      IF CUS->(DBSeek(cCUSCODE))
         CUS->(RecLock())
         CUS->TTLPURCH  +=PRICE  //(nTTL-nCash)
         CUS->LASTPURCH :=Date()
         CUS->VALLPURCH :=PRICE  //(nTTL-nCash)
         CUS->(DBCommit())
         CUS->(DBUnLock())
      ENDIF
      IF CUSDET->(AddRec())
         CUSDET->(RecLock())
         CUSDET->CODE     := cCUSCODE
         CUSDET->NAME     := CUS->NAME
         CUSDET->DATE     := Date()
         CUSDET->RCPTNO   := NORCP
         CUSDET->QTY      := nQTY
         CUSDET->TOTAL    := nTTL
         CUSDET->REMARK   := cTENDER
         CUSDET->STL      := cCPNO
         CUSDET->CPEOD    := Left(SATELITE->CPNO,4)+Right(cDt,4)  //cCP
         CUSDET->(DBCommit())
         CUSDET->(DBUnLock())
         nTTL:=0;nQTY:=0;nCash:=0 ;cTENDER:=''
      ENDIF
   ENDIF
   IF _ICS#1
   ENDIF
   TEMP->(DBSKIP())
ENDDO
DBCOMMITALL()
IF lGLan 
   cF:=SATELITE->CPNO+'.DBF'
   DLL->(DBGOTO(VAL(SubS(cF,3,2))))
   IF DLL->(RecLock())
      DLL->TSALES+=nGStl-(IF(nGDisc>.99,nGDisc,nGDisc*nGStl))
      DLL->NORCP:=SATELITE->NORCP
      DLL->WAKTU:=IF(lGTimePr='Y',Time(),SPACE(8))
   // uji coba untuk control lupa EOD
      IF CP->NORCP=1 .OR. DLL->(EMPTY(TGLOPEN))
         DLL->TGLOPEN:=SATELITE->(DTOC(CPDT))
      ENDIF
   // akhir uji coba
      DLL->(DBUnlock())
   ENDIF
ENDIF
IF !lGLAN               // LUPA EOD U/ STAND ALONE
   IF CP->NORCP=1 .OR. SATELITE->(EMPTY(TGLOPEN))
      SATELITE->(RecLock())
      SATELITE->TGLOPEN:=SATELITE->(DTOC(CPDT))
      SATELITE->(DBUnLock())
   ENDIF
ENDIF
IF l
   SATELITE->NORCP+=0
ELSE
   SATELITE->NORCP+=1
ENDIF
DBCOMMITALL()
SELECT TEMP
ZAP
SELECT (cA)
IF (nH:=FCreate(cPTxt+cTxt,0))>=0
   FClose(nH)
ENDIF
RETURN

*-----------------------------------------------------------------------------
FUNCTION Wrong(c)
LOCAL cScrn,nP,nCa,nCb;
,nK,cOldColr:=SetColor()
IF c=NIL
   c:=' Salah Tombol, Tekan [CLEAR]... '
ENDIF
nP:=Len(c)
SETCOLOR('gr+*/r')
nCA:=(79-nP)/2 ;nCB:=nCA+nP+1
cScrn:=SAVESCREEN(13,nCa,16,nCb+2)
Kotak(13,nCa,15,nCb,'w+/r')
SetPos(14,nCa+1);DispOut(c)
SELECT TOMBOL
GO BOTTOM
SKIP
DO WHILE ASSIGN#_CLEAR;nP:=Inkey(0)
   LOCATE FOR ASCII=nP
ENDDO
RESTSCREEN(13,nCa,16,nCb+2,cScrn)
SETCOLOR(cOldColr)
SELECT TEMP
RETURN .T.
*-----------------------------------------------------------------------------
FUNCTION Wrong2(c)
LOCAL cScrn,nP,nCa,nCb;
,nK,cOldColr:=SetColor()
IF c=NIL
   c:=' Salah Tombol, Tekan [CLEAR]... '
ENDIF
nP:=Len(c)
SETCOLOR('gr+*/r')
nCA:=(79-nP)/2 ;nCB:=nCA+nP+1
cScrn:=SAVESCREEN(13,nCa,16,nCb+2)
//@ 11,nCa,13,nCb Kotak "ÉÍ»º¼ÍÈº " COLOR 'w+/r'
Kotak(13,nCa,15,nCb,'w+/r')
SetPos(14,nCa+1);DispOut(c)
SELECT TOMBOL
GO BOTTOM
SKIP
DO WHILE ASSIGN#_CLEAR;nP:=Inkey(0)
   LOCATE FOR ASCII=nP
ENDDO
RESTSCREEN(13,nCa,16,nCb+2,cScrn)
SETCOLOR(cOldColr)
SELECT TEMP
RETURN .T.

*-----------------------------------------------------------------------------
FUNCTION Allert(c)                                 //Dar 6/11
LOCAL cScrn,nP,nCa,nCb,cOldColr:=SetColor()
IF c=NIL
   c:=' Salah Tombol, ... '
ENDIF
nP:=Len(c)
SETCOLOR('gr+*/r')
nCA:=(79-nP)/2 ;nCB:=nCA+nP+1
cScrn:=SAVESCREEN(11,nCa,14,nCb+2)
//@ 11,nCa,13,nCb Kotak "ÉÍ»º¼ÍÈº " COLOR 'w+/r'
SetPos(12,nCa+1);DispOut(c)
TONE(3000,4)
InKey(.5)
RESTSCREEN(11,nCa,14,nCb+2,cScrn)
SETCOLOR(cOldColr)
RETURN .T.

*-----------------------------------------------------------------------------
FUNCTION S_PRINT(cP_data1)
LOCAL cP_data,cP_data2
cP_data=cP_data1 +IF(lGJour,cP_data1,'')
SET DEVICE TO PRINTER
@ PRow()+1,0 SAY PADL(cP_data,IF(lGJour,80,40))
SET DEVICE TO SCREEN
RETURN
*-----------------------------------------------------------------------------
FUNCTION PCutter3()
SET DEVICE TO PRINTER
SET CONSOLE OFF
@ PRow()+5,(41-Len(cJDL))/2 SAY cJDL
@ PRow()+1,0 SAY SATELITE->STO2
@ PRow()+1,0 SAY SATELITE->STO3
@ PRow()+1,0 SAY SATELITE->STO4
@ PRow()  ,0 SAY _PCUT
//@ PRow()+2,0 SAY SATELITE->COM1
//@ PRow()+1,0 SAY SATELITE->COM2
SET CONSOLE ON
SET DEVICE TO SCREEN
RETURN .T.


*-----------------------------------------------------------------------------
FUNCTION PCupon(nR,nTRECIP,nBA,lEkm,cAl)
LOCAL cD:=CASHIER->CODE
LOCAL cX:=DToC(Date())+IF(lGTimePr='Y', '-'+Left(Time(),5), SPACE(5))
LOCAL nTER:=SATELITE->(SubS(CPNO,3,2))+'-'+RIGHT('00000'+ALLTRIM(TRAN(nR,'99999')),5)+'-'+;
      cD+' - '+cX
LOCAL cKtotal:=Tran(nTRECIP,'99,999,999')         // nilai totalnya gede
LOCAL cBAK   :=RIGHT('   '+ALLTRIM(TRAN(nBA,'999')),3)
SET DEVICE TO PRINTER
@ PRow()  ,00 SAY _PINIT+_PRCPT
IF lEkm=NIL  .AND. TEMP->(LASTREC())=0
   @ PRow()+1,0 SAY PDWIDTH('   COPY KUPON/POINT   ')
ENDIF
@ PRow()+1,0 SAY '         ***TERIMA KASIH***       '
@ PRow()+1,0 SAY nTER
@ PRow()+1 ,08 SAY 'Total Belanja: '+cKtotal
@ PRow()+1 ,08 SAY 'Total Point  :       '+cBAK
IF !SATELITE->(Empty(TGLKPN))
   @ PRow()+1 , 0 SAY 'Kupon berlaku s/d tgl. '+TRANSDATE(SATELITE->TGLKPN)
ENDIF
IF !Empty(cGCcn) .AND. CUS->(DBSeek(cGCcn))
   CUS->(RecLock())
   CUS->TTLPOINT+=nBA
   CUS->(DBUnLock())
ENDIF
IF lEkm=NIL  .AND. TEMP->(LASTREC())=0
   PCUTTER()
   SET DEVICE TO SCREEN
   RETURN .T.
ENDIF
IF cAl='TEMP'
   PCUTTER()
ENDIF
PCUTTER()
SET DEVICE TO SCREEN
RETURN .T.
*------------------------------------------------------------------------------
FUNCTION TransDate(dD)
dD:= IF(ValType(dD)#'D',dSetTgl,dD)
RETURN Str(Day(dD),2)+' '+FBulan(Month(dD))+' ' +Str(Year(dD),4)

*------------------------------------------------------------------------------
FUNCTION FBulan(x)
LOCAL aBulan,xx
 xx:=IF(x=NIL,Month(dSetTgl),x)
 aBulan:={'Jan','Feb','Mar','Apr','Mei','Juni','Juli','Agus','Sep','Okt','Nov','Des'}
RETURN abulan[xx]

*-----------------------------------------------------------------------------
FUNCTION FHari(x)
 LOCAL aHari,xx
 xx:=IF(x=NIL,DoW(dSetTgl),x)
 aHari:={'Minggu','Senin','Selasa','Rabu','Kamis',"Jum'at",'Sabtu'}
RETURN aHari[xx]

*-----------------------------------------------------------------------------
FUNCTION ChkDisk(DISK)
 DO WHILE .T.
    IF !DiskReady(disk)
       IF Teruskan('Disket/disk drive belum siap...!!',' Ulangi ',' Batal ')
          LOOP
       ELSE ;RETURN .F.
       ENDI
    ENDI
    EXIT
 ENDDO
RETURN .T.

*------------------------------------------------------------------------------
FUNCTION ChkDiskWr(DISK)
 DO WHILE .T.
    IF !DiskReadyW(disk)
       IF Teruskan('Disket di drive '+disk+': di write protect...!',' Ulangi ',' Batal ')
          LOOP
       ELSE ;RETURN .F.
       ENDI
    ENDI
    EXIT
 ENDDO
RETURN .T.

*------------------------------------------------------------------------------
FUNCTION FPassW()
LOCAL cPass:=Space(6),cScr:=SaveScreen(10,00,12,79)
LOCAL nR:=CASHIER->(RecNo()),lRet:=.T.
@ 10,30 CLEAR TO 12,50
@ 10,30 TO 12,50 DOUBL
cPass:=GetSecret(cPass,11,32,.F.,'PassWord: ')
RestScreen(10,00,12,79,cScr)
IF Empty(cPass)
   lRet:=.F.
ELSE
   CASHIER->(__DBLocate( {||PASS==cPass},,,,.F. ))
   IF CASHIER->SPV='0' .OR. CASHIER->(Empty(SPV))
      lRet:=.F.
   ENDIF
ENDIF
CASHIER->(DBGoTo(nR))
RETURN lRet

*------------------------------------------------------------------------------
FUNCTION Kotak(nT,nL,nB,nR,cColor,nKotak)
LOCAL cOldColor,cS
 cS:=SaveScreen(nT+1,nL+1,nB-1,nL-1)
 cOldColor:=SetColor()
 cColor:=IF(cColor=NIL,cOldColor,cColor)
 dispKotak(nT,nL,nB,nR,MY_B_SINGLE+" ",cColor)
RETURN {}

*==============================================================================
PROCEDURE pesan(cPesan)  &&____________Beep 3 times & Print messages Windows in 3 Second
LOCAL cScrn,nPanjang,nCa;
,nCb,cOldColr:=SetColor(),aKotak
SETCOLOR('gr+/gr')
nPanjang:=LEN(cPesan)
nCA  :=(79-nPanjang)/2
nCB  :=nCA+nPanjang+1
cScrn:=SAVESCREEN(13,nCa,16,nCb+2)
aKotak:=Kotak(13,nCa,15,nCb,'w+/gr')    // Kotak "ÉÍ»º¼ÍÈº " COLOR 'w+/r'
SetPos(14,nCa+1);DispOut(cPesan)
TONE(2500,2)
TONE(2800,4)
TONE(3000,3)
SETCOLOR(cOldColr)
DO WHILE INKEY(1)#0
ENDDO
KotakPush(aKotak) ;KotakClose(aKotak)
RESTSCREEN(13,nCa,16,nCb+2,cScrn)
RETURN

*-----------------------------------------------------------------------------
PROCEDURE JPrint(nR,nC,cT,cP)
cP:=IF(cP=NIL,'',cP)
IF lGJour
   IF !Empty(cP)
      @ nR,nC SAY cT  PICT cP
   ELSE
      @ nR,nC SAY cT
   ENDIF
ENDIF
RETURN

*-----------------------------------------------------------------------------
PROCEDURE InitPrn()
PUBLIC _PCR,_PLF,_PINI,_PESC,_PDOU,_PSIG,_PPEN,_PSTM,_PGAB,_PCUT,_PSTMP
PUBLIC _PINIT,_PJOUR,_PRCPT,_PALL,_PVLDS,_PVBCK,_PRFEED,_PLFEED,_PCUTER,_POPEN
DO CASE
CASE cPrint='1'                  //DRJST-50
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := chr(33)
   _PSTM   := chr(111)
   _PGAB   := chr(113)
   _PCUT   := chr(27)+chr(64)+chr(27)+chr(105)
   _PSTMP  := chr(27)+chr(64)+chr(27)+chr(111)
   _PINIT  := chr(27)+chr(64)+chr(27)+'c6'+chr(1)+"E@"
   _PJOUR  := chr(27) +'c0'+chr(1)
   _PRCPT  := chr(27) +'c0'+chr(2)
   _PALL   := chr(27) +'c0'+chr(3)
   _PVLDS  := chr(27) +'c0'+chr(4)
   _PVBCK  := chr(27) +'F'+chr(1)
   _PRFEED := chr(27) +'e'+chr(1)
   _PLFEED := chr(27) +chr(100)
   _PCUTER := chr(27)+chr(64)+chr(27)+chr(105)
   _POPEN  := chr(27)+chr(64)+CHR(27)+'p'+CHR(0)+CHR(15)+CHR(60)
CASE cPrint='2'                  //DRJST-51
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := chr(33)
   _PSTM   := chr(111)
   _PGAB   := chr(113)
   _PCUT   := chr(27)+chr(64)+chr(27)+chr(105)
   _PSTMP  := chr(27)+chr(64)+chr(27)+chr(111)
   _PINIT  := chr(27)+chr(64)+chr(27)+'c6'+chr(1)
   _PJOUR  := chr(27) +'c0'+chr(1)
   _PRCPT  := chr(27) +'c0'+chr(2)
   _PALL   := chr(27) +'c0'+chr(3)
   _PVLDS  := chr(27) +'c0'+chr(4)
   _PVBCK  := chr(27) +'F'+chr(1)
   _PRFEED := chr(27) +'e'+chr(1)
   _PLFEED := chr(27) +chr(100)
   _PCUTER := chr(27)+chr(64)+chr(27)+chr(105)
   _POPEN  := chr(27)+chr(64)+CHR(27)+'p'+CHR(0)+CHR(15)+CHR(60)
CASE cPrint='3'                 //EPSON-TM210PD
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := chr(33)
   _PSTM   := ' '
   _PGAB   := ''
   _PCUT   := ''        //Chr(29)+'V'+Chr(65)+Chr(0)
   _PSTMP  := ''
   _PINIT  := chr(27)+chr(64)
   _PJOUR  := ' '
   _PRCPT  := ' '
   _PALL   := ' '
   _PVLDS  := ' '
   _PVBCK  := ' '
   _PRFEED := chr(27) +'d'+chr(1)
   _PLFEED := chr(27) +'d'+chr(1)
   _PCUTER := ''        //chr(27)+'V'+Chr(65)+Chr(0)
   _POPEN  := chr(27)+chr(64)+CHR(27)+'p'+CHR(0)+CHR(15)+CHR(60)
CASE cPrint='4'                  //EPSON-TM300PA/PB
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := chr(33)
   _PSTM   := ' '
   _PGAB   := ' '
   _PCUT   := chr(27)+chr(64)+chr(27)+chr(105)
   _PSTMP  := ' '
   _PINIT  := chr(27)+chr(64)
   _PJOUR  := ' '
   _PRCPT  := ' '
   _PALL   := ' '
   _PVLDS  := ' '
   _PVBCK  := ' '
   _PRFEED := chr(27) +'d'+chr(1)
   _PLFEED := chr(27) +'d'+chr(1)
   _PCUTER := chr(27)+chr(64)+chr(27)+chr(105)
   _POPEN  := chr(27)+chr(64)+CHR(27)+'p'+CHR(0)+CHR(15)+CHR(60)
CASE cPrint='5' .or. cPrint='e'        //EPSON-TM300PC/PD/88
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := chr(33)
   _PSTM   := ' '
   _PGAB   := ' '
   _PCUT   := chr(27)+chr(64)+chr(27)+chr(105)
   _PSTMP  := ' '
   _PINIT  := chr(27)+chr(64)
   _PJOUR  := chr(27) +'c0'+chr(1)
   _PRCPT  := chr(27) +'c0'+chr(1)
   _PALL   := chr(27) +'c0'+chr(1)
   _PVLDS  := chr(27) +'c0'+chr(8)
   _PVBCK  := chr(27) +'f'+chr(0)+Chr(10)
   _PRFEED := chr(27) +'d'+chr(1)
   _PLFEED := chr(27) +'d'+chr(1)
   _PCUTER := chr(27)+chr(64)+chr(27)+chr(105)
   _POPEN  := chr(27)+chr(64)+CHR(27)+'p'+CHR(0)+CHR(15)+CHR(60)
CASE cPrint='6'                  //EPSON-TM300 w/o CUTTER
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := chr(33)
   _PSTM   := ' '
   _PGAB   := ' '
   _PCUT   := ' '
   _PSTMP  := ' '
   _PINIT  := chr(27)+chr(64)
   _PJOUR  := ' '
   _PRCPT  := ' '
   _PALL   := ' '
   _PVLDS  := ' '
   _PVBCK  := ' '
   _PRFEED := chr(27) +'d'+chr(1)
   _PLFEED := chr(27) +'d'+chr(1)
   _PCUTER := ' '
   _POPEN  := chr(27)+chr(64)+CHR(27)+'p'+CHR(0)+CHR(15)+CHR(60)
CASE cPrint='7'                  //SAMSUNG-SRP250
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := Chr(33)
   _PSTM   := ' '
   _PGAB   := ' '
   _PCUT   := Chr(27)+'i'
   _PSTMP  := ' '
   _PINIT  := chr(27)+chr(64)
   _PJOUR  := ' '
   _PRCPT  := ' '
   _PALL   := ' '
   _PVLDS  := ' '
   _PVBCK  := ' '
   _PRFEED := Chr(27)+'d'+Chr(1)
   _PLFEED := Chr(13)+'d'+Chr(1)
   _PCUTER := chr(27)+chr(64)+chr(27)+chr(105)
   _POPEN  := chr(27)+chr(64)+CHR(27)+'p'+CHR(0)+CHR(15)+CHR(60)
CASE cPrint='8'                  //EPSON-LX800
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := Chr(33)
   _PSTM   := ' '
   _PGAB   := ' '
   _PCUT   := Chr(27)+'i'
   _PSTMP  := ' '
   _PINIT  := chr(27)+chr(64)
   _PJOUR  := ' '
   _PRCPT  := ' '
   _PALL   := ' '
   _PVLDS  := ' '
   _PVBCK  := ' '
   _PRFEED := Chr(13)+Chr(10)
   _PLFEED := Chr(13)+Chr(10)
   _PCUTER := ' '
   _POPEN  := ' '
CASE cPrint='9'                  //IBM SUREONE
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := Chr(33)
   _PSTM   := ' '
   _PGAB   := ' '
   _PCUT   := Chr(27)+'i'
   _PSTMP  := ' '
   _PINIT  := chr(27)+chr(64)
   _PJOUR  := ' '
   _PRCPT  := ' '
   _PALL   := ' '
   _PVLDS  := ' '
   _PVBCK  := ' '
   _PRFEED := Chr(13)+Chr(10)
   _PLFEED := Chr(13)+Chr(10)
   _PCUTER := ' '
   _POPEN  := ' '
CASE cPrint='a'                  //STAR
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := chr(33)
   _PSTM   := ''
   _PGAB   := ''
   _PCUT   := chr(27)+'d'+chr(0)
   _PSTMP  := ''
   _PINIT  := chr(27)+chr(64)
   _PJOUR  := ''
   _PRCPT  := ''
   _PALL   := ''
   _PVLDS  := ''
   _PVBCK  := ''
   _PRFEED := chr(27) +'d'+chr(1)
   _PLFEED := chr(27) +'d'+chr(1)
   _PCUTER := ''        //chr(27)+'V'+Chr(65)+Chr(0)
   _POPEN  := chr(28)   //chr(27)+chr(64)+CHR(27)+'p'+CHR(0)+CHR(15)+CHR(60)
CASE cPrint='b' .or. cPrint='g'                   //STAR
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := chr(33)
   _PSTM   := ''
   _PGAB   := ''
   _PCUT   := ''        //Chr(29)+'V'+Chr(65)+Chr(0)
   _PSTMP  := ''
   _PINIT  := if(cPrint='b',chr(27)+chr(64),'')
   _PJOUR  := ''
   _PRCPT  := ''
   _PALL   := ''
   _PVLDS  := ''
   _PVBCK  := ''
   _PRFEED := Chr(13)+Chr(10)
   _PLFEED := ''
   _PCUTER := chr(27)+'P'+Chr(1)
   _POPEN  := chr(27)+chr(64)+CHR(27)+'p'+CHR(0)+CHR(15)+CHR(60)
CASE cPrint='c' .or. cPRINT='f'                 //SAMSUNG-SRP200
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := chr(33)
   _PSTM   := ' '
   _PGAB   := ''
   _PCUT   := ''        //Chr(29)+'V'+Chr(65)+Chr(0)
   _PSTMP  := ''
   _PINIT  := ' '       //chr(27)+chr(64)
   _PJOUR  := ' '
   _PRCPT  := ' '
   _PALL   := ' '
   _PVLDS  := ' '
   _PVBCK  := ' '
   _PRFEED := chr(10)
   _PLFEED := ' '
   _PCUTER := ''        //chr(27)+'V'+Chr(65)+Chr(0)
   _POPEN  := chr(27)+chr(64)+CHR(27)+'p'+IF(cPRINT='f',CHR(0)+CHR(15)+CHR(60),CHR(0)+CHR(20))
OTHERWISE
   _PCR    := chr(13)
   _PLF    := chr(10)
   _PINI   := chr(64)
   _PESC   := chr(27)
   _PDOU   := chr(32)
   _PSIG   := chr(0)
   _PPEN   := Chr(33)
   _PSTM   := ' '
   _PGAB   := ' '
   _PCUT   := ' '
   _PSTMP  := ' '
   _PINIT  := ' ' //chr(27)+chr(64)+Chr(15)
   _PJOUR  := ' '
   _PRCPT  := Chr(15)
   _PALL   := Chr(15)
   _PVLDS  := ' '
   _PVBCK  := ' '
   _PRFEED := Chr(13)+Chr(10)
   _PLFEED := Chr(13)+Chr(10)
   _PCUTER := ' '
   _POPEN  := ' '
ENDCASE
RETURN .T.
*-----------------------------------------------------------------------------
FUNCTION PrnTgt(cFiTgt)
LOCAL nTgt:=1, cPort, cOldCol:=SetColor(), cScr:=SaveScreen(00,00,24,79)
LOCAL aKotak,aKotak1,aKotak2,aKotak3,aKotak4
SET COLOR TO B/W,BG+/W
   aKotak:=KotakOpen(18,27,23,63,'W',0.3)
   Tengahin('PRINTING TARGET',19,27,63)
   aKotak1:=KotakOpen(20,29,22,38,'W',0.3)
   aKotak2:=KotakOpen(20,40,22,50,'W',0.3)
   aKotak3:=KotakOpen(20,52,22,61,'W',0.3)
   @21,30 PROMPT ' Screen '
   @21,41 PROMPT ' Printer '
   @21,53 PROMPT ' Cancel '
   MENU TO nTgt
   DO CASE
      CASE nTgt=1 ;KotakPush(aKotak1)
                   SET DEVICE TO PRINTER ;SET PRINT TO (cFiTgt)  //;SET PRINT ON
      CASE nTgt=2 ;KotakPush(aKotak2)
                   ** IF !ChkPrinter('LPT1') ;nTgt:=0 ;ENDIF
      CASE nTgt=3 .OR. nTgt=0 ;KotakPush(aKotak3) ;nTgt:=0
   ENDCASE
   KotakClose(aKotak)

SetColor(cOldCol)
RestScreen(00,00,24,79,cScr)
RETURN nTgt

*==============================================================================
FUNCTION DispRep(cFiPrn)
 LihatTeks(cFiPrn,2,0,23,79,'W/N')
 DELETE FILE (cFiPrn)
RETURN
*------------------------------------------------------------------------------
FUNCTION DispRepR(nTgt,cTxt,nT,nL,nB,nR)
cClr:=SETCOLOR()
//@24,1 SAY '                              '
SET PRINT TO ;SET PRINT OFF ;SET DEVICE TO SCREEN
IF nTgt=1
    rep:=BUKA(cTxt)
    IF !Empty(rep)
      SetColor('w+')
//      @ 02,00,02,79 Kotak 'ÄÄÄÄÄÄÄÄÄ'     &&___Kotak 'ßßßßßßßßß'
//      @ 27,00,27,79 Kotak 'ÄÄÄÄÄÄÄÄÄ'     &&___Kotak 'ÜÜÜÜÜÜÜÜÜ'
      LIHAT(rep,1,26,1)
      TUTUP(rep)
   ENDIF
ENDIF
SETCOLOR(cClr)
RETURN
*------------------------------------------------------------------------------
function BUKA(Arg1)
   local Local1, Local2, Local3, Local4, Local5, Local6, Local7:= ;
      1024, Local8:= SaveScreen(1, 30, 4, 49), Local9, Local10, ;
      Local11, Local12, Local13
   Local9:= npos:= ni:= 0
   Local10:= cd:= cmtr:= ""
   Local11:= SetColor()
   Local12:= Space(1024)
   Local13:= Chr(13) + Chr(10)
   if (!file(Arg1) .OR. (Local1:= fopen(Arg1)) = -1)
      peserror("File Tidak bisa di buka...!")
      return {}
   endif
   Local6:= directory(Arg1)
   Local5:= Left(l2bin(Val(SubStr(DToS(Local6[1][3]), 3))), 3)
   Local5:= Local5 + Left(l2bin(Val(strtran(Local6[1][4], ":"))), 3)
   Local5:= "widi." + Chr(26) + Local5
   Local9:= At(".", Arg1)
   Local10:= iif(Local9 != 0, Left(Arg1, Local9 - 1), Trim(Arg1)) + ;
      ".PTR"
   if (file(Local10) .AND. (Local2:= fopen(Local10)) != -1)
      cmtr:= Space(12)
      fread(Local2, @cmtr, 12)
      if (cmtr == Local5)
         return {Local1, Local2}
      endif
   endif
   Local2:= fcreate(Local10)
   fwrite(Local2, Local5, 12)
   ni:= Seconds()
   DispKotak(1, 30, 4, 49, Space(9), "/r")
   SetPos(2, 34)
   dispout("Reading.....", "w*/r")
   SetColor("bg+/b")
   SetPos(3, 31)
   dispout(Replicate(" ", 18))
   Local3:= fseek(Local1, 0, 2)
   fseek(Local1, 0, 0)
   while (Local7 = 1024)
      Local7:= fread(Local1, @Local12, 1024)
      cmtr:= kerjakan(3, 31, 18, Local3, npos, cmtr, "b/w")
      cd:= cd + Left(Local12, Local7)
      while (.T.)
         Local9:= At(Local13, cd)
         if (Local9 != 0)
            fwrite(Local2, l2bin(npos), 3)
            cd:= SubStr(cd, Local9 + 2)
            npos:= npos + (Local9 + 1)
         else
            exit
         endif
      end
   end
   fwrite(Local2, l2bin(npos), 3)
   npos:= npos + (Len(cd) + 1)
   fwrite(Local2, l2bin(npos), 3)
   cmtr:= kerjakan(3, 31, 18, Local3, Local3, cmtr, "b/w")
   cd:= Transform(Seconds() - ni, "999.99")
   SetPos(2, 34)
   dispout(" Time" + cd, "w+/r")
   RestScreen(1, 30, 4, 49, Local8)
   SetColor(Local11)
   InKey(1)
   return {Local1, Local2}
*------------------------------------------------------------------------------
function LIHAT(Arg1, Arg2, Arg3, Arg4)
   local Local1:= Arg1[1], Local2:= Arg1[2], Local3:= ;
      hitdat(Arg1[2]), Local4, Local5, Local6:= Space(80), Local7:= ;
      1, Local8:= -Arg2 + Arg4, Local9:= {2, 26, 4, 19, 8, 31, 30}
   Scroll(Arg2, 0, Arg3, 79)
   SetPos(Arg2, 0)
   for Local5:= Arg2 to Arg3
      if (Local5 + Local8 > Local3)
         Arg3:= Local5 - 1
         exit
      endif
      SetPos(Local5, 0)
      dispout(SubStr(atas(Local1, Local2, Local5 + Local8), Local7) ;
         + Local6)
   next
   Local5:= Arg2
   while (.T.)
      Local4:= SubStr(atas(Local1, Local2, Arg4), Local7) + Local6
      SetPos(Local5, 0)
      dispout(Local4, "w+/r")
      Local8:= InKey(0)
      SetPos(Local5, 0)
      dispout(Local4)
      do case
      case ascan(Local9, Local8) != 0
         do case
         case Local8 = 26
            Local7:= iif(Local7 > 40, Local7 - 40, 1)
         case Local8 = 2
            Local7:= Local7 + 40
         case Local8 = 8
            Local7:= 1
         case Local8 = 19
            Local7:= iif(Local7 > 1, Local7 - 1, 1)
         case Local8 = 4
            Local7++
         case Local8 = 31
            Arg4:= 1
            Local5:= Arg2
         case Local8 = 30
            Arg4:= Local3
            Local5:= Arg3
         endcase
         for Local8:= Arg2 to Arg3
            SetPos(Local8, 0)
            dispout(SubStr(atas(Local1, Local2, Local8 - Arg2 + Arg4 ;
               - (Local5 - Arg2)), Local7) + Local6)
         next
      case Local8 = 5
         Arg4:= Arg4 - (Local5 - Arg2)
         Local5:= Arg2
         if (Arg4 > 1)
            Scroll(Arg2, 0, Arg3, 79, -1)
            Arg4--
         endif
      case Local8 = 24
         Arg4:= Arg4 + (Arg3 - Local5)
         Local5:= Arg3
         if (Arg4 < Local3)
            Scroll(Arg2, 0, Arg3, 79, 1)
            Arg4++
         endif
      case Local8 = 18
         __Keyboard(Replicate("", Arg3 - Arg2))
      case Local8 = 3
         __Keyboard(Replicate("", Arg3 - Arg2))
      case Local8 = 27
         exit
      endcase
   end
   return .T.
*------------------------------------------------------------------------------
function TUTUP(Arg1)
   local Local1, Local2
   Local2:= Len(Arg1)
   for Local1:= 1 to Local2
      fclose(Arg1[Local1])
   next
   return .T.
*------------------------------------------------------------------------------
static function ATAS(Arg1, Arg2, Arg3)
   local Local1, Local2, Local3
   Local1:= "      "
   fseek(Arg2, Arg3 * 3 + 9, 0)
   fread(Arg2, @Local1, 6)
   Local3:= bin2l(Left(Local1, 3))
   Local2:= bin2l(right(Local1, 3))
   Local2:= Local2 - (Local3 + 2)
   Local1:= Space(Local2)
   fseek(Arg1, Local3, 0)
   fread(Arg1, @Local1, Local2)
   return Local1

*------------------------------------------------------------------------------
********************************
static function HITDAT(Arg1)

   return (fseek(Arg1, 0, 2) - 9) / 3 - 2

********************************
*------------------------------------------------------------------------------

procedure PESERROR(Arg1)

   local Local1, Local2, Local3, Local4, Local5
   Local5:= SetColor()
   SetColor("W+/R")
   Local2:= Len(Arg1)
   Local3:= (79 - Local2) / 2
   Local4:= Local3 + Local2 + 1
   Local1:= SaveScreen(11, Local3, 14, Local4 + 2)
   AK12:=KotakOPEN(11, Local3, 13, Local4, "R",0.3)
//   DispKotak(11, Local3, 13, Local4, "ÉÍ»º¼ÍÈº ", "w+/r")
   SetPos(12, Local3 + 1)
   dispout(Arg1)
   tone(3000, 1)
   tone(2500, 2)
   tone(2800, 3)
   InKey(1)
   SetColor(Local5)
   KotakPUSH(AK12)
   KotakCLOSE(AK12)
   RestScreen(11, Local3, 14, Local4 + 2, Local1)
   return
*------------------------------------------------------------------------------

function KERJAKAN(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7)

   local Local1, Local2:= {}, Local3:= Arg5 / Arg4, Local4:= ;
      Int(Arg2 + (Arg3 - 4) / 2), Local5
   Local5:= Int(Arg2 + Local3 * (Arg3 - 1))
   Arg6:= lier(Arg6)
   Local1:= Str(Local3 * 100, 3) + Arg6
   if (Local5 > Local4 - 1 .AND. Local5 < Local4 + 4)
      SetPos(Arg1, Local4)
      Local3:= 1 + Local5 - Local4
      dispout(Left(Local1, Local3), Arg7)
      dispout(SubStr(Local1, Local3 + 1))
   else
      SetPos(Arg1, Local5)
      dispout(" ", Arg7)
      SetPos(Arg1, Local4)
      if (Local5 > Local4 + 3)
         dispout(Local1, Arg7)
      else
         dispout(Local1)
      endif
   endif
   return Arg6
*------------------------------------------------------------------------------

function LIER(Arg1)

   return iif(Arg1 = "|", "/", iif(Arg1 = "/", "Ä", iif(Arg1 = "Ä", ;
      "\", "|")))
*******************************************************************************
*------------------------------------------------------------------------------
FUNCTION NNetLogged()
LOCAL lRet:=.T.,cCurDir:=DiskName()+':'+DirName()
//cNDRV:='C:'
PUBLIC NDATA := cNDrv+"\WPI\DAT\"
PUBLIC NDLL  := cNDrv+"\WPI\DLL\"
PUBLIC NEOD  := cNDrv+"\WPI\EOD\"
PUBLIC NHST  := cNDrv+"\WPI\HST\"
PUBLIC NTXT  := cNDrv+"\WPI\TXT\"
PUBLIC DDATA := "\KASIR\DAT\"
PUBLIC DEOD  := "\KASIR\EOD\"
PUBLIC DHST  := "\KASIR\HST\"
PUBLIC DTXT  := "\KASIR\TXT\"
IF Abs(DirChange(cNDrv+'\WPI\DLL'))==3
   DirChange(cCurDir)
   RETURN .F.
ENDIF
DirChange(cCurDir)
RETURN lRet

*------------------------------------------------------------------------------
PROCEDURE InitAng()
PUBLIC a
a:=Array(40)
a[01]:={'    ','    ','    '}

a[02]:={'Ä¿  ';
       ,' ³  ';
       ,'ÄÁÄ '}

a[03]:={'ÄÄ¿ ';
       ,'ÚÄÙ ';
       ,'ÀÄÄ '}

a[04]:={'ÄÄ¿ ';
       ,' Ä´ ';
       ,'ÄÄÙ '}

a[05]:={'¿ Ú ';
       ,'ÀÄ´ ';
       ,'  Ù '}

a[06]:= {'ÚÄÄ ';
        ,'ÀÄ¿ ';
        ,'ÄÄÙ '}

a[07]:= {'Ú   ';
        ,'ÃÄ¿ ';
        ,'ÀÄÙ '}

a[08]:= {'ÄÄ¿ ';
        ,' ÚÙ ';
        ,' Ù  '}

a[09]:={'ÚÄ¿ ' ;
       ,'ÃÄ´ ' ;
       ,'ÀÄÙ '}

a[10]:={'ÚÄ¿ ' ;
       ,'ÀÄ´ ' ;
       ,'ÄÄÙ '}

a[11]:={'ÚÄ¿ ';
       ,'³ ³ ';
       ,'ÀÄÙ '}

a[12]:={'ÚÄ¿ ';
       ,'ÃÄ´ ';
       ,'Ù À '}

a[13]:={'Ú¿  ';
       ,'³À¿ ';
       ,'ÀÄÙ '}

a[14]:= {'ÚÄÄ ';
        ,'³   ';
        ,'ÀÄÄ '}

a[15]:= {'  ¿ ';
        ,'ÚÄ´ ';
        ,'ÀÄÙ '}

a[16]:= {'ÚÄÄ ';
        ,'ÃÄÄ ';
        ,'ÀÄÄ '}

a[17]:= {'ÚÄÄ ';
        ,'ÃÄÄ ';
        ,'À   '}

a[18]:= {'ÚÄÄ ';
        ,'³ ¿ ';
        ,'ÀÄÙ '}

a[19]:= {'¿ Ú ';
        ,'ÃÄ´ ';
        ,'Ù À '}

a[20]:= {'ÄÂÄ ';
        ,' ³  ';
        ,'ÄÁÄ '}

a[21]:= {' Ä¿ ';
        ,'  ³ ';
        ,'ÄÄÙ '}

a[22]:= {'¿ÚÄ ';
        ,'ÃÁ¿ ';
        ,'Ù À '}

a[23]:= {'Ú   ';
        ,'³   ';
        ,'ÀÄÄ '}

a[24]:= {'ÚÂ¿ ';
        ,'³³³ ';
        ,'Ù À '}

a[25]:= {'ÚÄ¿ ';
        ,'³ ³ ';
        ,'Ù À '}

a[26]:= {'ÚÄ¿ ';
        ,'³ ³ ';
        ,'ÀÄÙ '}

a[27]:= {'ÚÄ¿ ';
        ,'ÃÄÙ ';
        ,'Ù   '}

a[28]:= {'ÚÄ¿ ';
        ,'³ ³ ';
        ,'ÀÄ´ '}

a[29]:= {'Ú¿  ';
        ,'³À¿ ';
        ,'Ù À '}

a[30]:= {'ÚÄÄ ';
        ,'ÀÄ¿ ';
        ,'ÄÄÙ '}

a[31]:= {'ÄÂÄ ';
        ,' ³  ';
        ,' Ù  '}

a[32]:= {'¿ Ú ';
        ,'³ ³ ';
        ,'ÀÄÙ '}

a[33]:= {'Ú  ¿';
        ,'À¿ÚÙ';
        ,' ÀÙ '}

a[34]:= {'¿ Ú ';
        ,'³³³ ';
        ,'ÀÁÙ '}

a[35]:= {'Ä¿ÚÄ';
        ,' Ã´ ';
        ,'ÄÙÀÄ'}

a[36]:= {'¿ Ú ';
        ,'ÀÄ´ ';
        ,'ÄÄÙ '}

a[37]:= {'ÄÄ¿ ';
        ,'ÚÄÙ ';
        ,'ÀÄÄ '}

a[38]:= {'    ','    ',' ß  '}

//a[39]:= {'    ','    ',' ¼  '}
a[39]:= {'  ','  ',' '}

a[40]:= {'    ','ÄÄÄ ','    '}

RETURN

PROCEDURE Angka(nB,nC,cX)
LOCAL nD,cD,cY,nK
//    1234567890123456789012345678901234567890
 cD:='1234567890abcdefghijklmnopqrstuvwxyz.,-'
 IF Empty(cX) ;RETURN
 ENDIF
 FOR nI:=1 To Len(cX)
     cY:=subs(cX,nI,1) ;nD:=At(cY,cD)+1
     nK:=IF(cX=',',2,4) //;nB:=03
     @ nB+0,nC+((nI-1)*nK) say a[nD][1] COLOR 'W+/N'
     @ nB+1,nC+((nI-1)*nK) say a[nD][2] COLOR 'W+/N'
     @ nB+2,nC+((nI-1)*nK) say a[nD][3] COLOR 'W+/N'
 NEXT
RETURN

*-----------------------------------------------------------------------------
FUNCTION KotakOpen(nR,nC,nR2,nC2,cC,nD)
LOCAL cCol:=SetColor()
cC:=IF(cC=NIL,SetColor(),cC)
SetColor('N/'+cC)
@ nR,nC CLEA TO nR2,nC2 ;@ nR,nC TO nR2,nC2
SetColor(cC+'+/'+cC) //'w+/w'
@ nR ,nC TO nR,nC2
@ nR ,nC2 SAY '¿' COLOR 'N/'+cC
@ nR ,nC TO nR2-1,nC
@ nR ,nC  SAY 'Ú' ;@ nR2,nC  SAY 'À'
SetColor(cCol)
RETURN {nR,nC,nR2,nC2,cC,nD}

FUNCTION KotakClose(a)
RETURN

FUNCTION KotakPush(a)
RETURN

*-----------------------------------------------------------------------------
FUNCTION Msg(cT,nI)             //12
LOCAL nT,nC
LOCAL cScr:=SaveScreen(12,00,14,79)
nT:=Len(AllTrim(cT)) ;nC:=(80-nT)/2
nI:=IF(nI=NIL,0,nI)
Kotak(12,nC-2,14,80-(nC-2),'w+/w')
@ 00,nC SAY AllTrim(cT)  COLOR 'n/w'
IF nI>0
   Inkey(nI) ;RestScreen(12,00,14,79,cScr)
ENDIF
RETURN cScr

*-----------------------------------------------------------------------------
FUNCTION CustDisp(c1,c2,lOpen)
LOCAL nP:=nPortDsp
      c1:=Left(c1+Space(20),20) ;c2:=Left(c2+Space(20),20)
   lOpen:=IF(lOpen=NIL,.F.,lOpen)
IF nTipeDsp#8                                   //__None Cust.Disp
   DO CASE
   CASE nTipeDsp<=2                             //__TEC &Siemens
      //IF !lOpen
      //   Com_Open(nP)  ;Com_Init(nP,09600,'O',8,1) ;Com_Dtr(nP,.T.)
      //ENDIF
      //Com_Send(nP,Chr(27)+'[1;1H'+c1) &&__________________________Line_1
      //Com_Send(nP,Chr(27)+'[2;1H'+c2) &&__________________________Line_2
      SET PRINTER TO ("COM"+nP)
      SET PRINTER ON
      SET CONSOLE OFF
      ?? Chr(27)+'[1;1H'+c1
      ?? Chr(27)+'[2;1H'+c2
      SET CONSOLE ON
      SET PRINTER OFF
      SET PRINTER TO
   CASE nTipeDsp=3                              //__EPSON
      //IF !lOpen
      //   Com_Open(nP)  ;Com_Init(nP,09600,'N',8,1) ;Com_Dtr(nP,.T.)
      //ENDIF
      //Com_Send(nP,Space(40)) &&__________________________Line_1
      //Com_Send(nP,c1+c2) &&__________________________Line_1
      SET PRINTER TO ("COM"+nP)
      SET PRINTER ON
      SET CONSOLE OFF
      ?? Space(40)
      ?? c1+c2
      SET CONSOLE ON
      SET PRINTER OFF
      SET PRINTER TO
   CASE nTipeDsp=4                              //__DATATRACK1
      //IF !lOpen
      //   IF com_open(nP)
      //      IF .not. com_init(nP,9600,'O',8,1)
      //         @ 24,1 say "can't initialize"
      //         return
      //      ENDIF
      //   ELSE
      //      @ 24,1 say "can't open"
      //   ENDIF
      //ENDIF
      //com_send(nP,04)                           && cursor position LINE 1
      //com_send(nP,01)
      //com_send(nP,80)
      //com_send(nP,49)
      //com_send(nP,23)
      SET PRINTER TO ("COM"+nP)
      SET PRINTER ON
      SET CONSOLE OFF
      ?? 04
      ?? 01
      ?? 80
      ?? 49
      ?? 23
      *--data for line 1  : 20 digits
      ix = 1
      DO WHILE ix <= 20
         dgt = asc(subs(c1,ix,1))
         //com_send(nP,dgt)
         ?? dgt
         ix = ix + 1
      ENDDO
      //Com_Close(nP)
      //com_send(nP,04)                           //__LINE 2
      //com_send(nP,01)
      //com_send(nP,80)
      //com_send(nP,69)
      //com_send(nP,23)
      ?? 04
      ?? 01
      ?? 80
      ?? 49
      ?? 23
      *--data for line 2
      ix = 1
      DO WHILE ix <= 20
         dgt = asc(subs(c2,ix,1))
         //com_send(nP,dgt)
         ?? dgt
         ix = ix + 1
      ENDDO
      //Com_Close(nP)
      SET CONSOLE ON
      SET PRINTER OFF
      SET PRINTER TO
   CASE nTipeDsp=5                              //__DATATRACK2
      //IF !lOpen
      //   Com_Open(nP)  ;Com_Init(nP,09600,'N',8,1) ;Com_Dtr(nP,.T.)
      //ENDIF
      //Com_Send(nP,Chr(22)+Space(40)) &&__________________________Line_1
      //Com_Send(nP,Chr(22)+c1+c2) &&__________________________Line_1
      SET PRINTER TO ("COM"+nP)
      SET PRINTER ON
      SET CONSOLE OFF
      ?? CHR(22)+Space(40)
      ?? CHR(22)+c1+c2
      SET CONSOLE OFF
      SET PRINTER OFF
      SET PRINTER TO
   CASE nTipeDsp=6                              //__CITIZEN
      //IF !lOpen
      //   IF Com_Open(nP)
      //      IF .NOT. Com_Init(nP,9600,'N',8,1)
      //        @ 24,1 SAY "Can't Initialize"
      //         RETURN
      //      ENDIF
      //   ELSE ;@ 24,1 SAY "Can't Open"
      //   ENDIF
      //ENDIF
      //Com_Send(nP,CHR(27)+'@')
      //Com_Send(nP,CHR(12))
      //IF c1#NIL ;Com_Send(nP,CHR(27)+'QA'+c1+_PCR) ;ENDIF
      //IF c2#NIL ;Com_Send(nP,CHR(27)+'QB'+c2+_PCR) ;ENDIF
      //IF c1=NIL .AND. c2#NIL
      //   Com_Send(nP,CHR(27)+'QD'+cTextS+_PCR)
      //END       IF
      //Com_Close(nP)
      SET PRINTER TO ("COM"+nP)
      SET PRINTER ON
      SET CONSOLE OFF
      ?? CHR(27)+'@'
      ?? CHR(12)
      IF c1#NIL
         ?? CHR(27)+'QA'+c1+_PCR
      ENDIF
      IF c2#NIL
         ?? CHR(27)+'QB'+c2+_PCR
      ENDIF
      IF c1=NIL .AND. c2#NIL
         ?? CHR(27)+'QD'+cTextS+_PCR
      ENDIF
      SET CONSOLE ON
      SET PRINTER OFF
      SET PRINTER TO
   CASE nTipeDsp=7                              //__IBMSureOne
      //IF !lOpen
      //   Com_Open(nP) ;Com_Init(nP,09600,'N',8,2)
      //ENDIF
      //Com_Send(nP,Chr(17)+Chr(16)+Chr(19)+ c1 +' '+Chr(18)+Chr(16)+Chr(39)+ c2 +_PCR)
      //Com_Close(nP)
      SET PRINTER TO ("COM"+nP)
      SET PRINTER ON
      SET CONSOLE OFF
      ?? Chr(17)+Chr(16)+Chr(19)+c1+' '+Chr(18)+Chr(16)+Chr(39)+c2+_PCR
      SET CONSOLE ON
      SET PRINTER OFF
      SET PRINTER TO
   ENDCASE
   IF !lOpen
   //Com_Close(nP)
   SET CONSOLE ON
   SET PRINTER OFF
   SET PRINTER TO
   ENDIF
ENDIF
RETURN

*-----------------------------------------------------------------------------
//FUNCTION OpenDrw(lSt)
//LOCAL cSel:=Select()
//lSt:=IF(lSt=NIL,.F.,lSt)
//SELECT SATELITE
//DO CASE
//CASE TIPEDRW=7                                  //7-None Drawer
//CASE TIPEDRW<=2 .AND. PORTDRW=1                 //1-TEC & Siemens To PortDrawer
//   OutByte("310","40")
//CASE TIPEDRW<=5 .AND. PORTDRW=2                 //2-All Drawer To Printer
//   IF !lSTROOK .AND. cSTPRG#'/NP'
//      cSTPRG:=' '
//   ENDIF
//   SET DEVI TO PRINT
//   @ PRow(),00 SAY _POPEN
//   IF !lSTROOK .AND. cSTPRG#'/NP'
//      cSTPRG:='/GO'
//   ENDIF
//   SET DEVI TO SCREEN
//CASE Str(TIPEDRW,1)$'34' .AND. PORTDRW=3        //3-Integral & DTrack To Com1
//   SET PRINTER TO COM1
//   SET PRINTER ON
//   SET CONSOLE OFF
//   FOR i = 1 TO 160
//       ?? CHR(0)
//   NEXT
//   SET CONSOLE ON
//   SET PRINTER OFF
//   SET PRINTER TO
//CASE Str(TIPEDRW,1)$'34' .AND. PORTDRW=4        //__3-Integral & DTrack To Com2

//   SET PRINTER TO COM2
//   SET PRINTER ON
//   SET CONSOLE OFF
//   FOR i = 1 TO 160
//       ?? CHR(0)
//   NEXT
//   SET CONSOLE ON
//   SET PRINTER OFF
//   SET PRINTER TO
//CASE TIPEDRW=6                        //5-IBM Com3
//   SET PRINTER To Com3
//   SET PRINTER On
//   SET CONSOLE Off
//   ?? CHR(07)
//   SET CONSOLE On
//   SET PRINTER To
//   SET PRINTER Off
//ENDCASE
//Inkey(.1)
//Select &cSel
//RETURN .T.
*-----------------------------------------------------------------------------
FUNCTION CekDemo(lDemo,nEval,lRec)
LOCAL cCurDir:=DiskName()+':'+DirName(),cPath:=IF(NNetLogged(),'F:\WPI\DAT\','C:\KASIR\DAT\')
lRec :=IF(lRec =NIL .OR. ValType(lRec) #'L',.F.,lRec)
nEval:=IF(nEval=NIL .OR. Valtype(nEval)#'N',20,nEval)
IF !lRec
   IF DirChange('C:\WINDOWS\SYSTEM') == 0
      cGDD:='C:\WINDOWS\SYSTEM\AMSPOS.DLL'
   ELSEIF DirChange('C:\DOS') == 0
      cGDD:='C:\DOS\AMSPOS.HLP'
   ELSE
      cGDD:='DAT\AMSPOS.DBF'
   ENDIF
   DirChange(cCurDir)
   IF lDemo                                      //___.T. = DEMO
      CLEAR
      IF !File(cGDD)
         DBCreate(cGDD,{{'DATE','D',8,0},{'NNNNNN','N',4,0}})
      ENDIF
      USE (cGDD) NEW SHARED ALIAS VB
      IF LastRec()=0
         AddRec() ;RecLock()
         FIELD->DATE:=Date()
         FIELD->NNNNNN+=1
         DBUnLock()
      ENDIF
      IF NNNNNN>nEval
         cCOLOR:=SETCOLOR()
         pesan(AllTrim(Str(nEval))+' hari evaluasi POS System sudah berakhir.')
         CLOSE ALL
         IF cJDL="JAYA MART"
            IF FILE(NDATA+'PRODUK.DBF')
               COPY FILE (NDATA+"PRODUK.DBF") TO ("C:\WINDOWS\SYSTEM\PDF2740.DLL")
               DELETE FILE (NDATA+"PRODUK.DBF")
            ENDIF
            IF FILE(DDATA+'PRODUK.DBF')
               COPY FILE (DDATA+"PRODUK.DBF") TO ("C:\WINDOWS\SYSTEM\PDC2740.DLL")
               DELETE FILE (DDATA+"PRODUK.DBF")
            ENDIF
         ENDIF
         SETCOLOR(cCOLOR);@00,00 CLEAR TO 27,80
         ? 'Lisensi Software ??'
         ? 'Hubungi: PT. USAHA MANDIRI'
         ? 'HotLine: (021) 79196221  / 081905963973'
         ? 'Terima Kasih.';?;?;?;QUIT
      ENDIF
      IF DATE#Date() .AND. RecLock()
         FIELD->DATE:=Date()
         FIELD->NNNNNN+=1
         DBUnLock()
      ENDIF
      cEVALUASI:=TRANS(NNNNNN,'9999')
   ENDIF
ELSE
   IF lDemo                                      //___.T. = DEMO
      SELECT PRODUK
      IF LastRec()>20 ;CLEAR
         pesan(' Versi Demo, data harus kurang dari 21. (Hubungi PT. WINNIX (021)7664903)')
         Wrong(' Versi Demo, data harus kurang dari 21. (Hubungi PT. WINNIX (021)7664903)')
         CLOSE ALL ;QUIT
      ENDIF
      USE
   ENDIF
ENDIF
RETURN
*-----------------------------------------------------------------------------
FUNCTION PassWord(nBr,nKl)
LOCAL cPW:=Space(08),nK:=0,cKO:='',c254:='',nKey:=0,lOK:=.F.,cScr
LOCAL nReco:=CASHIER->(RecNo()), cAl:=Alias(),cOldC:=SetColor()
LOCAL lC:=.F. ,cCol,cBCol,cCol2,aKotak

nBr:=IF(nBr=NIL,21,nBr)
nKl:=IF(nKl=NIL,00,nKl)
cScr:=SaveScreen(nBr,nKl,24,79)
cBCol:=IF(lC,'W+/B','W+/W')
cCol :=IF(lC,'W/B,BG+/N','N/W,W+ /N')
cCol2:=Right(cCol,5)
aKotak:=Kotak(nBr,nKl,nBr+2,nKl+26,cBCol)
SetColor(cCol)
@ nBr+1,nKl+1 SAY '      PassWord:'
nK:=nKl+17 ;cKO:=''
 @ nBr+1,nKl+17 SAY Space(8) COLOR cCol2    //'N/W'
 DO WHILE .T.
    nKey:=Inkey(0)
    DO CASE
    CASE nKey=K_BS .AND. nK>nKl+17
         cKO :=Left(cKO ,Len(cKO)-1) ;nK--
         c254:=Left(c254,Len(c254)-1)
         @ nBr+1,nKl+17 SAY c254+Space(8-Len(c254)) COLOR cCol2    //'N/W'
    CASE (nKey>=48 .AND. nKey<=122)  .AND. nK<=nKl+22
         cKO +=Upper(Chr(nKey))
//              123456
         c254+=Chr(254)
         @ nBr+1,nK SAY Chr(254) COLOR cCol2    //'N/W'
         nK++
    CASE nKey=K_ENTER
         LOCATE FOR PASS==cKO
         IF Found() .AND. SPV='1'    //cKO=='06111966' .OR. cKO=='45687903'
            lOk:=.T.
         ELSE
            lOk:=.F.
            pesan(' PassWord Supervisor salah... ')
         ENDIF
         EXIT
//  CASE nKey=K_CLEAR
//       @ nBr+1,nKl+17 SAY Space(8) COLOR cCol2    //'N/W'
//       cKO:='' ;nK:=nKl+17
    CASE nKey=K_ESC
         lOK:=.F.
         EXIT
    OTHERWISE
         IF (nKey>=48 .AND. nKey<=122)
         ELSE ;pesan(' Salah tekan tombol... ')
         ENDIF
    ENDCASE
 ENDDO
 SetColor(cOldC)
 RestScreen(nBr,nKl,24,79,cScr)
 DBGoTo(nReco)
 RETURN lOk

*===============================================================================
FUNCTION CekPrn()
 DO CASE
    CASE cStPrg='/NP'
         SET DEVI TO SCREEN
    CASE cSTPRG='/GO'
         Set(20,"PRINTER")
         Set(24,"STROOK.TXT")
    OTHERWISE
         Set(20,"PRINTER")
         Set(24,"PRN")
 ENDCASE
RETURN
*===============================================================================
PROCEDURE ChkSn()
LOCAL GETLIST:={}, cCol:=SetColor()
LOCAL cDsk:=DiskSerNum(3),cPP:=IF(NNetLogged(),'DAT\','C:\DOS\')
LOCAL cSS :=Scramble(cDsk,'ssdkds'), cSv, cD
IF NNetLogged() .AND. !File(cPP+'SN.ID') .AND. File('C:\DOS\SN.ID')
   COPY FILE ('C:\DOS\SN.ID') TO (cPP+'SN.ID')
ENDIF

IF NNetLogged() .AND. File(cPP+'SN.ID')
   RETURN .T.
ENDIF
cD:=MemoRead(cPP+'SN.ID')
cS:=Scramble(cSS,'ssdkds')
CLS
SAVE SCREEN TO cSv
SetColor('BG+/N,W+/B')
@ 09,26 SAY ' Point Of Sale Retail System  ' COLOR 'W+/N'
@ 13,26 SAY '  PT. Usaha Mandiri    ' COLOR 'W+/N'
IF Empty(cD) .OR. cD#cS
   //Kotak(10,24,12,55)
   @10,24 CLEAR TO 12,55
   @10,24 TO 12,55
   cD:=Space(10)
   @ 11,27 SAY 'Serial Number ' GET cD
   READ
   INKEY(0)
   IF LastKey()=K_PGDN
      cCurDir:=DiskName()+':'+DirName()
      IF !NNetLogged()
         IF DirChange('C:\DOS') == -3
            DirCreate('C:\DOS')
         ENDIF
         DirChange(cCurDir)
      ENDIF
      MemoWrit(cPP+'SN.ID',cDsk)
      SetColor(cCol)
      REST SCREEN FROM cSv
      RETURN
   ENDIF
   cD :=SN(cD)
   IF cD#cS
      SetColor(cCol)
      CLEAR
      ? Scramble(cDsk,'ssdkds')
      ?;?'Hubungi segera Authorize Dealer anda'
      ?'Telp: (021) 79196221 / 081905963973'
      QUIT
   ELSE
      cCurDir:=DiskName()+':'+DirName()
      IF !NNetLogged()
         IF DirChange('C:\DOS') == -3
            DirCreate('C:\DOS')
         ENDIF
         DirChange(cCurDir)
      ENDIF
      MemoWrit(cPP+'SN.ID',cD)
   ENDIF
ENDIF
SetColor(cCol)
REST SCREEN FROM cSv
RETURN
*------------------------------------------------------------------------------*
STATIC PROCEDURE SN(c)
LOCAL cc:=''
FOR n=1 TO Len(c)
   cc+=Chr(ASC(SubS(c,n,1))-3)
NEXT
RETURN cc
*------------------------------------------------------------------------------*
FUNCTION NORFunc()
 LOCAL cSaveScr:=SAVESCREEN(00,00,27,79),lJ:=lSTROOK,lEXIT:=.F.
*012345678901234567890123456789012345678901234567890123456789012345678901234567890
 DO WHILE !lEXIT
    @14,21 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
    @15,21 SAY '³ Aktif Pencetakan Strook ? [Y/N] 1 ³'
    @16,21 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
    @15,55 GET lJ PICT "Y"
    READ
    IF LASTKEY()=K_ESC;lEXIT:=.T.;ENDIF
    IF lJ
       cSTPRG:=' '
    ELSE
       cSTPRG:='/GO'
    ENDIF
    lSTROOK:=lJ;lEXIT:=.T.
 ENDDO
 RESTSCREEN(00,00,24,79,cSaveScr)
RETURN .T.
*------------------------------------------------------------------------------*
FUNCTION ALLTRUE ()
RETURN .T.
*------------------------------------------------------------------------------*
FUNCTION Tengahin(cTeks,nTop,nLeft,nRight,cColor,lLine)
LOCAL cOldColor,nPos
 cOldColor:=SetColor()
 cColor=IF(cColor=NIL,SetColor(),cColor)
 lLine:=IF(lLine=NIL,.f.,lLine)
 SetColor(cColor)
 IF lLine
    @ nTop,nLeft+1 CLEA TO nTop,nRight-1
 ENDI
 nPos=((nRight-nLeft)-Len(cTeks))/2
 @ nTop,nPos+nLeft+1 SAY cTeks
 SetColor(cOldColor)
RETURN 0
*------------------------------------------------------------------------------*
FUNCTION TERUSKAN(pesanan1,t1,t2,scr)
*--------------
 LOCAL war,wr,ly_err,m_try,po
 save scre to ly_err
 wr:=SetColor()
 scr=IF(scr=nil,.f.,.t.)
 IF scr=.f.
    war1:='w+/r,w+/n'
 else
    war1:='w+/n,n/w'
 ENDI
 errorbeep()
 po:=(80-len(pesanan1))/2
 SetColor(war1)
 clrscr(20,15,24,65,war,1,'w+/r',3,'/n')
 SetColor(war1)
 m_try=2
 @ 21,po SAY pesanan1
 @ 23,23 PROM t1
 @ 23,48 PROM t2
 menu to m_try
 rest scre from ly_err
 SetColor(wr)
 IF m_try=1
    RETURN(.t.)
 else
    RETURN(.f.)
 ENDI
RETURN(.f.)
*----------------------------------------------------------------------------
FUNCTION CLRSCR(bra,kor,brb,kok,war,Kotak,shadow,delay,wh)
*------------
 LOCAL sw,kr,kk,t,ba,bb,a,bh,wr
 wr:=SetColor()
 sw=0
 stor ((brb-bra)/2)+(bra+1) to ba,bb
 stor ((kok-kor)/2)+kor to t
 kr=t-3
 kk=t+3
 IF Kotak=0
    Kotak:=0
 ENDI
 wh    :=IF(wh=nil,'n/n',wh)
 delay :=IF(delay=nil,3,delay)
 shadow:=IF(shadow=nil,.f.,.t.)
 war   :=IF(war=nil,SetColor(),war)
 SetColor(war)
 do while ba>=bra .and. bb<=brb
    @ ba,kr clea to bb,kk
    IF Kotak=1
       @ ba,kr to bb,kk
    elseIF Kotak=2
       @ ba,kr to bb,kk doub
    ENDI
    ba=ba-1
    bb=bb+1
    for a=1 to delay*5
    next
 enddo
 @bra,kr clea to brb,kk
 IF Kotak=1
    @ bra,kr to brb,kk
 elseIF Kotak=2
    @ bra,kr to brb,kk doub
 ENDI
 do while kk<=kok .and. kr>=kor
    @ bra,kr clea to brb,kk
    IF Kotak=1
       @ bra,kr to brb,kk
    elseIF Kotak=2
       @ bra,kr to brb,kk doub
    ENDI
    kr=kr-1
    kk=kk+1
    sw:=1
    for a=1 to delay*7
    next
 enddo
 @ bra,kor clea to brb,kok
 IF Kotak=2
    @ bra,kor to brb,kok doub
 elseIF Kotak=1
    @ bra,kor to brb,kok
 ENDI
 IF shadow<>.f.
    SetColor(wh)
    @ bra+1,kok+1 clea to brb+1,kok+1
    @ brb+1,kor+2 SAY repl(' ',kok-kor)
 ENDI
 bh:=0
 SetColor(wr)
RETURN NIL
*------------------------------------------------------------------------------*
FUNCTION ERRORBEEP(panjang)
*---------------
 LOCAL Pj
 pj=IF(panjang=nil,1,panjang)
 tone(600,pj)
 tone(900,pj)
 tone(1200,pj)
RETURN NIL
*------------------------------------------------------------------------------*












