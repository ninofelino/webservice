#include "kassa.ch"
#include "box.ch"
*-----------------------------------------------------------------------------
FUNCTION CASHFunc(c,n,a)
STATIC nCash
LOCAL  cA:=ALIAS(), lFinish := .F. , lCetak:=.T. , lRA:=.T.,lJINF:=.F.
LOCAL  nD := 0, nChg:= 0, nItem := 0, nNORCP, cSales:=Space(39),nJMINF:=0,nAMTINF:=0
PRIVATE nITEMPCS:=0
lGlodok:=Right(Upper(cJdl),17)=='GLODOK ELEKTRINDO'
IF !lGStl .AND. ASCAN({'R/A','P/O'},FLAG)=0
   Warning(' Tekan SUBTOTAL sebelum tutup transaksi... ') ;c:=''
   RETURN .T.
ENDIF
IF nCash == NIL
   nCash := 0
ENDIF

SELECT TOMBOL ;GO TOP
LOCATE FOR ASCII=LASTKEY()
&&.OR. TEMP->PRICE=0__tadinya ATTL 0 tidak boleh,...! WD 4-12-95 
*IF !FOUND() .OR. TEMP->(LastRec())<3  &&Harus ada transaksi
IF !FOUND()            &&_Kur 04-12-95 .or. temp tdk dipakai
                       &&_karena bila 1 item lalu attl tdk mau
   RETURN .T.
ENDIF

cFLAG:={'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11',;
        'T12','T13','T14'} [ASCAN({_T01,_T02,_T03,_T04,_T05,_T06,_T07,_T08,;
        _T09,_T10,_T11,_T12,_T13,_T14},TOMBOL->ASSIGN)]
cDESC:=ASGNNM

IF nGStl<0                    &&___ini untuk nilai transaksi + / -
   lGRtn:=.T. ;ELSE
   lGRtn:=.F.
ENDIF          

SELECT TEMP ;GO BOTT
nD:=If(nGDisc>.99,nGDisc*If(nGStl>0,1,-1),Int(nGDisc*nGStl))*(-1)
IF lGRtn
   IF nCash+(INT(VAL(c))*(-1))  < nGStl+nD
      Warning(' Pembayaran RTN Lebih...! ')
      IF nCash <> 0
         cGKey:=CHR(200-_B_SPC)+CHR(200-_CLEAR)+CHR(200-_T01)+;        
                CHR(200-_T02)+CHR(200-_T03)+CHR(200-_T04)+CHR(200-_T05)+;
                CHR(200-_T06)+CHR(200-_T07)+CHR(200-_T08)+CHR(200-_T09)+CHR(200-_T14)+;
                CHR(200-_T10)+CHR(200-_T11)+CHR(200-_T12)+CHR(200-_T13)+CHR(200-_B_KEY)
         a:=GetPosKey(cGKey)
      ENDIF
      c:=''
      RETURN .T.
   ELSE
      IF INT(VAL(c)) = 0
         IIF(nCash<>0,c:=STR(ABS((nGStl+nD)-nCash)),c:=STR(ABS(nGStl+nD)))
      ENDIF
   ENDIF
   IIF(LEFT(cDESC ,1) = '*',cDESC:=SUBSTR(TOMBOL->ASGNNM,2),.T.)
   nCash+=(INT(VAL(c))*(-1))
ELSE
   IF INT(VAL(c)) = 0 .AND. LEFT(cDESC ,1) <> '*'
      IIF(nCash<>0,c:=STR(ABS((nGStl+nD)-nCash)),c:=STR(ABS(nGStl+nD)))
   ENDIF
   IIF(LEFT(cDESC ,1) = '*',cDESC:=SUBSTR(TOMBOL->ASGNNM,2),.T.)
   nCash+=INT(VAL(c))
ENDIF

DO CASE
CASE TEMP->PRICE = 0 .AND. TEMP->FLAG <>'CRC'
     Warning(' Harga Belum Ada, Salah Tombol ... ! ')
     RETURN .T.
CASE ASCAN({'P/O','R/A'},ALLTRIM(TEMP->FLAG)) > 0
     cFLAG := "T"+IIF(TEMP->FLAG == "P/O","PO","RA")
     cDESC := TEMP->FLAG+' <CASH>'
     nCash := nGStl+nD
     nGRaPo:= nCash
     AddRec()
     FIELD->FLAG  := cFLAG
     FIELD->DESC  := cDESC
     FIELD->QTY   := 1
     FIELD->PRICE := nCash
     FIELD->NORCP := SATELITE->NORCP
     FIELD->ETYPE := 'A'
     lRA:=.F.         // utk kupon agar tdk tercetak
     SET DEVICE TO PRINT
     @ PRow()   ,00 SAY cDESC
     @ PRow()   ,30 SAY nCash PICT '99,999,999'
     JPrint(PRow(),40,cDESC)
     JPrint(PRow(),70,nCash,'99,999,999')
     SET DEVICE TO SCREEN

CASE ASCAN({'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11',;
            'T12','T13','T14','TTL'},ALLTRIM(TEMP->FLAG))=0
     lGBayar:=.T.
     SET DEVICE TO PRINT
     AddRec()
     FIELD->FLAG  := 'TTL'
     FIELD->DESC  := 'TOTAL'
     FIELD->QTY   := 1
     FIELD->PRICE := nGStl+nD
     FIELD->NORCP := SATELITE->NORCP
     FIELD->ETYPE := 'A'
     cKtotal      := Tran(nGStl+nD,'999,999,999') // nilai totalnya gede
     @ PRow()+1 ,00 SAY Repli('-',40)
     @ PRow()+1    ,00 SAY 'TOTAL'
     @ PRow()      ,29 SAY cKTotal
     JPrint(PRow() ,40,    'TOTAL')
     JPrint(PRow() ,69,    cKTotal)

     AddRec()
     FIELD->FLAG  := cFLAG
     FIELD->DESC  := cDESC
     FIELD->QTY   := 1
     IF !lGRtn
        FIELD->PRICE := IF(nCash > nGStl+nD, nGStl+nD,nCash)
     ELSE
        FIELD->PRICE := IF(nCash < nGStl+nD, nGStl+nD,nCash)
     ENDIF
     FIELD->NORCP := SATELITE->NORCP
     FIELD->ETYPE := 'A'

     @ PRow()+1 ,00 SAY cDESC
     @ PRow()   ,29 SAY nCash PICT '999,999,999'
     JPrint(PRow()   ,40,cDESC)
     JPrint(PRow()   ,69,nCash,'999,999,999')
     IF cPRINT='e'
        @ PRow()+1 ,00 SAY CHR(13)
     ENDIF
     SET DEVICE TO SCREEN

OTHERWISE
     lGBayar:=.T.
     SET DEVICE TO PRINT
     AddRec()
     FIELD->FLAG  := cFLAG
     FIELD->DESC  := cDESC
     FIELD->QTY   := 1
     IF !lGRtn
         FIELD->PRICE := IF(nCash > nGStl+nD,(nGStl+nD)-(nCash-INT(VAL(c))),INT(VAL(c)) )
     ELSE
         FIELD->PRICE := IF(nCash < nGStl+nD,(nGStl+nD)-(nCash-INT(VAL(c))*(-1)),INT(VAL(c))*(-1) )
     ENDIF
     FIELD->NORCP := SATELITE->NORCP
     FIELD->ETYPE := 'A'

     @ PRow()+1 ,00 SAY Left(cDESC,14)
     IF !lGRtn
        @ PRow()   ,29 SAY INT(VAL(c)) PICT '999,999,999'      //IF(nCash > nGStl+nD,(nGStl+nD)-(nCash-INT(VAL(c))),INT(VAL(c)) ) PICT ' 99,999,999'
        JPrint(PRow()   ,40,cDESC)
        JPrint(PRow()   ,69,INT(VAL(c)),'999,999,999')         //IF(nCash > nGStl+nD,(nGStl+nD)-(nCash-INT(VAL(c))),INT(VAL(c)) ) PICT ' 99,999,999'
     ELSE
        @ PRow()   ,29 SAY INT(VAL(c))*(-1) PICT '99,999,999'  //IF(nCash < nGStl+nD,(nGStl+nD)-(nCash-INT(VAL(c))*(-1)),INT(VAL(c))*(-1) ) PICT ' 99,999,999'
        JPrint(PRow()   ,40,cDESC)
        JPrint(PRow()   ,69,INT(VAL(c))*(-1),'99,999,999')     //IF(nCash < nGStl+nD,(nGStl+nD)-(nCash-INT(VAL(c))*(-1)),INT(VAL(c))*(-1) ) PICT ' 99,999,999'
     ENDIF
     IF cPRINT='e'
        @ PRow()+1 ,00 SAY CHR(13)
     ENDIF
     SET DEVICE TO SCREEN

ENDCASE

IF !lGRtn
   IF nCash >= nGStl+nD
      lFinish := .T.
      nChg    := nCash - (nGStl+nD)
   ELSE
      lFinish := .F.
      nChg    := nCash - (nGStl+nD)
   ENDIF
ELSE
   IF nCash <= nGStl+nD
      lFinish := .T.
      nChg    := nCash - (nGStl+nD)
   ELSE
      lFinish := .F.
      nChg    := nCash - (nGStl+nD)
   ENDIF
ENDIF

@ 25,66 SAY Trans(nCash,' 999,999,999')
@ 25,78 SAY '*' color 'w*/n'
IF nChg>=0
   @ 26,55 SAY 'KEMBALI' COLOR 'W+'
ELSE
   @ 26,55 SAY 'KURANG ' COLOR 'W+'
ENDIF
@ 26,66 SAY Trans(nChg ,' 999,999,999')

CustDisp('TTL# :'+PADL(TRAN((nGStl+nD),nMU+' 999,999,999'),14),;
         'PAY# :'+PADL(TRAN(nCash,nMU+' 999,999,999'),14))

nNORCP:= SATELITE->NORCP

// tambahan MCR untuk Matahari Kalau Butuh 010396 KUR
IF TOMBOL->MCR
   TONE(2800,2)
   TONE(3000,4)
   TONE(2800,2)
   TONE(3000,4)
   @ 19,2,21,52 BOX B_SINGLE+' '
   @ 19,3  SAY cFLAG+'/'+cDesc
   * 19,10 SAY cDESC                    COLOR 'W+*'
   @ 19,39 SAY '[ESC]->Batal '          COLOR 'W+'
   @ 20,3 SAY 'Slot Card :'
   cD:=ReadMCR(20,15,cFLAG)
   FIELD->DESC:=Left(DESC,14)+cD
   IF ALLTRIM(cD )#'0'
      SET DEVICE TO PRINT
      @ PRow()+1   ,00 SAY 'ID '+cDESC +' : '+cD
      JPrint(PRow(),40,    'ID '+cDESC +' : '+cD)
      SET DEVICE TO SCREEN
   ELSE
      SET DEVICE TO PRINT
      @ PRow()     ,00 SAY Replicate('-',40)
      JPrint(PRow(),40,    Replicate('-',40))
      SET DEVICE TO SCREEN

      TEMP->(DBGOBOTTOM())
      IF ASCAN({'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11',;
         'T12','T13','T14'},TEMP->FLAG)>0
         IF lFinish          // KRN SDH TEKAN TOMBOL MEDIA CREDIT & SDH KE REPL DBFnya DI temp
            TEMP->(RecLock())
            TEMP->(DBDELETE())
            TEMP->(__DBPACK())
            TEMP->(DBUNLOCK())
            TEMP->(DBSKIP(-1))
            TEMP->(DBGOBOTTOM())
            IF ASCAN({'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11',;
              'T12','T13','T14'},TEMP->FLAG)=0
               nCash:=NIL
               IF nCash=NIL
                  nCash=0
                  @ 22,66 SAY Trans(nCash,' 999,999,999')
               ENDIF
            ELSE
               nCash:=TEMP->PRICE
               @ 22,66 SAY Trans(nCash,' 999,999,999')
            ENDIF
         ENDIF
      ENDIF
      lFinish:=.F.
   ENDIF
ENDIF   

IF TOMBOL->DCR                   // DCR INI U/ KONTROL STATUS OTOMTAIC KUPON BTKNYA LOGIK
   AADD(aGTENKPN,TOMBOL->DCR)
ENDIF

IF lFinish
   nItem:=ItemCount()
   IF lGlodok
      SELECT TEMP
      COPY TO (DDATA+'___TEMP')
   ENDIF

   SET DEVICE TO PRINT
   IF !cPrint $ '9ac' //__STAR
      @ PRow()   ,00  SAY _PINIT+_PALL
   ENDIF

   IF nChg>0
      @ PRow()+1   ,00 SAY 'KEMBALI'
      @ PRow()     ,29 SAY nChg PICT ' 99,999,999'
      JPrint(PRow(),40,    'KEMBALI')
      JPrint(PRow(),69,    nChg,     ' 99,999,999')

      IF lINFAK
         TONE(2800,2)
         TONE(3000,4)
         TONE(2800,2)
         TONE(3000,4)
         SET DEVICE TO SCREEN
         SET CONFIRM OFF
         SAVE SCREEN TO SCINF
         cCL:=SETCOLOR()
         SETCOLOR('GR+/R,GR+/R')
         Box(12,20,14,55)     //,'GR+/R,GR+/R')
         @ 13,22 SAY 'Akan memberikan infak ? (Y/N)' GET lJINF PICT 'Y'
         READ
         IF lJINF
            IF lININFAK
               @ 13,22 SAY '                             '
               @ 13,22 SAY 'Masukkan jumlah infak : ' GET nJMINF PICT '999,999'
               READ
               nAMTINF:=nJMINF
            ELSE
               nCHG:=INT(nCHG)
               nLEN:=LEN(ALLTRIM(STR(nCHG)))-2
               cDG1:=LEFT(ALLTRIM(STR(nCHG)),nLEN);cDG2:=RIGHT(ALLTRIM(STR(nCHG)),2)
               nAMTINF:=VAL(cDG2)
            ENDIF
            SETCOLOR(cCL)
            RESTORE SCREEN FROM SCINF
            SET DEVICE TO PRINT
            cINFMSG:=LEFT(SATELITE->INF1,30)
            @PROW()+2 ,00 SAY cINFMSG
            @PROW()   ,33 SAY TRANS(nAMTINF,'999,999')
            JPrint(PRow()   ,40,cINFMSG)
            JPrint(PRow()   ,73,TRANS(nAMTINF,'999,999'))
            @PROW()+1 ,00 SAY REPLI('Ä',39)
            JPrint(PRow()   ,40,REPLI('Ä',39))
            @PROW()+1 ,00 SAY 'TOTAL KEMBALI'
            @PROW()   ,33 SAY TRANS(nCHG-nAMTINF,'999,999')
            JPrint(PRow()   ,40,'TOTAL KEMBALI')
            JPrint(PRow()   ,73,TRANS(nCHG-nAMTINF,'999,999'))
            TEMP->(ADDREC())
            TEMP->FLAG:='IFA'
            TEMP->CODE:=CASHIER->CODE
            TEMP->DESC:='INFAK'
            TEMP->PRICE:=nAMTINF
         ELSE
            RESTORE SCREEN FROM SCINF
            SETCOLOR(cCL)
            SET DEVICE TO PRINT
         ENDIF
      ENDIF
   ENDIF

   IF lItmnpcs
      @ PRow()+2 ,05  SAY "RCPNO:"+RIGHT('000000'+ALLTRIM(STR(nNORCP)),6)+" þ "+;
                           ALLTRIM(STR(nItemPcs))+" Items"+" þ "+ALLTRIM(STR(nItem))+" Pcs"
      JPrint(PRow()   ,45,"RCPNO:"+RIGHT('000000'+ALLTRIM(STR(nNORCP)),6)+" þ "+;
                           ALLTRIM(STR(nItemPcs))+" Items"+" þ "+ALLTRIM(STR(nItem))+" Pcs")
   ELSE
      @ PRow()+2 ,15  SAY "RCPNO:"+RIGHT('000000'+ALLTRIM(STR(nNORCP)),6)+" þ "+;
                           ALLTRIM(STR(nItem))+" Items"
      JPrint(PRow()   ,55,"RCPNO:"+RIGHT('000000'+ALLTRIM(STR(nNORCP)),6)+" þ "+;
                           ALLTRIM(STR(nItem))+" Items")
   ENDIF

   IF lFootNote
      SET DEVICE TO PRINT
      IF cPrint='9'
         @ PRow()+1,00 SAY ' '
      ENDIF
      IF SATELITE->COM3#SPACE(40) ;@ PRow()+1,00   SAY SATELITE->COM3 ;ENDIF
      IF SATELITE->COM4#SPACE(40) ;@ PRow()+1,00   SAY SATELITE->COM4 ;ENDIF
      IF SATELITE->COM5#SPACE(40) ;@ PRow()+1,00   SAY SATELITE->COM5 ;ENDIF
   ENDIF

   IF nGSTL+nGDisc > 0
      nBANYAK:=INT((nGSTL+nGDisc)/SATELITE->KUPON)
      nSisa:=MOD((nGSTL+nGDisc),SATELITE->KUPON)
      nSisanya:=SATELITE->KUPON - nSisa
      IF(nSisanya<=SATELITE->TLR,nBANYAK+=1,nBANYAK)

      IF SATELITE->CTK='Y' .AND. nBANYAK > 0 .AND. LEN(aGTENKPN)#0 .AND. lRA
         @ PRow()+1 ,0   SAY '========================================'
         JPrint(PRow()   ,40,'========================================')
         EkmFunc('Î')
         lRA:=.T.
         lCetak:=.F.
      ENDIF
   ENDIF
   IF lCetak
      SET DEVICE TO PRINTER
      PCUTTER()    // u/ motong bila transaksi tdk dapat kupon
   ENDIF
   SET DEVICE TO SCREEN


   //OpenDrw()                                        &&___Buka DRAWER
   CapTransfer()    &&___Pindahin diBawah agar bisa ngeprint di Receipt


   @ 25,78 SAY ' ' COLOR "W/N"

   IF lINFAK
      Angka(03,01,Space(6)+TRAN(nChg-nAMTINF,'  999,999,999'),"W*/N")
      @ 26,66 SAY Trans(nChg-nAMTINF ,' 999,999,999')
   ELSE
      Angka(03,01,Space(6)+TRAN(nChg,'  999,999,999'),"W*/N")
   ENDIF

   CustDisp('PAY# :'+PADL(TRAN(nCash,nMU+' 999,999,999'),14),;
            'CHG# :'+PADL(TRAN(nChg,nMU+' 999,999,999'),14))

   IF cStPrg='/NP'
      RestScreen(0,0,2,45,cSSS)
   ENDIF

   IF lFaktur
      aCust:=FakturF()
//      IF Continue(" Cetak Surat Jalan? "," Y a ","Tidak")
//         aCust:=FakturF(.T.,aCust)
//      ENDIF
   ENDIF

   IF SATELITE->TIPEDRW>2 .OR. SATELITE->PORTDRW>1
      Wrong2("  L U N A S  ")                       &&___non Drawer (AUS Embassy)
   ELSE
      Wrong2("  L U N A S  ")
      DO WHILE AScan({0,59},InByte("310"))=nStDrw   &&___Drawer TEC-ST
      ENDDO
   ENDIF

   nCash:= NIL
   lGBarCode:=.F.
   nGKeyLock:=0
   lGVod    :=.F.
   lGRtn    :=.F.
   lGStl    :=.F.
   lCash    :=.T.   && u/ tetap menampilkan kembalian
   cGDFlag  :=''
   cGDDesc  :=''
   cGVipNo  :=''
   nGDisc   :=0
   nGStl    :=0
   cGSales  :=''
   cGCCn:=' '
   cGCn:=' '
   cGNm:=' '
   dGValid:=CToD('  /  /    ')
   lGAct:=.F.
   nGDsc:=0
   lGBayar:=.F.
   nSwGs:=0
   nGQty:=0
   cCGCus   :=''    && Reset Var For Cust Function
   cCodeCs  :=''    && Idm
   cNameGCs :=''    && Idm
   cGMember :=''    && Idm
   ViewTrn(0);nGBrs:=8

   ResetKey(@a)
   @ 26,55 SAY 'KEMBALI'                   COLOR 'w+/n'
   @ 21,66 SAY Trans(0,' 999,999,999')     //COLOR 'n/w'
   @ 22,66 SAY Trans(0,' 999,999,999')+' ' //COLOR 'n/w'
   @ 23,66 SAY Trans(0,' 999,999,999')+' ' //COLOR 'n/w'
   @ 24,66 SAY Trans(0,' 999,999,999')     //COLOR 'n/w'
   @ 25,66 SAY Trans(0,' 999,999,999')+' ' //COLOR 'n/w'
   @ 26,66 SAY Trans(0,' 999,999,999')+' ' //COLOR 'n/w'
   ClearEntry()
ELSE
// Wrong(' Belum Lunas ...! ')                     //Dar 6/11
   cGKey:=CHR(200-_B_SPC)+CHR(200-_CLEAR)+CHR(200-_T01)+;
          CHR(200-_T02)+CHR(200-_T03)+CHR(200-_T04)+CHR(200-_T05)+CHR(200-_VLD)+;
          CHR(200-_T06)+CHR(200-_T07)+CHR(200-_T08)+CHR(200-_T09)+CHR(200-_T14)+;
          CHR(200-_T10)+CHR(200-_T11)+CHR(200-_T12)+CHR(200-_T13)+CHR(200-_B_KEY)

   a:=GetPosKey(cGKey)
ENDIF
c:=''; CLSFunc()
RETURN .T.

*-----------------------------------------------------------------------------
STATIC FUNCTION ItemCount()
LOCAL cA:=ALIAS()
LOCAL nItem := 0

SELE TEMP
TEMP->(DBGOTOP())
DO WHILE !TEMP->(EOF())
   DO CASE
   CASE TEMP->FLAG=='TTL'
        EXIT
   CASE TEMP->FLAG=='STL'
//      EXIT
   CASE TEMP->FLAG=='PLU'
        nItem+=TEMP->QTY
        nITEMPCS=nITEMPCS+1
   CASE TEMP->FLAG=='RTN'
        nItem-=TEMP->QTY
        nITEMPCS=nITEMPCS-1
   CASE TEMP->FLAG=='VOD'
        nItem+=(ABS(TEMP->PRICE)/TEMP->PRICE)*TEMP->QTY
        nITEMPCS=nITEMPCS-1
   OTHERWISE
   ENDCASE
   TEMP->(DBSKIP())
ENDDO
SELECT (cA)
RETURN nItem

*-----------------------------------------------------------------------------
