#Include 'kassa.ch'
#Include 'inkey.ch'

*-----------------------------------------------------------------------------
PROCEDURE Para(lLan)
LOCAL cO:=SetColor()
PRIVATE aPil1:={' (TEC) ',' (Siemens) ',' (Integral) ',' (DTrack) ',' (Citizen) ',' (IBM) ',' (None) '}
PRIVATE aPil2:={' (Port Drw) ',' (Printer) ',' (Com1) ',' (Com2) '}
PRIVATE aPil3:={' (TEC) ',' (Siemens) ',' (Epson) ',' (DTrack1) ',' (DTrack2) ',' (Citizen) ',' (IBM) ',' (None) '}
PRIVATE aPil4:={' (Com1) ',' (Com2) ',' (Com3) ',' (Com4) '}
PRIVATE aPil5:={' (Lpt1) ',' (Com1) ',' (Com2) ',' (Com3) ',' (Com4) '}
PRIVATE aPil6:={' (Receipt) ',' (Faktur) '}

SET WRAP ON
IF Select('SATELITE')#0
   SELECT  SATELITE
   USE
ENDIF
IF !NetUse({{If(lLan,NDATA,DDATA)+'SATELITE',.f.}})
   RETURN
ENDIF
cCTK     :=SATELITE->CTK          // cetak otomatis/manual tekan tombol var hrs public
nKUPON   :=SATELITE->KUPON        // kelipatan nilai dapat kupon
nTLR     :=SATELITE->TLR          // toleransi
dTGLKPN  :=SATELITE->TGLKPN       // tanggal berlaku
nDrawer  :=SATELITE->DRAWER       // tipe Drawer
nStDrw   :=SATELITE->STDRW        // Status Drawer Open
nTipeDrw :=SATELITE->TIPEDRW      // Status Drawer Open
nTipeDsp :=SATELITE->TIPEDSP      // Status Drawer Open
nPortDsp :=SATELITE->PORTDSP      // Status Drawer Open
nPortDrw :=SATELITE->PORTDRW      // Status Drawer Open
nPortPrn :=SATELITE->PORTPRN      // Status Drawer Open
nTipePrn :=SATELITE->TIPEPRN      // Cetak receipt atau faktur
cTimePr  :=SATELITE->TIMEPR       // Cetak Jam atau tidak
lJournal :=SATELITE->JOURNAL      // Cetak Journal atau tidak
lPCode   :=SATELITE->PCODE        // Cetak Code atau tidak
lINFAK   :=SATELITE->INFAK        // Akstifasi cetak infak
lININFAK :=SATELITE->ININFAK      // Tipe Inputan infak (isian atau pembulatan)
nQtyH1  :=SATELITE->QTYH1        //
nQtyH2  :=SATELITE->QTYH2        //
nQtyH3  :=SATELITE->QTYH3        //

IF _ICS#1
   nStockC :=SATELITE->STOCKC     // Ngecek Stock Warning Limit
ENDIF

nT:=3  //__4
nL:=0  //__14
SetColor('n/bg,w+/n,,,n/bg')
*---------------------------
Box(nT,nL,nT+17,nL+79,'w+/bg')
@ nT+ 1,nL+2  SAY 'PARAMETER SETTING '  COLOR 'bg+/bg'
@ nT+ 2,nL+2  SAY ' Cetak Kupon : [ ]                        þ Tgl Berlaku  : [  /  /    ]'
@ nT+ 3,nL+2  SAY ' Kelipatan Rp: [         ]                þ Toleransi $  : [     ]'
@ nT+ 4,nL+2  SAY ' CetakJournal: [ ]  (Y/N)                 þ Print Time   : [ ] (Y/N)'
@ nT+ 5,nL+2  SAY ' Aktif Infak : [ ]  (Y/N)                 þ Cetak Code   : [ ] (Y/N)'
@ nT+ 6,nL+2  SAY ' Input Infak : [ ]  (Y/N)'
IF _ICS#1
   @ nT+6,nL+44 SAY 'þ Stock Limit  : [     ]'
ENDIF
@ nT+ 7,nL+2  SAY ' Qty Harga1   : [   ]                     þ Qty Harga2   : [   ]'
@ nT+ 8,nL+2  SAY ' Qty Harga3   : [   ]'
@ nT+ 9,nL+2  SAY 'PARAMETER HARDWARE '  COLOR 'bg+/bg'
@ nT+10,nL+2  SAY ' Tipe Drawer : [ ]                        þ Status Drawer: [ ] (0/1/2)'
@ nT+11,nL+2  SAY ' Port Drawer : [ ]'
@ nT+12,nL+2  SAY ' Tipe Display: [ ]'
@ nT+13,nL+2  SAY ' Port Display: [ ]'
@ nT+14,nL+2  SAY ' Port Printer: [ ]'
@ nT+15,nL+2  SAY ' Tipe Cetakan: [ ]'
@ nT+10,nL+20 SAY IF(nDrawer >0,aPil1[nDrawer]+Space(8),'                ')
@ nT+11,nL+20 SAY IF(nPortDrw>0,aPil2[nPortDrw]+Space(8),'               ')
@ nT+12,nL+20 SAY IF(nTipeDsp>0,aPil3[nTipeDsp]+Space(8),'               ')
@ nT+13,nL+20 SAY IF(nPortDsp>0,aPil4[nPortDsp]+Space(8),'               ')
@ nT+14,nL+20 SAY IF(nPortPrn>0,aPil5[nPortPrn]+Space(8),'               ')
@ nT+15,nL+20 SAY IF(nTipePrn>0,aPil6[nTipePrn]+Space(8),'               ')

@ nT+ 2,nL+18 GET cCTK      PICT '@!'   VALID cCTK='Y' .OR. cCTK='N'
@ nT+ 2,nL+62 GET dTGLKPN   PICT '@D'
@ nT+ 3,nL+18 GET nKUPON    PICT '9,999,999'
@ nT+ 3,nL+62 GET nTLR      PICT '9,999'
@ nT+ 4,nL+18 GET lJournal  PICT 'Y'
@ nT+ 4,nL+62 GET cTimePr   PICT '!'    VALID cTimePR='Y' .OR. cTimePr='N'
@ nT+ 5,nL+18 GET lInfak    PICT 'Y'
@ nT+ 5,nL+62 GET lPCode    PICT 'Y'
@ nT+ 6,nL+18 GET lInInfak  PICT 'Y'
IF _ICS#1
   @ nT+6,nL+62 GET nStockC   PICT '99999'
ENDIF
@ nT+ 7,nL+19 GET nQtyH1    PICT '999'       VALID nQtyH1>=0
@ nT+ 7,nL+62 GET nQtyH2    PICT '999'       VALID (!Empty(nQtyH1) .AND. nQtyH2>nQtyH1) .OR. nQtyH2=0
@ nT+ 8,nL+19 GET nQtyH3    PICT '999'       VALID (!Empty(nQtyH2) .AND. nQtyH3>nQtyH2) .OR. nQtyH3=0
@ nT+10,nL+18 GET nDrawer   PICT '9'    RANGE 1,5  WHEN DrwList(nT+ 9,nL+06,nDrawer)
@ nT+10,nL+62 GET nStDrw    PICT '9'    RANGE 0,3
@ nT+11,nL+18 GET nPortDrw  PICT '9'    RANGE 1,4  WHEN DrwPort(nT+10,nL+07,nPortDrw)  //VALID CekPort(nPortDrw,nPortDsp)
@ nT+12,nL+18 GET nTipeDsp  PICT '9'    RANGE 0,8  WHEN DspTipe(nT+11,nL+01,nTipeDsp)
@ nT+13,nL+18 GET nPortDsp  PICT '9'    RANGE 1,4  WHEN DspPort(nT+12,nL+07,nPortDsp)  //VALID CekPort(nPortDrw,nPortDsp)
@ nT+14,nL+18 GET nPortPrn  PICT '9'    RANGE 1,5  WHEN PrnPort(nT+13,nL+07,nPortPrn)  //VALID CekPort(nPortDrw,nPortDsp)
@ nT+15,nL+18 GET nTipePrn  PICT '9'    RANGE 1,2  WHEN PrnTipe(nT+14,nL+08,nTipePrn)
READ
SetColor(cO)
IF LASTKEY()=K_ESC .OR. !RecLock()
   RETURN
ENDIF
SATELITE->CTK    :=cCTK
SATELITE->KUPON  :=nKUPON
SATELITE->TLR    :=nTLR
SATELITE->TGLKPN :=dTGLKPN
SATELITE->DRAWER :=nDrawer
SATELITE->TIPEDRW:=nDrawer
SATELITE->STDRW  :=nStDrw
SATELITE->TIMEPR :=cTimePr
SATELITE->JOURNAL:=lJournal
SATELITE->TIPEDSP:=nTipeDsp      //
SATELITE->PORTDSP:=nPortDsp      //
SATELITE->PORTDRW:=nPortDrw      //
SATELITE->PORTPRN:=nPortPrn      //
SATELITE->TIPEPRN :=nTipePrn
SATELITE->PCODE  :=lPCode        //
SATELITE->INFAK  :=lINFAK        //
SATELITE->ININFAK:=lININFAK      //
SATELITE->QTYH1   :=nQtyH1        //
SATELITE->QTYH2   :=nQtyH2        //
SATELITE->QTYH3   :=nQtyH3        //
        IF _ICS#1
   SATELITE->STOCKC:=nStockC
ENDIF
lGJour :=lJournal
lGCode :=lPCode

CLOSE ALL
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION DrwList(nR,nC,nD)
LOCAL nPil:=nD,cScr:=SaveScreen(nR+1,nC+2,nR+3,nC+69),cCol:=SetColor()
SetColor('w/n,n/w')
@ nR+1,nC+2 CLEAR TO nR+3,nC+69
@ nR+1,nC+2 TO nR+3,nC+69
@ nR+1,nC+3 SAY 'Tipe Drawer'      COLOR 'w+'
@ nR+2,nC+3    PROMPT aPil1[1]
@ nR+2,Col()+0 PROMPT aPil1[2]
@ nR+2,Col()+0 PROMPT aPil1[3]
@ nR+2,Col()+0 PROMPT aPil1[4]
@ nR+2,Col()+0 PROMPT aPil1[5]
@ nR+2,Col()+0 PROMPT aPil1[6]
@ nR+2,Col()+0 PROMPT aPil1[7]
MENU TO nPil
SetColor(cCol)
RestScreen(nR+1,nC+2,nR+3,nC+69,cScr)
IF nPil#0 ;nD:=nPil
   @ nR+1,nC+14 SAY aPil1[nPil]+Space(8)
ENDIF
nDRAWER:=nD ;KeyBoard Chr(13)
RETURN .T.

*-----------------------------------------------------------------------------
STATIC FUNCTION DrwPort(nR,nC,nD)
LOCAL nPil:=nD,cScr:=SaveScreen(nR+1,nC+2,nR+3,nC+42),cCol:=SetColor()
DO WHILE .T.
   SetColor('w/n,n/w')
   @ nR+1,nC+2 CLEAR TO nR+3,nC+42
   @ nR+1,nC+2 TO nR+3,nC+42
   @ nR+1,nC+3 SAY 'Port Drawer'   COLOR 'w+'
   @ nR+2,nC+3    PROMPT aPil2[1]
   @ nR+2,Col()+0 PROMPT aPil2[2]
   @ nR+2,Col()+0 PROMPT aPil2[3]
   @ nR+2,Col()+0 PROMPT aPil2[4]
   MENU TO nPil
   IF (nPil=3 .AND. nPortDsp=1) .OR. (nPil=4 .AND. nPortDsp=2)
      Tone(2800,4) ;LOOP
   ENDIF
   EXIT
ENDDO
SetColor(cCol)
RestScreen(nR+1,nC+2,nR+3,nC+42,cScr)
IF nPil#0 ;nD:=nPil
   @ nR+1,nC+13 SAY aPil2[nPil]+Space(8)
ENDIF
nPortDrw:=nD ;KeyBoard Chr(13)
RETURN .T.

*-----------------------------------------------------------------------------
STATIC FUNCTION DspTipe(nR,nC,nD)
LOCAL nPil:=nD,cScr:=SaveScreen(nR+1,nC+2,nR+3,nC+78),cCol:=SetColor()
SetColor('w/n,n/w')
@ nR+1,nC+2 CLEAR TO nR+3,nC+78
@ nR+1,nC+2 TO nR+3,nC+78
@ nR+1,nC+3 SAY 'Tipe Display'  COLOR 'w+'
@ nR+2,nC+3    PROMPT aPil3[1]
@ nR+2,Col()+0 PROMPT aPil3[2]
@ nR+2,Col()+0 PROMPT aPil3[3]
@ nR+2,Col()+0 PROMPT aPil3[4]
@ nR+2,Col()+0 PROMPT aPil3[5]
@ nR+2,Col()+0 PROMPT aPil3[6]
@ nR+2,Col()+0 PROMPT aPil3[7]
@ nR+2,Col()+0 PROMPT aPil3[8]
MENU TO nPil
SetColor(cCol)
RestScreen(nR+1,nC+2,nR+3,nC+78,cScr)
IF nPil#0 ;nD:=nPil
   @ nR+1,nC+19 SAY aPil3[nPil]+Space(8)
ENDIF
nTipeDsp:=nD ;KeyBoard Chr(13)
RETURN .T.

*-----------------------------------------------------------------------------
STATIC FUNCTION DspPort(nR,nC,nD)
LOCAL nPil:=nD,cScr:=SaveScreen(nR+1,nC+2,nR+3,nC+36),cCol:=SetColor()
DO WHILE .T.
   SetColor('w/n,n/w')
   @ nR+1,nC+2 CLEAR TO nR+3,nC+36
   @ nR+1,nC+2 TO nR+3,nC+36
   @ nR+1,nC+3 SAY 'Port Display'  COLOR 'w+'
   @ nR+2,nC+3    PROMPT aPil4[1]
   @ nR+2,Col()+0 PROMPT aPil4[2]
   @ nR+2,Col()+0 PROMPT aPil4[3]
   @ nR+2,Col()+0 PROMPT aPil4[4]
   MENU TO nPil
   IF (nPil=1 .AND. nPortDrw=3) .OR. (nPil=2 .AND. nPortDrw=4)
      Tone(2800,4) ;LOOP
   ENDIF
   EXIT
ENDDO
SetColor(cCol)
RestScreen(nR+1,nC+2,nR+3,nC+36,cScr)
IF nPil#0 ;nD:=nPil
   @ nR+1,nC+13 SAY aPil4[nPil]+Space(8)
ENDIF
nPortDsp:=nD ;KeyBoard Chr(13)
RETURN .T.

*-----------------------------------------------------------------------------
STATIC FUNCTION PrnPort(nR,nC,nD)
LOCAL nPil:=nD,cScr:=SaveScreen(nR+1,nC+2,nR+3,nC+46),cCol:=SetColor()
DO WHILE .T.
   SetColor('w/n,n/w')
   @ nR+1,nC+2 CLEAR TO nR+3,nC+46
   @ nR+1,nC+2 TO nR+3,nC+46
   @ nR+1,nC+3 SAY 'Port Printer'  COLOR 'w+'
   @ nR+2,nC+3    PROMPT aPil5[1]
   @ nR+2,Col()+0 PROMPT aPil5[2]
   @ nR+2,Col()+0 PROMPT aPil5[3]
   @ nR+2,Col()+0 PROMPT aPil5[4]
   @ nR+2,Col()+0 PROMPT aPil5[5]
   MENU TO nPil
   IF (nPil=2 .AND. nPortDrw=3) .OR. (nPil=3 .AND. nPortDrw=4) .OR. ;
      (nPil=2 .AND. nPortDsp=1) .OR. (nPil=3 .AND. nPortDsp=2) .OR. ;
      (nPil=4 .AND. nPortDsp=3) .OR. (nPil=5 .AND. nPortDsp=4)
      Tone(2800,4) ;LOOP
   ENDIF
   EXIT
ENDDO
SetColor(cCol)
RestScreen(nR+1,nC+2,nR+3,nC+46,cScr)
IF nPil#0 ;nD:=nPil
   @ nR+1,nC+13 SAY aPil5[nPil]+Space(8)
ENDIF
nPortPrn:=nD ;KeyBoard Chr(13)
RETURN .T.
*----------------------------------------------------------------------------
STATIC FUNCTION PrnTipe(nR,nC,nD)
LOCAL nPil:=nD,cScr:=SaveScreen(nR+1,nC+2,nR+3,nC+25),cCol:=SetColor()
DO WHILE .T.
   SetColor('w/n,n/w')
   @ nR+1,nC+2 CLEAR TO nR+3,nC+25
   @ nR+1,nC+2 TO nR+3,nC+25
   @ nR+1,nC+3 SAY 'Tipe Cetakan'  COLOR 'w+'
   @ nR+2,nC+3    PROMPT aPil6[1]
   @ nR+2,Col()+0 PROMPT aPil6[2]
   MENU TO nPil
   EXIT
ENDDO
SetColor(cCol)
RestScreen(nR+1,nC+2,nR+3,nC+25,cScr)
IF nPil#0 ;nD:=nPil
   @ nR+1,nC+13 SAY aPil6[nPil]+Space(8)
ENDIF
nTipePrn:=nD //;KeyBoard Chr(13)
RETURN .T.
*-----------------------------------------------------------------------------
STATIC FUNCTION CekPort(nPil1,nPil2,n)
IF (nPil1=3 .AND. nPil2=1) .OR. (nPil1=4 .AND. nPil2=2)
   Tone(2800,4) ;RETURN .F.
ENDIF
IF n=1 .AND. !Str(nPil1,1)$'1234'
   Tone(2800,4) ;RETURN .F.
ELSEIF n=2 .AND. !Str(nPil1,1)$'1234'
   Tone(2800,4) ;RETURN .F.
ENDIF
RETURN .T.
