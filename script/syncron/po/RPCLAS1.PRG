#include "kassa.ch"
#define FC_NORMAL    0
*-----------------------------------------------------------------------------
PROCEDURE RPCLAS1(aDbf,cTitle,lTxt)
LOCAL bFirst, bWhile, bFor,I,cM:=' '
LOCAL nItem:= 0, nCust:= 0, nPrice:= 0
LOCAL nTItem:= 0, nTPrice:=0
LOCAL cCODE:=' ', nNorcp
LOCAL RCLAS

LOCAL nHandle:=0, cBuffer:=''
LOCAL LF, aHead, aFoot, cExt, cFile, cMcn

IF(lTxt == NIL,lTxt:=.T.,.F.)

IF SELE("CP") > 0
   CLOSE CP
ENDIF

IF SELE("RCP") > 0
   CLOSE RCP
ENDIF

USE (aDbf[1]) NEW ALIAS RCLAS
INDEX ON CLASDX1('RCLAS') TO (DDATA+"$RCLAS1")

bFirst := {|| RCLAS->(DBSEEK("þ")) }
bWhile := {|| !RCLAS->(EOF()) }
bFor   := {|| .t.  }

EVAL(bFirst)
DBEVAL({|| nTPrice+=RCLAS->PRICE*QTY, IIF(RCLAS->PRICE > 0 ,;
           nTItem+=RCLAS->QTY,nTItem-=RCLAS->QTY ) },bFor,bWhile)

IF nTItem == 0
   WARNING(' Tidak Ada Transaksi ... ! ')
   CLOSE RCLAS
   RETURN
ENDIF

IF lTxt
   nHandle:=0
   cBuffer:=''
   LF:=CHR(13)+CHR(10)
   cMcn:=RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
   aHead:=TXTHeader({aDbf[1]},'CLS',cMcn)
   aFoot:=TXTFooter({aDbf[1]})
   cExt:='.'+SUBSTR(aDbf[1],AT('CP',aDbf[1])+2,2)
   cFile:='CLS'+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,4)+cExt
   IF (nHandle:=FCREATE(DTXT+cFile,FC_NORMAL))=-1
      Warning(' Tidak Berhasil Membuat File Text [Dos Error : '+ALLTRIM(STR(FERROR(),2))+'] ') 
      CLOSE RCLAS
      RETURN
   ENDIF
   FOR I=1 TO LEN(aHead)
       FWRITE(nHandle,aHead[I]+LF)
   NEXT
ENDIF

@ MAXROW(),0 SAY "  Printing .....  ³ ³ þþ Class Report þþ                                         " COLOR "N/W"
SET DEVICE TO PRINT
@ PRow()   ,00 SAY _PINIT+_PALL
@ PRow()+1 ,00  SAY REPLI('-',33)
@ PRow()   ,33  SAY REPLI('-',33)
@ PRow()+1 ,00  SAY 'CLASS REPORT    '
JPrint(PRow() ,40, 'CLASS REPORT    ')
@ PRow()+1 ,00  SAY DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle)
@ PRow()   ,33  SAY DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle)
@ PRow()+1 ,00  SAY REPLI('-',33)
@ PRow()   ,33  SAY REPLI('-',33)

EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      IF cCode <> LEFT(RCLAS->CODE,3)
         IF nItem <> 0
            @ PRow()+2 ,00 SAY cCODE+'-'+IIF(CLASS->(DBSEEK(cCODE)),Left(CLASS->DESC,15),'???')
            @ PRow()   ,20 SAY TRAN(nItem,'9999999')+` ITEM'
            @ PRow()   ,33 SAY cCODE+'-'+IIF(CLASS->(DBSEEK(cCODE)),Left(CLASS->DESC,15),'???')
            @ PRow()   ,53 SAY TRAN(nItem,'9999999')+` ITEM'
            @ PRow()+1 ,00 SAY TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')
            @ PRow()   ,20 SAY TRAN(nPrice,' 999,999,999')
            @ PRow()   ,33 SAY TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')
            @ PRow()   ,53 SAY TRAN(nPrice,' 999,999,999')
            IF lTxt
               cBuffer:=cCODE+','+NumToChar('000000',nCUST)+','+;
                        NumToChar('0000000',nItem)+','+;
                        NumToChar('000000000000',nPrice)+LF
               FWRITE(nHandle,cBuffer)
            ENDIF
         ENDIF
         cCode  := LEFT(RCLAS->CODE,3)
         nNorcp := RCLAS->NORCP
         nCust  := 1
         nItem  := 0
         nPrice := 0
      ENDIF

      IF nNorcp <> RCLAS->NORCP .AND. RCLAS->FLAG=='PLU'
         nCust++
         nNorcp := RCLAS->NORCP
      ENDIF

      nPrice+=RCLAS->PRICE*QTY
      IIF(RCLAS->PRICE > 0, nItem+=RCLAS->QTY, nItem-=RCLAS->QTY)
   ENDIF

   RCLAS->(DBSKIP())
   SET DEVICE TO SCREEN
   @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
   SET DEVICE TO PRINT
ENDDO

cMcn:=RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
@ PRow()+2 ,00 SAY cCODE+'-'+IIF(CLASS->(DBSEEK(cCODE)),Left(CLASS->DESC,15),'???')
@ PRow()   ,20 SAY TRAN(nItem,'9999999')+` ITEM'
@ PRow()   ,33 SAY cCODE+'-'+IIF(CLASS->(DBSEEK(cCODE)),Left(CLASS->DESC,15),'???')
@ PRow()   ,53 SAY TRAN(nItem,'9999999')+` ITEM'
@ PRow()+1 ,00 SAY TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')
@ PRow()   ,20 SAY TRAN(nPrice,' 999,999,999')
@ PRow()   ,33 SAY TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')
@ PRow()   ,53 SAY TRAN(nPrice,' 999,999,999')
@ PRow()+2 ,00 SAY "**  T o t a l  **"
@ PRow()   ,33 SAY "**  T o t a l  **"
@ PRow()+1 ,20 SAY TRAN(nTItem,'9999999')+` ITEM'
@ PRow()   ,53 SAY TRAN(nTItem,'9999999')+` ITEM'
@ PRow()+1 ,00 SAY '   100.00 %'
@ PRow()   ,20 SAY TRAN(nTPrice,'9999,999,999')
@ PRow()   ,33 SAY '   100.00 %'
@ PRow()   ,53 SAY TRAN(nTPrice,'9999,999,999')
@ PROW()+2,00 SAY 'FROM SATELITE '
@ PROW()+0,33 SAY 'FROM SATELITE '
IF cTitle='<Read>'
   cE:=DTos(Date())
   cE:=SUBSTR(cE,7,2)+'/'+SUBSTR(cE,5,2)
ELSE
   cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
ENDIF
@ PRow()+1 ,00 SAY '- '+cMcn+' '+SUBSTR(aDbf[1],AT("CP",aDbf[1])+2,2)+" <"+cE+">"
@ PRow()   ,33 SAY '- '+cMcn+' '+SUBSTR(aDbf[1],AT("CP",aDbf[1])+2,2)+" <"+cE+">"
//@ PRow()+1 ,00 SAY 'SATELITE : #'+SUBSTR(aDbf[1],AT("CP",aDbf[1])+2,2)+" <"+;
//		   SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)+">"
//@ PRow()   ,33 SAY 'SATELITE : #'+SUBSTR(aDbf[1],AT("CP",aDbf[1])+2,2)+" <"+;
//		   SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)+">"
@ PRow()   ,PCol() SAY CHR(13)
@ PRow()+2 ,0      SAY Replicate('#',33)
@ PRow()   ,33     SAY Replicate('#',33)
PCutter()

IF lTxt
   cBuffer:=cCODE+','+NumToChar('000000',nCUST)+','+;
            NumToChar('0000000',nItem)+','+;
            NumToChar('000000000000',nPrice)+LF
   FWRITE(nHandle,cBuffer)
   FOR I=1 TO LEN(aFoot)
       FWRITE(nHandle,aFoot[I]+LF)
   NEXT
   FCLOSE(nHandle)
ENDIF

SET PRINTER TO
SET DEVICE TO SCREEN
CLOSE RCLAS

IF lTxt
   @ MAXROW(),0  SAY "  Copy File ....  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
   @ MAXROW(),19 SAY "*" COLOR "N*/W"
   IF !LGLan.AND.ChkDrv(DIRECTORY(DTXT+cFile)[1][2])
      FILECOPY(DTXT+cFile,"A:\"+cFile)
   ENDIF
ENDIF
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION CLASDX1(cAlias)
IF LEN(ALLTRIM((cAlias)->CODE)) = 3 .AND. ( (cAlias)->FLAG == 'PLU';
   .OR. (cAlias)->FLAG == 'VOD'.OR. (cAlias)->FLAG == 'RTN')
   RETURN "þ"+LEFT((cAlias)->CODE,3)+STR((cAlias)->NORCP,6)
ENDIF
RETURN SPACE(10)

