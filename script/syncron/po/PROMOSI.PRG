#include  'inkey.ch'
#include  'kassa.ch'
*------------------------------------------------------------------------------*
PROCEDURE Promosi(lNet)
LOCAL  nK,aD[4],oB,oC,nX,b,nD,lD,cM:=''
LOCAL  cD1,cD2,c1,c2,GETLIST:={}
IF Select('PROMOSI')#0
   SELECT  PROMOSI
   USE
ENDIF
IF !NetUse({{IF(lNet,NDATA,DDATA)+'PROMOSI.DBF',.f.}})
   RETURN {}
ENDIF
*--------------------------
@ 1,1 SAY ' File ' COLOR 'w/n'
@ 2,0,20,79 BOX Space(9) COLOR '/bg'
oB:=TBrowseDB(3,0,19,79)
oB:ColSep:='Ё'
oB:HeadSep:='бд'
oB:AutoLite:=.t.
oB:ColorSpec:='/bg,bg+/'
oB:SkipBlock:={|n|TBSkip(n)}
*------------------------------------------
@ oB:nTop-1,oB:nLeft+1 SAY '[ ]Tabel Customer Disp' COLOR '/bg'
@ oB:nBottom+1,oB:nLeft+1 SAY '['+Chr(26)+Chr(27)+Chr(24)+Chr(25)+']' COLOR '/bg'
DispOut(' [<ды]-Edit','w+/bg') &&[Del]-Delete
oC:=TBColumnNew('No',{||If(Eof(),'EO',Str(RecNo(),2))})
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Line 1',FieldBlock('LINE1'))
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Line 2',FieldBlock('LINE2'))
oC:FootSep:='ад';oB:AddColumn(oC)
*---------------------------------------------
// Com_Open(3)  ;Com_Init(3,09600,'O',8,1)
DO While nK#K_ESC
   IF oB:Stabilize();TLight(oB,nK)
      oC:=oB:GetColumn(oB:ColPos)
      aD[1]:=aD[3]:=oB:RowPos;aD[2]:=aD[4]:=oB:ColPos
      oB:ColorRect(aD,{If(oC:Heading='No',5,If(Eof(),3,2)),1})
      cD1:=LINE1
      cD2:=LINE2
      DO WHILE (nK:=Inkey(.1))=0
         cD1:=SubS(cD1,2)+Left(cD1,1) 
         cD2:=Right(cD2,1)+Left(cD2,Len(cD2)-1)
         c1:=Left(cD1,20) ;c2:=Left(cD2,20)
         //Com_Send(3,Chr(27)+'[1;1H'+c1) &&__________________________Line_1
         //Com_Send(3,Chr(27)+'[2;1H'+c2) &&__________________________Line_2
      ENDDO
      oB:RefreshCurrent()
      oB:Stabilize()
   ELSEIF (nK:=InKey())=0;LOOP
   ENDIF
   cM:=Muter(cM)
   @ oB:nTop-1,oB:nLeft+2 SAY cM COLOR '/bg'
   If (b:=SetKey(nK))<>NIL                          // check for SET KEY first
      Eval(b,ProcName(),ProcLine(),ReadVar())
      LOOP
   End
   DO CASE
   CASE TKey(oB,nK)
   CASE nK=K_F12;oB:GoBottom()
*  CASE nK=K_DEL .AND. !Eof() .AND. RecLock()
*     DELETE ;UnLock ;SKIP ;oB:RefreshAll()
   CASE (nK=K_ENTER .OR. (nK>31 .AND. nK<127)) .AND. oC:Heading#'No'
      b:=oC:Block   ;x:=Eval(b)
      @ oB:Cargo[1],oB:Cargo[2] GET x PICT '@!' COLOR 'gr+/b'
      KEYBOARD If(nK=K_ENTER,'',Chr(nK))
      READ
      nK:=LastKey()
      IF (Eof() .AND. !Empty(x) .And. AddRec()) .OR. (!Eof() .AND. RecLock())
         Eval(b,x);COMMIT;UNLOCK
      ENDIF
      oB:RefreshCurrent()
      KEYBOARD If(nK=K_DOWN .OR. nK=K_UP,Chr(nK),Chr(K_RIGHT))
   ENDCASE
ENDDO
//Com_Close(3)
USE
RETURN
*-----------------------------------------------------------------------------
Static Function TBSkip(n)
LOCAL  nX:=0,;
       lX:=!Eof(),;
       nC:=If(n>0,1,-1)
DO WHILE n#nX ;SKIP nC
   DO CASE
   CASE Eof()
      IF lX
         nX++
      ENDIF
      EXIT
   CASE Bof()
      GO TOP
      EXIT
   ENDCASE
   nX+=nC
ENDDO
RETURN nX

