#include "hmg.ch"
#include 'set.ch'
#include 'inkey.ch'
#include "Getexit.ch"
#include "Kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION LKPName(c,n,a)
LOCAL nA:=Select('PRODUK')
LOCAL nO:=Select()
SELECT (nA)
SET ORDER TO 2
GO TOP
LKPFunc(@c,@n,@a)
SET ORDER TO 1
SELECT (nO)
RETURN .T.

*-----------------------------------------------------------------------------
FUNCTION LKPCode(c,n,a)
LOCAL nA:=Select('PRODUK')
LOCAL nO:=Select()
SELECT (nA)
SET ORDER TO 1
GO TOP
LKPFunc(@c,@n,@a)
SET ORDER TO 1
SELECT (nO)
RETURN .T.

*-----------------------------------------------------------------------------
FUNCTION LKPFunc(c,n,a)
LOCAL cS:=SaveScreen(0,0,27,79),nX,nK:=0,cM:=''
LOCAL cO:=SetColor(),GETLIST:={},cGet:=Space(22)
@ 3,02,24,77 BOX Space(9) COLOR '/bg'
oB:=TBrowseDB(4,03,23,76)
oB:ColSep:='Ё'
oB:HeadSep:='бд'
oB:AutoLite:=.f.
oB:ColorSpec:='/bg,bg+/,w+/r'
*------------------------------------------
@ oB:nTop-1,oB:nLeft+1 SAY '[ ]Tabel Item Barang ' COLOR '/bg'
@ oB:nBottom+1,oB:nLeft SAY '['+Chr(26)+Chr(27)+Chr(24)+Chr(25)+'BkSpace]' COLOR '/bg'
DispOut('[PLU]-Select[SGNON]-Batal','/bg')

DispOut(' Search :','w+/bg');DispOut('_','w*+/bg')
@  row(),col() Get cGet Pict '@!' COLOR '/bg'
GETLIST[1]:SetFocus()

oC:=TBColumnNew('Kode',FieldBlock('CODE'))
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Deskripsi',FieldBlock('DESC'))
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Stock',FieldBlock('STOCK'))
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Unit',FieldBlock('UNIT'))    //GUN
oC:FootSep:='ад';oB:AddColumn(oC)              //GUN
oC:=TBColumnNew('H.Jual1',{|c|If(c=NIL,Trans(PRICE,'9,999,999'),FIELD->PRICE:=c)})
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('H.Jual2',{|c|If(c=NIL,Trans(PRICE1,'9,999,999'),FIELD->PRICE1:=c)})
oC:FootSep:='ад';oB:AddColumn(oC)
*------------------------------------------
DO While .T.
   IF !oB:Stabilize()
      LOOP
   ENDIF
   TLight(oB,nK)
   oB:RefreshCurrent()
   nK:=InKey(0);cM:=Muter(cM)
   @ oB:nTop-1,oB:nLeft+2 SAY cM COLOR '/bg'

   If (b:=SetKey(nK))<>NIL                          // check for SET KEY first
      Eval(b,ProcName(),ProcLine(),ReadVar())
      LOOP
   End

   nX:=Select()
   SELECT TOMBOL
   LOCATE FOR ASCII=nK
   SELECT (nX)

   DO CASE
   CASE TOMBOL->ASSIGN=_PLU   ;c:=CODE
        RestScreen(0,0,27,79,cS)
	PLUFunc(@c,@n,@a)
	EXIT
   CASE TOMBOL->ASSIGN=_SGNON
        RestScreen(0,0,27,79,cS)
	EXIT
   CASE TOMBOL->ASSIGN=_UP    ;oB:Up()
   CASE TOMBOL->ASSIGN=_DOWN  ;oB:Down()
   CASE TOMBOL->ASSIGN=_RIGHT ;GetList[1]:Right()
   CASE TOMBOL->ASSIGN=_LEFT  ;GetList[1]:Left()
   CASE TOMBOL->ASSIGN=_B_SPC
	If(GetList[1]:TypeOut,GetList[1]:delete(),GetList[1]:backSpace())
	GetList[1]:Assign()
	SEEK Rtrim(cGet)
	oB:RefreshAll()
   CASE (nK>=32 .AND. nK<=255);cChr:=Chr(nK)
	IF Set( _SET_INSERT )
	   GetList[1]:insert( cChr )
	ELSE
	   GetList[1]:overstrike( cChr )
	ENDIF
	GetList[1]:Assign()
	IF GetList[1]:typeOut
	   IF Set( _SET_BELL )
	      ??Chr(7)
	   ENDIF
	ENDIF
	SEEK Rtrim(cGet)
	oB:RefreshAll()
   ENDCASE
ENDDO
RETURN .T.


