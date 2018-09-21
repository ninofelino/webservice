#include "hmg.ch"
#include "kassa.ch"
#define FC_NORMAL    0
*-----------------------------------------------------------------------------
PROCEDURE RPGRP2(aDbf,cTitle,lTxt,cMth,aInline)
LOCAL aStruct:={}, cFlTmp:=DDATA+'$GDEPT.DBF'
LOCAL RGDEPT,DBF1, DBF2, cM:=' '

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

//AEVAL(aDbf,{|cF| AADD(aSATELITE,SUBSTR(cF,AT("CP",cF)+2,2) ) } )
//@ MAXROW(),0  SAY "  Proses .......  ³ ³ þþ Group Report þþ                                              " COLOR "N/W"
//@ MAXROW(),19 SAY "*" COLOR "N*/W"

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

USE (cFlTmp) NEW ALIAS RGDEPT
INDEX ON GROUP+STR(NORCP)+STR(MACHINE)  TO (DDATA+"$RGDEPT1")

bFirst := {|| RGDEPT->(DBGOTOP()) }
bWhile := {|| !RGDEPT->(EOF())  }
bFor   := {|| .T. }

EVAL(bFirst)
DBEVAL({|| nTPrice+=RGDEPT->PRICE*QTY, IIF(RGDEPT->PRICE > 0 ,;
           nTItem+=RGDEPT->TJQTY,nTItem-=RGDEPT->TJQTY ) },bFor,bWhile)

IF nTItem == 0
   WARNING(' Tidak Ada Transaksi ... ! ')
   CLOSE RGDEPT
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

IF lTxt
   nHandle:=0
   cBuffer:=''
   LF:=CHR(13)+CHR(10)
   aHead:=TXTHeader(aDbf,'GRP',cMcn)
   aFoot:=TXTFooter(aDbf)
   cExt:='.'+IF(LEN(aDbf)>1,'GAB',SUBSTR(aDbf[1],AT('CP',aDbf[1])+2,2))
   cFile:='GRP'+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,4)+cExt
   IF (nHandle:=FCREATE(NTXT+cFile,FC_NORMAL))=-1
      Warning(' Tidak Berhasil Membuat File Text [Dos Error : '+ALLTRIM(STR(FERROR(),2))+'] ') 
      CLOSE RGDEPT
      RETURN
   ENDIF
   FOR I=1 TO LEN(aHead)
       FWRITE(nHandle,aHead[I]+LF)
   NEXT
ENDIF

@ MAXROW(),0 SAY "  Printing .....  ³ ³ þþ Group Report þþ                                              " COLOR "N/W"
S_PRINT(REPLI('-',40))
SET DEVICE TO PRINTER
@ PRow()+1 ,00  SAY 'GROUP REPORT        '
JPrint(PRow() ,40, 'GROUP REPORT        ')
IF cMth=='MONTH'
   @ PRow()+1 ,00  SAY '<    M O N T H     >'
   JPrint(PRow() ,40, '<    M O N T H     >')
ENDIF
SET DEVICE TO SCREEN
DT:=DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle)
S_PRINT(IF(LEN(DT)<40,DT+SPACE(40-LEN(DT)),DT))
S_PRINT(REPLI('-',40))

EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      IF cCode <> LEFT(RGDEPT->GROUP,2)
         IF nItem <> 0
            S_PRINT(SPACE(40))
            S_PRINT(cCODE+'-'+IIF(GROUP->(DBSEEK(cCODE)),Left(GROUP->DESC,15),'???'+SPACE(12))+;
            SPACE(10)+TRAN(nItem,'9999999')+` ITEM')
            S_PRINT(TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')+;
             +TRAN(nPrice,'          999,999,999'))
            IF lTxt
               cBuffer:=cCODE+','+NumToChar('000000',nCUST)+','+;
                        NumToChar('0000000',nItem)+','+;
                        NumToChar('000000000000',nPrice)+LF
               FWRITE(nHandle,cBuffer)
            ENDIF
         ENDIF
         cCode   := LEFT(RGDEPT->GROUP,2)
         nNorcp  := RGDEPT->NORCP
         nMACHINE:= RGDEPT->MACHINE
         nCust   := 1
         nItem   := 0
         nPrice  := 0
      ENDIF
      IF (nNorcp <> RGDEPT->NORCP .OR. nMACHINE <> RGDEPT->MACHINE);
         .AND. RGDEPT->FLAG=='PLU'
         nCust++
         nNorcp  := RGDEPT->NORCP
         nMACHINE:= RGDEPT->MACHINE
      ENDIF
      nPrice+=RGDEPT->PRICE*QTY
      IIF(RGDEPT->PRICE > 0, nItem+=RGDEPT->TJQTY, nItem-=RGDEPT->TJQTY)
   ENDIF
   RGDEPT->(DBSKIP())
   @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
ENDDO
S_PRINT(SPACE(40))
S_PRINT(cCODE+'-'+IIF(GROUP->(DBSEEK(cCODE)),Left(GROUP->DESC,15),'???'+SPACE(12))+;
SPACE(10)+TRAN(nItem,'9999999')+` ITEM')
S_PRINT(TRAN(nCust,'999999')+` CUST'+TRAN(nPrice/nTPrice*100,' 999.99%')+;
 +TRAN(nPrice,'          999,999,999'))
S_PRINT(SPACE(40))
S_PRINT("**  T o t a l  **" +SPACE(23))
S_PRINT(SPACE(28)+TRAN(nTItem,'9999999')+` ITEM')
S_PRINT('   100.00 %'+SPACE(16)+TRAN(nTPrice,'9,999,999,999'))
S_PRINT(SPACE(40))
S_PRINT('FROM SATELITE '+SPACE(26))
IF cMTH == 'MONTH'
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
          DT:='- '+cD+' '+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+cE+">"
          S_PRINT(IF(LEN(DT)<40,DT+SPACE(40-LEN(DT)),DT))
       ELSEIF cD=SATELITE->(SubS(CPNO,AT("CP",CPNO)+2,2))
          nD:=SATELITE->MCHNID
          cD:=Str(nD)
          IF cTitle='<Read>'
             cD1:=DTos(Date())
             cE:=SUBSTR(cD1,7,2)+'/'+SUBSTR(cD1,5,2)
          ELSE
             cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
          ENDIF
          DT:='- '+cD+' '+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+cE+">"
          S_PRINT(IF(LEN(DT)<40,DT+SPACE(40-LEN(DT)),DT))
       ENDIF
   NEXT
ENDIF
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
CLOSE RGDEPT
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
    INDEX ON DEPTDX1('FL2') TO (DDATA+"$RGDEPT2")
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
          FL1->GROUP   := FL2->GROUP
          FL1->DEPT    := FL2->DEPT
          *FL1->ETYPE   := FL2->ETYPE
          *FL1->REVERSE := FL2->REVERSE
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
/**
STATIC FUNCTION DEPTDX1(cAlias)
IF LEN(ALLTRIM((cAlias)->CODE)) = 8 .AND. ( (cAlias)->FLAG == 'PLU';
   .OR. (cAlias)->FLAG == 'VOD'.OR. (cAlias)->FLAG == 'RTN')
   RETURN "þ"
ENDIF
RETURN " "
**/

STATIC FUNCTION DEPTDX1(cAlias)
IF AScan({'PLU','VOD','RTN'},(cAlias)->FLAG)>0
   RETURN "þ"
ENDIF
RETURN " "

*-----------------------------------------------------------------------------
