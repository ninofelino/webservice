#include "hmg.ch"
#include "kassa.ch"
#define FC_NORMAL    0

*-------------------------------------------------------
PROCEDURE RPDEPT1(aDbf,cTitle,lTxt)
LOCAL bFirst, bWhile, bFor,I,cM:= ' '
LOCAL nItem:= 0, nCust:= 0, nPrice:= 0
LOCAL nTItem:= 0, nTPrice:=0
LOCAL cCODE:=' ', nNorcp
LOCAL RDEPT

LOCAL nHandle:=0, cBuffer:=''
LOCAL LF, aHead, aFoot, cExt, cFile, cMcn

IF(lTxt == NIL,lTxt:=.T.,.F.)

//@ MAXROW(),0  SAY "  Proses .......  ³ ³ þþ Departemen Report þþ                                         " COLOR "N/W"
//@ MAXROW(),19 SAY "*" COLOR "N*/W"

IF SELE("CP") > 0
   CLOSE CP
ENDIF

IF SELE("RCP") > 0
   CLOSE RCP
ENDIF

USE (aDbf[1]) NEW ALIAS RDEPT
INDEX ON DEPTDX1('RDEPT') TO (DDATA+"$RDEPT1")

bFirst := {|| RDEPT->(DBSEEK("þ")) }
bWhile := {|| !RDEPT->(EOF()) }
bFor   := {|| .t.  }

EVAL(bFirst)
DBEVAL({|| nTPrice+=RDEPT->PRICE*QTY, IIF(RDEPT->PRICE > 0 ,;
           nTItem+=RDEPT->TJQTY,nTItem-=RDEPT->TJQTY ) },bFor,bWhile)

IF nTItem == 0
   WARNING(' Tidak Ada Transaksi ... ! ')
   CLOSE RDEPT
   RETURN
ENDIF

IF lTxt
   nHandle:=0
   cBuffer:=''
   LF:=CHR(13)+CHR(10)
   cMcn:=RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
   aHead:=TXTHeader({aDbf[1]},'DPT',cMcn)
   aFoot:=TXTFooter({aDbf[1]})
   cExt:='.'+SUBSTR(aDbf[1],AT('CP',aDbf[1])+2,2)
   cFile:='DPT'+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,4)+cExt
   IF (nHandle:=FCREATE(DTXT+cFile,FC_NORMAL))=-1
      Warning(' Tidak Berhasil Membuat File Text [Dos Error : '+ALLTRIM(STR(FERROR(),2))+'] ') 
      CLOSE RDEPT
      RETURN
   ENDIF
   FOR I=1 TO LEN(aHead)
       FWRITE(nHandle,aHead[I]+LF)
   NEXT
ENDIF

@ MAXROW(),0 SAY "  Printing .....  ³ ³ þþ Departemen Report þþ                                         " COLOR "N/W"
SET DEVICE TO PRINT
@ PRow()   ,00 SAY _PINIT+_PALL
@ PRow()+1 ,00  SAY REPLI('-',40)
JPrint(PRow()   ,40, REPLI('-',40))
@ PRow()+1 ,00  SAY 'DEPARTMENT REPORT   '
JPrint(PRow() ,40, 'DEPARTMENT REPORT   ')
@ PRow()+1 ,00  SAY DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle)
JPrint(PRow()   ,40,DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle))
@ PRow()+1 ,00  SAY REPLI('-',40)
JPrint(PRow()   ,40, REPLI('-',40))

EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      IF cCode <> RDEPT->DEPT              &&___LEFT(RDEPT->CODE,_DDD)
         IF nItem <> 0
            @ PRow()+2 ,00 SAY cCODE+'-'+IIF(CLASS->(DBSEEK(cCODE)),Left(CLASS->DESC,15),'???'+space(12))
            @ PRow()   ,27 SAY TRAN(nItem,'9999999')+` ITEM'
            JPrint(PRow()   ,40, cCODE+'-'+IIF(CLASS->(DBSEEK(cCODE)),Left(CLASS->DESC,15),'???'+space(12)))
            JPrint(PRow()   ,67, TRAN(nItem,'9999999')+` ITEM')
            @ PRow()+1 ,00 SAY TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')
            @ PRow()   ,27 SAY TRAN(nPrice,' 999,999,999')
            JPrint(PRow()   ,40, TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%'))
            JPrint(PRow()   ,67, TRAN(nPrice,' 999,999,999'))
            IF lTxt
               cBuffer:=cCODE+','+NumToChar('000000',nCUST)+','+;
                        NumToChar('0000000',nItem)+','+;
                        NumToChar('000000000000',nPrice)+LF
               FWRITE(nHandle,cBuffer)
            ENDIF
         ENDIF
         cCode  := RDEPT->DEPT             &&___LEFT(RDEPT->CODE,_DDD)
         nNorcp := RDEPT->NORCP
         nCust  := 1
         nItem  := 0
         nPrice := 0
      ENDIF

      IF nNorcp <> RDEPT->NORCP .AND. RDEPT->FLAG=='PLU'
         nCust++
         nNorcp := RDEPT->NORCP
      ENDIF

      nPrice+=RDEPT->PRICE*QTY
      IIF(RDEPT->PRICE > 0, nItem+=RDEPT->TJQTY, nItem-=RDEPT->TJQTY)
   ENDIF

   RDEPT->(DBSKIP())
   SET DEVICE TO SCREEN
   @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
   SET DEVICE TO PRINT
ENDDO

cMcn:=RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
@ PRow()+2 ,00 SAY cCODE+'-'+IIF(CLASS->(DBSEEK(cCODE)),Left(CLASS->DESC,15),'???'+space(12))
@ PRow()   ,27 SAY TRAN(nItem,'9999999')+` ITEM'
JPrint(PRow()   ,40, cCODE+'-'+IIF(CLASS->(DBSEEK(cCODE)),Left(CLASS->DESC,15),'???'+space(12)))
JPrint(PRow()   ,67, TRAN(nItem,'9999999')+` ITEM')
@ PRow()+1 ,00 SAY TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')
@ PRow()   ,27 SAY TRAN(nPrice,' 999,999,999')
JPrint(PRow()   ,40, TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%'))
JPrint(PRow()   ,67, TRAN(nPrice,' 999,999,999'))
@ PRow()+2 ,00 SAY "**  T o t a l  **"
JPrint(PRow()   ,40, "**  T o t a l  **")
@ PRow()+1 ,27 SAY TRAN(nTItem,'9999999')+` ITEM'
JPrint(PRow()   ,67, TRAN(nTItem,'9999999')+` ITEM')
@ PRow()+1 ,00 SAY '   100.00 %'
@ PRow()   ,27 SAY TRAN(nTPrice,'9999,999,999')
JPrint(PRow()   ,40, '   100.00 %')
JPrint(PRow()   ,67, TRAN(nTPrice,'9999,999,999'))
@ PROW()+2,00 SAY 'FROM SATELITE '
JPrint(PROW()  ,40, 'FROM SATELITE ')

IF cTitle='<Read>'
   cE:=DTos(Date())
   cE:=SUBSTR(cE,7,2)+'/'+SUBSTR(cE,5,2)
ELSE
   cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
ENDIF
@ PRow()+1 ,00 SAY '- '+cMcn+' '+SUBSTR(aDbf[1],AT("CP",aDbf[1])+2,2)+" <"+cE+">"
JPrint(PRow()   ,40, '- '+cMcn+' '+SUBSTR(aDbf[1],AT("CP",aDbf[1])+2,2)+" <"+cE+">")
@ PRow()   ,PCol() SAY CHR(13)
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

IF lTxt
   @ MAXROW(),0  SAY "  Copy File ....  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
   @ MAXROW(),19 SAY "*" COLOR "N*/W"
   IF !LGLan.AND.ChkDrv(DIRECTORY(DTXT+cFile)[1][2])
      FILECOPY(DTXT+cFile,"A:\"+cFile)
   ENDIF
ENDIF
CLOSE  RDEPT
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION DEPTDX1(cAlias)
//LEN(ALLTRIM((cAlias)->CODE)) = 8 .AND.
IF AScan({'PLU','VOD','RTN'},(cAlias)->FLAG)>0
// RETURN "þ"+LEFT((cAlias)->CODE,_DDD)+STR((cAlias)->NORCP,6)
   RETURN "þ"+(cAlias)->DEPT+STR((cAlias)->NORCP,6)
ENDIF
RETURN SPACE(9)

*-----------------------------------------------------------------------------
PROCEDURE RPDEPT180Prn(aDbf,cTitle,lTxt,lPrn)
LOCAL bFirst, bWhile, bFor,I,cM:= ' '
LOCAL nItem:= 0, nCust:= 0, nPrice:= 0
LOCAL nTItem:= 0, nTPrice:=0
LOCAL cCODE:=' ', nNorcp
LOCAL RDEPT

LOCAL nHandle:=0, cBuffer:=''
LOCAL LF, aHead, aFoot, cExt, cFile, cMcn

IF(lTxt == NIL,lTxt:=.T.,.F.)

IF SELE("CP") > 0
   CLOSE CP
ENDIF

IF SELE("RCP") > 0
   CLOSE RCP
ENDIF

USE (aDbf[1]) NEW ALIAS RDEPT
INDEX ON DEPTDX1('RDEPT') TO (DDATA+"$RDEPT1")

bFirst := {|| RDEPT->(DBSEEK("þ")) }
bWhile := {|| !RDEPT->(EOF()) }
bFor   := {|| .t.  }

EVAL(bFirst)
DBEVAL({|| nTPrice+=RDEPT->PRICE*QTY, IIF(RDEPT->PRICE > 0 ,;
           nTItem+=RDEPT->QTY,nTItem-=RDEPT->QTY ) },bFor,bWhile)

IF nTItem == 0
   WARNING(' Tidak Ada Transaksi ... ! ')
   CLOSE RDEPT
   RETURN
ENDIF

IF lTxt
   nHandle:=0
   cBuffer:=''
   LF:=CHR(13)+CHR(10)
   cMcn:=RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
   aHead:=TXTHeader({aDbf[1]},'DPT',cMcn)
   aFoot:=TXTFooter({aDbf[1]})
   cExt:='.'+SUBSTR(aDbf[1],AT('CP',aDbf[1])+2,2)
   cFile:='DPT'+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,4)+cExt
   IF (nHandle:=FCREATE(DTXT+cFile,FC_NORMAL))=-1
      Warning(' Tidak Berhasil Membuat File Text [Dos Error : '+ALLTRIM(STR(FERROR(),2))+'] ') 
      CLOSE RDEPT
      RETURN
   ENDIF
   FOR I=1 TO LEN(aHead)
       FWRITE(nHandle,aHead[I]+LF)
   NEXT
ENDIF

@ MAXROW(),0 SAY "  Printing .....  ³ ³ þþ Departemen Report þþ                                         " COLOR "N/W"
IF !lPrn ;SET PRINTER   TO $Temp.TXT
ENDIF
SET DEVICE TO PRINT
@ PRow()   ,00 SAY _PINIT+_PALL
//@ PRow()+1 ,00  SAY REPLI('-',77)
@ PRow()+1 ,00  SAY 'DEPT. REPORT    '
JPrint(PRow() ,40, 'DEPT. REPORT    ')
@ PRow()+1 ,00 SAY DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle)
@ PRow()+1 ,00  SAY REPLI('=',77)
@ PRow()+1 ,00  SAY 'Dep-Nama'
@ PRow()   ,27  SAY '  Total Item'
@ PRow()   ,54  SAY ' Total Customer   %'
@ PRow()   ,65  SAY ' Total Sales'
@ PRow()+1 ,00  SAY REPLI('=',77)

EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      IF cCode <> LEFT(RDEPT->CODE,_DDD)
         IF nItem <> 0
            @ PRow()+2 ,00 SAY cCODE+'-'+IIF(CLASS->(DBSEEK(cCODE)),Left(CLASS->DESC,15),'???')
            @ PRow()   ,20 SAY TRAN(nItem,'9999999')+` ITEM'
            @ PRow()   ,40 SAY TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')
            @ PRow()   ,65 SAY TRAN(nPrice,' 999,999,999')
            IF lTxt
               cBuffer:=cCODE+','+NumToChar('000000',nCUST)+','+;
                        NumToChar('0000000',nItem)+','+;
                        NumToChar('000000000000',nPrice)+LF
               FWRITE(nHandle,cBuffer)
            ENDIF
         ENDIF
         cCode  := LEFT(RDEPT->CODE,_DDD)
         nNorcp := RDEPT->NORCP
         nCust  := 1
         nItem  := 0
         nPrice := 0
      ENDIF

      IF nNorcp <> RDEPT->NORCP .AND. RDEPT->FLAG=='PLU'
         nCust++
         nNorcp := RDEPT->NORCP
      ENDIF

      nPrice+=RDEPT->PRICE*QTY
      IIF(RDEPT->PRICE > 0, nItem+=RDEPT->QTY, nItem-=RDEPT->QTY)
   ENDIF

   RDEPT->(DBSKIP())
   SET DEVICE TO SCREEN
   @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
   SET DEVICE TO PRINT
ENDDO

cMcn:=RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
@ PRow()+2 ,00 SAY cCODE+'-'+IIF(CLASS->(DBSEEK(cCODE)),Left(CLASS->DESC,15),'???')
@ PRow()   ,20 SAY TRAN(nItem,'9999999')+` ITEM'
@ PRow()   ,40 SAY TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')
@ PRow()   ,65 SAY TRAN(nPrice,' 999,999,999')
@ PRow()+2 ,00 SAY "**  T o t a l  **"
@ PRow()   ,20 SAY TRAN(nTItem,'9999999')+` ITEM'
@ PRow()   ,50 SAY '  100.00%'
@ PRow()   ,65 SAY TRAN(nTPrice,'9999,999,999')
@ PROW()+2,00 SAY 'FROM SATELITE '

IF cTitle='<Read>'
   cE:=DTos(Date())
   cE:=SUBSTR(cE,7,2)+'/'+SUBSTR(cE,5,2)
ELSE
   cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
ENDIF
@ PRow()+1 ,00 SAY '- '+cMcn+' '+SUBSTR(aDbf[1],AT("CP",aDbf[1])+2,2)+" <"+cE+">"
@ PRow()   ,PCol() SAY CHR(13)

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

SET DEVICE TO SCREEN
SET PRINTER TO
CLOSE RDEPT

IF lTxt
   @ MAXROW(),0  SAY "  Copy File ....  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
   @ MAXROW(),19 SAY "*" COLOR "N*/W"
   IF !LGLan.AND.ChkDrv(DIRECTORY(DTXT+cFile)[1][2])
      FILECOPY(DTXT+cFile,"A:\"+cFile)
   ENDIF
ENDIF
IF !lPrn ;TxtClose(TxtView(TxtOpen('$TEMP.TXT'),1,22,1))
ENDIF
CLOSE  RDEPT
RETURN

*------------------------------------------------------------------------------
