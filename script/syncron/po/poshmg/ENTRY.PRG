#include "hmg.ch"
#include "inkey.ch"
#include "kassa.ch"

*-----------------------------------------------------------------------------
PROCEDURE Entry(Asli)
LOCAL GETLIST:={}
LOCAL cMsg,cCCol:=SetColor()
LOCAL nD:=0          &&_Var Dummy
LOCAL nT:=0          &&_nT:=Len(cNum)   
LOCAL nLen :=14      &&_Panjang Max Get
LOCAL nLen1:=13      &&_Panjang Max View Angka
LOCAL cNum:=''       &&_Variable Character Get
LOCAL cKey:=''       &&_Char Var Inkey()
LOCAL nKey:=00       &&_Numr Var Inkey()
LOCAL lLogic:=.T.    &&_lLogic For DO WHILE
LOCAL b              && b Block For SET KEY ...

PRIVA nQTY:=0,nSwGs:=0
PRIVA lVld:=.F.,cSSS

SET CONF ON

lGHpHr :=.F.
@ 00,00 CLEAR TO 06,79
@ 02,00 TO 06,79
@ 06,00,27,79 BOX "ÚÄ¿³ÙÄÀ³ "
@ 20,54,27,79 BOX "ÚÄ´³ÙÄÁ³ "
@ 20,00,25,54 BOX "ÃÄÂ³´ÄÃ³ "
nLJdl:=Len('<< '+AllTrim(cJdl)+' >>')
@ 00,(80-nLJdl)/2 SAY '<< '+cJdl+' >>'  COLOR 'W+'
@ 00,69 SAY Date()
@ 21,55 SAY 'SUBTTL  '+nMU+'.'+Str(0,12) //COLOR 'N/W'
@ 22,55 SAY 'DISC.   '+nMU+'.'+Str(0,12) //COLOR 'N/W'
@ 23,55 SAY 'T A X   '+nMU+'.'+Str(0,12) //COLOR 'N/W'
@ 24,55 SAY 'TOTAL   '+nMU+'.'+Str(0,12) //COLOR 'N/W'
@ 25,55 SAY 'BAYAR   '+nMU+'.'+Str(0,12) //COLOR 'N/W'
@ 26,55 SAY 'KEMBALI '+nMU+'.'+Str(0,12) //COLOR 'N/W'

@ 21,55 SAY 'SUBTTL ' COLOR 'w+/n'
@ 22,55 SAY 'DISC.  ' COLOR 'w+/n'
@ 23,55 SAY 'T A X  ' COLOR 'w+/n'
@ 24,55 SAY 'TOTAL  ' COLOR 'w+/n'
@ 25,55 SAY 'BAYAR  ' COLOR 'w+/n'
@ 26,55 SAY 'KEMBALI' COLOR 'w+/n'

cStl:=SATELITE->(SubS(CPNO,3,2))
cMsg:='Versi 3.11.06'+' þ TM#:'+SATELITE->(SubS(CPNO,3,2))+' þ CS#:'+CASHIER ->CODE
ClearEntry()
CapOk();CLSFunc()
aKey:=GetPosKey(cGKey)
SELECT TEMP
IF lGTimePr='Y' ;ShowTime(1,71)
ENDIF
IF CP->(LastRec())#0 .AND. Date()>SATELITE->CPDT
   cScr:=SaveScreen(17,00,19,79) ;Box(17,00,19,79,'w+/w')
   @ 18,04 SAY 'Proses Reset/EOD belum dilakukan - Lakukan EOD sekarang? [0]-Tidak, [1]-Ya ' COLOR 'n/w' //GET nYn PICT '9' VALID nYn<2 COLOR 'w/n'
   DO WHILE .T.                                                              //Dar 5/13
      nYn:=InKey(0)                                                            //Dar 5/13
      IF UPPER(CHR(nYn))$'01'                                                  //Dar 5/13
         EXIT                                                                //Dar 5/13
      ENDIF                                                                  //Dar 5/13
   ENDDO                                                                     //Dar 5/13
   RestScreen(17,00,19,79,cScr)
   IF Chr(nYn)='1'
      EodFunc('1') ;c:=''
      IF lGLan
         DLL->(DBGoto(Val(SubS(SATELITE->CPNO,3,2))))
         IF DLL->STATUS=2 .AND. Left(DToC(Date()),8)#DLL->TGLCLOSE
            SOD()        //Start Of Day
            InitAng() ;InitPrn()
            lLan:=UseFile()
         ENDIF
      ENDIF
      RETURN
   ENDIF
ENDIF
cSSS:=SaveScreen(0,0,2,45)
Do While lLogic
   lBarCode:=.F.
   @ 26,01 SAY REPL(' ',52)
   @ 26,(53-LEN(ALLTRIM(cMSG)))/2 SAY cMsg
   IF cStPrg='/NP'
      RestScreen(0,0,2,45,cSSS)
   ENDIF
   IF lGLan ;@ 00,01 SAY 'NETWORK'     ///'+cStl
      ELSE  ;@ 00,01 SAY 'LOCAL'       ///'+cStl+'  ' //COLOR 'w+'
   ENDIF
   IF !lSTROOK
      @ 01,01 SAY '[ Tanpa Struk ! ]' COLOR 'W++'
   ELSE
      @ 01,01 SAY '                    '
   ENDIF

   IF     nGPrc=0 ;@ 07,47 SAY '  Harga' COLOR 'w+'
   ELSEIF nGPrc=1 ;@ 07,47 SAY 'Harga-2' COLOR 'w+'
   ELSEIF nGPrc=2 ;@ 07,47 SAY 'Harga-3' COLOR 'w+'
   ENDIF

   *@ 01,01 SAY IF(lGHpHr,'HAPPY HOUR'  ,Space(10)) COLOR IF(lGHpHr,'W+*/N','W+/N')
   @ 01,35 SAY IF(!Empty(cGSales),'SPG   : '+cGSales+'-'+SALES->DESC,Space(37))
   *@ IF(lSTROOK,01,19),01 SAY IF(!Empty(cGMember),cGMember,Space(37))
   IF !Empty(cGCCn)
      @ 01,01 SAY 'MEMBER: '+Alltrim(cGCCn)+'-'+Upper(Left(cGNm,20))+Space(1) COLOR 'w/n'
   ENDIF
   nT:=Len(cNum)
   Angka(22,01,Left(cNum+Space(nLen-nT),13))
   nKey:=ScanKey(@cNum,@nLen,@aKey)
   IF lGRTN ;@ 07,02 SAY 'RTN' COLOR 'w+*'
      ELSE  ;@ 07,02 SAY '   ' COLOR 'w+'
   ENDIF
   cKey:=Chr(nKey)
   If (b:=SetKey(nKey))<>NIL                      // check for SET KEY first
      Eval(b,ProcName(2),ProcLine(2),ReadVar())
      LOOP
   End

   IF AScan({00,59},InByte("310"))=nStDrw            &&_CekDrawer_ST4500=2
      Wrong('Drawer Terbuka - tekan [CLEAR] ... ! ')
   ENDIF

   IF lBarCode .OR. Len(cNum)+1>=nLen
      cNum+=Left(If(lBarCode,'',cKey),13)
      Angka(22,01,Left(cNum+Space(nLen-Len(cNum)),13))
      TOMBOL->(__DBLocate({||ASSIGN=_PLU},,,,.f.))
      nKey:=TOMBOL->ASCII
      lBarCode:=.T.
   ENDIF

   DO CASE
   CASE ValType(aKey)='A' .AND. (nD:=AScan(aKey,{|a|a[1]=nKey}))#0
      TOMBOL->(__DBLocate({||ASCII==nKey},,,,.f.))
      cKey:=TOMBOL->KEYL
      lVld:=TOMBOL->VLDS
      IF !Empty(cKey) .AND. cKey='P' .AND. !CASHIER->(PassWord())
         LOOP
      ELSEIF !Empty(cKey) .AND. Val(cKey)#nGKeyLock
//       Warning('Kunci harus ada  di posisi '+cKey)
	 cKey:=SATELITE->(Eval(FieldBlock('KeyM'+cKey)))
	 Warning(AllTrim(cKey))
	 LOOP
      ENDIF
      lLogic:=Eval(aKey[nD][3],@cNum,@nLen,@aKey)
      DBCommitAll()
      IF lVld .AND. (TEMP->PRICE#0 .OR. TEMP->(LastRec()=0))
         VldFunc()
      ENDIF
   CASE  cKey$'1234567890abcdefghijklmnopqrstuvwxyz.-'
      DO CASE
      CASE cKey='.' .And. At('.',cNum)#0
      CASE nT>=nLen ;Tone(500,3)
      OTHERWISE     ;cNum+=cKey
      ENDCASE       
   OTHERWISE
      Wrong()
      cNum:=''
   ENDCASE
ENDDO
cGLCd:=''
cGLPs:=''
lGEdit:=.F.
IF lGTimePr='Y' ;ShowTime(1,71)
ENDIF
cD:=SATELITE->(Left(CPNO,4))
SAVE TO (DDATA+cD+'TEMP.MEM') ALL LIKE ?G*
IF Select('DLL')#0
   DLL->(DBGoto(Val(SubS(cD,3,2))))
   IF DLL->STATUS =1 .And. DLL->(RecLock())
      DLL->STATUS:=0
      DLL->CCODE:=''
      DLL->(DBUnlock())
      DLL->(DBCommit())
   ENDIF
ENDIF
RETURN

*-----------------------------------------------------------------------------
FUNCTION GetPosKey(c)
LOCAL cD,nD,aKey:={},cWow
cGKey:=c;cD:=Left(SATELITE->CPNO,4)
cWow:=AllTrim(DDATA+cD+'TEMP.MEM')
SAVE TO (cWow) ALL LIKE ?G*
SELECT TOMBOL;GO TOP
DO WHILE !Eof()
   cD:=ASGNNM ;nD:=ASSIGN
   DO CASE
   CASE At(Chr(200-nD),c)=0
   CASE nD=_A_KEY  ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|AutoKey(@c,@n,@a)}})
   CASE nD=_B_KEY  ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|AutoKey(@c,@n,@a)}})
   CASE nD=_C_KEY  ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|AutoKey(@c,@n,@a)}})
   CASE nD=_D_KEY  ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|AutoKey(@c,@n,@a)}})
   CASE nD=_E_KEY  ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|AutoKey(@c,@n,@a)}})
   CASE nD=_SGN_ON ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|SONFunc(@c,@n,@a)}})
   CASE nD=_HLD    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|HLDFunc(@c,@n,@a)}})
   CASE nD=_B_SPC  ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|BSPFunc(@c,@n,@a)}})
   CASE nD=_CLEAR  ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|CLSFunc(@c,@n,@a)}})
   CASE nD=_AMT    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|AMTFunc(@c,@n,@a)}})
   CASE nD=_PLU    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|PLUFunc(@c,@n,@a)}})
   CASE nD=_PL1    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|PL1Func(@c,@n,@a)}})
   CASE nD=_PL2    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|PL2Func(@c,@n,@a)}})
   CASE nD=_X      ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|QTYFunc(@c,@n,@a)}})
   CASE nD=_NOS    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|NOSFunc(@c,@n,@a)}})
   CASE nD=_SBT    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|SBTFunc(@c,@n,@a)}})
   CASE nD=_STD    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|STDFunc(@c,@n,@a)}})
   CASE nD=_PCG    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|PCGFunc(@c,@n,@a)}})
   CASE nD=_CRC    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|CRCFunc(@c,@n,@a)}})
   CASE nD=_RTN    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|RTNFunc(@c,@n,@a)}})
   CASE nD=_VOD    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|VODFunc(@c,@n,@a)}})
   CASE nD=_PO     ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|POFunc( @c,@n,@a)}})
   CASE nD=_RA     ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|RAFunc( @c,@n,@a)}})
   CASE nD=_RPT    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|RPTFunc(@c,@n,@a)}})
   CASE nD=_VLD    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|VldKeys(@c,@n,@a)}})
   CASE nD=_JRF    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|JRFFunc(@c,@n,@a)}})
   CASE nD=_RCP    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|RCPFunc(@c,@n,@a)}})
   CASE nD=_EOD    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|EODFunc(@c,@n,@a)}})
   CASE nD=_ALV    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|ALVFunc(@c,@n,@a)}})
   CASE nD=_TAX    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|TAXFunc(@c,@n,@a)}})
   CASE nD=_DP1    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|DP1Func(@c,@n,@a)}})
   CASE nD=_DP2    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|DP2Func(@c,@n,@a)}})
   CASE nD=_DP3    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|DP3Func(@c,@n,@a)}})
   CASE nD=_DA1    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|DA1Func(@c,@n,@a)}})
   CASE nD=_DA2    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|DA2Func(@c,@n,@a)}})
   CASE nD=_DA3    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|DA3Func(@c,@n,@a)}})
   CASE nD=_LKP    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|LKPName(@c,@n,@a)}})  // _LNM
   CASE nD=_CRD    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|LKPCode(@c,@n,@a)}})  // _LCD
   CASE nD=_EKM    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|EKMFunc(@c,@n,@a)}})  // CETAK KUPON
   CASE nD=_STR    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|STDRim(@c,@n,@a)}})
   CASE nD=_HPH    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|HpHrFunc(@c,@n,@a)}})
   CASE nD=_PRC    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|PRCFunc(@c,@n,@a)}})
   CASE nD=_SLM    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|SLMFunc(@c,@n,@a)}})
   CASE nD=_FAK    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|FakturF()}})
   CASE nD=_CUS    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|CUsFunc(@c,@n,@a)}})
   CASE nD=_NOR    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|NORFunc(@c,@n,@a)}})
// CASE nD=_CRD    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|CRDFunc(@c,@n,@a)}})
// CASE nD=_VIP    ;AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|VIPFunc(@c,@n,@a)}})
   CASE ASCAN({_T01,_T02,_T03,_T04,_T05,_T06,_T07,;
	       _T08,_T09,_T10,_T11,_T12,_T13,_T14},nD) > 0
        AAdd(aKey,{ASCII,ASSIGN,{|c,n,a|CASHFunc(@c,@n,@a)}})
   ENDCASE
   SKIP
ENDDO
SELECT TEMP
RETURN aKey

*-----------------------------------------------------------------------------
PROCEDURE HpHrFunc(c,n,a)
IF !FPassW()
   Warning(' PassWord Salah ... ! ')
   RETURN .T.
ENDIF
lGHpHr:=!lGHpHr
RETURN .T.

*-----------------------------------------------------------------------------
PROCEDURE PRCFunc(c,n,a)
// lGPrc:=!lGPrc
IF nGPrc=0
   nGPrc:=0
   nGPrc++
ELSEIF nGPrc=1
   nGPrc:=1
   nGPrc++
ELSEIF nGPrc=2
   nGPrc:=2
   nGPrc=nGPrc-2
ENDIF
RETURN .T.

*-----------------------------------------------------------------------------
PROCEDURE SLMFunc(c,n,a)
LOCAL cYn:='3',cScr:=SaveScreen(17,10,19,60),cNAMES
IF Empty(c) .AND. Empty(cGSales)
   Wrong(' Kode Salesman belum di isi - Tekan [CLEAR]... ')
ELSEIF Empty(c) .AND. !Empty(cGSales)
   Box(17,10,19,60,'w')
   DO WHILE Val(cYn)>1
      cYn:='0'
      @ 18,12 SAY 'Reset Kode Salesman '+cGSales+' ? [1]-Ya  [0]-Tidak' COLOR 'n/w' GET cYn PICT '9' COLOR 'w/n'
      READ
   ENDDO
   RestScreen(17,10,19,60,cScr)
   IF cYn='1'
      cGSales='' ;c:=''
      CLSFunc(@c,@n,@a)
   ENDIF
ELSE
   SELECT SALES
   LOCATE FOR CODE=c
   IF Found() ;cGSales:=c
   ELSE       ;Warning(' Kode Salesman tidak ada... ')
   ENDIF
   SELECT TEMP
   c:=''
   cNAMES:=SALES->DESC
   CLSFunc(@c,@n,@a)
ENDIF
cSg:='SPG : '+alltrim(cGSales)+' þ '+SALES->desc
cGMember:=IF(cGSALES#' ',ALLTRIM(cSg),SPACE(37))
RETURN .T.

*-----------------------------------------------------------------------------
FUNCTION SONFunc(c,n,a)
LOCAL lD:=.F.
IF LastRec()#0 ;lD:=.T.
   Wrong('SIGN ON berlaku pada saat transaksi komplet...')
ENDIF
RETURN lD

*-----------------------------------------------------------------------------
STATIC PROCEDURE CapOk()
LOCAL nD:=0,cD:='',nT:=0,c1,c2
LOCAL aDSC:={'STD','D%1','D%2','D%3','DS1','DS2','DS3','TAX'}
cD:=DDATA+Left(SATELITE->CPNO,4)+'TEMP.MEM'
SELECT TOMBOL;GO TOP;cGKey:=''
DO WHILE !Eof()
   IF ASSIGN#0
      cGKey+=Chr(200-ASSIGN)
   ENDIF
   SKIP
ENDDO
IF NNetLogged()
   lGLan:=.T.
ENDIF
IF Select('DLL')#0
   DLL->(DBGoto(Val(SubS(SATELITE->CPNO,3,2))))
   DO CASE
   CASE DLL->STATUS=2
      Warning(' Status Mesin Sudah Di RESET ... ! ')
      cGLCd:=''      && Login Cashier
      cGLPs:=''      && Password Cashier
      BREAK
   CASE CP->(DTOC(DDATE))#DTOC(DATE()) .AND. CP->(LASTREC())#0 ;     //__utk eod
     .AND. !DLL->EOD              //__UTK CEK AGAR TDK KECAMPUR DATA TR TGL BEDA
     FOR I:=1 TO 2
         WARNING(' MESIN INI BELUM DILAKUKAN EOD, BERITAHU SUPERVISOR KASSA ANDA ')
     NEXT
     cGLCd:=''      && Login Cashier
     cGLPs:=''      && Password Cashier
     RETURN .T.         //BREAK
   CASE DLL->STATUS=1 .AND. !lGEdit
      Warning(' Status Mesin Sudah Ada Yang Pakai ... ! ')
      cGLCd:=''      && Login Cashier
      cGLPs:=''      && Password Cashier
      BREAK
   CASE DLL->(RecLock())
      DLL->CCODE:=CASHIER->CODE
      DLL->STATUS:=1
      DLL->(DBUnlock())
      DLL->(DBCommit())
   ENDCASE
ENDIF
IF CP->(LASTREC())=0 .AND. NNETLOGGED()      // EOD
   nRECDLL:=SATELITE->(VAL(SUBSTR(CPNO,3,2)))
   DLL->(DBGOTO(nRECDLL))
   DLL->(RECLOCK())
   DLL->FTYPE  :=''
   DLL->TSALES :=0
   DLL->NORCP  :=0
   DLL->CCODE  :=''
   DLL->WAKTU  :=''
   DLL->CMD    :=''
   DLL->TGLOPEN:=''
   DLL->TGLCLOSE:=''
   DLL->(DBUNLOCK())
ENDIF
IF !lGLan
   IF CP->FLAG='EOD'
      CP->(DBSKIP(-1))
   ENDIF
   IF CP->(DTOC(DDATE))#DTOC(DATE()) .AND. CP->(LASTREC())#0;
     .AND. !SATELITE->EOD    // UTK CEK AGAR TDK KECAMPUR DATA TR TGL BEDA
     FOR I:=1 TO 2
         WARNING('MESIN INI BELUM DILAKUKAN EOD, BERITAHU SUPERVISOR KASSA ANDA')
     NEXT
     cGLCd:=''      && Login Cashier
     cGLPs:=''      && Password Cashier
     RETURN .T.         //BREAK
  ENDIF
ENDIF
IF lGRTN ;@ 07,02 SAY 'RTN' COLOR 'w+*'
   ELSE  ;@ 07,02 SAY '   ' COLOR 'w+'
ENDIF
SELECT TEMP
nT:=LastRec()
IF nT>0
   nRTOM:=TEMP->NORCP                           //__TOMANG DLL
   SATELITE->NORCP:=nRTOM                       //__TOMANG DLL
   nGStl:=0
   nGBrs:=8
   FOR nD:=1 TO LastRec()
       GO nD
       DO CASE
       CASE FLAG='STD'
	  nGStl+=PRICE
	  ViewTrn(1,.f.)
       CASE AScan(aDSC,FLAG)>0
	  nGStl+=PRICE
	  ViewTrn(0,.f.)
       CASE AScan({'PLU','VOD','RTN','P/O','R/A'},FLAG)>0
	  nGStl+=PRICE*QTY 
	  ViewTrn(1,.f.)
       CASE ASCAN({'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11',;      // utk total recount
                   'T12','T13','T14','TTL'},ALLTRIM(TEMP->FLAG))>0
          DELETE REST      // apa ini ya ???
	  PACK
          CustDisp('  <<**  TOTAL  **>> ','  <<** RECOUNT **>> ')
	  SET DEVICE TO PRINT
          @ PRow()   ,00     SAY _PINIT+IF(lGJour,_PALL,_PRCPT)
          @ PRow()+2 ,0      SAY Replicate('-',40)
          @ PRow()+1 ,00     SAY PDWidth("   TOTAL  RECOUNT   "+IF(lGJour,"   TOTAL  RECOUNT   ",''))
          @ PRow()+1 ,0      SAY Replicate('-',40)
	  SET DEVICE TO SCREEN
	  Warning(' Jumlah / Total Transaksi Harus Di Ulang ... ! ')
	  EXIT
       ENDCASE 
   NEXT
ELSEIF !lGEdit
   IF cStPrg#'/NP'
      DO WHILE !PrintReady()
         Wrong(' Printer Error ... ! ')
      ENDDO
   ENDIF
   IF CP->(Reccount())=0 .AND. cStPrg#'/NP'
      SET DEVI TO PRINT
      PHeader()
      @ PRow()+1,00 SAY PDWidth("*þ#   SIGN   ON #þ*")
      PCutter()
      SET DEVI TO SCREEN
   ENDIF
ELSEIF nT=0
   IF nGSTL>0 ; nGSTL:=0 ; ENDIF
ENDIF

*** TAMBAHAN TOMANG DLL  ***
IF lGlan .AND. MARIMAR->(LASTREC())#0
   cF:=SATELITE->CPNO+'.DBF'
   DLL->(DBGOTO(VAL(SubS(cF,3,2))))
   MARIMAR->(DBGOTOP())
   DO WHILE !MARIMAR->(EOF())
      IF DLL->(RecLock())
         DLL->TSALES+=MARIMAR->PRICE
         DLL->NORCP=SATELITE->NORCP-1
         DLL->(DBUnlock())
      ENDIF
      MARIMAR->(DBSKIP())
   ENDDO
   MARIMAR->(FILLOCK())
   MARIMAR->(__dBZap())
   MARIMAR->(DBUNLOCK())
ENDIF
CP->(DBGOBOTTOM())
IF CP->NORCP==TEMP->NORCP .AND. !CP->(BOF())
   IF lGLan
      cF:=SATELITE->CPNO+'.DBF'
      DLL->(DBGOTO(VAL(SubS(cF,3,2))))
      IF DLL->(RecLock())
         DLL->TSALES-=nGStl+(IF(nGDisc>.99,nGDisc,nGDisc*nGStl))
         DLL->NORCP:=SATELITE->NORCP
         DLL->WAKTU:=IF(lGTimePr='Y',Time(),SPACE(8))
         DLL->(DBUnlock())
      ENDIF
   ENDIF
ENDIF
*** END TOMANG DLL ***
lGEdit:=.T.
RETURN

*-----------------------------------------------------------------------------
FUNCTION Saver()
LOCAL cScr, nK:=0, nBr, nCntr:=0
LOCAL cD1:=PROMOSI->LINE1,cD2:=PROMOSI->LINE2
LOCAL cCol:=SetColor(),nP:=nPortDsp
 SAVE SCREEN TO cScr ;SetCursor(0)
 SET COLOR TO
 SET KEY K_ALT_F1 TO
 KeySec()
 //Com_Open(nP) ;Com_Init(nP,09600,'O',8,1)
 DO WHILE Inkey(.1)=0
    cD1:=SubS(cD1,2)+Left(cD1,1)
    cD2:=Right(cD2,1)+Left(cD2,Len(cD2)-1)
    c1:=Left(cD1,20) ;c2:=Left(cD2,20)
    CustDisp(c1,c2,.T.)
    FOR n=1 TO 01000 ;NEXT
 ENDDO
 //Com_Close(nP)
 SetKey(K_ALT_F1,{||Saver()})
 KeySec(K_ALT_F1,30,,.T.)
 SetColor(cCol)
 REST SCREEN FROM cScr ;SetCursor(1)
 KeyBoard Chr(LastKey())
RETURN
*******************************************************************************
