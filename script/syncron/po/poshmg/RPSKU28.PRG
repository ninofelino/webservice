#include "hmg.ch"
#include "kassa.ch"
#DEFINE TOP_MARGIN      4
#DEFINE BOTTOM_MARGIN   4
#DEFINE PAGE_LENGTH     60    // 72 FOLIO
#define FC_NORMAL    0

*--------------------------------------------------------80Col_RESET_PLU_OnLine
PROCEDURE RPSKU28(aDbf,cTitle,lTxt,lPrn)
LOCAL aStruct:={}, cFlTmp:=DDATA+'$G8SKUL.DBF'
LOCAL RG8SKUL,DBF1, DBF2, cM:=' ', nPAGE:=0
LOCAL cWARNA:=SETCOLOR("W")
LOCAL bFirst, bWhile, bFor, I
LOCAL nItem:= 0, nCust:= 0, nPrice:= 0, nCPrice:=0, nProfit:=0
LOCAL nTItem:= 0, nTPrice:=0, nTCPrice:=0, nTProfit:=0
LOCAL cCODE:=' ', nNORCP:=0, nMACHINE:=0

LOCAL nHandle:=0, cBuffer:=''
LOCAL LF, aHead, aFoot, cExt, cFile, cMcn

IF(lTxt == NIL,lTxt:=.T.,.F.)
IF VALTYPE(aDbf) <> 'A' .OR. EMPTY(aDbf)
   WARNING(' File Belum Dipilih ... ! ')
   RETURN
ENDIF


IF SELE("CP") > 0
   CLOSE CP
ENDIF

IF SELE("RCP") > 0
   CLOSE RCP
ENDIF

USE (aDBF[1]) NEW SHARED ALIAS DBF1
aStruct:=DBF1->(DBSTRUCT())
CLOSE DBF1

AADD(aStruct,{'MACHINE','N',8,0})
DBCREATE(cFlTmp,aStruct)

IF !GabDbf(cFlTmp,aDbf)
   WARNING(' Tidak Ada Transaksi ... ! ')
   RETURN
ENDIF

USE (cFlTmp) NEW ALIAS RG8SKUL
INDEX ON LEFT(CODE,8)+STR(NORCP)+STR(MACHINE)  TO (DDATA+"$RG8SKUL1")

bFirst := {|| RG8SKUL->(DBGOTOP()) }
bWhile := {|| !RG8SKUL->(EOF())  }
bFor   := {|| .T. }

EVAL(bFirst)
DBEVAL({|| nTPrice+=RG8SKUL->PRICE*QTY,  nTCPRICE+=RG8SKUL->CPRICE*QTY, IIF(RG8SKUL->PRICE > 0 ,;
           nTItem+=RG8SKUL->TJQTY,nTItem-=RG8SKUL->TJQTY ) },bFor,bWhile)

IF nTItem == 0
   WARNING(' Tidak Ada Transaksi ... ! ')
   CLOSE RG8SKUL
   RETURN
ENDIF

nTPROFIT:=nTPRICE-nTCPRICE

FOR I=1 TO LEN(aDbf)
    cD:=SubS(aDbf[I],AT("CP",aDbf[I])+2,2)
    IF lGLan  
       DLL->(DBGoto(Val(cD)))
       nD  :=DLL->(MCHNID)
       cMcn:=RIGHT('000000'+ALLTRIM(STR(nD)),6)
    ENDIF
NEXT

@ MAXROW(),0 SAY "  Prosessing....  ³ ³ þþ P L U      Report þþ                                         " COLOR "N/W"

SET DEVICE TO PRINT
IF lPrn="1" ;SET PRINTER   TO $Temp.TXT
ENDIF


HPLU(cTitle,nPAGE)

EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      IF cCode <> LEFT(RG8SKUL->CODE,8)          // CODE,_DDD)
         IF nItem <> 0
           IF PROW()+BOTTOM_MARGIN > PAGE_LENGTH
              EJECT
              HPLU(cTitle,nPAGE)                                 // SETPRC(0,0)
            ENDI
            @ PRow()+1 ,01 SAY cCODE
            @ PRow()   ,15 SAY IIF(PRODUK->(DBSEEK(cCODE)),Left(PRODUK->DESC,30),cDESC)
            @ PRow()   ,46 SAY TRAN(nITEM,'9,999,999')
            * @ PRow()   ,49 SAY TRAN(nCUST,'999,999')
            * @ PRow()   ,56 SAY TRAN(nPRICE/nTPRICE*100,'999.99%')
            @ PRow()   ,56 SAY TRAN(nPRICE,'999,999,999')
            @ PRow()   ,68 SAY TRAN(nPROFIT,'999,999,999')
         ENDIF
         cCode   := LEFT(RG8SKUL->CODE,8)         // CODE,_DDD)
         cDESC   := RG8SKUL->DESC
         nNorcp  := RG8SKUL->NORCP
         nMACHINE:= RG8SKUL->MACHINE
         nCust   := 1
         nItem   := 0
         nPrice  := 0
         nCPrice := 0
      ENDIF

      IF (nNorcp <> RG8SKUL->NORCP .OR. nMACHINE <> RG8SKUL->MACHINE);
         .AND. RG8SKUL->FLAG=='PLU'
         nCust++
         nNorcp  := RG8SKUL->NORCP
         nMACHINE:= RG8SKUL->MACHINE
      ENDIF

      nPrice+=RG8SKUL->PRICE*QTY
      nCPrice+=RG8SKUL->CPRICE*QTY
      nProfit := nPrice-nCPrice
      IIF(RG8SKUL->PRICE > 0, nItem+=RG8SKUL->TJQTY, nItem-=RG8SKUL->TJQTY)
   ENDIF
   RG8SKUL->(DBSKIP())
   IF lPRN='2'
      SET DEVICE TO SCREEN
      @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
      SET DEVICE TO PRINT
   ENDIF
ENDDO
cMcn:=RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
IF PROW()+BOTTOM_MARGIN > PAGE_LENGTH
   EJECT
   HPLU(cTitle,nPAGE)                                 // SETPRC(0,0)
 ENDI
@ PRow()+1 ,01 SAY cCODE
@ PRow()   ,15 SAY  IIF(PRODUK->(DBSEEK(cCODE)),Left(PRODUK->DESC,30),cDESC)  // cDESC
@ PRow()   ,46 SAY TRAN(nITEM,'9,999,999')
* @ PRow()   ,49 SAY TRAN(nCUST,'999,999')
* @ PRow()   ,56 SAY TRAN(nPRICE/nTPRICE*100,'999.99%')
@ PRow()   ,56 SAY TRAN(nPRICE,'999,999,999')
@ PRow()   ,68 SAY TRAN(nPROFIT,'999,999,999')
@ PROW()+1 ,01 SAY REPL('=',78)
@ PRow()+1 ,01 SAY '    T O T A L    '
@ PRow()   ,46 SAY TRAN(nTITEM,'9,999,999')
* @ PRow()   ,56 SAY '100.00%'
@ PRow()   ,56 SAY TRAN(nTPRICE,'999,999,999')
@ PRow()   ,68 SAY TRAN(nTPROFIT,'999,999,999')
@ PROW()+1 ,01 SAY REPL('=',78)
@ PROW()+1 ,01 SAY 'FROM SATELITE '

FOR I=1 TO LEN(aDbf)
    cD:=SubS(aDbf[I],AT("CP",aDbf[I])+2,2)
    IF lGLan  
       DLL->(DBGoto(Val(cD)))
       nD:=DLL->(MCHNID)
       cD:=RIGHT('000000'+ALLTRIM(STR(nD)),6)
       IF cTitle='<Read>'
          cE:=DTos(Date())
          cE:=SUBSTR(cE,7,2)+'/'+SUBSTR(cE,5,2)
       ELSE
          cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
       ENDIF
       DT:='- '+cD+' '+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+cE+">"

       @ PROW()+1,2 SAY IF(LEN(DT)<33,DT+SPACE(33-LEN(DT)),DT)
    ELSEIF cD=SATELITE->(SubS(CPNO,AT("CP",CPNO)+2,2))
       nD:=SATELITE->MCHNID
       cD:=Str(nD)
       IF cTitle='<Read>'
          cE:=DTos(Date())
          cE:=SUBSTR(cD,7,2)+'/'+SUBSTR(cD,5,2)
       ELSE
          cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
       ENDIF
       
       DT:='- '+cD+' '+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+cE+">"
       @ PROW()+1,2 SAY IF(LEN(DT)<33,DT+SPACE(33-LEN(DT)),DT)
    ENDIF
NEXT
@ PRow()+1 ,01 SAY CHR(12)
SET DEVICE TO SCREEN
SET PRINTER TO
IF lPrn="1"
   LIHATTEKS('$TEMP.TXT',2,0,23,79,"W/N")
   FILEDELETE('$TEMP.TXT')
ENDIF
CLOSE  RG8SKUL
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION GabDbf(cFlTmp,aDbf)
LOCAL I, nMACHINE:=0
LOCAL bFirst, bWhile, bFor
LOCAL FL1,FL2

bFirst := {|| FL2->(DBSEEK("þ")) }
bWhile := {|| !FL2->(EOF()) }
bFor   := {|| .t.  }

USE (cFlTmp) NEW ALIAS FL1

FOR I=1 TO LEN(aDbf)
    USE (aDbf[I]) NEW SHARED ALIAS FL2
    FL2->(DBGOTOP())
    DO WHILE FL2->FLAG<>'NEW' .AND. !FL2->(EOF())
       FL2->(DBSKIP())
    ENDDO
    IF FL2->(EOF())
       CLOSE FL2
       LOOP
    ENDIF
    nMACHINE:=FL2->PRICE

    SELE FL2
    INDEX ON DEPTDX1('FL2') TO (DDATA+"$RGDPLU2")
    EVAL(bFirst)
    DO WHILE EVAL(bWhile)
       IF EVAL(bFor)
          FL1->(DBAPPEND())
          FL1->FLAG    := FL2->FLAG
          FL1->CODE    := FL2->CODE
          FL1->DESC    := FL2->DESC
          FL1->GROUP   := FL2->GROUP
          FL1->DEPT    := FL2->DEPT
          FL1->QTY     := FL2->QTY
          FL1->PRICE   := FL2->PRICE
          FL1->CPRICE  := FL2->CPRICE
          FL1->NORCP   := FL2->NORCP
          FL1->MACHINE := nMACHINE
       ENDIF
       FL2->(DBSKIP())
    ENDDO
    CLOSE FL2
NEXT

IF FL1->(LASTREC()) == 0
   CLOSE FL1
   RETURN .F.
ENDIF
CLOSE FL1
RETURN .T.

*-----------------------------------------------------------------------------
STATIC FUNCTION DEPTDX1(cAlias)
IF AScan({'PLU','VOD','RTN'},(cAlias)->FLAG)>0
   RETURN "þ"
ENDIF
RETURN " "

*-----------------------------------------------------------------------------
FUNCTION HPLU(cTitle,nPAGE)
cTitle2=cTitle
SETPRC(0,0)
@ PRow()+TOP_MARGIN ,01  SAY  'P.L.U. REPORT'
@ PRow()   ,68  SAY 'Hal.: '
@ PRow()   ,74  SAY TRAN(++nPAGE,'999')
@ PRow()+1 ,01  SAY DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle2)
@ PRow()+1 ,01  SAY REPLI('=',78)
@ PRow()+1 ,01  SAY 'CODE'
@ PRow()   ,15  SAY 'DESCRIPTION'
@ PRow()   ,51  SAY '  ITEM'
* @ PRow()   ,51  SAY ' CUST'
* @ PRow()   ,58  SAY ' PRCN'
@ PRow()   ,58  SAY 'TOTAL SALES'
@ PRow()   ,73  SAY 'PROFIT'
@ PRow()+1 ,01  SAY REPLI('=',78)
RETURN

*-----------------------------------------------------------------------------




