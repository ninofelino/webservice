#include "kassa.ch"
#define FC_NORMAL    0
*-----------------------------------------------------------------------------
PROCEDURE RPCLAS2(aDbf,cTitle,lTxt)
LOCAL aStruct:={}, cFlTmp:=DDATA+'$GCLAS.DBF'
LOCAL RGCLAS,DBF1, DBF2, cM:=' '

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
//@ MAXROW(),0  SAY "  Proses .......  ³ ³ þþ Class Report þþ                                         " COLOR "N/W"
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

USE (cFlTmp) NEW ALIAS RGCLAS
INDEX ON LEFT(CODE,3)+STR(NORCP)+STR(MACHINE)  TO (DDATA+"$RGCLAS1")

bFirst := {|| RGCLAS->(DBGOTOP()) }
bWhile := {|| !RGCLAS->(EOF()) }
bFor   := {|| .t. }

EVAL(bFirst)
DBEVAL({|| nTPrice+=RGCLAS->PRICE*QTY, IIF(RGCLAS->PRICE > 0 ,;
           nTItem+=RGCLAS->QTY,nTItem-=RGCLAS->QTY) },bFor,bWhile)

IF nTItem == 0
   WARNING(' Tidak ada Transaksi ... ! ')
   CLOSE RGCLAS
   RETURN
ENDIF

// test Dar
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
   aHead:=TXTHeader(aDbf,'CLS',cMcn)
   aFoot:=TXTFooter(aDbf)
   cExt:='.'+IF(LEN(aDbf)>1,'GAB',SUBSTR(aDbf[1],AT('CP',aDbf[1])+2,2))
   cFile:='CLS'+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,4)+cExt
   IF (nHandle:=FCREATE(NTXT+cFile,FC_NORMAL))=-1
      Warning(' Tidak Berhasil Membuat File Text [Dos Error : '+ALLTRIM(STR(FERROR(),2))+'] ') 
      CLOSE RGCLAS
      RETURN
   ENDIF
   FOR I=1 TO LEN(aHead)
       FWRITE(nHandle,aHead[I]+LF)
   NEXT
ENDIF
// end test Dar

@ MAXROW(),0 SAY "  Printing .....  ³ ³ þþ Class Report þþ                                         " COLOR "N/W"
SET DEVICE TO PRINT
@ PRow()   ,00 SAY _PINIT+_PALL
@ PRow()+1 ,00  SAY REPLI('-',33)
@ PRow()   ,33  SAY REPLI('-',33)
@ PRow()+1 ,00  SAY 'CLASS REPORT    '
JPrint(PRow() ,40,'CLASS REPORT    ')
@ PRow()+1 ,00  SAY DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle)
@ PRow()   ,33  SAY DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle)
@ PRow()+1 ,00  SAY REPLI('-',33)
@ PRow()   ,33  SAY REPLI('-',33)

EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      IF cCode <> LEFT(RGCLAS->CODE,3)
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
         cCode   := LEFT(RGCLAS->CODE,3)
         nNorcp  := RGCLAS->NORCP
         nMACHINE:= RGCLAS->MACHINE
         nCust   := 1
         nItem   := 0
         nPrice  := 0
      ENDIF

      IF (nNorcp <> RGCLAS->NORCP .OR. nMACHINE <> RGCLAS->MACHINE);
         .AND. RGCLAS->FLAG=='PLU'
         nCust++
         nNorcp := RGCLAS->NORCP
         nMACHINE:= RGCLAS->MACHINE
      ENDIF

      nPrice+=RGCLAS->PRICE*QTY
      IIF(RGCLAS->PRICE > 0, nItem+=RGCLAS->QTY, nItem-=RGCLAS->QTY)
   ENDIF

   RGCLAS->(DBSKIP())
   SET DEVICE TO SCREEN
   @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
   SET DEVICE TO PRINT
ENDDO

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
@ PRow()+2 ,00 SAY ' '
@ PROW()+1,00 SAY 'FROM SATELITE '
@ PROW()+0,33 SAY 'FROM SATELITE '

FOR I=1 TO LEN(aDbf)
    cD:=SubS(aDbf[I],AT("CP",aDbf[I])+2,2)
    IF lGLan  
       DLL->(DBGoto(Val(cD)))
       nD:=DLL->(MCHNID)
       cD:=RIGHT('000000'+ALLTRIM(STR(nD)),6)
       IF cTitle='<Read>'
          cE:=DTos(Date())
          cE:=SUBSTR(cD,7,2)+'/'+SUBSTR(cD,5,2)
       ELSE
          cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
       ENDIF
       @ PROW()+1,00 SAY '- '+cD+' '+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+cE+">"
       @ PROW()+0,33 SAY '- '+cD+' '+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+cE+">"
    ELSEIF cD=SATELITE->(SubS(CPNO,AT("CP",CPNO)+2,2))
       nD:=SATELITE->MCHNID
       cD:=RIGHT('000000'+ALLTRIM(STR(nD)),6)
       IF cTitle='<Read>'
          cE:=DTos(Date())
          cE:=SUBSTR(cD,7,2)+'/'+SUBSTR(cD,5,2)
       ELSE
          cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
       ENDIF
       @ PROW()+1,00 SAY '- '+cD+' '+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+cE+">"
       @ PROW()+0,33 SAY '- '+cD+' '+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+cE+">"
    ENDIF
//  @ PRow()+1 ,00 SAY 'SATELITE : #'+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+;
//                     SUBSTR(aDbf[I],AT("CP",aDbf[I])+6,2)+"/"+SUBSTR(aDbf[I],AT("CP",aDbf[I])+4,2)+">"
//  @ PRow()   ,33 SAY 'SATELITE : #'+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+;
//                     SUBSTR(aDbf[I],AT("CP",aDbf[I])+6,2)+"/"+SUBSTR(aDbf[I],AT("CP",aDbf[I])+4,2)+">"
    //@ PRow()+1 ,00 SAY 'SATELITE : #'+SUBSTR(aDbf[I],AT('CP',aDbf[I])+2,2)
NEXT
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
CLOSE RGCLAS
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
    INDEX ON CLASDX1('FL2') TO (DDATA+"$RGCLAS2")
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
STATIC FUNCTION CLASDX1(cAlias)
IF LEN(ALLTRIM((cAlias)->CODE)) = 3 .AND. ( (cAlias)->FLAG == 'PLU';
   .OR. (cAlias)->FLAG == 'VOD'.OR. (cAlias)->FLAG == 'RTN')
   RETURN "þ"
   //RETURN "þ"+LEFT((cAlias)->CODE,3)+STR((cAlias)->NORCP)+STR((cAlias)->MACHINE)
ENDIF
RETURN ' '

