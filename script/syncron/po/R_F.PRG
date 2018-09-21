#include "Kassa.ch"
#include "FileIO.ch"
#define   F_BLOCK 512

*-----------------------------------------------------------------------------
FUNCTION R_Finance(aFCap)
LOCAL aFlag:={},cD:='',cFile:=DDATA+'_R_FIN'
LOCAL nQTY:=0 ,nCUST:=0 ,nTSALES:=0 ,cM:=' '
LOCAL aFlagDS:={'D%1','D%2','D%3','DS1','DS2','DS3','STD','TAX'}
LOCAL aQPrice:={'PLU','VOD','RTN','R/A','P/O',;
                'D%1','D%2','D%3','DS1','DS2','DS3','STD','ALV','CRC','PCG',;
                'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11','T12','T13','T14'}
IF !CPTemp(aFCap)
   Warning(' Tidak Ada Transaksi ... ! ')
   SELECT CPTEMP ;USE
   RETURN .F.
ENDIF
IF !FILE(cFile) ;CreateFile(cFile) ;ENDIF
USE (cFile) NEW ALIAS R_F; ZAP
SELECT R_F ;ZAP
aFlag:=SeekFlag()
FOR nF:=1 TO LEN(aFlag[1])
    nQTY:=0 ;nCUST:=0 ;nTSALES:=0

    SELECT CPTEMP 
    SET ORDER TO 1
    SEEK aFlag[1][nF]

    IF !FOUND()
       SELECT R_F
       APPEND BLANK
       REPLACE FLAG  WITH aFlag[1][nF]
       REPLACE DESC  WITH aFlag[3][nF]
       LOOP
    ENDIF

    SELECT CPTEMP
    SET ORDER TO 1
    DO WHILE FLAG=aFlag[1][nF].AND.!EOF()
       nNORCP  :=NORCP
       nMACHINE:=MACHINE
       nCUST++
       DO WHILE NORCP=nNORCP.AND.MACHINE=nMACHINE.AND.FLAG=aFlag[1][nF].AND.!EOF()
          IF FLAG='TAX'
                nQTY    += QTY*1
          ELSE ;nQTY    += TJQTY*IF(ASCAN(aFlagDS,FLAG)>0,IF(PRICE>0,-1,1),1)
          ENDIF
          nPRICE:=0

          IF FLAG='PCG'
             nPRICE:=PRICE        ;GO RecNo()+1
//           nPRICE:=nPRICE-PRICE ;GO RecNo()-1    //Dar 4/11
             nPRICE:=PRICE-nPRICE ;GO RecNo()-1    //Dar 4/11
             nTSALES += nPRICE*(IF(ASCAN(aQPrice,FLAG)>0,QTY,1))
          ELSE
             nTSALES += PRICE*(IF(ASCAN(aQPrice,FLAG)>0,QTY,1))
          ENDIF
          IF FLAG='T01'
             nQTY+=QTY
          ELSEIF FLAG='T02'
             nQTY+=QTY
          ELSEIF FLAG='T03'
             nQTY+=QTY
          ELSEIF FLAG='T04'
             nQTY+=QTY
          ELSEIF FLAG='T05'
             nQTY+=QTY
          ELSEIF FLAG='T06'
             nQTY+=QTY
          ELSEIF FLAG='T07'
             nQTY+=QTY
          ELSEIF FLAG='T08'
             nQTY+=QTY
          ELSEIF FLAG='T09'
             nQTY+=QTY
          ELSEIF FLAG='T10'
             nQTY+=QTY
          ELSEIF FLAG='T11'
             nQTY+=QTY
          ELSEIF FLAG='T12'
             nQTY+=QTY
          ELSEIF FLAG='T13'
             nQTY+=QTY
          ELSEIF FLAG='T14'
             nQTY+=QTY
          ENDIF
          IF FLAG='R/A'
             nQTY+=QTY
          ELSEIF FLAG='P/O'
             nQTY+=QTY
          ENDIF

          SELECT CPTEMP
          SET ORDER TO 1
          SKIP
          @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"   &&__Buat Tampilan Sedang Proses OK
       ENDDO
    ENDDO
    SELECT R_F
    APPEND BLANK
    REPLACE FLAG   WITH aFlag[1][nF]
    REPLACE DESC   WITH aFlag[3][nF]
    REPLACE CUST   WITH nCUST
    REPLACE QTY    WITH nQTY
    REPLACE TSALES WITH nTSALES
NEXT nRec
RETURN .T.

*-----------------------------------------------------------------------------
PROCEDURE F_Print(aFCap,cRorF,cMth,aInline)
LOCAL aFlagGS  :={'PLU','VOD','RTN'}
LOCAL aFlagDS  :={'D%1','D%2','D%3','DS1','DS2','DS3','STD','TAX'}
LOCAL aFlagRAPO:={'R/A','P/O'}
LOCAL aFlagCASH:={'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11','T12','T13','T14'}
LOCAL aFlagRPC :={'R/A','P/O','T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11','T12','T13','T14'}
LOCAL aFlagElse:={'CRC','VOD','RTN','NOS','PCG','ALV'}
LOCAL nTCust:=0,nTQty:=0,nTSales:=0,n:=0,cM:=' '
PUBLIC cMcn:=''

IF !R_Finance(aFCap)
   RETURN
ENDIF

aGS  :=CountFlag(aFlagGS,aFlagDS,aFlagRAPO)[1]
aDS  :=CountFlag(aFlagGS,aFlagDS,aFlagRAPO)[2]
aRAPO:=CountFlag(aFlagGS,aFlagDS,aFlagRAPO)[3]
aNS  :=CountFlag(aFlagGS,aFlagDS,aFlagRAPO)[4]

acSatelite:=F_TO_S(aFCap)
SET DEVI TO SCREEN
@ MAXROW(),0 SAY "  Printing .....  ³ ³ þþ Financial Report þþ                                          " COLOR "N/W"
S_PRINT(REPL('-',40))
SET DEVICE TO PRINTER
@ PROW()+01,00 SAY 'FINANCIAL REPORT    '
JPrint(PROW()  ,40, 'FINANCIAL REPORT    ')
IF cMth == 'MONTH'
   @ PROW()+01,00 SAY '<     M O N T H    >'
   JPrint(PROW() ,40, '<     M O N T H    >')
ENDIF
// AUSTRALIAN EMBASSY
IF cMth == 'READ '
   @ PROW()+01,00 SAY '<      R E A D     >'
   JPrint(PROW() ,40, '<      R E A D     >')
ENDIF
IF cMth == 'RESET'
   @ PROW()+01,00 SAY '<     R E S E T    >'
   JPrint(PROW() ,40, '<     R E S E T    >')
ENDIF
// END AUSTRALIAN EMBASSY
SET DEVICE TO SCREEN
DT:=DTOC(DATE())+'þ'+IF(lGTimePr='Y',Time(),'')+'þ'+cRorF
S_PRINT(IF(LEN(DT)<40,DT+SPACE(40-LEN(DT)),DT))
S_PRINT(REPL('-',40))
S_PRINT(SPACE(40))
S_PRINT('DESCRIPTION                          QTY')
S_PRINT('CUST                               SALES')
S_PRINT(REPL('=',40))
SET DEVICE TO PRINTER
@ PROW()+01,00 SAY 'GROSS SALES'
@ PROW()   ,30 SAY aGS[2] PICT       ' 9,999,999'
JPrint(PROW() ,40, 'GROSS SALES')
JPrint(PROW()   ,70,aGS[2], ' 9,999,999')
SET DEVICE TO SCREEN
S_PRINT(TRAN(aGS[1],'999,999')+SPACE(18)+TRAN(aGS[3],'999,999,999,999'))
SELECT R_F ; GO TOP
FOR nF=1 TO LEN(aFlagDS)
    SELECT R_F 
    LOCATE FOR FLAG=aFlagDS[nF]
    PrintTrans()
    SKIP
    SET DEVI TO SCREEN
    @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"   &&__Buat Tampilan Sedang Proses OK
NEXT nF
SET DEVICE TO PRINTER
@ PROW()+01,00 SAY 'NET SALES'
@ PROW()   ,30 SAY aGS[2] PICT       ' 9,999,999'
JPrint(PROW() ,40, 'NET SALES')
JPrint(PROW()   ,70,aGS[2], ' 9,999,999')
SET DEVICE TO SCREEN
S_PRINT(TRAN(aGS[1],'999,999')+SPACE(18)+TRAN(aNS[3],'999,999,999,999'))

SELECT R_F ; GO TOP
FOR nF=1 TO LEN(aFlagRPC)
    SELECT R_F 
    LOCATE FOR FLAG=aFlagRPC[nF]
    PrintTrans()
    SKIP
    SET DEVI TO SCREEN
    @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"   &&__Buat Tampilan Sedang Proses OK
NEXT nF

* sementara funtion IN DRAWER ini tidak digunakan yach ...

S_PRINT(REPL('-',40))
SELECT R_F ; GO TOP
FOR nF=1 TO LEN(aFlagElse)
    SELECT R_F
    LOCATE FOR FLAG=aFlagElse[nF]
    PrintTrans()
    SKIP
    SET DEVI TO SCREEN
    @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"   &&__Buat Tampilan Sedang Proses OK
NEXT nF

S_PRINT(REPL('=',40))
S_PRINT(SPACE(40))
S_PRINT('FROM SATELITE'+IF(NNETLOGGED(),' ONLINE  ',' OFFLINE ')+SPACE(18))
FOR nX:=1 TO LEN(aFCap)
    cD:=SubS(aFCap[nX],AT("CP",aFCap[nX])+2,2)
    IF lGLan  
       DLL->(DBGoto(Val(cD)))
       nD:=DLL->(MCHNID) ;cD:=RIGHT('000000'+ALLTRIM(STR(nD)),6) ;cMcn:=cD
       nR:=DLL->(TRESET) ;cR:=Str(nR)
    ELSEIF cD=SATELITE->(SubS(CPNO,AT("CP",CPNO)+2,2))
       nD:=SATELITE->MCHNID ;cD:=RIGHT('000000'+ALLTRIM(STR(nD)),6) ;cMcn:=cD
       nR:=SATELITE->TRESET ;cR:=Str(nR)
    ELSE;nR:=0
    ENDIF
    IF cMth=='MONTH' .OR.  cMth=='READ ' .OR.  cMth=='RESET'
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
       DT:='- '+cD+' '+acSatelite[nX][1] +IF(cRorF='<Reset>','þZ-30 '+TRAN(nR,'9999'),'')  //Dar 14/11
       S_PRINT(IF(LEN(DT)<40,DT+SPACE(40-LEN(DT)),DT))
    ENDIF

NEXT nX
PCutter()
CloseDel()
RETURN

*-----------------------------------------------------------------------------
FUNCTION CountFlag(aFlagGS,aFlagDS,aFlagRAPO)
LOCAL aGS:={},aDS:={},aNS:={},aRAPO:={}
LOCAL nGCust:=0,nGQty:=0,nGSales:=0,nDCust:=0,nDQty:=0,nDSales:=0
LOCAL nRAPOCust:=0,nRAPOQty:=0,nRAPOSales:=0
LOCAL aFRAPO:={'R/A','P/O'}
LOCAL aFCASH:={'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11','T12','T13','T14'}

SELECT R_F ;GO TOP
DO WHILE !EOF()
   nGCust    +=IF(ASCAN(aFlagGS,FLAG)>0,  CUST,0)
   nGQty     +=IF(ASCAN(aFlagGS,FLAG)>0.AND.FLAG='PLU',QTY,;
               IF(ASCAN(aFlagGS,FLAG)>0.AND.ASCAN({'VOD','RTN'},FLAG)>0,QTY*(-1),0))
   nGSales   +=IF(ASCAN(aFlagGS,FLAG)>0,TSALES,0)
   nDCust    +=IF(ASCAN(aFlagDS,FLAG)>0,  CUST,0)

   nDQty     +=IF(ASCAN(aFlagGS,FLAG)>0,   QTY,0)

   nDSales   +=IF(ASCAN(aFlagDS,FLAG)>0,TSALES,0)
   nRAPOCust +=IF(ASCAN(aFRAPO ,FLAG)>0,  CUST,0)
   nRAPOQty  +=IF(ASCAN(aFRAPO ,FLAG)>0,   QTY,0)
   nRAPOSales+=IF(ASCAN(aFRAPO ,FLAG)>0,TSALES,0)
   SKIP
ENDDO

AADD(aGS ,nGCust); AADD(aGS,nGQty); AADD(aGS,nGSales)                      &&__GROSS SALES
AADD(aDS ,nDCust); AADD(aDS,nDQty); AADD(aDS,nDSales)                      &&__TOTAL DISCOUNT
AADD(aRAPO,nRAPOCust); AADD(aRAPO,nRAPOQty); AADD(aRAPO,nRAPOSales)        &&__TOTAL RA+PO
AADD(aNS ,nGCust+nDCust); AADD(aNS,nGQty+nDQty); AADD(aNS,nGSales+nDSales) &&__NET SALES
RETURN {aGS,aDS,aRAPO,aNS}                                                 &&__{{nGCust,nGQty,nGSales},aDS}
*-----------------------------------------------------------------------------
STATIC PROCEDURE PrintTrans() 
    SELECT R_F
    IF TSALES<>0
       S_PRINT(DESC+SPACE(18)+TRAN(QTY,'999,999'))
       S_PRINT(TRAN(CUST,'9,999,999')+SPACE(16)+TRAN(TSALES,'999,999,999,999'))
    ENDIF
RETURN
*-----------------------------------------------------------------------------
FUNCTION F_TXT(aFCap)
LOCAL nHandle:=0, cBuffer:='',cMcn:=''
LOCAL LF:=CHR(13)+CHR(10)
LOCAL aHead:=TXTHeader(aFCap,'FIN',cMcn)
LOCAL aFoot:=TXTFooter(aFCap)
LOCAL cExt:='.'+IF(LEN(aFCap)>1,'GAB',SUBSTR(aFCap[1],AT('CP',aFCap[1])+2,2))
LOCAL cFile:='FIN'+SubStr(aFCap[1],At('CP',aFCap[1])+4,4)+cExt

IF !R_Finance(aFCap)
   RETURN
ENDIF

IF (nHandle:=FCREATE(IF(lGLan,NTXT,DTXT)+cFile,FC_NORMAL))=-1
   Warning(' Tidak Berhasil Membuat File Text [Dos Error : '+ALLTRIM(STR(FERROR(),2))+'] ') 
ENDIF

SELECT R_F ;GO TOP
FOR nH:=1 TO LEN(aHead)
    FWRITE(nHandle,aHead[nH]+LF)
NEXT nH
DO WHILE !EOF()
   cBuffer:='000000,'+FLAG+','+PosNeg(TSALES)+','+NumToChar('000000',CUST)+','+;
            NumToChar('0000000',QTY)+','+NumToChar('000000000000',ABS(TSALES))+LF
   FWRITE(nHandle,cBuffer)
   SKIP
ENDDO
FOR nF:=1 TO LEN(aFoot)
    FWRITE(nHandle,aFoot[nF]+LF)
NEXT nF
FCLOSE(nHandle)
CloseDel()

IF !LGLan.AND.ChkDrv(DIRECTORY(DTXT+cFile)[1][2])
   SET DEVI TO SCREEN
   @ MAXROW(),0  SAY "  Copy File ....  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
   @ MAXROW(),19 SAY "*" COLOR "N*/W"
   FILECOPY(DTXT+cFile,"A:\"+cFile)
ENDIF
RETURN

*-----------------------------------------------------------------------------
STATIC PROCEDURE CreateFile(cFile)
LOCAL aStruct:={}
AADD(aStruct,{'FLAG'  ,'C',03,0})
AADD(aStruct,{'DESC'  ,'C',15,0})
AADD(aStruct,{'CUST'  ,'N',06,0})
AADD(aStruct,{'QTY'   ,'N',07,0})
AADD(aStruct,{'TSALES','N',12,0})
DBCREATE(cFile,aStruct)
RETURN 

*-----------------------------------------------------------------------------
STATIC PROCEDURE CloseDel()
SELECT R_F    ;USE
SELECT CPTEMP ;USE
DELETE FILE (DDATA+'_CPTEMP.DBF' )
DELETE FILE (DDATA+'_R_FIN.DBF'  )
DELETE FILE (DDATA+'_R_FIN_1.NTX')
DELETE FILE (DDATA+'_R_CAS_1.NTX')
DELETE FILE (DDATA+'_R_HOU_1.NTX')
RETURN
*-----------------------------------------------------------------------------

