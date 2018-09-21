#include "hmg.ch"
#include "kassa.ch"
#define FC_NORMAL    0
*-----------------------------------------------------------------------------
PROCEDURE RPPLUC2(aDbf,cTitle,lTxt,cMth,aInline)
LOCAL aStruct:={}, cFlTmp:=DDATA+'$GPLUC.DBF'
LOCAL RGPLUC,DBF1, DBF2, cM:=' '

LOCAL bFirst, bWhile, bFor, I
LOCAL nItem:= 0, nCust:= 0, nPrice:= 0
LOCAL nTItem:= 0, nTPrice:=0
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

USE (cFlTmp) NEW ALIAS RGPLUC
INDEX ON LEFT(CODE,8)+STR(NORCP)+STR(MACHINE)  TO (DDATA+"$RGPLUC1")

bFirst := {|| RGPLUC->(DBGOTOP()) }
bWhile := {|| !RGPLUC->(EOF())  }
bFor   := {|| .T. }

EVAL(bFirst)
DBEVAL({|| nTPrice+=RGPLUC->PRICE*QTY, IIF(RGPLUC->PRICE > 0 ,;
           nTItem+=RGPLUC->TJQTY,nTItem-=RGPLUC->TJQTY ) },bFor,bWhile)

IF nTItem == 0
   WARNING(' Tidak Ada Transaksi ... ! ')
   CLOSE RGPLUC
   RETURN
ENDIF

FOR I=1 TO LEN(aDbf)
    cD:=SubS(aDbf[I],AT("CP",aDbf[I])+2,2)
    IF lGLan  
       DLL->(DBGoto(Val(cD)))
       nD  :=DLL->(MCHNID)
       cMcn:=RIGHT('000000'+ALLTRIM(STR(nD)),6)
    ENDIF
NEXT

@ MAXROW(),0 SAY "  Printing .....  ³ ³ þþ PLU Reset  Report þþ                                         " COLOR "N/W"
S_PRINT(REPLI('-',40))
SET DEVICE TO PRINT
@ PRow()+1 ,00  SAY 'P.L.U. REPORT       '
JPrint(PRow() ,40, 'P.L.U. REPORT       ')
SET DEVICE TO SCREEN
DTK:=DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle)
S_PRINT(IF(LEN(DTK)<40,DTK+SPACE(40-LEN(DTK)),DTK))
S_PRINT(REPLI('-',40))

EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      IF cCode <> LEFT(RGPLUC->CODE,8)
         IF nItem <> 0
            S_PRINT(SPACE(40))
            DTK:=cCODE+'-'+IIF(PRODUK->(DBSEEK(cCODE)),Left(PRODUK->DESC,10),'???')
            S_PRINT(IF(LEN(DTK)<19,DTK+SPACE(19-LEN(DTK)),DTK)+SPACE(8)+TRAN(nItem,'9999999')+'  ITEM')
            S_PRINT(TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')+;
                    TRAN(nPrice,'          999,999,999'))
         ENDIF
         cCode   := LEFT(RGPLUC->CODE,8)
         nNorcp  := RGPLUC->NORCP
         nMACHINE:= RGPLUC->MACHINE
         nCust   := 1
         nItem   := 0
         nPrice  := 0
      ENDIF
      IF (nNorcp <> RGPLUC->NORCP .OR. nMACHINE <> RGPLUC->MACHINE);
         .AND. RGPLUC->FLAG=='PLU'
         nCust++
         nNorcp  := RGPLUC->NORCP
         nMACHINE:= RGPLUC->MACHINE
      ENDIF
      nPrice+=RGPLUC->PRICE*QTY
      IIF(RGPLUC->PRICE > 0, nItem+=RGPLUC->TJQTY, nItem-=RGPLUC->TJQTY)
   ENDIF
   RGPLUC->(DBSKIP())
   @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
ENDDO
S_PRINT(SPACE(40))
DTK:=cCODE+'-'+IIF(PRODUK->(DBSEEK(cCODE)),Left(PRODUK->DESC,10),'???')
S_PRINT(IF(LEN(DTK)<19,DTK+SPACE(19-LEN(DTK)),DTK)+TRAN(nItem,'        9999999')+'  ITEM')
S_PRINT(TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')+;
        TRAN(nPrice,'          999,999,999'))
S_PRINT(SPACE(33))
S_PRINT("**  T o t a l  **" +TRAN(nTItem,'           9999999')+` ITEM')
S_PRINT('   100.00 %'+SPACE(17)+TRAN(nTPrice,'9999,999,999'))
S_PRINT(SPACE(40))
S_PRINT('FROM SATELITE '+SPACE(26))

IF cMth == 'MONTH'
   FOR nInl=1 TO LEN(aInline)
       cIn1:=SubS(aINLINE[nINL],AT("CP",aINLINE[nINL])+2,2)
       cIn2:=SubS(aINLINE[nINL],AT("CP",aINLINE[nINL])+4,4)
       cIN21:=LEFT(cIN2,2)
       cIN22:=RIGHT(cIN2,2)
       IF NNETLOGGED()
          DLL->(DBGoto(Val(cIn1)))
          nD:=DLL->(MCHNID) ;cD:=RIGHT('000000'+ALLTRIM(STR(nD)),6)      // ;cMcn:=cD
          DT:='- '+cD+' '+cIN1+' '+'<'+cIN22+'/'+cIN21+'>'
       ELSE
          nD:=SATELITE->MCHNID;cD:=RIGHT('000000'+ALLTRIM(STR(nD)),6)      // ;cMcn:=cD
          DT:='- '+cD+' '+cIN1+' '+'<'+cIN22+'/'+cIN21+'>'
       ENDIF
       S_PRINT(IF(LEN(DT)<40,DT+SPACE(40-LEN(DT)),DT))
   NEXT nInl
ELSE
   FOR I=1 TO LEN(aDbf)
       cD:=SubS(aDbf[I],AT("CP",aDbf[I])+2,2)
       IF lGLan
          DLL->(DBGoto(Val(cD)))
          nD:=DLL->(MCHNID)
          cD:=RIGHT('000000'+ALLTRIM(STR(nD)),6)
          IF cTitle='<Read>'
             cD1:=DTos(Date())
             cE:=SUBSTR(cD1,7,2)+'/'+SUBSTR(cD1,5,2)
          ELSE
             cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
          ENDIF
          DTK:= '- '+cD+' '+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+cE+">"
          S_PRINT(IF(LEN(DTK)<40,DTK+SPACE(40-LEN(DTK)),DTK))
       ELSEIF cD=SATELITE->(SubS(CPNO,AT("CP",CPNO)+2,2))
          nD:=SATELITE->MCHNID
          cD:=Str(nD)
          IF cTitle='<Read>'
             cD:=DTos(Date())
             cE:=SUBSTR(cD,7,2)+'/'+SUBSTR(cD,5,2)
          ELSE
             cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
          ENDIF
          DTK:='- '+cD+' '+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+cE+">"
          S_PRINT(IF(LEN(DTK)<40,DTK+SPACE(40-LEN(DTK)),DTK))
       ENDIF
   NEXT
ENDIF
PCutter()
COPY TO DAT\PLUMONTH
CLOSE RGPLUC
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
    INDEX ON DEPTDX1('FL2') TO (DDATA+"$RGPLUC2")
    EVAL(bFirst)
    DO WHILE EVAL(bWhile)
       IF EVAL(bFor)
          FL1->(DBAPPEND())
          FL1->FLAG    := FL2->FLAG
          FL1->CODE    := FL2->CODE
          FL1->DESC    := FL2->DESC
          FL1->QTY     := FL2->QTY
          FL1->PRICE   := FL2->PRICE
          FL1->NORCP   := FL2->NORCP
          FL1->MACHINE := nMACHINE
          FL1->GROUP   := FL2->GROUP
          FL1->DEPT    := FL2->DEPT
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
IF ( (cAlias)->FLAG == 'PLU' .OR. (cAlias)->FLAG == 'VOD'.OR. (cAlias)->FLAG == 'RTN' )
   RETURN "þ"
ENDIF
RETURN " "
*-----------------------------------------------------------------------------

