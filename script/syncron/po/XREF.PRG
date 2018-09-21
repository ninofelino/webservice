#include  'inkey.ch'
#include  'kassa.ch'
PROCEDURE XRef()
LOCAL  nK,aD[4],oB,oC,x,b,nD,lD,cPath,cM:=''
LOCAL  GETLIST:={}
cPath:=If(cStPRG='BAKERY',DDATA,NDATA)
IF Select('XREF')#0
   SELECT  XREF
   USE
ENDIF
IF !NetUse({{cPath+'XREF.DBF',.t.}})             // .f.
   RETURN
ENDIF
IF  !File(cPath+"XREF.NTX")
    INDEX ON XREF          TO (cPath+"XREF.NTX")
ENDIF
SET INDEX TO (cPath+"XREF.NTX")
*--------------------------------------------------------------------------------
@ 3,19,20,62 BOX Space(9) COLOR '/bg'
oB:=TBrowseDB(4,20,19,61)
oB:ColSep:='Ё'
oB:HeadSep:='ям'
oB:AutoLite:=.t.
oB:ColorSpec:='/bg,bg+/'
oB:SkipBlock:={|n|TBSkip(n)}
*------------------------------------------
@ oB:nTop-1,oB:nLeft+1 SAY '[ ]Tabel X-Reference ' COLOR '/bg'
@ oB:nBottom+1,oB:nLeft SAY '['+Chr(26)+Chr(27)+Chr(24)+Chr(25)+']' COLOR '/bg'
DispOut(' [<ды]-Rubah [Del]-Hapus [F3] Search','w+/bg')
oC:=TBColumnNew('Ref',FieldBlock('XREF'))
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('SKUCode',FieldBlock('SKUC'))
oC:FootSep:='ад';oB:AddColumn(oC)
*------------------------------------------
DO While nK#K_ESC
   IF oB:Stabilize()
      IF Eof()
         FOR nD:=1 TO oB:ColCount
             oC:=oB:GetColumn(nD)
             IF oC:Heading='Ref'
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
   CASE nK=K_F1;oB:GoTop()
   CASE nK=K_F12;oB:GoBottom();KEYBOARD Chr(24)
   CASE nK=K_DEL .AND. !Eof() .AND. RecLock()
      DELETE ;UnLock;SKIP ;oB:RefreshAll()
   CASE nK=K_F3
      nK:=oB:nBottom+1
      x:=Space((oB:nRight-oB:nLeft)-10)
      cD:=SaveScreen(nK,oB:nLeft,nK,oB:nRight)
      @ nK,oB:nLeft SAY ' Search : ' GET x Pict '@9'
      Read
      nD:=RecNo()
      x:=AllTrim(x)
      IF DBSeek(x)
	 oB:RefreshAll()
	 ELSE;GO nD
      ENDIF
      RestScreen(nK,oB:nLeft,nK,oB:nRight,cD)
   CASE (nK=K_ENTER .OR. (nK>31 .AND. nK<127)) .AND. oC:Heading#'No'
//    IF Len(AllTrim(CODE))>4;Warning(' Kode Tidak Boleh di Rubah ... !')
//       LOOP
//    ENDIF
      b:=oC:Block   ;x:=Eval(b);x:=If(oC:Heading='Harga',Val(StrTran(x,',','')),x)
      @ oB:Cargo[1],oB:Cargo[2] GET x PICT  ;
      If(Valtype(x)='N','999,999,999',If(oC:Heading='Ref','9999999999999','')) COLOR 'gr+/b'
      KEYBOARD If(nK=K_ENTER,'',Chr(nK));READ
      nD:=RecNo()
      IF oC:Heading='Kode' &&___.OR. oC:Heading='Ref'
         IF Empty(x);Warning(oC:Heading+' Tidak Boleh Kosong ... !')
	    LOOP
         ENDIF
         //IF oC:Heading='Ref'
         //   SET ORDER TO 3
            IF Eof()
               IF !DBSeek(x) ;Eval(b,x)
               ELSE;Warning(' Kode Sudah Ada ... ! ')
               ENDIF
            ELSE
               IF DBSeek(x) .AND. nD=RecNo() .Or. Eof() ;GO nD
                  IF RecLock()
                     Eval(b,x)
                  ENDIF
               ELSE;Warning(' Kode Sudah Ada ... ! ')
               ENDIF
            ENDIF
            SET ORDER TO 1
         //ELSE
         //   IF Eof()
         //      IF !DBSeek(x) .AND. AddRec() ;Eval(b,x)
         //      ELSE;Warning(' Kode Sudah Ada ... ! ')
         //      ENDIF
         //   ELSE
         //      IF DBSeek(x) .AND. nD=RecNo() .Or. Eof() ;GO nD
         //         IF RecLock()
         //            Eval(b,x)
         //         ENDIF
         //      ELSE;Warning(' Kode Sudah Ada ... ! ')
         //      ENDIF
         //   ENDIF
         //ENDIF
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


