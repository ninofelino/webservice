#include 'kassa.ch'
*-----------------------------------------------------------------------------
PROCEDURE SFKC(lLan)
LOCAL oTbr,oTbc,cD,nD
LOCAL nT,nI,nKey:=0,cS,cColo:=SetColor()
aKey:=DefKey(lLan) ;nT:=Len(aKey)
IF Empty(aKey)
   RETURN
ENDIF
ShowTime()
SAVE SCREEN TO cS
CLEAR ;GO TOP
SET SCOR  OFF
SET CONF  ON
@ 0,38 CLEAR TO 26,79
SetColor('n/w,w+/n')
Box(0,29,26,79,'w+/w')
//@ 0,38,24,58 BOX 'º ººº ºº '
//@ 0,59,24,79 BOX 'º ººº ºº '
FOR nI:=1 TO 75
    GO nI                                                    // 1
    IF nI>0 .AND. nI<26
       @ nI, 30 SAY Trans(nI,'99. ') //+INTERN
       @ nI, Col() SAY INTERN      //COLOR 'n/w'
    ELSEIF nI>25 .AND. nI<51
       @ nI-25, 47 SAY Trans(nI,'99. ') //+INTERN
       @ nI-25, Col() SAY INTERN      //COLOR 'n/w'
    ELSEIF nI>50 .AND. nI<76
       @ nI-50, 63 SAY Trans(nI,'99. ') //+INTERN
       @ nI-50, Col() SAY INTERN      //COLOR 'n/w'
    ENDIF
NEXT
SetColor('n/bg,w+/n')
Box(0,0,26,28,'w+/bg')
//@ 00,0 TO 24,28 DOUBLE
@ 22,1 SAY '[0]Ext [1]PKB [2]MCR [.]Asg'
@ 23,1 SAY '[3]P%D [4]P%D [5]Kpn [6]Prt'
@ 24,1 SAY '[7]Msg [8]KEY/PassWr [9]Vld'
oTbr:=TBrowseDb(2,1,21,27) ;oTbr:HeadSep:='ÂÄ' ;oTbr:ColSep:='³'
oTbc:=TBColumnNew('ASCII',{||ASCNM}) ;oTbc:FootSep:='ÁÄ' ;oTbr:AddColumn(oTbc)
oTbc:=TBColumnNew('KODE' ,{||Kode()});oTbc:FootSep:='ÁÄ' ;oTbr:AddColumn(oTbc)
oTbc:=TBColumnNew('KET'  ,{||ASGNNM});oTbc:FootSep:='ÁÄ' ;oTbr:AddColumn(oTbc)
SetColor(cColo)
GO TOP

lLayar:=.F.
DO WHILE .T.
   DO WHILE !oTbr:Stabilize()
   ENDDO
   nI:=ASSIGN
   nRec:=RecNo()
   IF nI>0 .AND. nI<76
      lLayar:=.F.
      SetColor('n/w,w+/n')
      Box(0,29,26,79,'w+/w')
      FOR nIMu:=1 TO 75
          GO nIMu
          IF nIMu>0 .AND. nIMu<26
             @ nIMu, 30 SAY Trans(nIMu,'99. ') //+INTERN
             @ nIMu, Col() SAY INTERN      //COLOR 'n/w'
          ELSEIF nIMu>25 .AND. nIMu<51
             @ nIMu-25, 47 SAY Trans(nIMu,'99. ') //+INTERN
             @ nIMu-25, Col() SAY INTERN      //COLOR 'n/w'
          ELSEIF nIMu>50 .AND. nIMu<75
             @ nIMu-50, 63 SAY Trans(nIMu,'99. ') //+INTERN
             @ nIMu-50, Col() SAY INTERN      //COLOR 'n/w'
          ENDIF
      NEXT
   ENDIF
   IF nI>0 .AND. nI<76
      GO nI         // kolom kanan
      IF nI>0 .AND. nI<26
         @ nI   , 30 SAY Trans(nI,'99. ')+INTERN  COLOR 'w/n*'
      ELSEIF nI>25 .AND. nI<51
         @ nI-25, 47 SAY Trans(nI,'99. ')+INTERN  COLOR 'w/n*'
      ELSEIF nI>50 .AND. nI<76
         @ nI-50, 63 SAY Trans(nI,'99. ')+INTERN  COLOR 'w/n*'
      ENDIF
   ENDIF
   nKey:=InKey(0)       // Saat Akan Tekan Tombol............
   IF nI>0 .AND. nI<76
      IF nI>0 .AND. nI<26   // kolom kiri
         @ nI-00, 30 SAY Trans(nI,'99. ') COLOR 'n/w'
         @ nI-00, Col() SAY INTERN        COLOR 'n/w'
      ELSEIF nI>25 .AND. nI<51
         @ nI-25, 47 SAY Trans(nI,'99. ') COLOR 'n/w'
         @ nI-25, Col() SAY INTERN        COLOR 'n/w'
      ELSEIF nI>50 .AND. nI<76
         @ nI-50, 63 SAY Trans(nI,'99. ') COLOR 'n/w'
         @ nI-50, Col() SAY INTERN        COLOR 'n/w'
      ENDIF
   ENDIF
   LOCATE FOR nKey=ASCII
   nD:=RecNo();GO nRec
   DO CASE

   CASE nKey=46  &&_______________________________________________________='.'
      IF !(ASSIGN>0 .AND. ASSIGN<76)
         FIELD->KEYL:=''
         FIELD->VLDS:=.f.
         FIELD->ASSIGN:=0
         FIELD->ASGNNM:=''
      ENDIF
      nD:=ASSIGN
      oTbr:RefreshCurrent();oTbr:Stabilize()
      oTbr:End()  ;oTbr:Stabilize()
      @ Row(),Col() GET nD PICT '999'
      oTbr:Left() ;oTbr:Stabilize()
      @ Row(),Col() SAY Kode() 
      READ
      IF nD>0 .AND. nD<76
         GO nD;cD:=INTERN
         GO nRec
         FIELD->ASSIGN:=nD
         FIELD->ASGNNM:=cD
      ENDIF
   CASE nKey=48  &&_______________________________________________________='0'
      EXIT
   CASE nKey=50 .AND. ASSIGN>14 .AND. ASSIGN<29  &&_______________________='2'
      FIELD->MCR:=!MCR
   CASE nKey=53 .AND. ASSIGN>14 .AND. ASSIGN<29  &&_______________________='2'
      FIELD->DCR:=!DCR
   CASE Chr(nKey)$'1345' &&_____________________________________________'1345'
      IF ASSIGN#-1*(nKey-48)
         FIELD->KEYL:=''
         FIELD->VLDS:=.f.
         FIELD->ASSIGN:=0
         FIELD->ASGNNM:=''
      ENDIF
      cD:=ASGNNM
      oTbr:RefreshCurrent();oTbr:Stabilize()
      oTbr:End()           ;oTbr:Stabilize()
      DO CASE
      CASE nKey=49 ;@ Row(),Col() GET cD PICT '99999999'
      CASE nKey=51 ;@ Row(),Col() GET cD PICT '99'
      CASE nKey=52 ;@ Row(),Col() GET cD PICT '99'
//      CASE nKey=53 ;@ Row(),Col() GET cD PICT '99'
      ENDCASE
      oTbr:Left()  ;oTbr:Stabilize()
      @ Row(),Col() SAY Kode(-1*(nKey-48))
      READ
      IF !Empty(cD)
	 FIELD->ASSIGN:=-1*(nKey-48)
	 FIELD->ASGNNM:=cD
      ENDIF
   CASE nKey=54 &&______________________________________________________Print.
      nI:=TOMBOL->(RecNo())
      DO WHILE !PrintReady()
	 Warning(' Printer Error ... ! ')
      ENDDO
      SET DEVI TO PRINT
      PHeader()
      TOMBOL->(DBGOTOP())
      @ Prow()+1,0 SAY _PINIT+_PRCPT
      @ Prow()+1,0 SAY '[M]   Key Code   Function        Assign'
      @ Prow()+1,0 SAY '===   ========   ========        ======'
      DO WHILE !TOMBOL->(Eof())
	 IF TOMBOL->ASSIGN#0 .AND. TOMBOL->ASCII#0
            cD:=TOMBOL->(Kode(ASSIGN)+' '+Left(ASCNM,10)+' '+ASGNNM+'       '+STR(ASSIGN))
	    @ Prow()+1,0 SAY cD
	 ENDIF
	 TOMBOL->(DBSkip())
      ENDDO
      @ Prow()+1,0 SAY Repli('=',40)
      @ Prow()+1,0 SAY '[.]   Function Key'
      @ Prow()+1,0 SAY '[1]   Preset K Brg'
      @ Prow()+1,0 SAY '[2]   Preset Key'
      @ Prow()+1,0 SAY '[ ]?  Validasi'
      @ Prow()+1,0 SAY '[ ] ? Keylock'
      @ Prow()+1,0 SAY '[ ]  ?M.C.R.'
      @ Prow()+1,0 SAY Repli('=',40)
      @ Prow()+1,0 SAY _PINIT+_PALL
      PCutter() ;SET DEVI TO SCREEN
      TOMBOL->(DBGoto(nI))
   CASE nKey=55 .AND. ((ASSIGN>0 .AND. ASSIGN<47) .OR. ;   &&_____________________ChgMsg
      (ASSIGN>48 .AND. ASSIGN<60))
      cD:=ASGNNM
      oTbr:End();oTbr:Stabilize()
      @ Row(),Col() GET cD PICT '@!'  COLOR 'GR+/B'
      READ
      IF !Empty(cD)
	 FIELD->ASGNNM:=cD
      ENDIF
   CASE nKey=56 .AND. ;
      ((ASSIGN>0 .AND. ASSIGN<47) .OR. ;
      (ASSIGN>-6 .AND. ASSIGN<-2))              &&_____________________KeyLock
      DO CASE
      CASE KEYL=' ' ;cD:='P'
      CASE KEYL='P' ;cD:='0'
      CASE KEYL='0' ;cD:='1'
      CASE KEYL='1' ;cD:='2'
      CASE KEYL='2' ;cD:='3'
      CASE KEYL='3' ;cD:='4'
      CASE KEYL='4' ;cD:='5'
      CASE KEYL='5' ;cD:='6'
      CASE KEYL='6' ;cD:='7'
      CASE KEYL='7' ;cD:=' '
      ENDCASE
      FIELD->KEYL:=cD
   CASE nKey=57 .AND. ;
      ((ASSIGN>0 .AND. ASSIGN<47) .OR. ;
      (ASSIGN>-6 .AND. ASSIGN<-2))              &&_____________________Validasi
      FIELD->VLDS:=!VLDS
   CASE nD<=nT
      DO WHILE nKey#ASCII    // Move Record
         IF RecNo()<=nD
	    oTbr:Down()
	 ELSE;oTbr:Up()
	 ENDIF
	 oTbr:Stabilize()
      ENDDO
   ENDCASE
   oTbr:home()
   oTbr:RefreshCurrent()
ENDDO
USE
REST SCREEN FROM cS
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION Kode(nD)
LOCAL cD
IF nD =NIL
   nD:=ASSIGN
ENDIF
DO CASE
CASE  nD>0  ;
.AND. nD<151 ;cD:='.'
CASE  nD=-1 ;cD:='1'
CASE  nD=-2 ;cD:='2'
CASE  nD=-3 ;cD:='3'
CASE  nD=-4 ;cD:='4'
CASE  nD=-3 ;cD:='5'
CASE  nD=-4 ;cD:='6'
OTHERWISE   ;cD:='?'
ENDCASE
RETURN cD+']'+If(VLDS,'V',' ')+KEYL+If(MCR,'M',' ')+If(DCR,'K',' ')
//RETURN '['+cD+']'+If(VLDS,'V',' ')+KEYL+If(MCR,'M',' ')

*-----------------------------------------------------------------------------
FUNCTION DefKey(lLan)
LOCAL nI,nD,cF,aKey:={}
IF lLan;cF:=NDATA+'TOMBOL.DBF'
   ELSE;cF:=DDATA+'TOMBOL.DBF'
ENDIF
CLOSE ALL
UseFile()
IF File(cF)
   IF Select('TOMBOL')#0
      SELECT  TOMBOL
      USE
   ENDIF
   IF !NetUse({{cf,.f.}})
      RETURN {}
   ENDIF
   DO WHILE !Eof()
      AAdd(aKey,{ASCII,ASSIGN,AllTrim(ASGNNM)})
      SKIP
   ENDDO
   RETURN aKey
ENDIF
DBCREATE(cF,;
{{'ASCII' ,'N',03,0};
,{'ASCNM' ,'C',10,0};
,{'ASSIGN','N',03,0};
,{'ASGNNM','C',12,0};
,{'KEYL'  ,'C',01,0};
,{'VLDS'  ,'L',01,0};
,{'INTERN','C',12,0}})
IF !NetUse({{cf,.f.}})
   RETURN {}
ENDIF
aKey:={ ;
{ 28,'K_F1'   ,'#NO SALE   '},;
{ -1,'K_F2'   ,'%DISC 01   '},;
{ -2,'K_F3'   ,'%DISC 02   '},;
{ -3,'K_F4'   ,'%DISC 03   '},;
{ -4,'K_F5'   ,'AMOUNT     '},;
{ -5,'K_F6'   ,'PRICE CHG  '},;
{ -6,'K_F7'   ,'CLEAR      '},;
{ -7,'K_F8'   ,'DISCOUNT 01'},;
{ -8,'K_F9'   ,'DISCOUNT 02'},;
{ -9,'K_F10'  ,'DISCOUNT 03'},;
{-40,'K_F11'  ,'SUBTOT DISC'},;
{-41,'K_F12'  ,'HOLD       '},;
{ 01,'K_HOME' ,'JURNAL FEED'},;
{ 03,'K_PGDN' ,'ITEM CORECT'},;
{ 04,'K_RIGHT','TENDER 01  '},;
{ 05,'K_UP'   ,'TENDER 02  '},;
{ 06,'K_END'  ,'TENDER 03  '},;
{ 07,'K_DEL'  ,'TENDER 04  '},;
{ 08,'K_B_SPC','TENDER 05  '},;
{ 09,'K_TAB'  ,'TENDER 06  '},;
{ 13,'K_ENTER','TENDER 07  '},;
{ 18,'K_PGUP' ,'TENDER 08  '},;
{ 19,'K_LEFT' ,'TENDER 09  '},;
{ 22,'K_INS'  ,'TENDER 10  '},;
{ 24,'K_DOWN' ,'TENDER 11  '},;
{ 27,'K_ESC'  ,'TENDER 12  '},;
{ 32,'K_SPC'  ,'TENDER 13  '},;
{ 33,'K_!'    ,'TENDER 14  '},;
{ 35,'K_#'    ,'P/O        '},;
{ 36,'K_$'    ,'PANAH ATAS '},;
{ 37,'K_%'    ,'PANAH BAWAH'},;
{ 42,'K_*'    ,'PANAH BSPC '},;
{ 43,'K_+'    ,'PANAH KANAN'},;
{ 44,'K_,'    ,'PANAH KIRI '},;
{ 45,'K_-'    ,'PLU        '},;
{ 47,'K_/'    ,'R/A        '},;
{ 58,'K_:'    ,'REPRINT    '},;
{ 59,'K_;'    ,'RETURN     '},;
{ 60,'K_<'    ,'RECPT FEED '},;
{ 62,'K_>'    ,'SIGN ON    '},;
{ 64,'K_@'    ,'SUB TOTAL  '},;
{ 91,'K_['    ,'VALIDATE   '},;
{ 92,'K_\'    ,'VOID       '},;
{ 93,'K_]'    ,'X          '},;
{ 97,'K_a'    ,'ALL VOID   '},;
{ 98,'K_b'    ,'END OF DAY '},;
{ 99,'K_c'    ,'SEARCH NAME'},;
{ 100,'K_d'    ,'SEARCH CODE'},;
{ 101,'K_e'    ,'VALIDASI ST'},;
{ 102,'K_f'    ,'TAX %      '},;
{ 103,'K_g'    ,'PRICE__2   '},;
{ 104,'K_h'    ,'HAPPY HOUR '},;
{ 105,'K_i'    ,'PRICE SW   '},;
{ 106,'K_j'    ,'NO FUNCTION'},;
{ 107,'K_k'    ,'NO FUNCTION'},;
{ 108,'K_l'    ,'NO FUNCTION'},;
{ 109,'K_m'    ,'NO FUNCTION'},;
{ 110,'K_n'    ,'NO FUNCTION'},;
{ 111,'K_o'    ,'NO FUNCTION'},;
{ 112,'K_p'    ,'NO FUNCTION'},;
{ 113,'K_q'    ,'NO FUNCTION'},;
{ 114,'K_r'    ,'NO FUNCTION'},;
{ 115,'K_s'    ,'NO FUNCTION'},;
{ 116,'K_t'    ,'NO FUNCTION'},;
{ 117,'K_u'    ,'NO FUNCTION'},;
{ 118,'K_v'    ,'NO FUNCTION'},;
{ 119,'K_w'    ,'NO FUNCTION'},;
{ 120,'K_x'    ,'NO FUNCTION'},;
{ 121,'K_y'    ,'NO FUNCTION'},;
{ 122,'K_z'    ,'NO FUNCTION'}}           // ,;
// untuk buat array abjad a-z
FOR nI:=3 TO 26
    nD:=96+nI
    AAdd(aKey,{nD,'K_'+Chr(nD),''})
NEXT
nD:=Len(aKey)
FOR nI:=1 TO nD  ;APPEND BLANK
    FIELD->ASCII :=aKey[nI][1]
    FIELD->ASCNM :=aKey[nI][2]
    FIELD->INTERN:=aKey[nI][3]
    aKey[nI][2]:=0;aKey[nI][3]:=''
NEXT
RETURN aKey
