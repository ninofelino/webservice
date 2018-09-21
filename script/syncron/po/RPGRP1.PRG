#include "kassa.ch"
#define FC_NORMAL    0
*-----------------------------------------------------------------------------
PROCEDURE RPGRP1(aDbf,cTitle,lTxt)
LOCAL bFirst, bWhile, bFor,I,cM:= ' '
LOCAL nItem:= 0, nCust:= 0, nPrice:= 0
LOCAL nTItem:= 0, nTPrice:=0
LOCAL cCODE:=' ', nNorcp
LOCAL RGROU

LOCAL nHandle:=0, cBuffer:=''
LOCAL LF, aHead, aFoot, cExt, cFile, cMcn

IF(lTxt == NIL,lTxt:=.T.,.F.)

IF SELE("CP") > 0
   CLOSE CP
ENDIF

IF SELE("RCP") > 0
   CLOSE RCP
ENDIF

USE (aDbf[1]) NEW ALIAS RGROU
INDEX ON DEPTDX1('RGROU') TO (DDATA+"$RGROU1")

bFirst := {|| RGROU->(DBSEEK("þ")) }
bWhile := {|| !RGROU->(EOF()) }
bFor   := {|| .t.  }

EVAL(bFirst)
DBEVAL({|| nTPrice+=RGROU->PRICE*QTY, IIF(RGROU->PRICE > 0 ,;
           nTItem+=RGROU->TJQTY,nTItem-=RGROU->TJQTY ) },bFor,bWhile)

IF nTItem == 0
   WARNING(' Tidak Ada Transaksi ... ! ')
   CLOSE RGROU
   RETURN
ENDIF

IF lTxt
   nHandle:=0
   cBuffer:=''
   LF:=CHR(13)+CHR(10)
   cMcn:=RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
   aHead:=TXTHeader({aDbf[1]},'GRP',cMcn)
   aFoot:=TXTFooter({aDbf[1]})
   cExt:='.'+SUBSTR(aDbf[1],AT('CP',aDbf[1])+2,2)
   cFile:='GRP'+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,4)+cExt
   IF (nHandle:=FCREATE(DTXT+cFile,FC_NORMAL))=-1
      Warning(' Tidak Berhasil Membuat File Text [Dos Error : '+ALLTRIM(STR(FERROR(),2))+'] ') 
      CLOSE RGROU
      RETURN
   ENDIF
   FOR I=1 TO LEN(aHead)
       FWRITE(nHandle,aHead[I]+LF)
   NEXT
ENDIF

@ MAXROW(),0 SAY "  Printing .....  ³ ³ þþ Group Report þþ                                              " COLOR "N/W"
S_PRINT(REPLI('-',40))
SET DEVICE TO PRINT
@ PRow()+1 ,00  SAY 'GROUP REPORT        '
JPrint(PRow() ,40, 'GROUP REPORT        ')
SET DEVICE TO SCREEN
DT:=DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle)
S_PRINT(IF(LEN(DT)<40,DT+SPACE(40-LEN(DT)),DT))
S_PRINT(REPLI('-',40))

EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      IF cCode <> LEFT(RGROU->GROUP,2)
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
         cCode  := LEFT(RGROU->GROUP,2)    &&___LEFT(RGROU->CODE,_DDD)
         nNorcp := RGROU->NORCP
         nCust  := 1
         nItem  := 0
         nPrice := 0
      ENDIF
      IF nNorcp <> RGROU->NORCP .AND. RGROU->FLAG=='PLU'
         nCust++
         nNorcp := RGROU->NORCP
      ENDIF
      nPrice+=RGROU->PRICE*QTY
      IIF(RGROU->PRICE > 0, nItem+=RGROU->TJQTY, nItem-=RGROU->TJQTY)
   ENDIF
   RGROU->(DBSKIP())
   @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
ENDDO

cMcn:=RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
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
IF cTitle='<Read>'
   cE:=DTos(Date())
   cE:=SUBSTR(cE,7,2)+'/'+SUBSTR(cE,5,2)
ELSE
   cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
ENDIF
DT:='- '+cMcn+' '+SUBSTR(aDbf[1],AT("CP",aDbf[1])+2,2)+" <"+cE+">"
S_PRINT(IF(LEN(DT)<40,DT+SPACE(40-LEN(DT)),DT))
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
CLOSE  RGROU
RETURN

*-----------------------------------------------------------------------------
/***
STATIC FUNCTION DEPTDX1(cAlias)
IF LEN(ALLTRIM((cAlias)->GROUP)) = 2 .AND. ( (cAlias)->FLAG == 'PLU';
   .OR. (cAlias)->FLAG == 'VOD'.OR. (cAlias)->FLAG == 'RTN')
   RETURN "þ"+(cAlias)->GROUP+STR((cAlias)->NORCP,6)
ENDIF
RETURN " "
***/

STATIC FUNCTION DEPTDX1(cAlias)
//LEN(ALLTRIM((cAlias)->CODE)) = 8 .AND.
IF AScan({'PLU','VOD','RTN'},(cAlias)->FLAG)>0
// RETURN "þ"+LEFT((cAlias)->CODE,_DDD)+STR((cAlias)->NORCP,6)
   RETURN "þ"+(cAlias)->GROUP+STR((cAlias)->NORCP,6)
ENDIF
RETURN SPACE(9)

*-----------------------------------------------------------------------------
