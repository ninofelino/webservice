#include 'box.ch'
#include 'inkey.ch'
#include 'setcurs.ch'
#include 'kassa.ch'

*------------------------------------------------------------------------------
PROCEDURE STOCKCRD(l)
PRIVATE dTGL1:=Date(), dTGL2:=Date()
PRIVATE cTgl1        , cTgl2
SetBlink(.T.)
PRIVATE  ColMenu :='W/N,N/W'      ,ColMenu2:='N+/N,N+/W'
PRIVATE  ColBack1:='W/N'          ,ColBack2:='W/N'
PRIVATE  ColEdit1:='W/N,N/W'      ,ColEdit2:='W/N,N/W'
PRIVATE  ColEdit3:='W/N,N/W'
PRIVATE  ColBox1 :='W/N'          ,ColBox2 :='W/N'
PRIVATE  ColBrig :='W+/N'         ,ColBlink:='W+*'
PRIVATE  ColBar1 :='N/W,W+/N'     ,ColBar2 :='W+/N,N/W'
PRIVATE  ColBar3 :='W/N,N/W'      ,ColTrigger:='W+/N,N/W*'
PRIVATE  ColDigit:='W/N'          ,ColHide :='W/W'

cPath:=IF(NNetLogged(),NDATA,DDATA)
IF Select('PRODUK')#0
   SELECT  PRODUK
   USE
ENDIF
IF !NetUse({{cPath+'PRODUK.DBF',.t.}})             // .f.
   RETURN
ENDIF
IF  !File(cPath+"PRODUK_1.NTX")      ;
    .OR. !File(cPath+"PRODUK_2.NTX") ;
    .OR. !File(cPath+"PRODUK_3.NTX")
    INDEX ON CODE          TO (cPath+"PRODUK_1.NTX")
    INDEX ON Left(DESC,10) TO (cPath+"PRODUK_2.NTX")
    INDEX ON REF           TO (cPath+"PRODUK_3.NTX")
ENDIF
SET INDEX TO (cPath+"PRODUK_1.NTX"),(cPath+"PRODUK_2.NTX"),(cPath+"PRODUK_3.NTX")
IF Select('STCRD')#0
   STCRD->(DBCloseArea())
ENDIF
IF !NetUse({{cPath+'STCRD',.T.}})
   RETURN
ENDIF
SET INDEX TO (cPath+'STCRD__1'), (cPath+'STCRD__2'), (cPath+'STCRD__3')
DBSetOrder(3)
SET RELA TO CODE INTO PRODUK
STCRD->(Proses())
SET RELA TO
STCRD->(DBCloseArea())
PRODUK->(DBSetOrder(1))
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE Proses()
 LOCAL  GETLIST:={}
 NO:=0 ;NO='NO+1'
 aFiel:={'CODE','DATE','PRODUK->DESC','PRODUK->STOCK',;
         'PRODUK->PRICE','PRODUK->DEPT'}

 aHead:={'ITEM CODE','FIRST DATE','DESCRIPTION','STOCK','UNIT PRICE',;
         'DEP'}
 OldColor:=SetColor()
 Screen()
 DBEDIT(2,1,22,78,aFiel,'InvProc',,aHead)
 SetColor(OldColor)
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE Screen()
Box(01,00,23,79,,2)
CenterIn('     STOCK PRODUK TABLE      ',0,0,79,ColBar2)
@ 24,0 SAY SPACE(79)
@ 24,0 SAY 'ÛF3-SearchÛF4-Stock CardÛESC-Quit' COLOR '/w'
RETURN

*------------------------------------------------------------------------------
FUNCTION InvProc(nMode,nFld)
LOCAL  nInKey, cScr, nRec, nRetVal:=1, nRow:=Row(), nCol:=Col()
 IF Deleted() ;@ 01,73 SAY 'DELETE' COLOR 'w+'      //;KeyBoard Chr(32)
 ELSE         ;@ 01,73 SAY 'ÍÍÍÍÍÍ' COLOR ColEdit1  //;KeyBoard Chr(32)
 ENDIF
 cField:=aFiel[nFld]
 SAVE SCREEN TO cScr
 SetCursor(SC_NONE)
 nInKey:=LastKey()
   SetCursor(SC_NORMAL)
   DO CASE
   CASE nInKey=K_F3   ;F3Search()                   //Search..
   CASE nInKey=K_F4   ;STCRD->(StockTbl())          //Add.....
// CASE nInKey=K_F7   ;F7SortBy()                   //Change Data Sort
//                     KeyBoard Chr(32) ;nRetVal:=2
   CASE nInKey=K_ESC  ;nRetVal:=0                   //Quit......
   ENDCASE
REST SCREEN FROM cScr
SetCursor(SC_NONE)
DBSetOrder(3)
lExit:=.F.
RETURN nRetVal

*------------------------------------------------------------------------------
STATIC PROCEDURE STOCKTBL()
GetList:={} ;DBSetOrder(1)
dTGL1:=DATE
Box(20,11,22,50)
@ 21,13 SAY 'Date:' GET dTGL1
@ 21,30 SAY 'To'    GET dTGL2
READ
IF LastKey()=27 .OR. Empty(dTGL1) .OR. Empty(dTgl2)
   RETURN .F.
ENDIF
cCODE:=CODE
PRODUK->(DBSeek(cCODE))
CLASS->(DBSeek(PRODUK->DEPT))
SET RELA TO
CreaTmp()
cTgl1:=DToC(dTGL1) ;cTgl2:=DToC(dTGL2)
Show()             ;Browser()
SELECT STCRD       ;DBSetOrder(3)
DBSeek(CODE)
SET RELA TO CODE INTO PRODUK
CARDTMP->(DBCloseArea())
RETURN .T.

*------------------------------------------------------------------------------
STATIC PROCEDURE Show()
@01,00 CLEAR TO 24,79
@ 24,0 SAY Space(80)
@ 01,07 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 02,07 SAY '³                                                                  ³'
@ 03,07 SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 04,07 SAY '³        Item :                                                    ³'
@ 05,07 SAY '³  Sales Price:                                                    ³'
@ 06,07 SAY '³  Dept.þGroup:                                                    ³'
@ 07,07 SAY '³         Date:                                                    ³'
@ 08,07 SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 09,07 SAY '³   DATE     ³ MARK ³ FROM/TO  ³     QTY ³ BALANCE ³  RETAIL VALUE ³'
@ 10,07 SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 11,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 12,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 13,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 14,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 15,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 16,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 17,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 18,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 19,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 20,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 21,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 22,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 23,07 SAY '³            ³      ³          ³         ³         ³               ³'
@ 24,07 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
Centerin('WAREHOUSE STOCK CARD - '+SATELITE->(Left(DESC,30)),02,08,72,'W+/N')
@ 04,08 SAY '        Item : '
@ 04,23 SAY PRODUK->(AllTrim(CODE))+'þ'+PRODUK->DESC                 COLOR 'W+/N'
@ 05,08 SAY '  Sales Price: '
@ 05,23 SAY PRODUK->('Rp. '+AllTrim(Trans(PRICE,'99,999,999')))      COLOR 'W+/N'
@ 06,08 SAY '  Dept.þGroup: '
@ 06,23 SAY CLASS->(AllTrim(Left(DESC,20)))+'þ'+PRODUK->GROUP        COLOR 'W+/N'
@ 07,08 SAY '         Date: '
@ 07,23 SAY cTgl1+' To '+cTgl2                                       COLOR 'W+/N'
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE Browser()
LOCAL cScr:=SaveScreen(0,00,24,79)
DBGoTop()
aFiel2:={'DATE','FLAG','STORE','QTY','SALDO','SALDO*SELLPRC'}
aHead2:={'DATE','FLAG','KET','QTY','SALDO','RETAIL VALUE'  }
aPict2:={'@D','@!','@!','999,999','999,999','999,999,999'}
DBedit(11,08,23,72,aFIEL2,'BrowseStk',aPict2,'','')  //,'      ')
RestScreen(0,00,24,79,cScr)
KeyBoard Chr(32)
RETURN

*===============================================================================
FUNCTION BrowseStk(mode,pointer)
LOCAL nInkey
IF LastKey()=27 //.OR. LastKey()=K_ENTER
   RETURN 0
ENDI
//³   DATE    ³ MARK      ³     QTY ³ BALANCE ³ RETAIL VALUE ³'
//ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
//³  11/11/11 ³ OUT->001  ³         ³         ³              ³'
//90123456789012345678901234567890123456789012345678901234567890
// 1         2         3         4         5         6         7

//@ Row(),10 SAY '  '+DToC(DATE)+'  '                                     COLOR 'N/W'
//@ Row(),21 SAY '³'                                                      COLOR 'N/W'
//@ Row(),22 SAY ' '+Trans(FLAG,'@!')+IF(FLAG='OUT','->'+STORE+' ','      ')    COLOR 'N/W'
//@ Row(),33 SAY '³'                                                      COLOR 'N/W'
//@ Row(),34 SAY ' '+Trans(QTY,'999,999')+'  '                        COLOR 'N/W'
//@ Row(),43 SAY '³'                                                      COLOR 'N/W'
//@ Row(),44 SAY ' '+Trans(SALDO,'999,999')+' '                        COLOR 'N/W'
//@ Row(),53 SAY '³'                                                      COLOR 'N/W'
//@ Row(),54 SAY ' '+Trans(SALDO*SELLPRC,'999,999,999')+'  '           COLOR 'N/W'
//nInkey:=Inkey(0)
//Keyboard Chr(nInkey)
//@ Row(),10 SAY ' '
//Keyboard Chr(32)
RETURN 1

*===============================================================================
STATIC PROCEDURE F7SortBy()
 LOCAL nSort, cFirst:=Space(28)
 Box(17,46,23,61)
 @ 18,47 PROMPT ' ITEM CODE    '
 @ 19,47 PROMPT ' DESCRIPTION  '
 @ 20,47 PROMPT ' SUPPLIER     '
 @ 21,47 PROMPT ' DEPARTMENT   '
 @ 22,47 PROMPT ' GROUP        '
 MENU TO nSort
 IF LastKey()#27
    DO CASE
    CASE nSort=1 ;DBSetOrder(1)
    CASE nSort=2 ;DBSetOrder(2)
    CASE nSort=3 ;DBSetOrder(3)
    CASE nSort=4 ;DBSetOrder(4)
    CASE nSort=5 ;DBSetOrder(5)
    ENDCASE
    Box(15,30,17,78)
    @ 16,33 SAY 'First Pointer :' GET cFirst PICT '@!'  ;READ
    cFirst:=AllTrim(cFirst)
    IF !Empty(cFirst) ;DBSeek(cFirst)
    ELSE              ;DBGoTop()
    ENDIF
 ELSE
    KeyBoard Chr(32)
 ENDIF
RETURN

*===============================================================================
STATIC PROCEDURE F3Search()
LOCAL  GetList:={}, cSearch:=Space(Len(CODE)), cCol:=SetColor()
Box(20,01,22,31)
@ 21,03 SAY 'Search Code:' GET cSearch PICT '9999999999999'
READ
IF LastKey()=K_ESC ;RETURN ;ENDIF
IF !DBSeek(cSearch)
   ErrMsg(' That Code does not exist in DataBase...','')
ENDIF
RETURN

*===============================================================================
STATIC PROCEDURE SF10AQuit(lAdd)
IF YNQuit() ;lExit:=.T. ;CLEAR GETS //keluar dari READ...
ENDI
RETURN

*===============================================================================
STATIC PROCEDURE CreaTmp()
LOCAL aStruct:=DBStruct(), dTgl:=DATE
DBCreate('DAT\CRDTMP',aStruct)
USE ('DAT\CRDTMP') ALIAS CARDTMP NEW
INDEX ON CODE+DToS(DATE) TO ('DAT\CRDTMP')
DO WHILE STCRD->DATE>=dTGL1 .AND. STCRD->DATE<=dTGL2 .AND. STCRD->CODE=PRODUK->CODE
   AddRec()
   FIELD->DATE   :=STCRD->DATE
   FIELD->FLAG   :=STCRD->FLAG
   FIELD->STORE  :=STCRD->STORE
   FIELD->QTY    :=STCRD->QTY
   FIELD->SALDO  :=STCRD->SALDO
   FIELD->SELLPRC:=PRODUK->PRICE
   STCRD->(DBSkip())
ENDDO
RETURN

*===============================================================================
STATIC PROCEDURE ErrMsg(cMsg1,cMsg2)
LOCAL nL1,nL2,nL3,cMsg3,aBox,nP
LOCAL aCol:={'B/W,W/N','W','N/W'}
//CAL aCol:=IF(SYSTEM->COLOR='COLOR',{'W+/R,N/W','R','GR+/R'},{'B/W,W/N','W','N/W'})
cMsg3:=' OK ' ;Tone(3000,5)
cMsg2:=IF(cMsg2=NIL,' ',cMsg2)
nL1  := Len(cMsg1)    ;nL2 := Len(cMsg2)
nL3  := Len(cMsg3)    ;nP  := nL2
IF nL1>nL2 ;nP := nL1 ;ENDIF
IF nL3>nP  ;nP := nL3 ;ENDIF
nL   := (80-nP+5)/2-6 ;nR  := nL+nP+6
nT   := IF(Empty(cMsg2),5,6)
//nPos := (nR-nL-6)/2+1
nPos := (80-6)/2-1
aBox:=BoxOpen(24-nT,nL,24,nR,aCol[2],0.2)
Centerin(cMsg1,24-nT+1,nL-3,nR,aCol[1])
IF !Empty(cMsg2)
   Centerin(cMsg2,24-nT+2,nL-3,nR,aCol[1])
   aBox1:=BoxOpen(24-nT+3,nPos,24-nT+5,nPos+5,aCol[2],0.3)
   Centerin(cMsg3,24-nT+4,nL-3,nR,aCol[3])
ELSE
   aBox1:=BoxOpen(24-nT+2,nPos,24-nT+4,nPos+5,aCol[2],0.3)
   Centerin(cMsg3,24-nT+3,nL-3,nR,aCol[3])
ENDIF
Inkey(0)
BoxPush(aBox1) ;BoxClose(aBox)
RETURN
*===============================================================================
STATIC FUNCTION YNQuit()
LOCAL  nTop:=9, nLeft:=24
LOCAL  nYN:=1, lYN:=.F., GetList:={}
LOCAL  cSvScreen, cOldCol:=SetColor(), aBox, aBox1, aBox2
LOCAL aColor:={'B/W,BG+/W','W','B/W'}
//CAL aColor:=IF(SYSTEM->COLOR='COLOR',{'W/R,GR+/R','R','W+/R'},{'B/W,BG+/W','W','B/W'})

cSvScreen:=SaveScreen(0,0,24,79)
aBox:=BoxOpen(nTop,nLeft,nTop+06,nLeft+38,aColor[2],0.2)
aBox1:=BoxOpen(nTop+3,nLeft+07,nTop+05,nLeft+13,aColor[2],0.3)
aBox2:=BoxOpen(nTop+3,nLeft+25,nTop+05,nLeft+31,aColor[2],0.3)
SetColor(aColor[3])
@ nTop+00,nLeft+2 SAY 'CANCEL REQUEST'
@ nTop+02,nLeft+1 SAY ' Cancel this editing session [Y/N] ? '
SetColor(aColor[1])
DO WHILE .T.
   @ nTop+04,nLeft+08 PROMPT ' Yes '
   @ nTop+04,nLeft+26 PROMPT ' N o '
   MENU TO nYN
   IF nYN=1     ;BoxPush(aBox1) ;lYN:=.T. ;EXIT
   ELSEIF nYN=2 ;BoxPush(aBox2) ;lYN:=.F. ;EXIT
   ENDIF
ENDDO
KEYBOARD ' ';InKey(0) //;KEYBOARD Chr(32)
BoxClose(aBox)
RestScreen(0,0,24,79,cSvScreen)
SetColor(cOldCol)
RETURN lYN


*===============================================================================

