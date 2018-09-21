#include "hmg.ch"
#include "kassa.ch"
#define FC_NORMAL    0
#DEFINE TOP_MARGIN      4
#DEFINE BOTTOM_MARGIN   4
#DEFINE PAGE_LENGTH     60    // 72 FOLIO

*---------------------------------------------- 80Col_Read & Reset_Group_OnLine

//          1         2         3         4         5         6         7
// 1234567890123456789012345678901234567890123456789012345678901234567890
//   NO     CODE       DESCRIPTION           QTY                 AMOUNT
// 9999     9999       X-------------X   999,999         99,999,999,999
// ======================================================================

PROCEDURE PGROUP28(aDbf,cTitle,lTxt,lPrn)
LOCAL aStruct:={}, cFlTmp:=DDATA+'$GGROUP.DBF'
LOCAL RGGROUP,DBF1, DBF2, cM:=' '
LOCAL bFirst, bWhile, bFor, I
LOCAL nItem:= 0, nCust:= 0, nPrice:= 0
LOCAL nTItem:= 0, nTPrice:=0, nPAGE:=0
LOCAL cCODE:=' ', nNORCP:=0, nMACHINE:=0,nNOUR:=0
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

USE (cFlTmp) NEW ALIAS RGGROUP
INDEX ON LEFT(GROUP,2)+STR(NORCP)+STR(MACHINE)  TO (DDATA+"$RGGROUP1")

bFirst := {|| RGGROUP->(DBGOTOP()) }
bWhile := {|| !RGGROUP->(EOF())  }
bFor   := {|| .T. }

EVAL(bFirst)
DBEVAL({|| nTPrice+=RGGROUP->PRICE*QTY, IIF(RGGROUP->PRICE > 0 ,;
           nTItem+=RGGROUP->QTY,nTItem-=RGGROUP->QTY ) },bFor,bWhile)

IF nTItem == 0
   WARNING(' Tidak Ada Transaksi ... ! ')
   CLOSE RGGROUP
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
      CLOSE RGGROUP
      RETURN
   ENDIF
   FOR I=1 TO LEN(aHead)
       FWRITE(nHandle,aHead[I]+LF)
   NEXT
ENDIF
@ MAXROW(),0 SAY "  Printing 80-Col ³ ³ þþ Group Report......þþ                                         " COLOR "N/W"

SET DEVICE TO PRINT
IF lPrn="1"
   SET PRINTER   TO $Temp.TXT
ENDIF

HEAD_2(cTitle,nPAGE)
EVAL(bFirst)
DO WHILE EVAL(bWhile)
   IF EVAL(bFor)
      IF cCode <> LEFT(RGGROUP->GROUP,2)
         IF nItem <> 0
            IF PROW()+BOTTOM_MARGIN > PAGE_LENGTH
               EJECT
               HEAD_2(nPAGE,cTitle)
            ENDI
            @ PRow()+1 ,1  SAY nNOUR+=1  PICT '9999'
            @ PRow()   ,10 SAY cCODE
            @ PRow()   ,21 SAY IIF(GROUP->(DBSEEK(cCODE)),Left(GROUP->DESC,15),'???')
            @ PRow()   ,39 SAY TRAN(nItem,'999,999')
            @ PRow()   ,55 SAY TRAN(nPrice,'99,999,999,999')
            IF lTxt
               cBuffer:=cCODE+','+NumToChar('000000',nCUST)+','+;
                        NumToChar('0000000',nItem)+','+;
                        NumToChar('000000000000',nPrice)+LF
               FWRITE(nHandle,cBuffer)
            ENDIF
         ENDIF
         cCode   := LEFT(RGGROUP->GROUP,2)
         nNorcp  := RGGROUP->NORCP
         nMACHINE:= RGGROUP->MACHINE
         nCust   := 1
         nItem   := 0
         nPrice  := 0
      ENDIF

      IF (nNorcp <> RGGROUP->NORCP .OR. nMACHINE <> RGGROUP->MACHINE);
         .AND. RGGROUP->FLAG=='PLU'
         nCust++
         nNorcp  := RGGROUP->NORCP
         nMACHINE:= RGGROUP->MACHINE
      ENDIF

      nPrice+=RGGROUP->PRICE*QTY
      IIF(RGGROUP->PRICE > 0, nItem+=RGGROUP->QTY, nItem-=RGGROUP->QTY)
   ENDIF

   RGGROUP->(DBSKIP())
   IF lPRN='2'
      SET DEVICE TO SCREEN
      @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"
      SET DEVICE TO PRINT
   ENDIF
ENDDO
IF PROW()+BOTTOM_MARGIN > PAGE_LENGTH
   EJECT
   HEAD_2(nPAGE,cTitle)
ENDI

@ PRow()+1 ,1  SAY nNOUR+=1 PICT '9999'
@ PRow()   ,10 SAY cCODE
@ PRow()   ,21 SAY IIF(GROUP->(DBSEEK(cCODE)),Left(GROUP->DESC,15),'???')
@ PRow()   ,39 SAY TRAN(nItem,'999,999')
@ PRow()   ,55 SAY TRAN(nPrice,'99,999,999,999')
@ PRow()+1 ,01 SAY REPL('Ä',76)
@ PRow()+1 ,37 SAY TRAN(nTItem,'9,999,999')
@ PRow()   ,54 SAY TRAN(nTPrice,'999,999,999,999')
@ PRow()+1 ,01 SAY REPL('Ä',76)
@ PROW()+1 ,01 SAY 'FROM SATELITE'

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
       @ PROW()+1,01 SAY '- '+cD+' '+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+cE+">"
    ELSEIF cD=SATELITE->(SubS(CPNO,AT("CP",CPNO)+2,2))
       nD:=SATELITE->MCHNID
       cD:=Str(nD)
       IF cTitle='<Read>'
          cE:=DTos(Date())
          cE:=SUBSTR(cD,7,2)+'/'+SUBSTR(cD,5,2)
       ELSE
          cE:=SUBSTR(aDbf[1],AT("CP",aDbf[1])+6,2)+"/"+SUBSTR(aDbf[1],AT("CP",aDbf[1])+4,2)
       ENDIF
       @ PROW()+1,01 SAY '- '+cD+' '+SUBSTR(aDbf[I],AT("CP",aDbf[I])+2,2)+" <"+cE+">"+CHR(13)+CHR(10)
    ENDIF
NEXT
@PROW()+1 ,01 SAY CHR(12)

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

IF lPrn="1"
   LIHATTEKS('$TEMP.TXT',2,0,23,79,"W/N")
   FILEDELETE('$TEMP.TXT')
ENDIF
CLOSE RGGROUP
RETURN

// ---------------------------------------- utk gab report
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
    INDEX ON GROUPDX1('FL2') TO (DDATA+"$RGGROUP2")
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
          FL1->NORCP   := FL2->NORCP
          FL1->MACHINE  := nMACHINE
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

*------------------------------------------------------------------------------
STATIC FUNCTION GROUPDX1(cAlias)
IF AScan({'PLU','VOD','RTN'},(cAlias)->FLAG)>0
   RETURN "þ"
ENDIF
RETURN " "

/*
STATIC FUNCTION GROUPDX1(cAlias)
IF AScan({'PLU','VOD','RTN'},(cAlias)->FLAG)>0
   RETURN "þ"+LEFT((cAlias)->GROUP,2)+STR((cAlias)->NORCP,6)
ENDIF
RETURN SPACE(9)
*/

*------------------------------------------------------------------------------
FUNCTION HEAD_2(cTitle,nPAGE)
 cTitle2=cTitle
 SETPRC(0,0)
 @ PRow()+TOP_MARGIN ,01  SAY 'GROUP REPORT'
 @ PRow()   ,68  SAY 'Hal.: '
 @ PRow()   ,74  SAY TRAN(++nPAGE,'999')
 @ PRow()+1 ,01  SAY DTOC(DATE())+"þ"+IF(lGTimePr='Y',Time(),'')+"þ"+IF(cTitle == NIL ,'',cTitle2)
 @ PRow()+1 ,01  SAY REPL('Ä',76)
 @ PRow()+1 ,03  SAY 'NO.'
 @ PRow()   ,10  SAY 'CODE'
 @ PRow()   ,21  SAY 'DESCRIPTION'
 @ PRow()   ,43  SAY 'QTY'
 @ PRow()   ,63  SAY 'AMOUNT'
 @ PROW()+1 ,01  SAY REPL('Ä',76)
RETURN
*------------------------------------------------------------------------------

