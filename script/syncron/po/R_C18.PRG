#include "Kassa.ch"
#include "FileIO.ch"
#define   F_BLOCK 512
#DEFINE TOP_MARGIN      4
#DEFINE BOTTOM_MARGIN   4
#DEFINE PAGE_LENGTH     60    // 72 FOLIO

*----------------------------------------------------------- 80Col_Read_Cashier
STATIC PROCEDURE CTmp(cF) 
LOCAL a:=CP->(DBSTRUCT())
AAdd(a,{'CASHIER' ,'C',06,0})
AAdd(a,{'MACHINE' ,'N',08,0})
AAdd(a,{'SATELITE','C',10,0})
AAdd(a,{'TIME'    ,'C',08,0})
DBCREATE(cF,a)
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION CPrcs(aFC)
LOCAL nI,nFC:=Len(aFC),cM:=''
LOCAL cTime:='',cCASHIER:='',nMACHINE:=0,nNORCP:=0

CTmp(DDATA+'_CPTEMP.DBF')
IF !NNetLogged() .AND. Select('CP')#0
   CP->(DBCloseArea())
ENDIF
USE (DDATA+'_CPTEMP.DBF') NEW ALIAS CPTEMP;ZAP
FOR nI:=1 TO nFC
    @ 24,19 SAY '*' COLOR "R*/W"
    nRec:=LastRec();APPEND FROM (aFC[nI])
    cS:=SUBSTR(aFC[nI],AT('CP',UPPER(aFC[nI]))+2,2)
    cD:=SUBSTR(aFC[nI],AT('CP',UPPER(aFC[nI]))+6,2)+'/'+;
        SUBSTR(aFC[nI],AT('CP',UPPER(aFC[nI]))+4,2)
    cSatelite:=cS+' <'+cD+'>'
    GO nRec+1
    DO WHILE !EOF()
       IF FLAG='NEW'
          cTIME   :=CODE
          nNORCP  :=NORCP
          nMACHINE:=PRICE
          cCASHIER:=LEFT(DESC,6) ;DELETE
          @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "R/W"   &&Buat Tampilan Proses OK
       ELSEIF nNORCP=NORCP
          REPLACE TIME     WITH cTIME
          REPLACE CASHIER  WITH cCASHIER
          REPLACE MACHINE  WITH nMACHINE
          REPLACE SATELITE WITH cSatelite
       ELSEIF FLAG='EOD'  ;DELETE
       ENDIF
       SKIP
    ENDDO
NEXT
INDEX ON STR(MACHINE,8)+CASHIER+FLAG+Str(NORCP,6) TO (DDATA+'_CPTEMP')
IF Select('CP')=0
   USE (DDATA+SATELITE->CPNO) NEW ALIAS CP
ENDIF
SELECT CPTEMP
RETURN CPTEMP->(LASTREC()#0)

*-----------------------------------------------------------------------------
STATIC PROCEDURE CCas(cF)
LOCAL a:={{'FLAG'    ,'C',03,0};
         ,{'DESC'    ,'C',15,0};
         ,{'CASHIER' ,'C',06,0};
         ,{'CUST'    ,'N',06,0};
         ,{'QTY'     ,'N',07,0};
         ,{'MACHINE' ,'N',08,0};
         ,{'SATELITE','C',10,0};
         ,{'TSALES'  ,'N',12,0}}

DBCREATE(cF,a)
RETURN 

*-----------------------------------------------------------------------------
STATIC FUNCTION R_Cashier(aFCap)
LOCAL aFlag:={},cD:='',aCOnLine:={} ,cFile:=DDATA+'_R_CAS'
LOCAL nQTY:=0 ,nCUST:=0 ,nTSALES:=0 ,cM:=' '
LOCAL aFlagDS:={'D%1','D%2','D%3','DS1','DS2','DS3','STD','TAX'}
LOCAL aQPrice:={'PLU','VOD','RTN','R/A','P/O',;
                'D%1','D%2','D%3','DS1','DS2','DS3','STD','TAX','ALV','CRC','PCG',;
                'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11','T12','T13','T14'}
IF !CPrcs(aFCap)
   Warning(' Tidak Ada Transaksi ... ! ') ;RETURN .F.
ENDIF

aFlag:={{'D%1',_DP1,''},{'D%2',_DP2,''},{'D%2',_DP3,''};
       ,{'DS1',_DA1,''},{'DS2',_DA2,''},{'DS3',_DA3,''};
       ,{'STD',_STD,''},{'P/O',_PO ,''},{'CRC',_CRC,''};
       ,{'PLU',_PLU,''},{'R/A',_RA ,''},{'VOD',_VOD,''};
       ,{'NOS',_NOS,''},{'PCG',_PCG,''},{'RTN',_RTN,''};
       ,{'ALV',_ALV,''},{'T01',_T01,''},{'T02',_T02,''};
       ,{'T03',_T03,''},{'T04',_T04,''},{'T05',_T05,''};
       ,{'T06',_T06,''},{'T07',_T07,''},{'T08',_T08,''};
       ,{'T09',_T09,''},{'T10',_T10,''},{'T11',_T11,''};
       ,{'T12',_T12,''},{'T13',_T13,''},{'T14',_T14,''},{'TAX',_TAX,''}}
SELECT TOMBOL;GO TOP
DO WHILE !Eof()
   IF ASSIGN#0 .AND. (n:=AScan(aFlag,{|a|a[2]=ASSIGN}))#0
      aFlag[n][3]:=ASGNNM
   ENDIF
   SKIP
ENDDO

CCas(DDATA+'_R_CAS')
USE (DDATA+'_R_CAS') NEW ALIAS R_C; ZAP

SELECT CPTEMP
GO TOP
DO WHILE !Eof()
    nMACHINE:=MACHINE
    DO WHILE nMACHINE=MACHINE .AND. !EOF()
       nQTY:=0
       nCUST:=1
       nTSALES:=0
       cFLAG:=FLAG
       nNORCP:=NORCP
       cCASHIER:=CASHIER
       cSATELITE:=SATELITE
       DO WHILE cFLAG=FLAG .AND. ;
          cCASHIER=CASHIER .AND. ;
          nMACHINE=MACHINE .AND. !EOF()
          IF nNORCP #NORCP
             nNORCP:=NORCP
	     nCUST++
	  ENDIF
          nPRICE:=0
          IF FLAG='PCG'
             nPRICE:=PRICE        ;GO RecNo()+1
             nPRICE:=PRICE-nPRICE ;GO RecNo()-1    //Dar 4/11
             ELSE  ;nPrice:=PRICE
          ENDIF
          nTSALES+=nPRICE*(IF(ASCAN(aQPrice,FLAG)>0,QTY,1))
          IF FLAG='TAX'
             nQTY+=TJQTY*1
          ELSE
             nQTY+=TJQTY*IF(ASCAN(aFlagDS,FLAG)>0,IF(PRICE>0,-1,1),1)
          ENDI
          IF FLAG='T01'
             nQTY+=QTY
          ELSEIF FLAG='T02'
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
          ELSEIF FLAG='P/O'
             nQTY+=QTY
          ELSEIF FLAG='R/A'
             nQTY+=QTY
          ENDIF
          SKIP
       ENDDO
       IF (n:=AScan(aFlag,{|a|a[1]=cFLAG}))#0
	   c:=aFlag[n][3];ELSE
	   c:=cFLAG
       ENDIF
       SELECT R_C
       APPEND BLANK
       REPLACE DESC     WITH c
       REPLACE QTY      WITH nQTY
       REPLACE FLAG     WITH cFLAG
       REPLACE CUST     WITH nCUST
       REPLACE TSALES   WITH nTSALES
       REPLACE CASHIER  WITH cCASHIER
       REPLACE MACHINE  WITH nMACHINE
       REPLACE SATELITE WITH cSATELITE
       SELECT CPTEMP
       @ MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"   &&__Buat Tampilan Sedang Proses OK
    ENDDO
ENDDO
SELECT R_C
INDEX ON STR(MACHINE,8)+CASHIER+FLAG TO (DDATA+'_R_CAS')
RETURN .T.

*-----------------------------------------------------------------------------
FUNCTION C_Print18(aFCap,cRorF,lPRN)
LOCAL aFlagRP:={'R/A','P/O'}
LOCAL aFlagGS:={'PLU','VOD','RTN'}
LOCAL aFlagElse:={'CRC','VOD','RTN','NOS','PCG','ALV'}
LOCAL aFlagDS:={'D%1','D%2','D%3','DS1','DS2','DS3','STD','TAX'}
LOCAL aFlagRPC :={'R/A','P/O','T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11','T12','T13','T14'}
LOCAL nGQty,nGCust,nGSales,nDQty,nDCust,nDSales,nNQty,nNCust,nNSales,nRQty,nRCust,nRSales,nRec:=0,cM:='',cNama:=''
LOCAL nTCust:=0,nTQty:=0,nTSales:=0

nPAGE:=0
IF !R_Cashier(aFCap)
   RETURN .F.
ENDIF

@ MAXROW(),0 SAY "  Printing .....  � � �� Cashier Report ��                                            " COLOR "N/W"

SET DEVICE TO PRINT
IF lPrn="1"
   SET PRINTER TO $Temp.TXT
ENDIF

SELECT R_C
GO TOP
DO WHILE !EOF()
   IF MACHINE=0 
      SKIP;LOOP
   ENDIF
   nMACHINE:=MACHINE
   cCASHIER:=CASHIER
   cSATELITE:=SATELITE
   nGQty:=0;nGCust:=0;nGSales:=0
   nDQty:=0;nDCust:=0;nDSales:=0
   nNQty:=0;nNCust:=0;nNSales:=0
   nRQty:=0;nRCust:=0;nRSales:=0
   DO WHILE cCASHIER=CASHIER .AND. nMACHINE=MACHINE .AND. !EOF()
      nGQty  +=IF(ASCAN(aFlagGS, FLAG)>0.AND.FLAG='PLU',QTY,;
               IF(ASCAN(aFlagGS, FLAG)>0.AND.ASCAN({'VOD','RTN'},FLAG)>0,QTY*(-1),0))
      nGCust +=IF(ASCAN(aFlagGS, FLAG)>0,  CUST,0)
      nGSales+=IF(ASCAN(aFlagGS, FLAG)>0,TSALES,0)

      nDQty  +=IF(ASCAN(aFlagDS, FLAG)>0,   QTY,0)
      nDCust +=IF(ASCAN(aFlagDS, FLAG)>0,  CUST,0)
      nDSales+=IF(ASCAN(aFlagDS, FLAG)>0,TSALES,0)

      nRQty  +=IF(ASCAN(aFlagRP, FLAG)>0,   QTY,0)
      nRCust +=IF(ASCAN(aFlagRP, FLAG)>0,  CUST,0)
      nRSales+=IF(ASCAN(aFlagRP, FLAG)>0,TSALES,0)
      SKIP                          
   ENDDO
   nRec:=RecNo()
   nNQty:=nGQty+nDQty
   nNCust:=nGCust+nDCust
   nNSales:=nGSales+nDSales
   nTQty+=nGQty
   nTCust+=nGCust
   nTSales+=nNSales

   HEAD_C(cRORF)

   SELECT CASHIER
   LOCATE FOR cCASHIER=CODE ;cNama:=DESC
   SELECT R_C
   @ PROW()+01,01 SAY 'CASHIER : '+cCashier+'�'+cNama
   @ PROW()+02,08 SAY 'GROSS SALES'
   @ PROW()   ,31 SAY nGQty   PICT       '9,999,999'
   @ PROW()   ,44 SAY nGCust  PICT         '999,999'
   @ PROW()   ,61 SAY nGSales PICT '999,999,999,999'
   FOR nF=1 TO LEN(aFlagDS)
       LOCATE FOR FLAG=aFlagDS[nF] .AND. cCASHIER=CASHIER .AND. nMACHINE=MACHINE
       PrintTrans()
       SKIP
       IF lPRN='2'
          SET DEVICE TO SCREEN                           &&__
          @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"   &&__Buat Tampilan Sedang Proses OK
          SET DEVICE TO PRINT                            &&__
       ENDIF
   NEXT nF
   @ PROW()+01,08 SAY 'NET SALES'
   @ PROW()   ,31 SAY nGQty   PICT       '9,999,999'
   @ PROW()   ,44 SAY nGCust  PICT         '999,999'
   @ PROW()   ,61 SAY nNSales PICT '999,999,999,999'

   FOR nF=1 TO LEN(aFlagRPC)
       LOCATE FOR FLAG=aFlagRPC[nF] .AND. cCASHIER=CASHIER .AND. nMACHINE=MACHINE
       PrintTrans()
       SKIP
       IF lPRN='2'
          SET DEVICE TO SCREEN                           &&__
          @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"   &&__Buat Tampilan Sedang Proses OK
          SET DEVICE TO PRINT                            &&__
       ENDIF
   NEXT nF

   FOR nF=1 TO LEN(aFlagElse)
       LOCATE FOR FLAG=aFlagElse[nF] .AND. cCASHIER=CASHIER .AND. nMACHINE=MACHINE
       PrintTrans()
       SKIP
       IF lPRN='2'
          SET DEVICE TO SCREEN                           &&__
          @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"   &&__Buat Tampilan Sedang Proses OK
          SET DEVICE TO PRINT                            &&__
       ENDIF
   NEXT nF

   GO nRec
   IF nMACHINE#MACHINE
      IF PROW()+BOTTOM_MARGIN > PAGE_LENGTH
         EJECT
         HEAD_C(cRorF)                                 // SETPRC(0,0)
      ENDI
      @ PROW()+02,01 SAY REPL('�',76)
      @ PROW()+01,01 SAY 'TOTAL'
      @ PROW()+01,01 SAY 'QTY       : '+TRAN(nTQty  ,'999,999,999,999')
      @ PROW()+01,01 SAY 'CUST      : '+TRAN(nTCust ,'999,999,999,999')
      @ PROW()+01,01 SAY 'NET SALES : '+TRAN(nTSales,'999,999,999,999')
      @ PROW()+2 ,01 SAY 'FROM SATELITE'
     *@ PROW()   ,70 SAY 'HAL : '
     *nPAGE+=1
     *@ PROW()  ,76 SAY TRAN(nPAGE,'999')
      @ PROW()+1,01 SAY '- '+Str(nMACHINE,6)+' '+cSATELITE
      nTCust:=0;nTQty:=0;nTSales:=0
      @ PROW()+1,01 SAY CHR(12)       // EJECT
   ELSE
      @ PROW()+2,01 SAY 'FROM SATELITE'
      @ PROW()  ,70 SAY 'Hal.: '
      nPAGE+=1
      @ PROW()  ,76 SAY TRAN(nPAGE,'999')
      @ PROW()+1,01 SAY '- '+Str(nMACHINE,6)+' '+cSATELITE
      @ PROW()+1,01 SAY CHR(12)       // EJECT
   ENDIF
ENDDO
SET PRINTER TO
SET DEVICE TO SCREEN

IF lPrn="1"
   LIHATTEKS('$TEMP.TXT',2,0,23,79,"W/N")
   FILEDELETE('$TEMP.TXT')
ENDIF
CloseDel()
RETURN 

*-----------------------------------------------------------------------------
STATIC PROCEDURE PrintTrans() 
    SELECT R_C
    IF TSALES<>0
       IF PROW()+BOTTOM_MARGIN > PAGE_LENGTH
          EJECT
          HEAD_C(cRorF)                                 // SETPRC(0,0)
       ENDI
       @ PROW()+1,08 SAY DESC
       @ PROW()  ,31 SAY QTY    PICT       '9,999,999'
       @ PROW()  ,44 SAY CUST   PICT         '999,999'
       @ PROW()  ,61 SAY TSALES PICT '999,999,999,999'
    ENDI
RETURN
*-----------------------------------------------------------------------------
FUNCTION C_TXT18(aFCap)
LOCAL nHandle:=0, cBuffer:='',cMcn:=''
LOCAL LF:=CHR(13)+CHR(10)
LOCAL aHead:=TXTHeader(aFCap,'CAS',cMcn)
LOCAL aFoot:=TXTFooter(aFCap)
LOCAL cExt:='.'+IF(LEN(aFCap)>1,'GAB',SUBSTR(aFCap[1],AT('CP',aFCap[1])+2,2))
LOCAL cFile:='CAS'+SubStr(aFCap[1],At('CP',aFCap[1])+4,4)+cExt

IF !R_Cashier(aFCap)
   RETURN
ENDIF

IF (nHandle:=FCREATE(IF(lGLan,NTXT,DTXT)+cFile,FC_NORMAL))=-1
   Warning(' Tidak Berhasil Membuat File Text [Dos Error : '+ALLTRIM(STR(FERROR(),2))+'] ') 
ENDIF

SELECT R_C ;GO TOP
FOR nH:=1 TO LEN(aHead)
    FWRITE(nHandle,aHead[nH]+LF)
NEXT nH
DO WHILE !EOF()
   cBuffer:=CASHIER+','+FLAG+','+PosNeg(TSALES)+','+;
            NumToChar('000000',CUST)+','+NumToChar('0000000',QTY)+','+;
            NumToChar('000000000000',ABS(TSALES))+LF
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
STATIC PROCEDURE CloseDel()
CLOSE R_C
CLOSE CPTEMP
DELETE FILE (DDATA+'_R_CAS.DBF')
DELETE FILE (DDATA+'_R_FIN_1.NTX')
DELETE FILE (DDATA+'_R_CAS_1.NTX')
DELETE FILE (DDATA+'_R_CAS_2.NTX')
DELETE FILE (DDATA+'_R_HOU_1.NTX')
DELETE FILE (DDATA+'_CPTEMP.DBF')
RETURN

*-----------------------------------------------------------------------------
FUNCTION HEAD_C(cRORF)
 cRORF2=cRORF
 SETPRC(0,0)
 @ PROW()+TOP_MARGIN,01 SAY 'CASHIER REPORT'
 @ PRow()   ,68  SAY 'Hal.: '
 @ PRow()   ,74  SAY TRAN(++nPAGE,'999')
 @ PROW()+01,01  SAY DTOC(DATE())+'�'+IF(lGTimePr='Y',Time(),'')+'�'+cRorF2
 @ PROW()+01,01  SAY REPL('�',76)
 @ PROW()+1 ,08  SAY 'DESCRIPTION'
 @ PROW()   ,37  SAY 'QTY'
 @ PROW()   ,47  SAY 'CUST'
 @ PROW()   ,70  SAY 'AMOUNT'
 @ PROW()+1 ,01  SAY REPL('�',76)
RETURN
*-----------------------------------------------------------------------------
