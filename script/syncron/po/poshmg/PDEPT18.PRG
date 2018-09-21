#include "hmg.ch"
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
PROCEDURE PDEPT18(aDbf,cTitle,lTxt,lPrn)
LOCAL bFirst, bWhile, bFor,I,cM:= ' '
LOCAL nItem:= 0, nCust:= 0, nPrice:= 0
LOCAL nTItem:= 0, nTPrice:=0, nPAGE:=0
LOCAL cCODE:=' ', nNorcp, nNOUR:=0
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

@ MAXROW(),0 SAY "  Printing EPSON  ³ ³ þþ Departemen Report þþ                                         " COLOR "N/W"

SET DEVICE TO PRINT
IF lPrn="1"
   SET PRINTER   TO $Temp.TXT
ENDIF


HEA(nPAGE,cTitle)

EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      IF cCode <> LEFT(RDEPT->DEPT,3)
         IF nItem <> 0
            IF PROW()+BOTTOM_MARGIN > PAGE_LENGTH
               EJECT
               HEA(nPAGE,cTitle)
            ENDI
            @ PRow()+1 ,01 SAY nNOUR+=1 PICT '9999'
            @ PRow()   ,10 SAY cCODE
            @ PRow()   ,21 SAY IIF(CLASS->(DBSEEK(cCODE)),Left(CLASS->DESC,15),'???')
            @ PRow()   ,39 SAY TRAN(nItem,'999,999')
            @ PRow()   ,55 SAY TRAN(nPrice,'99,999,999,999')

            IF lTxt
               cBuffer:=cCODE+','+NumToChar('000000',nCUST)+','+;
                        NumToChar('0000000',nItem)+','+;
                        NumToChar('000000000000',nPrice)+LF
               FWRITE(nHandle,cBuffer)
            ENDIF

         ENDIF
         cCode  := LEFT(RDEPT->DEPT,3)
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
   IF lPRN='2'
      SET DEVICE TO SCREEN
      @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
      SET DEVICE TO PRINT
   ENDIF
ENDDO

cMcn:=RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
IF PROW()+BOTTOM_MARGIN > PAGE_LENGTH
   EJECT
   HEA(nPAGE,cTitle)
ENDI
@ PRow()+1 ,01 SAY nNOUR+=1 PICT '9999'
@ PRow()   ,10 SAY cCODE
@ PRow()   ,21 SAY IIF(CLASS->(DBSEEK(cCODE)),Left(CLASS->DESC,15),'???')
@ PRow()   ,39 SAY TRAN(nItem,'999,999')
@ PRow()   ,55 SAY TRAN(nPrice,'99,999,999,999')
@ PRow()+1 ,01 SAY REPLI('Ä',70)
@ PRow()+2 ,37 SAY TRAN(nTItem,'9,999,999')
@ PRow()   ,54 SAY TRAN(nTPrice,'999,999,999,999')
@ PROW()+1,01 SAY 'FROM SATELITE '
IF cTitle='<Read>'
   cE:=DTos(Date())
   cE:=SUBSTR(cE,7,2)+'/'+SUBSTR(cE,5,2)
ELSE
   cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
ENDIF
@ PRow()+1 ,00 SAY '- '+cMcn+' '+SUBSTR(aDbf[1],AT("CP",aDbf[1])+2,2)+" <"+cE+">"+CHR(13)+CHR(10)
@ PROW()+1, 01 SAY CHR(12)
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
IF lPrn="1"
   LIHATTEKS('$TEMP.TXT',2,0,23,79,"W/N")
   FILEDELETE('$TEMP.TXT')
ENDIF
CLOSE  RDEPT
RETURN
*-----------------------------------------------------------------------------
STATIC FUNCTION DEPTDX1(cAlias)
IF AScan({'PLU','VOD','RTN'},(cAlias)->FLAG)>0
   RETURN "þ"+LEFT((cAlias)->DEPT,3)+STR((cAlias)->NORCP,6)
ENDIF
RETURN SPACE(9)


FUNCTION HEA(nPAGE,cTitle)
cTitle2=cTitle
SETPRC(0,0)
@ PRow()+TOP_MARGIN ,01  SAY  '<DEPARTMENT  REPORT>'
@ PRow()   ,61  SAY 'HAL : '
@ PRow()   ,67  SAY TRAN(++nPAGE,'999')
@ PRow()+1 ,01  SAY DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle2)
@ PRow()+1 ,01  SAY REPLI('Ä',70)
@ PRow()+1 ,03  SAY 'NO'
@ PRow()   ,10  SAY 'CODE'
@ PRow()   ,21  SAY 'DESCRIPTION'
@ PRow()   ,43  SAY 'QTY'
@ PRow()   ,63  SAY 'AMOUNT'
@ PROW()+1 ,01  SAY REPLI('Ä',70)
RETURN

