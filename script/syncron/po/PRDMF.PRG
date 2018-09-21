#include 'box.ch'
#include 'inkey.ch'
#include 'setcurs.ch'
*------------------------------------------------------------------------------
PROCEDURE PrdMF(l)
PRIVATE cCODE
PRIVATE cREF
PRIVATE cDESC
PRIVATE cUNIT
PRIVATE cUNIT1
PRIVATE cUNIT2
PRIVATE nQTYJ
PRIVATE nQTYJ1
PRIVATE nQTYJ2
PRIVATE nSTOCK
PRIVATE nCPRICE
PRIVATE nPRICE
PRIVATE nPRICE1
PRIVATE nPRICE2
PRIVATE cGROUP
PRIVATE cDEPT
PRIVATE nTombol  :='FFF'
PRIVATE nQuit    := 0
PRIVATE nPAGE    :=0
PRIVATE lExit    :=.F.
PRIVATE lBox     :=.F.
PRIVATE COLEDIT1 :='BG+/N,W+/B'
PRIVATE ColEdit3 :='W+/B*,GR/BG*'
PRIVATE cOLDCLR  :=SETCOLOR()
PRIVATE GETLIST  :={},cFltmp:=DDATA+'RANGP.DBF',cSCR01

SETCOLOR(COLEDIT1)
SET DELETED ON
SETBLINK(.F.)

cPath:=If(!l,DDATA,NDATA)

IF SELECT('CLASS')=0
   IF !NetUse({{cPath+'CLASS.DBF',.T.}})
      RETURN
   ENDIF
   SET INDEX TO (cPath+"CLASS__1.NTX"),(cPath+"CLASS__2.NTX")
ENDIF

IF SELECT('GROUP')=0
   IF !NetUse({{cPath+'GROUP.DBF',.T.}})
      RETURN
   ENDIF
   SET INDEX TO (cPath+"GROUP__1.NTX")
ENDIF

IF Select('PRODUK')#0
   SELECT  PRODUK
   USE
ENDIF
IF !NetUse({{cPath+'PRODUK.DBF',.T.}})             // .f.
   RETURN
ENDIF
IF  !File(cPath+"PRODUK_1.NTX")      ;
    .OR. !File(cPath+"PRODUK_2.NTX") ;
    .OR. !File(cPath+"PRODUK_3.NTX") ;
    .OR. !File(cPath+"PRODUK_4.NTX")
    INDEX ON CODE          TO (cPath+"PRODUK_1.NTX")
    INDEX ON Left(DESC,28) TO (cPath+"PRODUK_2.NTX")
    INDEX ON REF           TO (cPath+"PRODUK_3.NTX")
    INDEX ON UNIT          TO (cPath+"PRODUK_4.NTX")
ENDIF
SET INDEX TO (cPath+"PRODUK_1.NTX"),(cPath+"PRODUK_2.NTX"),(cPath+"PRODUK_3.NTX"),(cPath+"PRODUK_4.NTX")

SET KEY K_F2  TO
SET KEY K_F3  TO
SET KEY K_F4  TO
SET KEY K_F5  TO
SET KEY K_F6  TO
SET KEY K_F7  TO
SET KEY K_ESC TO

Invent()

SET KEY K_F2  TO
SET KEY K_F3  TO
SET KEY K_F4  TO
SET KEY K_F5  TO
SET KEY K_F6  TO
SET KEY K_ESC TO
USE
SETBLINK(.T.)
SETCOLOR(cOLDCLR)
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE Invent()
 LOCAL GETLIST:={}
 NO:=0 ;NO='NO+1'

 aFiel:={'CODE','REF','DESC','UNIT','STOCK','TRANS(PRICE,"99,999,999")' ,;
         'TRANS(PRICE1,"99,999,999")','TRANS(PRICE2,"99,999,999")',;
         'TRANS(CPRICE,"99,999,999")','DEPT','GROUP'}

 aHead:={'KODE BRG','BARCODE','NAMA BARANG','UNIT','STOK','H.JUAL-1','H.JUAL-2',;
         'H.JUAL-3','HRG BELI','DEPT.','GROUP'}

 OldColor:=SetColor()
 Screen()
 DBEDIT(2,1,25,78,aFiel,'InvProses',,aHead,'Ä')
 SetColor(OldColor)
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE Screen()
Box(01,00,26,79,,2)
@ 27,0 SAY 'F2-EditF3-FindF4-AddF5-DelF6-DispF7-PrintESC-Quit' COLOR '/w'
//          012345678901234567890123456789012345678901234567890123456789012345678901234567890
RETURN

*------------------------------------------------------------------------------
FUNCTION InvProses(nMode,nFld)
LOCAL  nInKey, cScr, nRec, nRetVal:=1, nRow:=Row(), nCol:=Col(), cSel:=Select()
 IF Deleted() ;@ 01,73 SAY 'DELETE' COLOR 'w+'      //;KeyBoard Chr(32)
 ELSE         ;@ 01,73 SAY 'ÑÑÑÑÑÑ' COLOR ColEdit1  //;KeyBoard Chr(32)
 ENDIF        ;GetList:={}
 cField:=aFiel[nFld]
 SAVE SCREEN TO cScr
 SetCursor(SC_NONE)
 nInKey:=LastKey()
   SetCursor(SC_NORMAL)
   DO CASE
   CASE nInKey=K_F2   ;Show() ;F2Edit(); KEYBOARD CHR(32)   //Edit....
   CASE nInKey=K_F3   ;F3Search()                           //Search..
   CASE nInKey=K_F4   ;Show() ;F4Add() ; KEYBOARD CHR(32)   //Add.....
   CASE nInKey=K_F5                                         //Delete...
        DO CASE
        CASE Delete()
             IF RecLock() ;RECALL ;ENDIF

        CASE RecLock()
             IF RecLock() ;DELETE ;ENDIF
        ENDCASE
        nRetVal:=2
   CASE nInKey=K_F6   ;F6Display()                  //Previus...
   CASE nInKey=K_F7   ;F7Print()                    //Cetak Produk...
   CASE nInKey=K_ESC  ;nRetVal:=0
   CASE nInKey>=48.AND.nInkey<=122 ;nRec:=RecNo()   //1<=nInkey<=Z
        IF !DBSeek(Upper(Chr(nInkey))) ;DBGoTo(nRec) ;ENDIF
   ENDCASE
REST SCREEN FROM cScr
IF Deleted() ;@ 01,73 SAY 'DELETE' COLOR 'w+'      //;KeyBoard Chr(32)
ELSE         ;@ 01,73 SAY 'ÑÑÑÑÑÑ' COLOR ColEdit1  //;KeyBoard Chr(32)
ENDIF
SetCursor(SC_NONE)
lExit:=.F.
RETURN nRetVal

*------------------------------------------------------------------------------
STATIC PROCEDURE Show()
 @ 09,00 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
 @ 10,00 SAY '³                           PRODUK ITEM MAINTENANCE                            ³'
 @ 11,00 SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
 @ 12,00 SAY '³ Kode Barang                                                                  ³'
 @ 13,00 SAY '³ Barcode                                                                      ³'
 @ 14,00 SAY '³                                                                              ³'
 @ 15,00 SAY '³ Nama Barang                                                                  ³'
 @ 16,00 SAY '³                                                                              ³'
 @ 17,00 SAY '³ Harga Beli   (Rp)                                                            ³'
 @ 18,00 SAY '³ Harga Jual 1 (Rp)              Unit:     Qty:                                ³'
 @ 19,00 SAY '³ Harga Jual 2 (Rp)              Unit:     Qty:                                ³ '
 @ 20,00 SAY '³ Harga Jual 3 (Rp)              Unit:     Qty:                                ³'
 @ 21,00 SAY '³                                                                              ³'
 @ 22,00 SAY '³ Jumlah Stok                                                                  ³'
 @ 23,00 SAY '³                                                                              ³'
 @ 24,00 SAY '³ Department                                                                   ³'
 @ 25,00 SAY '³ Group                                                                        ³'
 @ 26,00 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
 @ 27,0 SAY Space(80)
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE Say()
 LOCAL cOld:=SetColor('w+')
 CLASS->(DBSeek(PRODUK->DEPT))
 GROUP->(DBSeek(PRODUK->GROUP))
 //@ 01,73 SAY If(Deleted(),'DELETE','ÄÄÄÄÄÄ') COLOR If(Deleted(),'w+',SetColor())
 @ 12,20 SAY CODE
 @ 13,20 SAY REF
 @ 15,20 SAY DESC
 @ 17,20 SAY CPRICE   PICT '99,999,999'
 @ 18,20 SAY PRICE    PICT '99,999,999'
 @ 18,39 SAY UNIT     PICT '@!'
 @ 18,48 SAY QTYJ     PICT '999'
 @ 19,20 SAY PRICE1   PICT '99,999,999'
 @ 19,39 SAY UNIT1    PICT '@!'
 @ 19,48 SAY QTYJ1    PICT '999'
 @ 20,20 SAY PRICE2   PICT '99,999,999'
 @ 20,39 SAY UNIT2    PICT '@!'
 @ 20,48 SAY QTYJ2    PICT '999'
 @ 22,23 SAY STOCK    PICT '999,999'
 @ 24,20 SAY DEPT     PICT '999'
 @ 25,20 SAY GROUP    PICT '999'
 @ 24,25 SAY '/ '+LEFT(CLASS->DESC,22)
 @ 25,25 SAY '/ '+LEFT(GROUP->DESC,22)
 SetColor(cOld)
RETURN

*------------------------------------------------------------------------------
STATIC FUNCTION CekCode()
 LOCAL nRec:=RecNo()
 IF DBSeek(cCODE)
    IF nTombol='F4'
       Warning(' Kode '+ALlTrim(cCODE)+' sudah ada ... ') ;RETURN .F.
    ELSEIF RecNo()#nRec
       Warning(' Kode '+ALlTrim(cCODE)+' sudah ada ... ')
       DBGoTo(nRec) ;cCODE:=CODE ;RETURN .F.
    ENDIF
 ELSE
    DBGoTo(nRec)
 ENDIF
RETURN .T.
*------------------------------------------------------------------------------
STATIC FUNCTION CekBarc()
 LOCAL nRec:=RecNo()
 PRODUK->(DBSetOrder(3))
 IF PRODUK->(DBSeek(LEFT(cREF+'             ',13))) .AND. !Empty(Alltrim(cREF))
    IF nTombol='F4'
       Warning(' Barcode '+ALlTrim(cREF)+' sudah ada ... ')
       PRODUK->(DBSetOrder(1))
       RETURN .F.
    ELSEIF RecNo()#nRec .AND. !Empty(Alltrim(cREF))
       Warning(' Barcode '+ALlTrim(cREF)+' sudah ada ... ')
       DBGoTo(nRec) ;cREF:=REF
       PRODUK->(DBSetOrder(1))
       RETURN .F.
    ENDIF
 ELSE
    PRODUK->(DBGoTo(nRec))
 ENDIF
 PRODUK->(DBSetOrder(1))
RETURN .T.
*------------------------------------------------------------------------------
STATIC PROCEDURE GetVar()
 GETLIST:={}
 @ 12,20 GET cCODE      PICT '@!'            VALID CekCode()
 @ 13,20 GET cREF       PICT '!!!!!!!!!!!!!' VALID CekBarc()
 @ 15,20 GET cDESC      PICT '@!'
 @ 17,20 GET nCPRICE    PICT '99,999,999'
 @ 18,20 GET nPRICE     PICT '99,999,999'
 @ 18,39 GET cUNIT      PICT '@!'
 @ 18,48 GET nQTYJ      PICT '999'
 @ 19,20 GET nPRICE1    PICT '99,999,999'
 @ 19,39 GET cUNIT1     PICT '@!'
 @ 19,48 GET nQTYJ1     PICT '999'
 @ 20,20 GET nPRICE2    PICT '99,999,999'
 @ 20,39 GET cUNIT2     PICT '@!'
 @ 20,48 GET nQTYJ2     PICT '999'
 IF nTOMBOL='F4'
    @ 22,23 GET nSTOCK     PICT '999,999'
 ELSE
    @ 22,23 SAY nSTOCK     PICT '999,999'
 ENDIF
 @ 24,20 GET cDEPT      PICT '999'           VALID AllTrue(CLASS->(SF5ADept()))
 @ 25,20 GET cGROUP     PICT '999'           VALID LASTKEY()=K_UP .AND. AllTrue(GROUP->(SF4AGroup()))
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE SetVar()
 cCODE      := CODE
 cREF       := REF
 cDESC      := DESC
 cUNIT      := UNIT
 cUNIT1     := UNIT1
 cUNIT2     := UNIT2
 nQTYJ      := QTYJ
 nQTYJ1     := QTYJ1
 nQTYJ2     := QTYJ2
 nSTOCK     := STOCK
 nCPRICE    := CPRICE
 nPRICE     := PRICE
 nPRICE1    := PRICE1
 nPRICE2    := PRICE2
 cDEPT      := DEPT
 cGROUP     := GROUP
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE SetBlank
 cCODE      := Space(Len(CODE))
 cREF       := Space(Len(REF))
 cDESC      := Space(Len(DESC))
 cUNIT      := Space(Len(UNIT))
 cUNIT1     := Space(Len(UNIT1))
 cUNIT2     := Space(Len(UNIT2))
 nQTYJ      := 0
 nQTYJ1     := 0
 nQTYJ2     := 0
 nSTOCK     := 0
 nCPRICE    := 0
 nPRICE     := 0
 nPRICE1    := 0
 nPRICE2    := 0
 cDEPT      := Space(Len(DEPT))
 cGROUP     := Space(Len(GROUP))
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE Write()
 FIELD->CODE      := cCODE
 FIELD->REF       := cREF
 FIELD->DESC      := cDESC
 FIELD->UNIT      := cUNIT
 FIELD->UNIT1     := cUNIT1
 FIELD->UNIT2     := cUNIT2
 FIELD->QTYJ      := nQTYJ
 FIELD->QTYJ1     := nQTYJ1
 FIELD->QTYJ2     := nQTYJ2
 FIELD->STOCK     := nSTOCK
 FIELD->CPRICE    := nCPRICE
 FIELD->PRICE     := nPRICE
 FIELD->PRICE1    := nPRICE1
 FIELD->PRICE2    := nPRICE2
 FIELD->DEPT      := cDEPT
 FIELD->GROUP     := cGROUP
 DBCommit()
 DBUnLock()
RETURN
*------------------------------------------------------------------------------
STATIC PROCEDURE F2Edit()
LOCAL  cSvScreen
cSvScreen:=SaveScreen(27,0,27,79)

Say()

@ 27,00 CLEAR TO 27,79
@ 27,00 SAY 'F2-SaveF4-GroupF5-DeptESC-Quit' COLOR '/w'

SetKey(K_F2 ,{||SF2ASave(.F.)})
SetKey(K_F4,{||GROUP->(SF4AGroup())})
SetKey(K_F5,{||CLASS->(SF5ADept())})
SetKey(K_F7,{||SF7Stock()})
SetKey(K_ESC,{||SF10AQuit(.F.)})

SetVar()
GetVar()
READ

SET KEY K_F2  TO
SET KEY K_F4  TO
SET KEY K_F5  TO
SET KEY K_F7  TO
SET KEY K_ESC TO
RestScreen(27,0,27,79,cSvScreen)
RETURN
*------------------------------------------------------------------------------
STATIC PROCEDURE F4Add()
LOCAL  cSvScreen

cSvScreen:=SaveScreen(27,0,27,79)
Say()
@ 27,00 CLEAR TO 27,79
@ 27,00 SAY 'F2-SaveF4-GroupF5-DeptESC-Quit' COLOR '/w'

SetKey(K_F2 ,{||SF2ASave(.T.)})
SetKey(K_F4,{||GROUP->(SF4AGroup())})
SetKey(K_F5,{||CLASS->(SF5ADept())})
SetKey(K_F7,{||SF7Stock()})
SetKey(K_ESC,{||SF10AQuit(.T.)})

nTombol:='F4'
SetBlank()
GetVar()
READ
nTombol:='FFF'

SET KEY K_F2  TO
SET KEY K_F4  TO
SET KEY K_F5  TO
SET KEY K_F7  TO
SET KEY K_ESC TO
RestScreen(27,0,27,79,cSvScreen)
RETURN

*===============================================================================
STATIC PROCEDURE F6Display()
LOCAL lLoop:=.T., nInkey
 SetCursor(0)
 Show()
 @ 27,0 SAY '-Next-PreviousHome-TopEnd-BottomF2-Edit' COLOR '/W'
 DO WHILE lLoop
    Say()
    nInkey:=Inkey(0)
    lLoop:=Skipping()
    IF nInkey=K_F2 ;SetCursor(1)
       F2Edit()    ;SetCursor(0)
    ENDIF
 ENDDO
 KeyBoard Chr(32) ;SetCursor(1)
RETURN

*===============================================================================
STATIC FUNCTION SF2ASave(lAdd)
 LOCAL nLstRec:=RecNo()
 DBSetOrder(1)
 SEEK cCODE
 IF lAdd
    IF Found() .OR. !AddRec();SetVar();GetVar()
       ErrMsg('Kode barang sudah ada dalam database','')
       RETURN .F.
     ENDIF
 ELSE
    IF Found() .AND. nLstRec<>RecNo();SetVar();GetVar()
       ErrMsg('Kode barang sudah ada dalam database','')
       RETURN .F.
    ENDIF
    GO nLstRec
    IF !RecLock()
       ErrMsg("Data record tidak dapat diakses",'')
       RETURN .F.
    ENDIF
 ENDIF
 CLEAR GETS //keluar dari READ...
 Write()
 KEYBOARD CHR(27)
 SET KEY K_ESC TO
RETURN .T.
*------------------------------------------------------------------------------*
STATIC PROCEDURE F3Search()
LOCAL   GetList:={},aF
LOCAL   cSvScreen,nLstRec,nInkey
LOCAL   cSearch:=Space(Len(CODE)), cCol:=SetColor()
PRIVATE cTeks,bField,xGet

cSvScreen:=SaveScreen(24,0,27,79)
@ 24,00 CLEAR TO 27,79
Box(24,00,27,79)
@ 27,02 SAY 'F2-KodeBrgF3-BarcodeF4-DescESC-Quit' COLOR '/w'
@ 25,02 SAY 'Select Search Type :'

DO WHILE .T.
   nInkey:=Inkey(0)
   SetColor(ColEdit3)
   DO CASE
      CASE nInkey=K_F2
           aF:={{'CODE'      ,'CODE' };
               ,{'DESC'      ,'DESC' };
               ,{'H.JUAL1'  ,'PRICE' };
               ,{'H.JUAL2'  ,'PRICE1'};
               ,{'H.JUAL3'  ,'PRICE2'}}
           cTeks:='Search Code:'
           xGet:=Space(Len(CODE))
           bFIELD:={||CODE}
           TBLook(aF,{|xD|DBSeek(xD)},'[List Inv]')
      CASE nInkey=K_F3
           aF:={{'BARCODE'  ,'REF'   };
               ,{'CODE'     ,'CODE'  };
               ,{'DESC'     ,'DESC'  };
               ,{'H.JUAL1' ,'PRICE'  };
               ,{'H.JUAL2'  ,'PRICE1'};
               ,{'H.JUAL3'  ,'PRICE2'}}
           cTeks:='Search Barcode:'
           xGet:=Space(Len(REF))
           bFIELD:={||REF}
           SET ORDER TO 3 ;TBLook(aF,{|xD|DBSeek(xD)},'[List Inv]')
           SET ORDER TO 1
      CASE nInkey=K_F4
           aF:={{'DESC'     ,'DESC'  };
               ,{'CODE'     ,'CODE'  };
               ,{'H.JUAL1'  ,'PRICE' };
               ,{'H.JUAL2'  ,'PRICE1'};
               ,{'H.JUAL3'  ,'PRICE2'}}
           cTeks:='Search Description:'
           xGet:=Space(Len(DESC))
           bFIELD:={||DESC}
           SET ORDER TO 2 ;TBLook(aF,{|xD|DBSeek(xD)},'[List Inv]')
           SET ORDER TO 1
      CASE nInkey=K_ESC
           RestScreen(24,0,27,79,cSvScreen)
           SetColor(cCol) ;RETURN
      OTHER ;LOOP
   ENDCASE
   SetColor(cCol)
   EXIT
ENDDO
GetList:={}
RestScreen(24,0,27,79,cSvScreen)
KeyBoard Chr(32) ;SetVar()
RETURN

*===============================================================================
STATIC PROCEDURE SF10AQuit(lAdd)
SET KEY K_ESC TO
IF LastKey()#K_ESC ;RETURN
ENDIF
IF YNQuit()
   lX:=.T. ;CLEAR GETS //keluar dari READ...
   //IF !lAdd
      KeyBoard Chr(27)
   //ENDIF
   SET KEY K_ESC TO
ELSE
   SetKey(K_ESC,{||SF10AQuit(lAdd)})
ENDI
RETURN
*===============================================================================
STATIC PROCEDURE SF4AGroup()
LOCAL nChoice,cSvScreen, cColor:=SetColor()
** cSvScreen:=SaveScreen(5,17,21,66)
IF LastKey()#K_F4 .AND. GROUP->(DBSeek(cGROUP))
   cNGROUP:=LEFT(DESC,22)
   @ 25,20 GET cGROUP
   @ 25,25 SAY '/ '+cNGROUP
   RETURN
ENDIF
SET KEY K_ESC TO
DBSetOrder(2)
aF:={{'NAME'  ,'DESC' };
    ,{'CODE'  ,'CODE' }}
SetColor(ColEdit3)
cSvScreen:=SaveScreen(0,0,27,79)
TBLook(aF,{|xD|DBSeek(xD)},'[Group List]',{12,0,27,45})
DBSetOrder(1)
SetColor(cColor)
RestScreen(0,0,27,79,cSvScreen)
IF LastKey()=K_ENTER
   cGROUP :=CODE
   cNGROUP:=LEFT(DESC,22)
   @ 25,20 GET cGROUP
   @ 25,25 SAY '/ '+cNGROUP
ENDI
SetKey(K_ESC,{||SF10AQuit(.F.)})
SetKey(K_F4,{||GROUP->(SF4AGroup())})
RETURN

*===============================================================================
STATIC PROCEDURE SF5ADept()
LOCAL nChoice,cSvScreen, cColor:=SetColor()
** cSvScreen:=SaveScreen(5,17,21,66)
IF LastKey()#K_F5 .AND. CLASS->(DBSeek(cDEPT))
   cNDEPT:=LEFT(DESC,22)
   @ 24,20 GET cDEPT
   @ 24,25 SAY '/ '+cNDEPT
   RETURN
ENDIF
SET KEY K_ESC TO
DBSetOrder(2)
aF:={{'NAME'  ,'DESC' };
    ,{'CODE'  ,'CODE' }}
SetColor(ColEdit3)
cSvScreen:=SaveScreen(0,0,27,79)
TBLook(aF,{|xD|DBSeek(xD)},'[Dept. List]',{12,0,27,45})
DBSetOrder(1)
SetColor(cColor)
RestScreen(0,0,27,79,cSvScreen)
IF LastKey()=K_ENTER
   cDEPT  :=CODE
   cNDEPT :=LEFT(DESC,22)
   @ 24,20 GET cDEPT
   @ 24,25 SAY '/ '+cNDEPT
ENDI
SetKey(K_ESC,{||SF10AQuit(.F.)})
SetKey(K_F5,{||CLASS->(SF5ADept())})
RETURN

*===============================================================================
STATIC PROCEDURE SF7Stock()
 LOCAL cScr :=SaveScreen(27,00,27,79)
 LOCAL nSTK :=0
 CLEA GETS
 SET KEY K_ESC TO
 SET KEY K_F7  TO
 @ 27,00 CLEA TO 27,79
 @ 27,01 SAY 'Qty Stock Adjusment (+/-) :' GET nSTK PICT '999,999'
 READ
 IF LastKey()#K_ESC //.AND. nStock#0
    nSTOCK+=nSTK
    @ 22,23 SAY nSTOCK PICT '999,999'
 ENDIF
 RestScreen(27,00,27,79,cScr)
 SetKey(K_ESC,{||SF10AQuit(.F.)})
 SetKey(K_F7,{||SF7Stock()})
RETURN
*===============================================================================
STATIC FUNCTION F7PRINT()
 LOCAL cScr :=SaveScreen(27,00,27,79),nTCOST:=nTSELL:=nTSTOCK:=0
 Box(22,46,26,57)
 @ 23,47 PROMPT 'CODE      '
 @ 24,47 PROMPT 'DEPARTMENT'
 @ 25,47 PROMPT 'GROUP     '
 MENU TO nPil1
 IF LastKey()#27
    DO CASE
    CASE nPil1=1 ;DBSetOrder(1)
    CASE nPIL1=2 ;DBSetOrder(2)
    CASE nPil1=3 ;DBSetOrder(3)
    ENDCASE
 ENDIF
 IF nPil1=1
    PRODUK->(DBSetorder(1))
    cPil:="1"
    cCode_1:=SPACE(13)
    cCode_2:=SPACE(13)
    SetCursor(1)
    @ 27,00
    @ 27,00 SAY " Pilihan [1]Layar [2]PrinterRcpt [3]Printer80Col ?                                      " COLOR "N/W"

    @ 27,10 SAY "1"                   COLOR "W+/r"
    @ 27,19 SAY "2"                   COLOR "W+/r"
    @ 27,34 SAY "3"                   COLOR "W+/r"
    @ 27,53 GET cPil Valid cPil$"123" COLOR "w+/B"
    READ
    IF LastKey()=27
       RestScreen(27,00,27,79,cScr);PRODUK->(DBSetOrder(1))
       PRODUK->(DBGOtop())
       RETURN
    ENDIF
    @ 27,0
    @ 27,00 SAY " CODE : 1234567890123 S/D CODE : 1234567890123                                             " COLOR "N/W"
    @ 27,08 GET cCode_1 PICT '@!'
    @ 27,33 GET cCode_2 PICT '@!'
    READ

    aStruct:=PRODUK->(DBSTRUCT())
    DBCREATE(cFlTmp,aStruct)
    PRODUK->(DBCLOSEAREA())

    USE (cFltmp) NEW ALIAS PRODUK
    IF NNetlogged()
       IF EMPTY(cCODE_1)
          APPEND FROM (NDATA+'PRODUK')
       ELSE
          APPEND FROM (NDATA+'PRODUK') FOR CODE>=cCode_1 .AND. CODE<=cCode_2
       ENDIF
    ELSE
       IF EMPTY(cCODE_2)
          APPEND FROM (DDATA+'PRODUK')
       ELSE
          APPEND FROM (DDATA+'PRODUK') FOR CODE>=cCode_1 .AND. CODE<=cCode_2
       ENDIF
    ENDIF
    INDEX ON CODE TO \KASIR\DAT\RP_1
    SET INDEX TO \KASIR\DAT\RP_1
 ENDIF
 //
 IF nPil1=2
    PRODUK->(DBSetorder(2))
    cPil:="1"
    cDept_1:=SPACE(3)
    cDept_2:=SPACE(3)
    SetCursor(1)
    @ 27,00
    @ 27,00 SAY " Pilihan [1]Layar [2]PrinterRcpt [3]Printer80Col ?                                      " COLOR "N/W"

    @ 27,10 SAY "1"                   COLOR "W+/r"
    @ 27,19 SAY "2"                   COLOR "W+/r"
    @ 27,34 SAY "3"                   COLOR "W+/r"
    @ 27,53 GET cPil Valid cPil$"123" COLOR "w+/B"
    READ
    IF LastKey()=27
       RestScreen(27,00,27,79,cScr);PRODUK->(DBSetOrder(1))
       PRODUK->(DBGOtop())
       RETURN
    ENDIF
    @ 27,0
    @ 27,00 SAY " DEPT : 123 S/D DEPT : 123                                             " COLOR "N/W"
    @ 27,08 GET cDept_1 PICT '@!'
    @ 27,23 GET cDept_2 PICT '@!'
    READ

    aStruct:=PRODUK->(DBSTRUCT())
    DBCREATE(cFlTmp,aStruct)
    PRODUK->(DBCLOSEAREA())

    USE (cFltmp) NEW ALIAS PRODUK
    IF NNetlogged()
       IF EMPTY(cDEPT_1)
          APPEND FROM (NDATA+'PRODUK')
       ELSE
          APPEND FROM (NDATA+'PRODUK') FOR DEPT>=cDept_1 .AND. DEPT<=cDept_2
       ENDIF
    ELSE
       IF EMPTY(cDEPT_2)
          APPEND FROM (DDATA+'PRODUK')
       ELSE
          APPEND FROM (DDATA+'PRODUK') FOR DEPT>=cDept_1 .AND. DEPT<=cDept_2
       ENDIF
    ENDIF
    INDEX ON DEPT TO \KASIR\DAT\RP_1
    SET INDEX TO \KASIR\DAT\RP_1
 ENDIF
 //
 IF nPil1=3
    PRODUK->(DBSetorder(3))
    cPil:="1"
    cGroup_1:=SPACE(2)
    cGroup_2:=SPACE(2)
    SetCursor(1)
    @ 27,00
    @ 27,00 SAY " Pilihan [1]Layar [2]PrinterRcpt [3]Printer80Col ?                                      " COLOR "N/W"

    @ 27,10 SAY "1"                   COLOR "W+/r"
    @ 27,19 SAY "2"                   COLOR "W+/r"
    @ 27,34 SAY "3"                   COLOR "W+/r"
    @ 27,53 GET cPil Valid cPil$"123" COLOR "w+/B"
    READ
    IF LastKey()=27
       RestScreen(27,00,27,79,cScr);PRODUK->(DBSetOrder(1))
       PRODUK->(DBGOtop())
       RETURN
    ENDIF
    @ 27,0
    @ 27,00 SAY " GROUP : 12 S/D GROUP : 12                                             " COLOR "N/W"
    @ 27,09 GET cGroup_1 PICT '@!'
    @ 27,24 GET cGroup_2 PICT '@!'
    READ

    aStruct:=PRODUK->(DBSTRUCT())
    DBCREATE(cFlTmp,aStruct)
    PRODUK->(DBCLOSEAREA())

    USE (cFltmp) NEW ALIAS PRODUK
    IF NNetlogged()
       IF EMPTY(cGROUP_1)
          APPEND FROM (NDATA+'PRODUK')
       ELSE
          APPEND FROM (NDATA+'PRODUK') FOR GROUP>=cGroup_1 .AND. GROUP<=cGroup_2
       ENDIF
    ELSE
       IF EMPTY(cGROUP_2)
          APPEND FROM (DDATA+'PRODUK')
       ELSE
          APPEND FROM (DDATA+'PRODUK') FOR GROUP>=cGroup_1 .AND. GROUP<=cGroup_2
       ENDIF
    ENDIF
    INDEX ON GROUP TO \KASIR\DAT\RP_1
    SET INDEX TO \KASIR\DAT\RP_1
 ENDIF
 //
 @ 27,0  SAY "  Proses .......  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
 @ 27,19 SAY "*"                  COLOR "N*/W"


 SET DEVICE TO PRINTER
 IF cPil="1"
    SET PRINTER TO $PTemp.TXT
 ENDIF
 IF cPil='3' .OR. cPil='1'
    @PROW(),00 SAY CHR(15)
    HeadPro2(0)
 ELSE
    HeadPro()
 ENDIF

 PRODUK->(DBGotOp())
 DO WHILE !PRODUK->(EOF())
   @PROW()+1 ,00                 SAY LEFT(CODE,8)
   @PROW()   ,IF(cPIL='2',10,09) SAY LEFT(DESC,22) //ALLTRIM(DESC)

   IF cPil='2'
      @PROW()+1 ,00 SAY TRANS(STOCK,            '99,999')
      @PROW()   ,13 SAY TRANS(CPRICE,       '99,999,999')
      @PROW()   ,30 SAY TRANS(PRICE,        '99,999,999')
      @PROW()+1 ,12 SAY TRANS(STOCK*CPRICE,'999,999,999')
      @PROW()   ,29 SAY TRANS(STOCK*PRICE, '999,999,999')
   ELSE
      @PROW()   ,32 SAY GROUP PICT '@!'
      @PROW()   ,36 SAY DEPT  PICT '@!'
      @PROW()   ,40 SAY TRANS(STOCK,             '99,999')
      @PROW()   ,47 SAY TRANS(CPRICE,        '99,999,999')
      @PROW()   ,58 SAY TRANS(PRICE,         '99,999,999')
      @PROW()   ,72 SAY TRANS(STOCK*CPRICE, '999,999,999')
      @PROW()   ,88 SAY TRANS(STOCK*PRICE,  '999,999,999')
   ENDIF
   nTCOST+=STOCK*CPRICE
   nTSELL+=STOCK*PRICE
   nTSTOCK+=STOCK
   SKIP
   IF PROW()+1>63
      IF cPil='3' .OR. cPil='1'
         @PROW()+1,00 SAY '---------------------------------------------------------------------------------------------------'
         @PROW()+1,00 SAY Chr(12)   //EJECT
         HeadPro2()
      ENDIF
   ENDIF
 ENDDO
 IF cPil='3' .OR. cPil='1'
    @PROW()+1,00 SAY '---------------------------------------------------------------------------------------------------'
    @PROW()+1,00 SAY 'T O T A L'
    @PROW()  ,39 SAY TRANS(nTSTOCK,'999,999')
    @PROW()  ,69 SAY TRANS(nTCOST,'99,999,999,999')
    @PROW()  ,84 SAY TRANS(nTSELL,'999,999,999,999')
    @PROW()+1,00 SAY '---------------------------------------------------------------------------------------------------'
    @PROW()+1,00 SAY CHR(18)
    @PROW()+1,00 SAY Chr(12)   //EJECT
 ELSE
    @PROW()+1,00 SAY REPL('-',40)
    @PROW()+1,00 SAY 'TOTAL H.BELI'
    @PROW()  ,29 SAY TRANS(nTCOST,'999,999,999')
    @PROW()+1,00 SAY 'TOTAL H.JUAL'
    @PROW()  ,29 SAY TRANS(nTSELL,'999,999,999')
    @PROW()+1,00 SAY REPL('-',40)
    PCutter()
 ENDIF
 SET PRINTER TO
 SET DEVI TO SCREEN
 IF cPil="1"   //.OR. cPil="2"
    SAVE SCREEN TO cSCR01
    DISPREPR(1,'$PTEMP.TXT')
    ** LIHATTEKS('$PTEMP.TXT',2,0,26,79,"W/N")
    FILEDELETE('$PTEMP.TXT')
    RESTORE SCREEN FROM cSCR01
 ENDIF
 PRODUK->(DBCLOSEAREA())

 IF NNetLogged() ;lGLan:=.T.
    IF !NetUse({{NDATA+"PRODUK"    ,.t.}})
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
 ELSE
    IF !NetUse({{DDATA+"PRODUK"    ,.t.}})
       BREAK
    ENDIF
    SELECT PRODUK
    IF !File(DDATA+"PRODUK_1.NTX")      ;
       .OR. !File(DDATA+"PRODUK_2.NTX") ;
       .OR. !File(DDATA+"PRODUK_3.NTX")
       INDEX ON CODE          TO (DDATA+"PRODUK_1.NTX")
       INDEX ON Left(DESC,28) TO (DDATA+"PRODUK_2.NTX")
       INDEX ON REF           TO (DDATA+"PRODUK_3.NTX")
    ENDIF
    SET INDEX TO (DDATA+"PRODUK_1.NTX"),(DDATA+"PRODUK_2.NTX"),(DDATA+"PRODUK_3.NTX")
 ENDIF

 nPAGE:=0
 PRODUK->(DBGOtop())
 RestScreen(27,00,27,79,cScr)
RETURN
*-------------------------------------------------------------------------------
Static Function HeadPro()
 SETPRC(0,0)
 @PROW()+1, 00 SAY 'Listing Data Item Barang'
 @PROW()+1, 00 SAY 'Tanggal Cetak : '+DTOC(DATE())
 @PROW()+1, 00 SAY REPLI('-',40)
 @PROW()+1, 00 SAY 'CODE      NAMA BARANG                   '
 @PROW()+1, 00 SAY 'STOCK            H.BELI           H.JUAL'
 @PROW()+1, 00 SAY '             TTL H.BELI       TTL H.JUAL'
 @PROW()+1, 00 SAY REPLI('-',40)
RETURN
*-------------------------------------------------------------------------------
Static Function HeadPro2()
 SETPRC(0,0)
 @PROW()+1, 00 SAY 'Listing Data Item Barang'
 @PROW()+1, 00 SAY 'Tanggal Cetak : '+DTOC(DATE())
 @PROW()  , 89 SAY 'Hal:'+Tran(++nPage,'9,999')
 @PROW()+1, 00 SAY '---------------------------------------------------------------------------------------------------'
 @PROW()+1, 00 SAY 'CODE     DESC                   GR DEP   STOCK     H.BELI     H.JUAL     TTL H.BELI      TTL H.JUAL'
 @PROW()+1, 00 SAY '---------------------------------------------------------------------------------------------------'
 //                                                 99 999 999,999 99,999,999 99,999,999 99,999,999,999  999,999,999,999
 //                 12345678 1234567890123456789012 12 123 1234567
 //                 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
 //                           1         2         3         4         5         6         7         8         9
RETURN
*-------------------------------------------------------------------------------
Static Function HeadPro3()
 SETPRC(0,0)
 @PROW()+1, 00 SAY 'Listing Data Item Barang Per DEPT'
 @PROW()+1, 00 SAY 'Tanggal Cetak : '+DTOC(DATE())
 @PROW()  , 89 SAY 'Hal:'+Tran(++nPage,'9,999')
 @PROW()+1, 00 SAY '---------------------------------------------------------------------------------------------------'
 @PROW()+1, 00 SAY 'CODE     DESC                   GR DEP   STOCK     H.BELI     H.JUAL     TTL H.BELI      TTL H.JUAL'
 @PROW()+1, 00 SAY '---------------------------------------------------------------------------------------------------'
 //                                                 99 999 999,999 99,999,999 99,999,999 99,999,999,999  999,999,999,999
 //                 12345678 1234567890123456789012 12 123 1234567
 //                 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
 //                           1         2         3         4         5         6         7         8         9
RETURN
*-------------------------------------------------------------------------------

