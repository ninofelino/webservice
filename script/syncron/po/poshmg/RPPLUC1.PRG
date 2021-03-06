#include "hmg.ch"
#include "kassa.ch"
#define FC_NORMAL    0
*-----------------------------------------------------------------------------
PROCEDURE RPPLUC1(aDbf,cTitle,lTxt)
LOCAL bFirst, bWhile, bFor,I,cM:= ' '
LOCAL nItem:= 0, nCust:= 0, nPrice:= 0
LOCAL nTItem:= 0, nTPrice:=0
LOCAL cCODE:=' ', nNorcp
LOCAL RPLUC

LOCAL nHandle:=0, cBuffer:=''
LOCAL LF, aHead, aFoot, cExt, cFile, cMcn

IF(lTxt == NIL,lTxt:=.T.,.F.)


IF SELE("CP") > 0
   CLOSE CP
ENDIF

IF SELE("RCP") > 0
   CLOSE RCP
ENDIF

USE (aDbf[1]) NEW ALIAS RPLUC
INDEX ON DEPTDX1('RPLUC') TO (DDATA+"$RPLUC1")

bFirst := {|| RPLUC->(DBSEEK("�")) }
bWhile := {|| !RPLUC->(EOF()) }
bFor   := {|| .t.  }

EVAL(bFirst)
DBEVAL({|| nTPrice+=RPLUC->PRICE*QTY, IIF(RPLUC->PRICE > 0 ,;
           nTItem+=RPLUC->TJQTY,nTItem-=RPLUC->TJQTY ) },bFor,bWhile)

IF nTItem == 0
   WARNING(' Tidak Ada Transaksi ... ! ')
   CLOSE RPLUC
   RETURN
ENDIF

@ MAXROW(),0 SAY "  Printing .....  � � �� PLU Report Reset  ��                                         " COLOR "N/W"
SET DEVICE TO PRINT
@ PRow()   ,00 SAY _PINIT+_PALL
@ PRow()+1 ,00  SAY REPLI('-',40)
JPrint(PRow()   ,40, REPLI('-',40))
@ PRow()+1 ,00  SAY 'P.L.U. REPORT       '
JPrint(PRow() ,40, 'P.L.U. REPORT       ')
@ PRow()+1 ,00  SAY DTOC(DATE())+"�"+IF(lGTimePr='Y',Time(),'')+"�"+IF(cTitle == NIL ,'',cTitle)
JPrint(PRow()   ,40, DTOC(DATE())+"�"+IF(lGTimePr='Y',Time(),'')+"�"+IF(cTitle == NIL ,'',cTitle))
@ PRow()+1 ,00  SAY REPLI('-',40)
JPrint(PRow()   ,40, REPLI('-',40))

EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      IF cCode <> LEFT(RPLUC->CODE,8)
         IF nItem <> 0
            @ PRow()+2 ,00 SAY cCODE+'-'+IIF(PRODUK->(DBSEEK(cCODE)),Left(PRODUK->DESC,15),'???')
            @ PRow()   ,27 SAY TRAN(nItem,'9999999')+` ITEM'
            JPrint(PRow()   ,40, cCODE+'-'+IIF(PRODUK->(DBSEEK(cCODE)),Left(PRODUK->DESC,15),'???'))
            JPrint(PRow()   ,67, TRAN(nItem,'9999999')+` ITEM')
            @ PRow()+1 ,00 SAY TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')
            @ PRow()   ,27 SAY TRAN(nPrice,' 999,999,999')
            JPrint(PRow()   ,40, TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%'))
            JPrint(PRow()   ,67, TRAN(nPrice,' 999,999,999'))
         ENDIF
         cCode  := LEFT(RPLUC->CODE,8)
         nNorcp := RPLUC->NORCP
         nCust  := 1
         nItem  := 0
         nPrice := 0
      ENDIF
      IF nNorcp <> RPLUC->NORCP .AND. RPLUC->FLAG=='PLU'
         nCust++
         nNorcp := RPLUC->NORCP
      ENDIF
      nPrice+=RPLUC->PRICE*QTY
      IIF(RPLUC->PRICE > 0, nItem+=RPLUC->TJQTY, nItem-=RPLUC->TJQTY)
   ENDIF
   RPLUC->(DBSKIP())
   SET DEVICE TO SCREEN
   @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
   SET DEVICE TO PRINT
ENDDO

cMcn:=RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
@ PRow()+2 ,00 SAY cCODE+'-'+IIF(PRODUK->(DBSEEK(cCODE)),Left(PRODUK->DESC,15),'???')
@ PRow()   ,27 SAY TRAN(nItem,'9999999')+` ITEM'
JPrint(PRow()   ,40, cCODE+'-'+IIF(PRODUK->(DBSEEK(cCODE)),Left(PRODUK->DESC,15),'???'))
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
JPrint(PROW()+0,40, 'FROM SATELITE ')

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
SET PRINTER TO
SET DEVICE TO SCREEN
CLOSE  RPLUC
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION DEPTDX1(cAlias)
IF AScan({'PLU','VOD','RTN'},(cAlias)->FLAG)>0
   RETURN "�"+LEFT((cAlias)->CODE,8)+STR((cAlias)->NORCP,6)
ENDIF
RETURN SPACE(9)
*-----------------------------------------------------------------------------


