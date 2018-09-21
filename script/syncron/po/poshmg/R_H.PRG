#include "hmg.ch"
#include "Kassa.ch"
#include "FileIO.ch"
#define   F_BLOCK 512
*-----------------------------------------------------------------------------
FUNCTION R_Hourly(aFCap)
LOCAL aTime:=RangeHour() ,cFile:=DDATA+'_R_HOU'
LOCAL nNORCP:=0 ,nMACHINE:=0 ,cM:=' '
LOCAL aFlag  :={'PLU','VOD','RTN','D%1','D%2','D%3','DS1','DS2','DS3','STD','TAX'}
LOCAL aQPrice:={'PLU','VOD','RTN',;
                'D%1','D%2','D%3','DS1','DS2','DS3','STD','TAX'}
IF !CPTemp(aFCap)
   Warning(' Tidak Ada Transaksi ... ! ')
   SELECT CPTEMP
   USE
   RETURN .F.
ENDIF
IF !FILE(cFile) ; CreateFile(cFile) ;ENDIF
USE (cFile) NEW ALIAS R_H; ZAP
SELECT R_H ;ZAP
SELECT CPTEMP
SET ORDER TO 2
GO TOP
DO WHILE !EOF()
    nCUST:=0 ;nQTY:=0 ;nTSALES:=0; nTDump:=0
    SELECT CPTEMP
    nNORCP  :=NORCP
    nMACHINE:=MACHINE
    DO WHILE NORCP=nNORCP.AND.nMACHINE=MACHINE.AND.!EOF()
       FOR nT:=1 TO LEN(aTime)
           IF TIME >= aTime[nT][1] .AND. TIME <= aTime[nT][2];
              .AND.ASCAN(aFlag,FLAG)>0              
              aTime[nT][4]+=IF(ASCAN({'VOD','RTN','PLU'},FLAG)>0,QTY*If(PRICE>0,1,-1),0)
              aTime[nT][5]+=PRICE*(IF(ASCAN(aQPrice,FLAG)>0,QTY,1))
              nTDump:=nT
           ENDIF
       NEXT nT
       SKIP
    ENDDO
    @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"   &&__Buat Tampilan Sedang Proses OK
    IF nTDump#0 ;aTime[nTDump][3]++ ;ENDIF
ENDDO

FOR nT:=1 TO LEN(aTime)
    IF aTime[nT][3]=0; LOOP ;ENDIF
    SELECT R_H
    APPEND BLANK
    REPLACE TIME   WITH aTime[nT][1]+'þ'+aTime[nT][2]
    REPLACE CUST   WITH aTime[nT][3]
    REPLACE QTY    WITH aTime[nT][4]
    REPLACE TSALES WITH aTime[nT][5]
NEXT nT
RETURN .T.

*-----------------------------------------------------------------------------
STATIC FUNCTION RangeHour()
LOCAL aTime:={}, cT1:='00:00:00',cT2:='00:59:59' ,cD:='' ,cD1:='' ,cD2:=''
LOCAL nCUST:=0 ,nQTY:=0 ,nTSALES:=0
AADD(aTime,{cT1,cT2,0,0,0})
FOR nX:=1 TO 24
    cD :=ALLTRIM(STR(nX,2)) ;nD:=LEN(cD)
    cD1:=STUFF(cT1,IF(nD>1,nD-1,2),nD,cD)
    cD2:=STUFF(cT2,IF(nD>1,nD-1,2),nD,cD)
    AADD(aTime,{cD1,cD2,nCUST,nQTY,nTSALES})
NEXT nX
RETURN aTime

*-----------------------------------------------------------------------------
PROCEDURE H_Print(aFCap,cRorF,l,cMth,aInline)
LOCAL nTCust:=0,nTQty:=0,nTSales:=0 ,cM:=' '
PUBLIC cMcn:=' '
IF !R_Hourly(aFCap)
   RETURN
ENDIF
acSatelite:=F_TO_S(aFCap)
SELECT R_H ; GO TOP
@ MAXROW(),0 SAY "  Printing .....  ³ ³ þþ Hourly Report þþ                                             " COLOR "N/W"
SET DEVICE TO PRINT
@ PROW()+01,00 SAY REPL('Ä',40)
JPrint(PROW()   ,40, REPL('Ä',40))
@ PROW()+01,00 SAY 'HOURLY REPORT       '
JPrint(PROW()   ,40, 'HOURLY REPORT       ')
IF cMth=='MONTH'
   @ PROW()+01,00 SAY '<    M O N T H     >'
   JPrint(PROW()   ,40, '<    M O N T H     >')
ENDIF
@ PROW()+01,00 SAY DTOC(DATE())+'þ'+IF(lGTimePr='Y',Time(),'')+'þ'+cRorF
JPrint(PROW()   ,40, DTOC(DATE())+'þ'+IF(lGTimePr='Y',Time(),'')+'þ'+cRorF)
@ PROW()+01,00 SAY REPL('Ä',40)
JPrint(PROW()   ,40, REPL('Ä',40))
@ PROW()+02,00 SAY 'TIME                                 QTY'
JPrint(PROW() ,40, 'TIME                                 QTY')
@ PROW()+01,00 SAY 'CUST                               SALES'
JPrint(PROW() ,40, 'CUST                               SALES')
@ PROW()+01,00 SAY REPL('Ä',40)
JPrint(PROW()   ,40, REPL('Ä',40))
DO WHILE !EOF()
   @ PROW()+01,00 SAY TIME
   JPrint(PROW()   ,40,TIME)
   @ PROW()   ,29 SAY QTY  PICT '999,999'
   JPrint(PROW()   ,69,QTY, '999,999')
   @ PROW()+01,00 SAY CUST   PICT       '9,999,999'
   JPrint(PROW()   ,40,CUST, '9,999,999')
   @ PROW()   ,22 SAY TSALES PICT '999,999,999,999'
   JPrint(PROW()   ,62,TSALES, '999,999,999,999')
   nTCust +=CUST
   nTQty  +=QTY
   nTSales+=TSALES
   SKIP
   SET DEVICE TO SCREEN                           &&__
   @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "N/W"   &&__Buat Tampilan Sedang Proses OK
   SET DEVICE TO PRINT                            &&__
ENDDO
@ PROW()+01,00 SAY REPL('Ä',40)
JPrint(PROW()   ,40,REPL('Ä',40))
@ PROW()+01,00 SAY 'TOTAL'
JPrint(PROW()   ,40, 'TOTAL')
@ PROW()+01,00 SAY 'CUST      : '+TRAN(nTCust ,'999,999,999,999')
JPrint(PROW()   ,40, 'CUST      : '+TRAN(nTCust ,'999,999,999,999'))
@ PROW()+01,00 SAY 'QTY       : '+TRAN(nTQty  ,'999,999,999,999')
JPrint(PROW()   ,40, 'QTY       : '+TRAN(nTQty  ,'999,999,999,999'))
@ PROW()+01,00 SAY 'NET SALES : '+TRAN(nTSales,'999,999,999,999')
JPrint(PROW()   ,40, 'NET SALES : '+TRAN(nTSales,'999,999,999,999'))

@ PROW()+02,00 SAY 'FROM SATELITE'
JPrint(PROW()   ,40,'FROM SATELITE')
FOR nX:=1 TO LEN(aFCap)
    cD:=SubS(aFCap[nX],AT("CP",aFCap[nX])+2,2)
    IF lGLan  
       DLL->(DBGoto(Val(cD)))
       nD:=DLL->(MCHNID)
       cD:=RIGHT('000000'+ALLTRIM(STR(nD)),6) ;cMcn:=cD
    ELSEIF cD=SATELITE->(SubS(CPNO,AT("CP",CPNO)+2,2))
       nD:=SATELITE->MCHNID
       cD:=RIGHT('000000'+ALLTRIM(STR(nD)),6) ;cMcn:=cD
    ENDIF
    IF cMth=='MONTH'
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
       DT:='- '+cD+' '+acSatelite[nX][1]
       S_PRINT(IF(LEN(DT)<40,DT+SPACE(40-LEN(DT)),DT))
    ENDIF
//    @ PROW()+01,00 SAY '- '+cD+' '+acSatelite[nX][1]
//    @ PROW()   ,40 SAY '- '+cD+' '+acSatelite[nX][1]
NEXT nX
PCutter()
SET DEVICE TO SCREEN
IF cMTH=='MONTH'
   CloseDel()
   RETURN
ENDIF
IF l#NIL
   H_TXT(aFCap)
ENDIF
CloseDel()
RETURN

*-----------------------------------------------------------------------------
FUNCTION H_TXT(aFCap)
LOCAL nHandle:=0, cBuffer:='',cMcn:=''
LOCAL LF:=CHR(13)+CHR(10)
LOCAL aHead:=TXTHeader(aFCap,'HOU',cMcn)
LOCAL aFoot:=TXTFooter(aFCap)
LOCAL cExt:='.'+IF(LEN(aFCap)>1,'GAB',SUBSTR(aFCap[1],AT('CP',aFCap[1])+2,2))
LOCAL cFile:='HOU'+SubStr(aFCap[1],At('CP',aFCap[1])+4,4)+cExt
/*
IF !R_Hourly(aFCap)
   RETURN
ENDIF
*/
IF (nHandle:=FCREATE(IF(lGLan,NTXT,DTXT)+cFile,FC_NORMAL))=-1
   Warning(' Tidak Berhasil Membuat File Text [Dos Error : '+ALLTRIM(STR(FERROR(),2))+'] ') 
ENDIF

SELECT R_H ;GO TOP
FOR nH:=1 TO LEN(aHead)
    FWRITE(nHandle,aHead[nH]+LF)
NEXT nH
DO WHILE !EOF()
   cBuffer:=STRTRAN(TIME,'þ',',')+','+NumToChar('000000',CUST)+','+;
            NumToChar('0000000',QTY)+','+NumToChar('000000000000',TSALES)+LF
   FWRITE(nHandle,cBuffer)
   SKIP
ENDDO
FOR nF:=1 TO LEN(aFoot)
    FWRITE(nHandle,aFoot[nF]+LF)
NEXT nF
FCLOSE(nHandle)

IF !LGLan.AND.ChkDrv(DIRECTORY(DTXT+cFile)[1][2])
   @ MAXROW(),0  SAY "  Copy File ....  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
   @ MAXROW(),19 SAY "*" COLOR "N*/W"
   FILECOPY(DTXT+cFile,"A:\"+cFile)
ENDIF
//CloseDel()
RETURN

*-----------------------------------------------------------------------------
STATIC PROCEDURE CreateFile(cFile)
LOCAL aStruct:={}
AADD(aStruct,{'TIME'  ,'C',17,0})
AADD(aStruct,{'CUST'  ,'N',06,0})
AADD(aStruct,{'QTY'   ,'N',07,0})
AADD(aStruct,{'TSALES','N',12,0})
DBCREATE(cFile,aStruct)
RETURN 

*-----------------------------------------------------------------------------
STATIC PROCEDURE CloseDel()
SELECT R_H    ;USE
SELECT CPTEMP ;USE
DELETE FILE (DDATA+'_CPTEMP.DBF' )
DELETE FILE (DDATA+'_R_HOU.DBF'  )
DELETE FILE (DDATA+'_R_HOU_1.NTX')
DELETE FILE (DDATA+'_R_FIN_1.NTX')
DELETE FILE (DDATA+'_R_CAS_1.NTX')
RETURN
*-----------------------------------------------------------------------------

