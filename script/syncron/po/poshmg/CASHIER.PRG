#include "hmg.ch"
#include  'inkey.ch'
#include  'kassa.ch'
*------------------------------------------------------------------------------*
PROCEDURE Cashier(lLan)
LOCAL  nK,aD[4],oB,oC,x,b,nD,lD,cM:=''
LOCAL  GETLIST:={}
IF Select('CASHIER')#0
   SELECT  CASHIER
   USE
ENDIF
IF !NetUse({{If(lLan,NDATA,DDATA)+'CASHIER.DBF',.t.}})
   RETURN {}
ENDIF
*--------------------------
SetColor('/bg')
Box(2,24,21,55,'w+/bg')
oB:=TBrowseDB(3,25,19,54)
oB:ColSep:='Ё'
oB:HeadSep:='бд'
oB:AutoLite:=.t.
oB:ColorSpec:='/bg,bg+/'
oB:SkipBlock:={|n|TBSkip(n)}
*------------------------------------------
@ oB:nTop-1,oB:nLeft+1 SAY '[ ]Tabel Cashier' COLOR '/bg'
@ oB:nBottom+1,oB:nLeft SAY '['+Chr(26)+Chr(27)+Chr(24)+Chr(25)+']' COLOR '/bg'
DispOut(' [<ды]-Edit [Del]-Hapus','w+/bg')
oC:=TBColumnNew('Kode',FieldBlock('CODE'))
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Nama',FieldBlock('DESC'))
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Spv',FieldBlock('SPV'))
oC:FootSep:='ад';oB:AddColumn(oC)
*---------------------------------------------
DO While nK#K_ESC
   IF oB:Stabilize()
      IF Eof()
         FOR nD:=1 TO oB:ColCount
             oC:=oB:GetColumn(nD)
             IF oC:Heading='Kode'
                oB:ColPos:=nD
                oB:Stabilize()
                EXIT
             ENDIF
         NEXT
      ENDIF
      TLight(oB,nK)
      oC:=oB:GetColumn(oB:ColPos)
      aD[1]:=aD[3]:=oB:RowPos;aD[2]:=aD[4]:=oB:ColPos
      nK:=InKey(0)
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
   CASE nK=K_DEL .AND. !Eof() .AND. RecLock()
      DELETE ;UnLock;SKIP ;oB:RefreshAll()
   CASE (nK=K_ENTER .OR. (nK>31 .AND. nK<127)) .AND. oC:Heading#'No'
      b:=oC:Block   ;x:=Eval(b)
      @ oB:Cargo[1],oB:Cargo[2] GET x PICT  ;
      If(oC:Heading='Kode','999999','')  COLOR 'gr+/b' VALID If(oC:Heading='Spv',x<'2',.T.)
      KEYBOARD If(nK=K_ENTER,'',Chr(nK));READ
      nD:=RecNo()
      IF oC:Heading='Kode' 
	 IF Empty(x);Warning(' Kode Tidak Boleh Kosong ... ! ');LOOP;ENDIF
	 IF Eof()
	    LOCATE FOR CODE=x
	    IF !Found() .AND. AddRec() ;Eval(b,x)
	       ELSE;Warning(' Kode Sudah Ada ... !')
            ENDIF
	 ELSE
	    LOCATE FOR CODE=x
	    IF Found() .AND. nD=RecNo() .Or. Eof() ;GO nD
	       IF RecLock()
		  Eval(b,x)
	       ENDIF
            ELSE;Warning('Kode sudah ada...')
	    ENDIF
	 ENDIF
      ELSEIF (!Eof() .And. RecLock()) ;
         .OR. (Eof() .And. AddRec())
         Eval(b,x)
      ENDIF
      COMMIT
      UNLOCK
      oB:RefreshAll();x:=0
      DO WHILE !oB:Stabilize();x++
         IF RecNo()=nD;oB:RowPos:=x
         ENDIF
      ENDDO
      KEYBOARD If(nK=K_DOWN .OR. nK=K_UP,Chr(nK),Chr(K_RIGHT))
   ENDCASE
ENDDO
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
