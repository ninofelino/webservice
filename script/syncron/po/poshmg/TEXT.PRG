#include "hmg.ch"
#include "inkey.ch"
#include "fileio.ch"
#define  LF Chr(13)+Chr(10)

*------------------------------------------------------------------------------------------------
FUNCTION LIHATTEKS(cFile,nT,nL,nB,nR,cC)
   LOCAL      cOld   :=SetColor()
   LOCAL      cS
   LOCAL      nK     :=0
   LOCAL      nOldCur:=SetCursor()
   PRIVATE    Width
   PRIVATE    Top
   PRIVATE    Left
   PRIVATE    Bottom
   PRIVATE    Right
   PRIVATE    Dummy
   PRIVATE    Handle
   PRIVATE    Cargo
   PRIVATE    Pos
   PRIVATE    Col
   
   SetColor('W/N,N/W')
   SetCursor(0)
   nT := IF(nT=NIL,0,nT)
   nL := IF(nL=NIL,0,nL)
   nB := IF(nB=NIL,MaxRow(),nB)
   nR := IF(nR=NIL,MaxCol(),nR)
   cC := IF(cC=NIL,'W/N,N/W',SetColor(cC))
   Handle:=FOpen(cFile)
   Init(nT+1,nL+1,nB-1,nR-1,Handle)
   cS:=SaveScreen(0,0,24,79)
   SetColor('W+')
   @nT,nL TO nB,nR //DOUBLE
   SetColor(cC)
   VAll()
   nK:=Inkey()
   DO WHILE nK#27
     ColorSelect(1);VLine()
     ColorSelect(0);nK:=inkey(0)
     VLine()
     DO CASE
     CASE nK=K_BS         ; VBS()
     CASE nK=K_UP         ; VUp()
     CASE nK=K_DOWN       ; VDown()
     CASE nK=K_PGUP       ; VPgUp()
     CASE nK=K_PGDN       ; VPgDn()
     CASE nK=K_LEFT       ; VLeft()
     CASE nK=K_RIGHT      ; VRight()
     CASE nK=K_HOME       ; VHome()
     CASE nK=K_END        ; VEnd()
     CASE nK=K_CTRL_LEFT  ; VBigLeft()
     CASE nK=K_CTRL_RIGHT ; VBigRight()
     ENDCASE
   ENDDO
   IF !FClose(Handle)
      Warning(' Error closing file '+cFILE+' ')
   ENDIF
   SetCursor(nOldCur)
   SetColor(cOld)
   RestScreen(0,0,24,79,cS)
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION Init(nT,nL,nB,nR,nH)
Col   :=1
Pos   :=nT
Top   :=nT
Left  :=nL
Bottom:=nB
Right :=nR
Handle:=nH
Width :=Right-Left+1
Dummy :=Space(Width)
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VHome()
   FSeek(Handle,0)
   Pos:=Top;VAll()
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VEnd()
   FSeek(Handle,0,FS_END)
   Pos:=Bottom;VAll()
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VLeft()
   IF Col>1
	 // Col--
      VAll()
   ENDIF
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VRight()
   //Col++
   VAll()
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VBigLeft()
   IF Col>20
      Col-=20
      VAll()
   ELSE
      Col:=1
      VAll()
   ENDIF
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VBigRight()
   Col+=20
   VAll()
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VUp()
   IF FSkipUp(Handle)
      IF Pos>Top
         Pos--;ELSE
         Scroll(Top,Left,Bottom,Right,-1)
      ENDIF
   ENDIF
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VDown()
   IF FSkipDown(Handle)
      IF Pos<Bottom
         Pos++;ELSE
         Scroll(Top,Left,Bottom,Right,01)
      ENDIF
   ENDIF
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VPgUp()
   FOR nI:= Top TO  Bottom-1
       FSkipUp( Handle)
   NEXT
    Pos:= Top
    VAll()
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VPgDn()
   FOR nI:= Top TO  Bottom-1
       FSkipDown( Handle)
   NEXT
    Pos:= Bottom
    VAll()
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VBS()
    Col:=1
    VAll()
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VAll()
PRIVATE nCrnt:=FSEEK( Handle,0,FS_RELATIVE)
PRIVATE nI,cW:=Space( Width),nP:= Pos
FOR nI:= Top TO  Pos -1
    FSkipUp( Handle)
NEXT
FOR nI:= Top TO  Bottom-1
     Pos:=nI; VLine()
    FSkipDown( Handle)
NEXT
 Pos:=nI; VLine(); Pos:=nP
FSEEK( Handle,nCrnt)
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION VLine()
   PRIVATE cD:=SubS(FGet( Handle), Col, Width)
   SetPos( Pos, Left) ;??Left(cD+ Dummy, Width)
RETURN

*----------------------------------------------------------------------------
STATIC FUNCTION FGet(nH)
PRIVATE cBfr:=Space(1024),nP
PRIVATE nC:=FSEEK(nH,0,FS_RELATIVE)
FREAD(nH,@cBfr,1024);FSEEK(nH,nC)
IF (nP:=AT(LF,cBfr))=0
   RETURN cBfr   ;ELSE
   RETURN Left(cBfr,nP-1)
ENDIF

*----------------------------------------------------------------------------
FUNCTION FSkipDown(nH)
PRIVATE cBfr:=Space(1024),nP
PRIVATE nC:=FSEEK(nH,0,FS_RELATIVE)
FREAD(nH,@cBfr,1024)
IF (nP:=AT(LF,cBfr))#0
   FSEEK(nH,nC+nP+1)
ENDIF
RETURN !Empty(cBfr)

*----------------------------------------------------------------------------
FUNCTION FSkipUp(nH)
PRIVATE cBfr:=Space(1024),nP,nT
PRIVATE nC:=FSEEK(nH,0,FS_RELATIVE)
IF nC>1024  ;nT:=1024
   nC:=FSEEK(nH,-1024,FS_RELATIVE)
   ELSE     ;nT:=nC
   nC:=FSEEK(nH,0)
ENDIF
FREAD(nH,@cBfr,nT)
IF (nP:=RAT(LF,Left(cBfr,nT-1)))#0
   FSEEK(nH,nC+nP+1);ELSE
   FSEEK(nH,0)
ENDIF
RETURN !Empty(cBfr)


