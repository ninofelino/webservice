#include "kassa.ch"
#define FC_NORMAL    0
#DEFINE TOP_MARGIN      4
#DEFINE BOTTOM_MARGIN   4
#DEFINE PAGE_LENGTH     60    // 72 FOLIO

*-----------------------------------------------------------------------------
//          1         2         3         4         5         6         7
// 1234567890123456789012345678901234567890123456789012345678901234567890
//   NO     CODE       DESCRIPTION           QTY                 AMOUNT
// 9999     9999       X-------------X   999,999         99,999,999,999
// ======================================================================

PROCEDURE PPLUK18(aDbf,cTitle,lTxt,lPrn)
LOCAL bFirst, bWhile, bFor,I,cM:= ' '
LOCAL nItem:= 0, nCust:= 0, nPrice:= 0, nCPrice:=0, nProfit:=0
LOCAL nTItem:= 0, nTPrice:=0, nPAGE:=0, nTCPrice:=0, nTProfit:=0
LOCAL cCODE:=' ', nNorcp, nNOUR:=0
LOCAL RPLUK

LOCAL nHandle:=0, cBuffer:=''
LOCAL LF, aHead, aFoot, cExt, cFile, cMcn

IF(lTxt == NIL,lTxt:=.T.,.F.)

IF SELE("CP") > 0
   CLOSE CP
ENDIF

IF SELE("RCP") > 0
   CLOSE RCP
ENDIF

USE (aDbf[1]) NEW ALIAS RPLUK
INDEX ON PLUKDX1('RPLUK') TO (DDATA+"$RPLUK1")

bFirst := {|| RPLUK->(DBSEEK("þ")) }
bWhile := {|| !RPLUK->(EOF()) }
bFor   := {|| .t.  }

EVAL(bFirst)
DBEVAL({|| nTPrice+=RPLUK->PRICE*QTY, nTCPRICE+=RPLUK->CPRICE*TJQTY, IIF(RPLUK->PRICE > 0 ,;
           nTItem+=RPLUK->TJQTY,nTItem-=RPLUK->TJQTY ) },bFor,bWhile)

IF nTItem == 0
   WARNING(' Tidak Ada Transaksi ... ! ')
   CLOSE RPLUK
   RETURN
ENDIF

nTPROFIT:=nTPRICE-nTCPRICE

@ MAXROW(),0 SAY "  Printing 80-Col ³ ³ þþ   P L U    Report þþ                                         " COLOR "N/W"

SET DEVICE TO PRINT
IF lPrn="1"
   SET PRINTER TO $Temp.TXT
ENDIF


HEA(nPAGE,cTitle)

EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      IF cCode <> LEFT(RPLUK->CODE,8)
         IF nItem <> 0
            IF PROW()+BOTTOM_MARGIN > PAGE_LENGTH
               EJECT
               HEA(nPAGE,cTitle)
            ENDI
            * @ PRow()+1 ,01 SAY nNOUR+=1 PICT '9999'
            @ PRow()+1 ,01 SAY cCODE
            @ PRow()   ,15 SAY IIF(PRODUK->(DBSEEK(cCODE)),Left(PRODUK->DESC,30),'???')
            @ PRow()   ,46 SAY TRAN(nItem,'9,999,999')
            @ PRow()   ,56 SAY TRAN(nPrice,'999,999,999')
            @ PRow()   ,68 SAY TRAN(nPROFIT,'999,999,999')
         ENDIF
         cCode  := LEFT(RPLUK->CODE,8)
         nNorcp := RPLUK->NORCP
         nCust  := 1
         nItem  := 0
         nPrice := 0
         nCPrice := 0
      ENDIF
      IF nNorcp <> RPLUK->NORCP .AND. RPLUK->FLAG=='PLU'
         nCust++
         nNorcp := RPLUK->NORCP
      ENDIF
      nPrice+=RPLUK->PRICE*QTY
      nCPrice+=RPLUK->CPRICE*TJQTY
      nProfit := nPrice-nCPrice
      IIF(RPLUK->PRICE > 0, nItem+=RPLUK->TJQTY, nItem-=RPLUK->TJQTY)
   ENDIF
   RPLUK->(DBSKIP())
   IF lPRN="2"
      SET DEVICE TO SCREEN
      @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
      SET DEVICE TO PRINT
   endif
ENDDO

cMcn:=RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
IF PROW()+BOTTOM_MARGIN > PAGE_LENGTH
   EJECT
   HEA(nPAGE,cTitle)
ENDI
* @ PRow()+1 ,01 SAY nNOUR+=1 PICT '9999'
@ PRow()+1 ,01 SAY cCODE
@ PRow()   ,15 SAY IIF(PRODUK->(DBSEEK(cCODE)),Left(PRODUK->DESC,15),'???')
@ PRow()   ,46 SAY TRAN(nItem,'9,999,999')
@ PRow()   ,56 SAY TRAN(nPrice,'999,999,999')
@ PRow()   ,68 SAY TRAN(nPROFIT,'999,999,999')
@ PRow()+1 ,01 SAY REPLI('=',78)

@ PRow()+1 ,01 SAY 'T O T A L'
@ PRow()   ,46 SAY TRAN(nTItem,'9,999,999')
@ PRow()   ,56 SAY TRAN(nTPrice,'999,999,999')
@ PRow()   ,68 SAY TRAN(nTPROFIT,'999,999,999')
@ PROW()+1 ,01 SAY 'FROM SATELITE '
IF cTitle='<Read>'
   cE:=DTos(Date())
   cE:=SUBSTR(cE,7,2)+'/'+SUBSTR(cE,5,2)
ELSE
   cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
ENDIF
@ PRow()+1 ,00 SAY '- '+cMcn+' '+SUBSTR(aDbf[1],AT("CP",aDbf[1])+2,2)+" <"+cE+">"+CHR(13)+CHR(10)
@ PROW()+1, 01 SAY CHR(12)

SET DEVICE TO SCREEN
SET PRINTER TO
IF lPrn="1"
   LIHATTEKS('$TEMP.TXT',2,0,23,79,"W/N")
   FILEDELETE('$TEMP.TXT')
ENDIF
CLOSE  RPLUK
RETURN
*-----------------------------------------------------------------------------
STATIC FUNCTION PLUKDX1(cAlias)
IF AScan({'PLU','VOD','RTN'},(cAlias)->FLAG)>0
   RETURN "þ"+LEFT((cAlias)->CODE,3)+STR((cAlias)->NORCP,6)
ENDIF
RETURN SPACE(9)

*-----------------------------------------------------------------------------
STATIC PROCEDURE HEA(nPAGE,cTitle)
cTitle2=cTitle
SETPRC(0,0)
@ PRow()+TOP_MARGIN ,01  SAY  '<  P L U  REPORT  >'
@ PRow()+1 ,01  SAY DTOC(DATE())+"þ"+TIME()+"þ"+IF(cTitle == NIL ,'',cTitle2)
@ PRow()   ,70  SAY 'HAL : '
@ PRow()   ,76  SAY TRAN(++nPAGE,'999')
@ PRow()+1 ,01  SAY REPLI('=',78)
* @ PRow()+1 ,03  SAY 'NO'
@ PRow()+1 ,01  SAY 'CODE'
@ PRow()   ,15  SAY 'DESCRIPTION'
@ PRow()   ,51  SAY 'ITEM'
@ PRow()   ,58  SAY 'TTL_SALES'
@ PRow()   ,73  SAY 'PROFIT'
@ PROW()+1 ,01  SAY REPLI('=',78)
RETURN

*-----------------------------------------------------------------------------

