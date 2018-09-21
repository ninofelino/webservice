#include "hmg.ch"
#include  'inkey.ch'                                        &&___SettingGroup
#include  'kassa.ch'
PROCEDURE Group(l)
*------------------------------------------------------------------------------*
LOCAL  nK,aD[4],oB,oC,x,b,nD,lD,cM:=''
LOCAL  GETLIST:={},cP
LOCAL  cFltmp:=DDATA+'RANGG.DBF',cSCR01
PRIVATE nPage:=0
IF Select('GROUP')#0
   SELECT  GROUP
   USE
ENDIF
cP:=If(l .AND. lGLan,NDATA,DDATA)
IF !NetUse({{cP+'GROUP.DBF',.t.}})
   RETURN {}
ENDIF
IF  !File(cP+"GROUP__1.NTX")
    INDEX ON CODE          TO (cP+"GROUP__1.NTX")
ENDIF
SET INDEX TO (cP+"GROUP__1.NTX")
*-----------------------------------------------------------------------------
//@ 3,04,20,75 BOX Space(9) COLOR '/bg'
SetColor('/bg')
Box(2,9,21,70,'w+/bg')
oB:=TBrowseDB(3,10,19,69)
oB:ColSep:='³'
oB:HeadSep:='ÂÄ'
oB:AutoLite:=.t.
oB:ColorSpec:='/bg,bg+/'
oB:SkipBlock:={|n|TBSkip(n)}
*------------------------------------------
@ oB:nTop-1,oB:nLeft+1 SAY '[ ]Tabel Group ' COLOR '/bg'
@ oB:nBottom+1,oB:nLeft SAY '['+Chr(26)+Chr(27)+Chr(24)+Chr(25)+']' COLOR '/bg'
DispOut(' [<ÄÙ]-Edit [Del]-Hapus [F6]-Print','w+/bg')
oC:=TBColumnNew('Kode',FieldBlock('CODE'))
oC:FootSep:='ÁÄ';oB:AddColumn(oC)
oC:=TBColumnNew('Deskripsi',FieldBlock('DESC'))
oC:FootSep:='ÁÄ';oB:AddColumn(oC)
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
     oB:Stabilize()
     IF nK=K_LEFT .AND. oC:Heading='Type'
        oB:Left()
     ELSEIF nK=K_RIGHT .AND. oC:Heading='Type'
        oB:Right()
     ENDIF
   CASE nK=K_F1;oB:GoTop()
   CASE nK=K_F12;oB:GoBottom();KEYBOARD Chr(24)
   CASE nK=K_DEL .AND. !Eof() .AND. RecLock()
      DELETE ;UnLock;SKIP ;oB:RefreshAll()
   CASE nK=K_F6
        GROUP->(DBSetorder(1))
        cPil:="1"
        cCode_1:=SPACE(3)
        cCode_2:=SPACE(3)
        SetCursor(1)
        @ 24,00
        @ 24,00 SAY " Pilihan [1] Layar atau [3] Printer Epson ?                                      " COLOR "N/W"
        @ 24,10 SAY "1"                  COLOR "W+/r"
        @ 24,25 SAY "3"                  COLOR "W+/r"
        @ 24,43 GET cPil Valid cPil$"13" COLOR "w+/B"
        READ
        IF LastKey()=27
           RestScreen(nK,oB:nLeft,nK,oB:nRight,cD);GROUP->(DBSetOrder(1))
           @24,00;@24,00 SAY SPACE(80) COLOR 'W/N'
           oB:RefreshAll()
           GROUP->(DBGOtop())
           LOOP
        ENDIF
        @24,0
        @ 24,00 SAY " CODE : 123 S/D CODE : 123                                             " COLOR "N/W"
        @ 24,08 GET cCode_1 PICT '@!'
        @ 24,23 GET cCode_2 PICT '@!'
        READ
        aStruct:=GROUP->(DBSTRUCT())
        DBCREATE(cFlTmp,aStruct)
        GROUP->(DBCLOSEAREA())
        USE (cFltmp) NEW ALIAS GROUP
        IF NNetlogged()
           IF !EMPTY(cCODE_1) .AND. !EMPTY(cCODE_2)
              APPEND FROM (NDATA+'GROUP') FOR CODE>=cCode_1 .AND. CODE<=cCode_2
           ELSE
              APPEND FROM (NDATA+'GROUP')
           ENDIF
        ELSE
           IF !EMPTY(cCODE_1) .AND. !EMPTY(cCODE_2)
              APPEND FROM (DDATA+'GROUP') FOR CODE>=cCode_1 .AND. CODE<=cCode_2
           ELSE
              APPEND FROM (DDATA+'GROUP')
           ENDIF
        ENDIF
        INDEX ON CODE TO \KASIR\DAT\RP_1
        SET INDEX TO \KASIR\DAT\RP_1

        @ 24,0  SAY "  Proses .......  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
        @ 24,19 SAY "*"                  COLOR "N*/W"
        SET DEVICE TO PRINTER
        IF cPil="1"  //.OR. cPil='2'
           SET PRINTER TO $CTemp.TXT
        ENDIF
        IF cPil='1'   // .OR. cPil='1'
           HeadPro2(0)
        ELSE
           HeadPro()
        ENDIF
        GROUP->(DBGotOp())
        DO WHILE !GROUP->(EOF())
          @PROW()+1 ,00 SAY CODE
          @PROW()   ,06 SAY DESC
          SKIP
          IF PROW()+1>63
             IF cPil='1' //.OR. cPil='1'
                @PROW()+1,00 SAY Chr(12)   //EJECT
                HeadPro2()
             ENDIF
          ENDIF
        ENDDO
        IF cPil='1' //.OR. cPil='1'
           @PROW()+1,00 SAY Chr(12)   //EJECT
        ELSE
           PCutter()
        ENDIF
        SET PRINTER TO
        SET DEVI TO SCREEN
        IF cPil="1"   //.OR. cPil="2"
           SAVE SCREEN TO cSCR01
           DISPREPR(1,'$CTEMP.TXT')
//           LIHATTEKS('$CTEMP.TXT',2,0,23,79,"W/N")
//           FILEDELETE('$CTEMP.TXT')
           RESTORE SCREEN FROM cSCR01
        ENDIF
        GROUP->(DBCLOSEAREA())
        IF NNetLogged() ;lGLan:=.T.
           IF !NetUse({{NDATA+"GROUP"    ,.T.}})
              BREAK
           ENDIF
           SELECT GROUP
           IF !File(NDATA+"GROUP__1.NTX")
              INDEX ON CODE TO (NDATA+"GROUP__1.NTX")
           ENDIF
           SET INDEX TO (NDATA+"GROUP__1.NTX")
        ELSE
           IF !NetUse({{DDATA+"GROUP"    ,.T.}})
              BREAK
           ENDIF
           SELECT GROUP
           IF !File(DDATA+"GROUP__1.NTX")
              INDEX ON CODE TO (DDATA+"GROUP__1.NTX")
           ENDIF
           SET INDEX TO (DDATA+"GROUP__1.NTX")
        ENDIF
        @ 24,0  SAY "  Proses Selesai                                                                 " COLOR "N/W"
        nPAGE:=0
        @24,00;@24,00 SAY SPACE(80) COLOR 'W/N'
        oB:RefreshAll()
        CLASS->(DBGOtop())
   CASE (nK=K_ENTER .OR. (nK>31 .AND. nK<127)) .AND. oC:Heading#'No'
      b:=oC:Block   ;x:=Eval(b)
      @ oB:Cargo[1],oB:Cargo[2] GET x PICT  ;
      If(oC:Heading='Kode','99','@!')  COLOR 'gr+/b'
      KEYBOARD If(nK=K_ENTER,'',Chr(nK));READ
      nD:=RecNo()
      IF oC:Heading='Kode' 
	 IF Empty(x);Warning(' Kode Tidak Boleh Kosong ... !') ;LOOP ;ENDIF
	 IF Eof()
	    IF !DBSeek(x) .AND. AddRec() ;Eval(b,x)
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
Static Function TCode(c)                   //hapus
c:=Left(c,1)                               //hapus
DO CASE                                    //hapus
CASE c$'123456789' ;c:='Class'             //hapus
CASE c='0'         ;c:='Dept '             //hapus
OTHERWISE          ;c:='     '             //hapus
ENDCASE                                    //hapus
RETURN c                                   //hapus
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
*-------------------------------------------------------------------------------
Static Function HeadPro()
 SETPRC(0,0)
 @PROW()+1, 00 SAY 'Print Out Data Group'
 @PROW()+1, 00 SAY REPLI('-',40)
 @PROW()+1, 00 SAY 'CODE  NAMA                          '
 //                 123   123456789012345678901234567890
 //                 01234567890123456789012345678901234567890
 @PROW()+1, 00 SAY REPLI('=',40)
RETURN
*-------------------------------------------------------------------------------
Static Function HeadPro2()
 SETPRC(0,0)
 @PROW()+1, 00 SAY 'Print Out Data Group'
 @PROW()  , 57 SAY 'Hal:'+Tran(++nPage,'9,999')
 @PROW()+1, 00 SAY REPLI('-',77)
 @PROW()+1, 00 SAY 'CODE  DESCRIPTION '
 //                 123                                         99  999     999,999,999  999,999
 //                 0123456789012345678901234567890123456789012345678901234567890
 @PROW()+1, 00 SAY REPLI('=',77)
RETURN
*-------------------------------------------------------------------------------

