#include "Kassa.ch"
#include "FileIO.ch"
#include "inkey.ch"
#define   F_BLOCK 1024
#DEFINE TOP_MARGIN      4
#DEFINE BOTTOM_MARGIN   4
#DEFINE PAGE_LENGTH     60    // 72 FOLIO

*-------------------------------------------------------- 80Col_Flash_Financial
STATIC FUNCTION R_Finance(aFCap)
LOCAL aFlag:={},cD:='',cFile:=DDATA+'_RFIN18'
LOCAL nQTY:=0 ,nCUST:=0 ,nTSALES:=0 ,cM:=' ' ,nTPROFIT:=0
LOCAL aFlagDS:={'D%1','D%2','D%3','DS1','DS2','DS3','STD','TAX','TAX'}
LOCAL aQPrice:={'PLU','VOD','RTN','R/A','P/O',;
                'D%1','D%2','D%3','DS1','DS2','DS3','STD','ALV','CRC','PCG',;
                'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11','T12','T13','T14'}
IF !CPTemp(aFCap)
   Warning(' Tidak Ada Transaksi ... ! ')
   SELECT CPTEMP ;USE
   RETURN .F.
ENDIF
IF !FILE(cFile) ;CreateFile(cFile) ;ENDIF
USE (cFile) NEW ALIAS R_F18; ZAP
SELECT R_F18 ;ZAP
aFlag:=SeekFlag()
FOR nF:=1 TO LEN(aFlag[1])
    nQTY:=0 ;nCUST:=0 ;nTSALES:=0 ;nTPROFIT:=0

    SELECT CPTEMP 
    SET ORDER TO 1
    SEEK aFlag[1][nF]
    cFlag:=aFlag[1][nF]

    IF !FOUND()
       SELECT R_F18
       APPEND BLANK
       REPLACE FLAG  WITH aFlag[1][nF]
       REPLACE DESC  WITH aFlag[3][nF]
       IF Left(cFlag,1)='T' .AND. Val(Right(cFlag,2))>=1 .AND. Val(Right(cFlag,2))<=14
          TOMBOL->(__dbLocate( {|| FLAG=cFlag},,,, .F. ))
          IF TOMBOL->(Found())
             nR:=TOMBOL->(RecNo())
             TOMBOL->(__dbLocate( {|| ASSIGN=nR},,,, .F. ))
             IF TOMBOL->(Found())
                REPLACE MCR WITH TOMBOL->MCR
             ENDIF
          ENDIF
       ENDIF
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
                nQTY+= QTY*1
          ELSE
                nQTY+= TJQTY*IF(ASCAN(aFlagDS,FLAG)>0,IF(PRICE>0,-1,1),1)
          ENDIF
          nPRICE :=0
          nCPRICE:=0
          IF FLAG='PCG'
             nPRICE  := PRICE         ;GO RecNo()+1
             nCPRICE := CPRICE        ;GO RecNo()+1
             nPRICE  := PRICE-nPRICE  ;GO RecNo()-1    //Dar 4/11
             nCPRICE := CPRICE-nCPRICE;GO RecNo()-1    //Dar 4/11
             nTSALES += nPRICE*(IF(ASCAN(aQPrice,FLAG)>0,QTY,1))
             nTPROFIT+= (nPRICE*QTY)-(nCPRICE*TJQTY) //(IF(ASCAN(aQPrice,FLAG)>0,QTY,1))
          ELSE
             nTSALES += PRICE*(IF(ASCAN(aQPrice,FLAG)>0,QTY,1))
             nTPROFIT+= (PRICE*QTY)-(CPRICE*TJQTY)  //(IF(ASCAN(aQPrice,FLAG)>0,QTY,1))
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
          @MAXROW(),19 SAY (cM:=Muter(cM))  COLOR "N/W"   &&__Buat Tampilan Sedang Proses OK
       ENDDO
    ENDDO
    SELECT R_F18
    APPEND BLANK
    REPLACE FLAG    WITH aFlag[1][nF]
    REPLACE DESC    WITH aFlag[3][nF]
    REPLACE CUST    WITH nCUST
    REPLACE QTY     WITH nQTY
    REPLACE TSALES  WITH nTSALES
    REPLACE TPROFIT WITH nTPROFIT
NEXT nRec
RETURN .T.

*-----------------------------------------------------------------------------
PROCEDURE F_Print18(aFCap,cRorF,lPRN,nPAGE)
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
 aNPFT:=CountFlag(aFlagGS,aFlagDS,aFlagRAPO)[5]

 acSatelite:=F_TO_S(aFCap)

 @ MAXROW(),0 SAY "  Printing .....  ³ ³ þþ Financial Report þþ                                          "         COLOR "N/W"

 SET DEVICE TO PRINT
 IF lPRN="1"
    SET PRINTER TO $TEMP.TXT
 ENDI

 H_F(cRorF)                                              //__ CETAK HEADER FINANCIAL

 @ PROW()+1 ,08 SAY 'GROSS SALES'
 @ PROW()   ,31 SAY aGS[2] PICT       '9,999,999'        // QTY
 @ PROW()   ,44 SAY aGS[1] PICT         '999,999'        // CUST
 @ PROW()   ,61 SAY aGS[3] PICT '999,999,999,999'        // SALES
 SELECT R_F18 ; GO TOP
 FOR nF=1 TO LEN(aFlagDS)
     SELECT R_F18
     LOCATE FOR FLAG=aFlagDS[nF]
     PrintTrans()
     SKIP
     IF lPRN='2'
        SET DEVICE TO SCREEN                                &&__
        @MAXROW(),19 SAY (cM:=Muter(cM))    COLOR "N/W"     &&__Buat Tampilan Sedang Proses OK
        SET DEVICE TO PRINT                                 &&__
     ENDIF
 NEXT nF

 @ PROW()+01,08 SAY 'NET SALES'
 @ PROW()   ,31 SAY aGS[2] PICT       '9,999,999'
 @ PROW()   ,44 SAY aGS[1] PICT         '999,999'
 @ PROW()   ,61 SAY aNS[3] PICT '999,999,999,999'

 @ PROW()+01,08 SAY 'PROFIT SALES'
 @ PROW()   ,31 SAY aGS[2]   PICT       '9,999,999'
 @ PROW()   ,44 SAY aGS[1]   PICT         '999,999'
 @ PROW()   ,61 SAY aNPFT[1] PICT '999,999,999,999'

 SELECT R_F18 ; GO TOP

 FOR nF=1 TO LEN(aFlagRPC)
     SELECT R_F18
     LOCATE FOR FLAG=aFlagRPC[nF]
     PrintTrans()
     SKIP
     IF lPRN='2'
        SET DEVICE TO SCREEN                                &&__
        @MAXROW(),19 SAY (cM:=Muter(cM))   COLOR "N/W"      &&__Buat Tampilan Sedang Proses OK
        SET DEVICE TO PRINT                                 &&__
     ENDIF
 NEXT nF

 SELECT R_F18 ; GO TOP
 FOR nF=1 TO LEN(aFlagElse)
     SELECT R_F18
     LOCATE FOR FLAG=aFlagElse[nF]
     PrintTrans()
     SKIP
     IF lPRN='2'
        SET DEVICE TO SCREEN                                &&__
        @MAXROW(),19 SAY (cM:=Muter(cM))  COLOR "N/W"       &&__Buat Tampilan Sedang Proses OK
        SET DEVICE TO PRINT                                 &&__
     ENDIF
 NEXT nF
 IF PROW()+BOTTOM_MARGIN > PAGE_LENGTH
    EJECT
    H_F(cRorF)                                           // SETPRC(0,0)
 ENDI
 @ PROW()+1 ,01 SAY REPL('Ä',76)
 @ PROW()+1 ,01 SAY 'FROM SATELITE'
 FOR nX:=1 TO LEN(aFCap)
     cD:=SubS(aFCap[nX],AT("CP",aFCap[nX])+2,2)
     IF lGLan
        DLL->(DBGoto(Val(cD)))
        nD:=DLL->(MCHNID) ;cD:=RIGHT('000000'+ALLTRIM(STR(nD)),6) ;cMcn:=cD
        nR:=DLL->(TRESET) ;cR:=Str(nR)
     ELSEIF cD=SATELITE->(SubS(CPNO,AT("CP",CPNO)+2,2))
        nD:=SATELITE->(MCHNID) ;cD:=RIGHT('000000'+ALLTRIM(STR(nD)),6) ;cMcn:=cD
        nR:=SATELITE->(TRESET) ;cR:=Str(nR)
     ELSE ;nR:=0 ;cR:=''
     ENDIF
     @ PROW()+01,01 SAY '- '+cD+' '+acSatelite[nX][1] +IF(cRorF='<Reset>', 'þZ-30 '+cR,'')
 NEXT nX
 @PROW()+1, 01 SAY CHR(12)
 SET DEVICE TO SCREEN
 SET PRINTER TO
 IF lPRN="1"
    LIHATTEKS('$TEMP.TXT',2,0,23,79,'W/N')
 ENDI
 CloseDel()
RETURN SETCOLOR()

*-----------------------------------------------------------------------------
STATIC FUNCTION CountFlag(aFlagGS,aFlagDS,aFlagRAPO)
LOCAL aGS:={},aDS:={},aNS:={},aRAPO:={},aNPFT:={}
LOCAL nGCust:=0,nGQty:=0,nGSales:=0,nDCust:=0,nDQty:=0,nDSales:=0
LOCAL nRAPOCust:=0,nRAPOQty:=0,nRAPOSales:=0,nGProfit:=0
LOCAL aFRAPO:={'R/A','P/O'}
LOCAL aFCASH:={'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11','T12','T13','T14'}

SELECT R_F18 ;GO TOP
DO WHILE !EOF()
   nGCust    +=IF(ASCAN(aFlagGS,FLAG)>0,  CUST,0)
   nGQty     +=IF(ASCAN(aFlagGS,FLAG)>0.AND.FLAG='PLU',QTY,;
               IF(ASCAN(aFlagGS,FLAG)>0.AND.ASCAN({'VOD','RTN'},FLAG)>0,QTY*(-1),0))
   nGSales   +=IF(ASCAN(aFlagGS,FLAG)>0,TSALES,0)
   nGProfit  +=IF(ASCAN(aFlagGS,FLAG)>0,TPROFIT,0)
   nDCust    +=IF(ASCAN(aFlagDS,FLAG)>0,  CUST,0)

   nDQty     +=IF(ASCAN(aFlagGS,FLAG)>0,   QTY,0)

   nDSales   +=IF(ASCAN(aFlagDS,FLAG)>0,TSALES,0)
   nRAPOCust +=IF(ASCAN(aFRAPO ,FLAG)>0,  CUST,0)
   nRAPOQty  +=IF(ASCAN(aFRAPO ,FLAG)>0,   QTY,0)
   nRAPOSales+=IF(ASCAN(aFRAPO ,FLAG)>0,TSALES,0)
   SKIP
ENDDO

AADD(aGS ,nGCust)      ; AADD(aGS,nGQty)      ; AADD(aGS,nGSales)                      &&__GROSS SALES
AADD(aDS ,nDCust)      ; AADD(aDS,nDQty)      ; AADD(aDS,nDSales)                      &&__TOTAL DISCOUNT
AADD(aRAPO,nRAPOCust)  ; AADD(aRAPO,nRAPOQty) ; AADD(aRAPO,nRAPOSales)    &&__TOTAL RA+PO
AADD(aNS,nGCust+nDCust); AADD(aNS,nGQty+nDQty); AADD(aNS,nGSales+nDSales) &&__NET SALES
AADD(aNPFT,nGProfit)
RETURN {aGS,aDS,aRAPO,aNS,aNPFT}                                                 &&__{{nGCust,nGQty,nGSales},aDS}

*-----------------------------------------------------------------------------
STATIC PROCEDURE PrintTrans() 
    SELECT R_F18
    IF TSALES<>0
       IF PROW()+BOTTOM_MARGIN > PAGE_LENGTH
          EJECT
          H_F(cRorF)                                 // SETPRC(0,0)
       ENDI
       @ PROW()+1,08 SAY DESC
       @ PROW()  ,31 SAY QTY    PICT       '9,999,999'
       @ PROW()  ,44 SAY CUST   PICT         '999,999'
       @ PROW()  ,61 SAY TSALES PICT '999,999,999,999'
   ENDI
RETURN

*-----------------------------------------------------------------------------
FUNCTION F_TXT18(aFCap)
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

SELECT R_F18 ;GO TOP
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
RETURN

*-----------------------------------------------------------------------------
STATIC PROCEDURE CreateFile(cFile)
 LOCAL aStruct:={}
 AADD(aStruct,{'FLAG'   ,'C',03,0})
 AADD(aStruct,{'DESC'   ,'C',15,0})
 AADD(aStruct,{'CUST'   ,'N',06,0})
 AADD(aStruct,{'QTY'    ,'N',07,0})
 AADD(aStruct,{'TSALES' ,'N',12,0})
 AADD(aStruct,{'TPROFIT','N',12,0})
 AADD(aStruct,{'MCR'    ,'L',01,0})
 DBCREATE(cFile,aStruct)
RETURN 

*-----------------------------------------------------------------------------
STATIC PROCEDURE CloseDel()
SELECT R_F18  ;USE
SELECT CPTEMP ;USE
//DELETE FILE (DDATA+'_CPTEMP8.DBF' )
//DELETE FILE (DDATA+'_RFIN18.DBF'  )
DELETE FILE (DDATA+'_R_FIN18.NTX')
DELETE FILE (DDATA+'_R_CAS18.NTX')
DELETE FILE (DDATA+'_R_HOU18.NTX')
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION CPTemp(aFile) &&____________________Buat Temporary File Capture Yang
LOCAL aStruct:=CP->(DBSTRUCT())     &&_______Ditambah Field 'TIME' & 'CASHIER'
LOCAL cFile:=DDATA+'_CPTEMP8.DBF'
AADD(aStruct,{'TIME   ','C',8,0})
AADD(aStruct,{'CASHIER','C',6,0})
AADD(aStruct,{'MACHINE','N',8,0})
SELECT 200
DBCREATE(cFile,aStruct)
USE (cFile) NEW ALIAS CPTEMP ;ZAP
    CPCombine(aFile)
    INDEX ON FLAG+STR(MACHINE,8)+STR(NORCP,6)         TO (DDATA+'_R_FIN18')
    INDEX ON TIME+STR(MACHINE,8)+STR(NORCP,6)         TO (DDATA+'_R_HOU18')
    INDEX ON FLAG+CASHIER+STR(MACHINE,8)+STR(NORCP,6) TO (DDATA+'_R_CAS18')
    SET INDEX TO (DDATA+'_R_FIN18'),(DDATA+'_R_HOU18'),(DDATA+'_R_CAS18')
RETURN CPTEMP->(LASTREC()#0)

*-----------------------------------------------------------------------------
FUNCTION H_F(cRorF)
 cRORF2=cRORF
 SETPRC(0,0)
 @ PROW()+TOP_MARGIN,01 SAY 'FINANCIAL REPORT'
 @ PRow()   ,68 SAY 'Hal.: '
 @ PRow()   ,74 SAY TRAN(++nPAGE,'999')
 @ PROW()+01,01 SAY DTOC(DATE())+'þ'+IF(lGTimePr='Y',Time(),'')+'þ'+cRorF2
 @ PROW()+01,01 SAY REPL('Ä',76)
 @ PROW()+01,02 SAY 'NO.'
 @ PROW()   ,08 SAY 'DESCRIPTION'
 @ PROW()   ,37 SAY 'QTY'
 @ PROW()   ,47 SAY 'CUST'
 @ PROW()   ,70 SAY 'AMOUNT'
 @ PROW()+1 ,01 SAY REPL('Ä',76)
RETURN
*-----------------------------------------------------------------------------

