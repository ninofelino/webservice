#include 'Kassa.ch'
#define MY_B_SINGLE ( chr(208)+chr(209)+chr(210)+chr(212)+chr(215)+chr(214)+chr(213)+chr(211) )
*-----------------------------------------------------------------------------
PROCEDURE MAIN(cX1,cX2)
LOCAL lD,nD,cD,nB:=1,lLan:=.F.,nK:=1, aBox
PRIVATE lDemo:=.F.,nTerm,nMaxTerm,cTM:='',lUMUM:=.T.
nTerm :=_TERM
nMaxTm:=_MAXTM

LOCK_ON()
SET KEY 96 TO KUNCI()
*KEYBOARD '`250'

aD:=Directory('*.')
For nI:=1 TO Len(aD)
    FErase(aD[nI][1])
NEXT

PUBLIC nMAXEVA  := 30        // Maximum nilai evaluasi bila modul demo

PUBLI cNDrv     :='F:'
PUBLI cGSales   :=''
PUBLI lGCode    :=.T.
PUBLI lGPrc     :=.T.
PUBLI nGPrc     :=0             && FLAG Untuk Aktifasi Harga1/2/3
PUBLI nGRaPo    :=0             && DATA STATUS FROM BAR CODE READING
PUBLI lGBarCode :=.F.           && DATA STATUS FROM BAR CODE READING
PUBLI nGKeyLock :=0             && KEY LOCK STATUS

PUBLI lGJour    :=.T.           && Cetak Journal : YES
PUBLI lGHpHr    :=.T.           && Happy Hour for Product
PUBLI lGStl     :=.F.           && FlipFlop SubTotal Disc
PUBLI lGEdit    :=.F.           && Status Editing Entry...
PUBLI lSTROOK   :=.T.           && Status Aktifasi Untuk Printer Strook ...
PUBLI cGDFlag   :=''            && Discount Flag Sub Total
PUBLI cGDDesc   :=''            && Discount Desc Sub Total
PUBLI nGDisc    :=0             && Discount Sub total
PUBLI nGStl     :=0             && Sub Total
PUBLI nStDrw    :=2             && Status Open Drawer
PUBLI nDrawer   :=1             && Tipe Drawer
PUBLI nPortDrw  :=1             && Port Drawer
PUBLI nTipeDsp  :=1             && Tipe Cust. Display
PUBLI nPortDsp  :=1             && Port Cust. Display
PUBLI nPortPrn  :=1             && Port Printer
PUBLI cGDEMOSWT :='       SOFTWARE DEMO NO CHARGE         '     // FOR DEMO SOFTWARE
PUBLI lGRTN     :=.F.           && STATUF RTN / PLU
PUBLI lGVOD     :=.F.           && STATUS VOD
PUBLI cGKey     :=''            && Key Mapping.......
PUBLI cGLCd     :=''            && Login Cashier
PUBLI cGLPs     :=''            && Password Cashier
PUBLI cGVipNo   :=''            && Global untuk Password
PUBLI GnPRICE   :=0             && untuk khusus RIMO
PUBLI aGTENKPN  :={}
PUBLI nGStockC  :=0             && Global parameter Stock Checking Limit
PUBLI lGTimePr  :='Y'           && Global parameter untuk time()
PUBLI lGLan     :=.F.
PUBLI lCash     :=.F.           && u/ tetap menampilkan kembalian
PUBLI lFootNote :=.F.           && Foot Note Aktif apa ngak !!
PUBLI lINFAK    :=.F.           && Aktifasi potongan infak
PUBLI lININFAK  :=.F.           && Type Aktifasi potongan infak
PUBLI lItmnPcs  :=.T.           && Untuk flag Item n Pcs di foot note
PUBLI lFaktur   :=.F.
PUBLI nGBrs     :=8
PUBLI cGCp      :=''
PUBLI cCGCus    :=''
PUBLI cCodeCs   :=''
PUBLI cNameGCs  :=''
PUBLI cGMember  :=''
PUBLI dMemGCs   :=ctod(' /  /    ')
PUBLIC cGCCN    :=' ', cGCN:=' ', cGNm:=' ',lGAct:=.F.
PUBLIC nGDsc    :=0, dGValid:=CToD('  /  /    ')
PUBLI cStPrg    :=If(cX1=NIL,'',Upper(cX1))
PUBLI cJdl      :=Crypt("ÎV€ÏŠu ÑKS»MZì6Où=j-Ó9",'567890123')
//PUBLI cJdl      :=Crypt("Ít£ó!à7œMW-èÆÛÐKÚ¾v9ç•YCúß-Ð¿a@WS5u",'567890123')
PUBLI cWin      :='PoS System Retail' //Crypt("•Ñ:‡°ðþæ&­k5",'379969999')

PUBLIC cPrint   :='3'   //1-DRJST-50    2-DRJST-51    3-TM210PD
                        //4-TM300PA/PB  5-TM300C/D    6-TM300w/oCUT
                        //7-SRP250      8-LX300       9-IBM SURE1
                        //a-STAR        b-CITIZEN     c-SRP200
                        //d-OTHER       e-TM88(Termal)f-TM88s(TermalSerial)
                        //g=Citizen_RS

PUBLIC cSto     :='1'   //1-Dibelakang  2-Didepan
PUBLIC nBaud    :=9600  //Baudrate scanner
PUBLIC nMU      :='Rp'  //Valuta Asing
PUBLIC cEVALUASI:=SPACE(05)// Variable untuk total evaluasi jika demo


cJdl  :=AllTrim(StrTran(cJdl,'þ',''))
cPrint:=IF(cX1#NIL .AND. cX1$'123456789abcdef',cX1,cPrint)
cSto  :=IF(cX2#NIL .AND. Val(cX2)>0,cX2,cSto  )
nBaud :=IF(cX2#NIL .AND. Len(cX2)>=4 .AND. Val(cX2)>0,Val(cX2),nBaud )
nBaud :=IF(cX1#NIL .AND. Len(cX1)>=4 .AND. Val(cX1)>0,Val(cX1),nBaud )

IF !lDemo ;ChkSn()
ENDIF

IF cTM#cJDL .AND. !lUMUM
   CLS
   ? 'Lisensi Software Hanya Untuk PT. USAHA MANDIRI !!!'
   ? '--------------------------------------------------'
   ? 'HotLine: 081905963973'
   ? 'Terima Kasih.';?;?;?;TONE(3000,30);QUIT
ENDIF

SET DATE BRIT
SET SCOR OFF
SET DELE ON
SET CENTURY ON

SetMode(50,80)
LoadFont('28.Fnt')
InitAng() ;InitPrn()

CLS
CekDemo(lDemo,nMAXEVA,.F.)     &&__kalau .F. 30 days

lLan:=UseFile()

cD:=DDATA+Left(SATELITE->CPNO,4)+'TEMP.MEM'
IF File(cD)
   RESTORE FROM (cD) ADDITIVE
   CASHIER->(__DBLocate({||CODE==cGLCd},,,,.f.))
ENDIF
IF File('GREEK.FON')
   FontLoad('GREEK.FON',1) ;FontSelect(1)
ENDIF

lGCode:=.T.
lGLan :=lLan

IF lGLan
   DLL->(DBGoto(Val(SubS(SATELITE->CPNO,3,2))))
   IF DLL->STATUS=2 .AND. Left(DToC(Date()),8)#DLL->TGLCLOSE
      SOD()        //Start Of Day
      InitAng() ;InitPrn()
      lLan:=UseFile()
   ENDIF
ENDIF

DO WHILE .t.
   CLOSE ALL;UseFile()
   cD:=SATELITE->(SubS(CPNO,3,2)) ;cGCP:=cD
   DO WHILE Empty(cGLCd) .AND. !lGEdit
      Clear Screen
      Box(00,00,00,79,'B/B')
      @ 02,63 SAY 'No. Terminal : '+cD  COLOR 'W+/N'
      @ 01,00 SAY REPLI('Ä',80)         COLOR 'B+/N'
      IF lGLan ;@ 02,00 SAY 'NETWORK '  COLOR 'W+/N'
         ELSE  ;@ 02,00 SAY 'LOCAL   '  COLOR 'W+/N'
      ENDIF
      @ 00,01 SAY 'Point of Sale RETAIL SYSTEM' COLOR 'R+/B'
      @ 00,60 SAY DTOC(DATE())+'þþ'     COLOR 'W/B'
      IF lGTimePr='Y'
         ShowTime(00,72,,'W/B')
      ENDIF

      Box(09,20,11,60,'w+/w')
      aBox:=Box(12,20,18,60,'w+/w')
      @ 16,21 SAY Repl('Ä',39)       COLOR 'n/w'
      @ 13,30 SAY 'Kode Kasir  : '   COLOR 'N/W'
      @ 15,30 SAY 'Sandi Kasir : '   COLOR 'N/W'
      @ 10,(81-Len(cJdl))/2 SAY cJdl COLOR 'b/w'
      @ 17,(81-Len(cWin))/2 SAY cWin COLOR 'b/w'
      @27,00 SAY ''

      IF lDEMO .AND. cJDL#"JAYA MART"
         @27,56 SAY 'Modul Versi Demo '+cEVALUASI+'.'+ALLTRIM(STR(nMAXEVA))
      ELSE
         cMESE1:='Lisensi Untuk : ';cMESE2:=ALLTRIM(SATELITE->DESC)
         * cMESE:=cMESE1+IF(!EMPTY(cMESE2),cMESE2,'-')
         cMESE:=cMESE1+cJDL   //IF(!EMPTY(cMESE2),cMESE2,'-')
         @27,80-LEN(cMESE) SAY cMESE
      ENDIF

      cGLCd:=LogIn(13,44,.f.)
      IF Empty(cGLCD);Scroll()
         SetMode(25,80)
         Inkey(.8);Clear;QUIT
      ENDIF
      SELECT CASHIER
      LOCATE FOR CODE==cGLCd
      IF !Found()     
	 Warning(' Kode Tidak Ada ... ! ')
	 cGLCd:=''
	 LOOP
      ENDIF
      cGLPs:=LogIn(15,44,.t.)
      DO WHILE .T.
	 nKey:=InKey(0)
	 IF (b:=SetKey(nKey))<>NIL                  // check for SET KEY first
	    Eval(b,ProcName(2),ProcLine(2),ReadVar());LOOP
	 ELSEIF Chr(nKey)$'1234567890';LOOP
	 ENDIF
	 EXIT
      ENDDO
      BoxPush(aBox)
      TOMBOL->(__DBLocate({||ASCII=nKey},,,,.f.))
      DO CASE
      CASE Chr(nKey)='.'
      CASE TOMBOL->ASSIGN=_SGN_ON
      OTHERWISE
	 Warning(' Salah Tombol ... ! ')
	 cGLCd:=''
	 cGLPs:=''
	 LOOP
      ENDCASE
      SELECT CASHIER
      IF !(PASS==cGLPs)
	 Warning(' PassWords Salah ... ! ')
	 cGLCd:=''
	 cGLPs:=''
      ELSEIF lGLan;nD:=DLL->(RecNo())
	 DLL->(__DBLocate({||CCODE==cGLCd},,,,.f.))
	 lD:=DLL->(Found() .AND. nD#RecNo());DLL->(DBGoto(nD))
	 IF lD;Warning(' Cashier Sudah Ada Yang Pakai ... ! ')
	    cGLCd:='' ;cGLPs:='' ;LOOP
	 ENDIF
      ENDIF            
   ENDDO
   ShowTime()
   DO CASE
   CASE Chr(LastKey())='.'                         //__.OR. Val(cD)<2
      KEYBOARD ' ' ;InKey(0)
      DO WHILE .T. 
         cXXX:=cStPrg ;cStPrg=''
	 BEGIN SEQUENCE;aX:=MkMenu()
	   aX:=WMenuSet(aX,{aX[1]},AllTrim(CASHIER->MENU))
           VScreen1(lDemo);ReadExit(.T.);nP:=WMenuMix(1,0,aX,nB,nK)
	 END
         cStPrg:=cXXX
	 IF LastKey()=27
            EXIT
	 ENDIF
	 CLOSE ALL
	 UseFile()
      ENDDO
      cGLCd:=''
      SET COLOR TO
   OTHERWISE
      BEGIN SEQUENCE
	Entry('!@#$')
      END
   ENDCASE
ENDDO
SetMode(25,80)
CLS
QUIT

*-----------------------------------------------------------------------------
FUNCTION USEFile()
LOCAL cD,nCPREC:=0
cPath:=IF(NNetLogged(),'NDATA','DDATA')
cOldColr:=SetColor()
CLOSE ALL
IF !NetUse({{DDATA+"TOMBOL"   ,.f.},;
            {DDATA+"PROMOSI"  ,.f.},;
            {DDATA+"CASHIER"  ,.f.},;
            {DDATA+"SALES"    ,.f.},;
            {DDATA+"SATELITE" ,.f.}})
            BREAK
ENDIF
c1       :=SATELITE->CPNO
c2       :=Left(c1,4)+'TEMP'
nDrawer  :=SATELITE->DRAWER
nTipedrw :=SATELITE->TIPEDRW
nStDrw   :=SATELITE->STDRW
nPortDrw :=SATELITE->PORTDRW
nTipeDsp :=SATELITE->TIPEDSP
nPortDsp :=SATELITE->PORTDSP
nPortPrn :=SATELITE->PORTPRN
lFaktur  :=SATELITE->TIPEPRN==2
lGTimePR :=SATELITE->TIMEPR
nGStockC :=SATELITE->STOCKC
lGJour   :=SATELITE->JOURNAL
lFootNote:=IF(SATELITE->FOOT='Y',.T.,.F.)
lGCode   :=SATELITE->PCODE
lINFAK   :=SATELITE->INFAK
lININFAK :=SATELITE->ININFAK

IF lFaktur ;cStPrg:='/NP'
ENDIF

USE (DDATA+'ONLINE') NEW ALIAS MARIMAR
USE (DDATA+c1) NEW ALIAS CP
USE (DDATA+c2) NEW ALIAS TEMP

IF NNetLogged()
   lGLan:=.T.
   IF !NetUse({{NDATA+"DLL"    ,.t.},;
               {NDATA+"PRODUK" ,.t.},;
               {NDATA+"GROUP"  ,.t.},;
               {NDATA+"CLASS"  ,.t.},;
               {NDATA+"CUS"    ,.t.},;
               {NDATA+"CUSDET" ,.t.},;
               {NDATA+"XREF"   ,.t.}})
      BREAK
   ENDIF

   SELECT PRODUK
   IF !File(NDATA+"PRODUK_1.NTX")      ;
      .OR. !File(NDATA+"PRODUK_2.NTX") ;
      .OR. !File(NDATA+"PRODUK_3.NTX")
      INDEX ON CODE          TO (NDATA+"PRODUK_1.NTX")
      INDEX ON Left(DESC,28) TO (NDATA+"PRODUK_2.NTX")
      INDEX ON REF           TO (NDATA+"PRODUK_3.NTX")
   ENDIF
   SET INDEX TO (NDATA+"PRODUK_1.NTX"),(NDATA+"PRODUK_2.NTX"),(NDATA+"PRODUK_3.NTX")

   SELECT GROUP
   IF  !File(NDATA+"GROUP__1.NTX")
       INDEX ON CODE          TO (NDATA+"GROUP__1.NTX")
   ENDIF
   SET INDEX TO (NDATA+"GROUP__1.NTX")

   SELECT CLASS
   IF  !File(NDATA+"CLASS__1.NTX") .OR. !File(NDATA+"CLASS__2.NTX")
       INDEX ON CODE          TO (NDATA+"CLASS__1.NTX")
       INDEX ON Left(DESC,10) TO (NDATA+"CLASS__2.NTX")
   ENDIF
   SET INDEX TO (NDATA+"CLASS__1.NTX"),(NDATA+"CLASS__2.NTX")

  SELECT CUS
  IF  !File(NDATA+"CUS____1.NTX") .OR. !File(NDATA+"CUS____2.NTX")
      INDEX ON CODE          TO (NDATA+"CUS____1.NTX")
      INDEX ON NAME          TO (NDATA+"CUS____2.NTX")
  ENDIF
  SET INDEX TO (NDATA+"CUS____1.NTX"),(NDATA+"CUS____2.NTX")

  SELECT CUSDET
   IF !File(NDATA+"CUSDET_1.NTX") .OR. !File(NDATA+"CUSDET_2.NTX")
      INDEX ON CODE+Str(RCPTNO,6)+DToS(DATE) TO (NDATA+"CUSDET_1.NTX")
      INDEX ON DToS(DATE)+CODE+Str(RCPTNO,6) TO (NDATA+"CUSDET_2.NTX")
   ENDIF
   SET INDEX TO (NDATA+"CUSDET_1.NTX"), (NDATA+"CUSDET_2.NTX")

   Select XREF
   IF !File(cPath+"XREF.NTX")
      c:=' MOHON DITUNGGU - Sedang Index ... '
      nP:=Len(c)
      SETCOLOR('gr+*/r')
      nCA:=(79-nP)/2 ;nCB:=nCA+nP+1
      cScrn:=SAVESCREEN(11,nCa,14,nCb+2)
      @ 11,nCa,13,nCb BOX "ÉÍ»º¼ÍÈº " COLOR 'w+/r'
      SetPos(12,nCa+1);DispOut(c)
      INDEX ON XREF          TO (cPath+"XREF.NTX")
      RESTSCREEN(11,nCa,14,nCb+2,cScrn)
      SETCOLOR(cOldColr)
   ENDIF
   SET INDEX TO (cPath+"XREF.NTX")

   IF !FILE(NDLL+c1+'.DBF')
      IF Select('CP')=0
         USE (DDATA+c1) NEW ALIAS COPY
         Copy To (NDLL+c1)
         SELECT COPY
         USE
      ELSE
         SELECT CP
         Copy To (NDLL+c1)
      ENDIF
   ENDIF

   IF SELECT("CP")=0
      USE (DDATA+c1) NEW ALIAS CP
   ENDIF

   nCPREC:=CP->(LASTREC())
   USE (NDLL+c1) SHARED ALIAS RCP
   IF nCPREC#LastRec()
      RCP->(DBCloseArea())
      IF Select('CP')=0
         IF SELECT('RCP')=0
            USE (DDATA+c1) ALIAS COPY
            Copy To (NDLL+c1)
            SELECT COPY
            USE
         ENDIF
      ELSE
         SELECT CP
         Copy To (NDLL+c1)
      ENDIF
      USE (NDLL+c1) SHARED ALIAS RCP
   ENDIF
ELSE                                            &&__IF cStPRG='BAKERY'  Off_Line
   IF !NetUse({{DDATA+"PRODUK",.t.},;
               {DDATA+"GROUP" ,.t.},;
               {DDATA+"CLASS" ,.t.},;
               {DDATA+"CUS"   ,.t.},;
               {DDATA+"CUSDET",.t.},;
               {DDATA+"XREF"  ,.t.}})
      BREAK
   ENDIF

   SELECT XREF
   IF !File(cPath+"XREF.NTX")
      INDEX ON XREF          TO (cPath+"XREF.NTX")
   ENDIF
   SET INDEX                 TO (cPath+"XREF.NTX")

   SELECT GROUP
   IF  !File(DDATA+"GROUP__1.NTX")
       INDEX ON CODE         TO (DDATA+"GROUP__1.NTX")
   ENDIF
   SET INDEX TO (DDATA+"GROUP__1.NTX")

   SELECT CLASS
   IF  !File(DDATA+"CLASS__1.NTX") .OR. !File(DDATA+"CLASS__2.NTX")
       INDEX ON CODE          TO (DDATA+"CLASS__1.NTX")
       INDEX ON Left(DESC,10) TO (DDATA+"CLASS__2.NTX")
   ENDIF
   SET INDEX TO (DDATA+"CLASS__1.NTX"),(DDATA+"CLASS__2.NTX")

   SELECT PRODUK
   IF !File(DDATA+"PRODUK_1.NTX")      ;  
      .OR. !File(DDATA+"PRODUK_2.NTX") ;
      .OR. !File(DDATA+"PRODUK_3.NTX")
      INDEX ON CODE          TO (DDATA+"PRODUK_1.NTX")
      INDEX ON Left(DESC,28) TO (DDATA+"PRODUK_2.NTX")
      INDEX ON REF           TO (DDATA+"PRODUK_3.NTX")
   ENDIF
   SET INDEX TO (DDATA+"PRODUK_1.NTX"),(DDATA+"PRODUK_2.NTX"),(DDATA+"PRODUK_3.NTX")

   SELECT CUS
   IF  !File(DDATA+"CUS____1.NTX") .OR. !File(DDATA+"CUS____2.NTX")
       INDEX ON CODE          TO (DDATA+"CUS____1.NTX")
       INDEX ON NAME          TO (DDATA+"CUS____2.NTX")
   ENDIF
   SET INDEX TO (DDATA+"CUS____1.NTX"),(DDATA+"CUS____2.NTX")

   SELECT CUSDET
   IF !File(DDATA+"CUSDET_1.NTX") .OR. !File(DDATA+"CUSDET_2.NTX")
      INDEX ON CODE+Str(RCPTNO,6)+DToS(DATE) TO (DDATA+"CUSDET_1.NTX")
      INDEX ON DToS(DATE)+CODE+Str(RCPTNO,6) TO (DDATA+"CUSDET_2.NTX")
   ENDIF
   SET INDEX TO (DDATA+"CUSDET_1.NTX"), (DDATA+"CUSDET_2.NTX")
ENDIF

***___Proteksi untuk banyaknya No Inline/Terminal
c199:=SATELITE->(SUBSTR(CPNO,3,2))
IF VAL(c199)>nTerm
   CLEAR
   @12,27 SAY 'Software Error ........!!!' COLOR 'W+*/'
   @13,27 SAY 'Nomor Terminal melebihi jumlah maximum terminal !!' COLOR 'W+*/'
   @14,27 SAY 'Hubungi PT. Usaha Mandiri '
   @15,27 SAY 'HotLine : 0819-05963973'
   Inkey(0) ;QUIT               //;ReBoot()
ENDIF
cD:=SATELITE->(SubS(CPNO,3,2))
CASHIER->(__DBLocate({||CODE==cGLCd},,,,.f.))
TOMBOL->(__DBLocate({||ASCII==LastKey()},,,,.f.))
IF lGLan;DLL->(DBGoto(Val(cD)));ENDIF
RETURN lGLan

*-----------------------------------------------------------------------------
STATIC FUNCTION LogIn(nB,nC,lPass)
LOCAL nT,b,cKey,nLen:=6,cNum:=''
SELECT TOMBOL
Do While .T.
   nT:=Len(cNum) 
   IF nT>=nLen  ;EXIT
   ELSEIF lPass ;@ nB,nC SAY Repl('þ',nT)+Space(nLen-nT) COLOR 'w/n'
          ELSE  ;@ nB,nC SAY cNum+Space(nLen-nT)         COLOR 'w/n'
   ENDIF
   nKey:=InKey(0)
   cKey:=Chr(nKey)
   If (b:=SetKey(nKey))<>NIL                      // check for SET KEY first
      Eval(b,ProcName(2),ProcLine(2),ReadVar())
      LOOP
   End
   IF cKey$'1234567890'
      cNum+=cKey
      LOOP
   ENDIF
   LOCATE FOR ASCII=nKey
   DO CASE
   CASE ASSIGN=_CLEAR  ;cNum:=''
   CASE ASSIGN=_B_SPC .And. nT>0 ;cNum:=Left(cNum,nT-1)
   CASE cKey='.'       ;cNum:=Left(cNum+'      ',6);EXIT
   CASE ASSIGN=_SGN_ON ;cNum:=Left(cNum+'      ',6);EXIT
   OTHERWISE           ;Warning(' Salah Tombol ... ! ')
   ENDCASE
ENDDO
IF lPass ;@ nB,nC SAY Repl('þ',nT)+Space(nLen-nT) COLOR 'w/n'
   ELSE  ;@ nB,nC SAY cNum+Space(nLen-nT)         COLOR 'w/n'
ENDIF
RETURN cNum

*-----------------------------------------------------------------------------
PROCEDURE KUNCI()
LOCAL cD,nKey:=0,cS
cD:=KeyLock()
DO CASE
CASE cD='0256' ;nKey=0
CASE cD='0250' ;nKey=1
CASE cD='0251' ;nKey=2
CASE cD='0252' ;nKey=3
CASE cD='0253' ;nKey=4
CASE cD='0254' ;nKey=5
CASE cD='0255' ;nKey=6
CASE cD='0257' ;nKey=7
OTHERWISE      ;nKey=8
ENDCASE
cS:=SaveScreen(1,1,4,78)
@ 1,1,4,78 BOX '######## '
@ 2,4 SAY 'POSISI KUNCI :'+Str(nKey,2)
IF nKey=1
   DO WHILE .T.
      @ 2,22 SAY 'LOCK....'
      cD:=SubS(KeyLock(),2)
      DO CASE
      CASE cD="0256" ;nKey=0;EXIT
      CASE cD="0251" ;nKey=2;EXIT
      CASE cD="0252" ;nKey=3;EXIT
      CASE cD="0253" ;nKey=4;EXIT
      CASE cD="0254" ;nKey=5;EXIT
      CASE cD="0255" ;nKey=6;EXIT
      CASE cD="0257" ;nKey=7;EXIT
      OTHERWISE      ;nKey=8
      ENDCASE
   ENDDO
ENDIF
lGRtn:=.F.
nGKeyLock:=nKey
RestScreen(1,1,4,78,cS)
@ 05,02 SAY '   ' COLOR ' /w'
RETURN

*-----------------------------------------------------------------------------
PROCEDURE ReadKill()
GetList:={}
RETURN
*-----------------------------------------------------------------------------
PROCEDURE Clipper501()
RETURN
*-----------------------------------------------------------------------------
PROCEDURE SOD()
PRIVATE cSccr:=SaveScreen(17,10,19,64)
   Box(18,05,20,75,'w+/w')
   @ 19,12 SAY 'TUNGGU !! SYSTEM SEDANG MELAKUKAN PROSES START OF DAY...' COLOR 'n*/w'

   //--1
   cD:='SATELITE'
   USE (NDATA+cD+'.DBF') NEW SHARED ALIAS ST
   SATELITE->CODE :=ST->CODE
   SATELITE->DESC :=ST->DESC
   SATELITE->ADD1 :=ST->ADD1
   SATELITE->ADD2 :=ST->ADD2
   SATELITE->TELP :=ST->TELP
   SATELITE->FACS :=ST->FACS
   SATELITE->COM1 :=ST->COM1
   SATELITE->COM2 :=ST->COM2
   SATELITE->COM3 :=ST->COM3
   SATELITE->COM4 :=ST->COM4
   SATELITE->COM5 :=ST->COM5
   SATELITE->STO1 :=ST->STO1
   SATELITE->STO2 :=ST->STO2
   SATELITE->STO3 :=ST->STO3
   SATELITE->STO4 :=ST->STO4
   SATELITE->INF1 :=ST->INF1
   SATELITE->KEYM0:=ST->KEYM0
   SATELITE->KEYM1:=ST->KEYM1
   SATELITE->KEYM2:=ST->KEYM2
   SATELITE->KEYM3:=ST->KEYM3
   SATELITE->KEYM4:=ST->KEYM4
   SATELITE->KEYM5:=ST->KEYM5
   SATELITE->KEYM6:=ST->KEYM6
   SATELITE->KEYM7:=ST->KEYM7
   SATELITE->KEYM8:=ST->KEYM8
   ST->(DBCLOSEAREA())
   //--2
   cD:='PROMOSI'
   SELECT (cD) ;USE
   COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
   USE (DDATA+cD)  ALIAS (cD)
   //--3
   cD:='CASHIER'
   SELECT (cD) ;USE
   COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
   USE (DDATA+cD)  ALIAS (cD)
   CASHIER->(__DBLocate({||CODE==cGLCd},,,,.f.))
   //--4
   cD:='TOMBOL'
   SELECT (cD) ;USE
   COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
   USE (DDATA+cD)  ALIAS (cD)  ;ResetKey(@a)
   //--5
   cD:='CLASS'
   SELECT (cD) ;USE
   COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
   USE (DDATA+cD)  ALIAS (cD)
   INDEX ON CODE TO (DDATA+'CLASS__1.NTX')
   INDEX ON Left(CODE,10) TO (DDATA+'CLASS__2.NTX')
   SET INDEX TO  (DDATA+'CLASS__1.NTX'),(DDATA+'CLASS__2.NTX')
   SELECT TEMP
   //--6
   cD:='PRODUK'
   SELECT (cD) ;USE
   COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
   USE (DDATA+cD)  ALIAS (cD)
   INDEX ON REF           TO (DDATA+'PRODUK_3.NTX')
   INDEX ON Left(DESC,28) TO (DDATA+'PRODUK_2.NTX')
   INDEX ON CODE          TO (DDATA+'PRODUK_1.NTX')
   SET INDEX TO  (DDATA+'PRODUK_1.NTX'),(DDATA+'PRODUK_2.NTX'),(DDATA+'PRODUK_3.NTX')
   SELECT TEMP

   DLL->(DBGoto(Val(SubS(SATELITE->CPNO,3,2))))
   IF DLL->(RecLock())
      DLL->STATUS:=0
      DLL->WAKTU:=''
      DLL->TGLOPEN :=DTOC(DATE())
      DLL->EOD:=.T.
      DLL->(DBUNLOCK())
      DLL->(DBCOMMIT())
   ENDIF
   DLL->(DBUnlock())
   RestScreen(17,10,19,64,cSccr)

RETURN
*-----------------------------------------------------------------------------
