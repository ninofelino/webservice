#include  'inkey.ch'
#include  'kassa.ch'
*------------------------------------------------------------------------------*
PROCEDURE DLL()
LOCAL  nK,oB,oC,nX,b,nD,lD,cM:=''
LOCAL  GETLIST:={}
IF Select('DLL')>0
   SELECT  DLL
   USE
ENDIF
IF !NetUse({{NDATA+'DLL.DBF',.t.}})
   RETURN {}
ENDIF
*--------------------------
@ 0,0,27,79 BOX Space(9)
Box(5,00,25,79)
Box(0,00,4,79)
oB:=TBrowseDB(7,1,22,78)
oB:ColSep:='Ё'
oB:HeadSep:='бд'
oB:AutoLite:=.t.
oB:ColorSpec:='w,w+/b,gr+/w,b/w,w/r,w+/g'
*----------------------------------------------
@ oB:nTop-1,oB:nLeft+1    SAY '[ ]MONITORING TERMINAL' COLOR 'w+'
SetPos(oB:nBottom,oB:nLeft+1)
@ oB:nBottom+1,oB:nLeft SAY '[1]Send/[2]All [3]Reqs/[4]All [5]Clear/[6]All Command'
@ oB:nBottom+2,oB:nLeft SAY '[8]File Type [7]Ijin EOD [9]Open [0]Release Terminal'
nX:=0 ;SUM TSALES TO  nX
cDD:=AllTrim(Trans(nX,'999,999,999'))
Angka(01,01,'total:  '+(cDD+Space(11-Len(cDD))))     
oC:=TBColumnNew('T/M ',{||Str(RecNo(),2)})
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Status ',{||Stat(STATUS)})
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('TotalSales ',{||Trans(TSALES,'999,999,999')})
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Receipt ',{||NORCP})
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Cashier '  ,{||CCODE})
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('CPSend ',{||WAKTU})
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Cmd ',{||CMD})
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('FileType ',{||FTYPE})
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Tgl.Open ',{||TGLOPEN})
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('Tgl.Close ',{||TGLCLOSE})
oC:FootSep:='ад';oB:AddColumn(oC)
oC:=TBColumnNew('EOD',{||EOD})
oC:FootSep:='ад';oB:AddColumn(oC)
*---------------------------------------------
GO TOP
DO While nK#K_ESC
   IF oB:Stabilize();TLight(oB,nK)
      @ oB:Cargo[1],oB:Cargo[2] SAY Eval((oB:GetColumn(oB:ColPos)):Block) COLOR 'r/bg+'
      nK:=InKey(01);oB:RefreshCurrent()
   ELSE;LOOP
   ENDIF
   @ oB:nTop-1,oB:nLeft+2 SAY (cM:=Muter(cM))
   If (b:=SetKey(nK))<>NIL                          // check for SET KEY first
      Eval(b,ProcName(),ProcLine(),ReadVar())
      LOOP
   End
   DO CASE
   CASE TKey(oB,nK);LOOP
   CASE nK=Asc('1') .And. RecLock() ;FIELD->CMD:='SND' ;UNLOCK
   CASE nK=Asc('3') .And. RecLock() ;FIELD->CMD:='RQS' ;UNLOCK
   CASE nK=Asc('5') .And. RecLock() ;FIELD->CMD:='   ' ;UNLOCK
   CASE nK=Asc('7') .And. RecLock()
        IF EOD
           FIELD->EOD:=.F.
        ELSE
           FIELD->EOD:=.T.
        ENDIF
        UNLOCK

   CASE nK=Asc('2') .OR.;
        nK=Asc('4') .OR.;
       	nK=Asc('6')
        cD:=FTYPE
        nD:=RecNo()
        GO TOP 
        DO WHILE !Eof()
          IF RecLock()
              DO CASE 
              CASE nK=Asc('2') ;FIELD->CMD:='SND'
                 IF cD#'CLASS' .OR. Empty(WAKTU)
                    FIELD->FTYPE:=cD
                 ENDIF
              CASE nK=Asc('4') ;FIELD->CMD:='RQS'
                 IF cD#'CLASS' .OR. Empty(WAKTU)
                    FIELD->FTYPE:=cD
                 ENDIF
              CASE nK=Asc('6') ;FIELD->CMD:='   '
                 FIELD->FTYPE:=''
              ENDCASE
              UNLOCK
          ENDIF          
          SKIP
        ENDDO
        GO nD
   CASE nK=Asc('8') .AND. RecLock()
      DO CASE
      CASE FTYPE='CAPTURE'  ;FIELD->FTYPE:='TERMINAL'
      CASE FTYPE='TERMINAL' ;FIELD->FTYPE:='PROMOSI'
      CASE FTYPE='PROMOSI'  ;FIELD->FTYPE:='TOMBOL'
      CASE FTYPE='TOMBOL'   ;FIELD->FTYPE:=If(Empty(WAKTU),'CASHIER','')
      CASE FTYPE='CASHIER'  ;FIELD->FTYPE:=If(Empty(WAKTU),'CLASS','')
      CASE FTYPE='CLASS'    ;FIELD->FTYPE:=''
      OTHERWISE             ;FIELD->FTYPE:='CAPTURE'
      ENDCASE
      IF FTYPE='ALL' ;FIELD->NO:=5
        ELSE         ;FIELD->NO:=0
      ENDIF
      UNLOCK
   CASE nK=Asc('9') .AND. FIELD->STATUS=1 .AND. RecLock()
      FIELD->FTYPE  :=''
      FIELD->STATUS :=0
      FIELD->CCODE  :=''
      FIELD->WAKTU  :=''
      FIELD->CMD    :=''
      UNLOCK
   CASE nK=Asc('0') ;GO TOP  ;nD:=RecNo()
      @ 26,00 Say 'Proses Release Semua TM....? [0] Tidak, [1] Ya '  //Did 30/11
      DO WHILE .T.                                                   //Wid 30/11
         @ 26,50 SAY ''                                              //Wid 30/11
         i:=InKey(0)                                                 //Wid 30/11
         IF UPPER(CHR(i))$'01'                                       //Wid 30/11
            EXIT                                                     //Wid 30/11
         ENDIF                                                       //Wid 30/11
      ENDDO                                                          //Wid 30/11
      @ 26,00 Say '                                               '  //Wid 30/11
      IF UPPER(CHR(i))$'0'                                           //Wid 30/11
         LOOP                                                        //Wid 30/11
      ENDIF                                                          //Wid 30/11
      GO TOP
      DO WHILE !Eof()
	 IF FIELD->STATUS=2 .AND. RecLock()
            FIELD->FTYPE  :=''
            FIELD->STATUS :=0
            FIELD->TSALES :=0
            FIELD->NORCP  :=0
            FIELD->CCODE  :=''
            FIELD->WAKTU  :=''
            FIELD->CMD    :=''
            FIELD->TGLOPEN:=''
            FIELD->TGLCLOSE:=''
            UNLOCK
         ELSEIF FIELD->TGLOPEN#FIELD->TGLCLOSE    // UJI COBA DULU
            FOR i:=1 TO 2
               WARNING(' NOMOR INLINE -> '+RIGHT('00'+ALLTRIM(STR(RECNO())),2)+' BELUM DILAKUKAN EOD ')
            NEXT
         ENDIF          
	 SKIP
      ENDDO
      GO nD
   OTHERWISE
      nX:=0
      nD:=RecNo()
      SUM TSALES TO nX
      cDD:=AllTrim(Trans(nX,'999,999,999'))
      Angka(01,01,'total:  '+(cDD+Space(11-Len(cDD))))
      GO nD
   ENDCASE
   COMMIT
   oB:RefreshAll()
ENDDO
USE
RETURN

STATIC FUNCTION Stat(n)
LOCAL  c
DO CASE
CASE n=1  ;c:='Used  '
CASE n=2  ;c:='E.O.D.'
OTHERWISE ;c:='Open  '
ENDCASE
RETURN c

