#include "kassa.ch"
#define FC_NORMAL    0
*-----------------------------------------------------------------------------
PROCEDURE RPSKU(aDbf,cTitle,lTxt)
LOCAL bFirst, bWhile, bFor, I,RGSKU,cM:=' '
LOCAL nCpSq:=0, nRcpSq:=0 ,cFLAG:='XXX', nPsNg:=0, cCODE:='00000000'
LOCAL nQty:=0, nOldPrice:=0, nPrice:=0, nMachine:=0, cEnTy := ' ' ,cMcn:=' '

LOCAL nHandle:=0, cBuffer:=''
LOCAL LF, aHead, aFoot, cExt, cFile

IF(lTxt == NIL,lTxt:=.T.,.F.)
IF VALTYPE(aDbf) <> 'A' .OR. EMPTY(aDbf)
   WARNING(' File Belum Dipilih ... ! ')
   RETURN
ENDIF

//@ MAXROW(),0  SAY "  Proses .......  ³ ³ þþ SKU Report <text> þþ                                         " COLOR "N/W"
//@ MAXROW(),19 SAY "*" COLOR "N*/W"

IF SELE("CP") > 0
   CLOSE CP
ENDIF

IF SELE("RCP") > 0
   CLOSE RCP
ENDIF

USE (aDbf[1]) NEW ALIAS RGSKU
//INDEX ON LEFT(CODE,2)+STR(NORCP)+STR(MACHINE)  TO (DDATA+"$RGSKU1")

IF RGSKU->(LASTREC()) == 0
   WARNING(' Tidak Ada Transaksi ... ! ')
   CLOSE RGSKU
   RETURN
ENDIF

bFirst := {|| RGSKU->(DBGOTOP()) }
bWhile := {|| !RGSKU->(EOF())  }
bFor   := {|| .T. }

IF lTxt
   nHandle:=0
   cBuffer:=''
   LF:=CHR(13)+CHR(10)
   aHead:=TXTHeader(aDbf,'SKU',cMcn)
   aFoot:=TXTFooter(aDbf)
   cExt:='.'+IF(LEN(aDbf)>1,'GAB',SUBSTR(aDbf[1],AT('CP',aDbf[1])+2,2))
   cFile:='SKU'+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,4)+cExt
   IF (nHandle:=FCREATE(IF(lGLan,NTXT,DTXT)+cFile,FC_NORMAL))=-1
      Warning(' Tidak Berhasil Membuat File Text [Dos Error : '+ALLTRIM(STR(FERROR(),2))+'] ') 
      CLOSE RGSKU
      RETURN
   ENDIF
   FOR I=1 TO LEN(aHead)
       FWRITE(nHandle,aHead[I]+LF)
   NEXT
ENDIF

@ MAXROW(),0 SAY "  Printing .....  ³ ³ þþ SKU Report <text> þþ                                         " COLOR "N/W"

EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      DO CASE
      CASE RGSKU->FLAG == 'NEW'
           nRcpSq++
           nMachine:=RGSKU->PRICE
      CASE RGSKU->FLAG == 'PCG'
           nOldPrice:= RGSKU->PRICE
      OTHERWISE
           nCpSq++
           cFLAG := RGSKU->FLAG
           nPsNg := PosNeg(RGSKU->PRICE)
           nQty  := RGSKU->QTY
           nPrice:= RGSKU->PRICE
           cEnTy := IIF(EMPTY(RGSKU->ETYPE), ' ',RGSKU->ETYPE)

           IF ASCAN({'TTL','TPO','TRA'}, RGSKU->FLAG ) > 0
              cCODE := RIGHT("00000000"+ALLTRIM(STR(nRcpSq,5)),8)
           ELSE
              cCODE := LEFT(ALLTRIM(RGSKU->CODE)+"00000000",8)
           ENDIF

           IF lTxt
              cBuffer:=NumToChar('0000',nCpSq)+','+;
                       cFLAG+','+nPsNg+','+cCODE+','+;
                       NumToChar('000',nQty)+','+;
                       NumToChar('000000000000',nPrice)+','+;
                       NumToChar('000000000000',nOldPrice)+','+;
                       cEnTy+','+;
                       NumToChar('000000',nMACHINE)+LF
              FWRITE(nHandle,cBuffer)
           ENDIF
           nOldPrice:=0
      ENDCASE
   ENDIF
   RGSKU->(DBSKIP())
   @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
ENDDO

IF lTxt
   FOR I=1 TO LEN(aFoot)
       FWRITE(nHandle,aFoot[I]+LF)
   NEXT
   FCLOSE(nHandle)
ENDIF
CLOSE RGSKU

IF lTxt
   @ MAXROW(),0  SAY "  Copy File ....  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
   @ MAXROW(),19 SAY "*" COLOR "N*/W"
   IF !LGLan.AND.ChkDrv(DIRECTORY(DTXT+cFile)[1][2])
      FILECOPY(DTXT+cFile,"A:\"+cFile)
   ENDIF
ENDIF

RETURN

