#include "hmg.ch"
#INCLUDE "KASSA.CH"
#INCLUDE "INKEY.CH"
*-----------------------------------------------------------------------------
FUNCTION CPTemp(aFile) &&____________________Buat Temporary File Capture Yang 
LOCAL aStruct:=CP->(DBSTRUCT())     &&_______Ditambah Field 'TIME' & 'CASHIER'
LOCAL cFile:=DDATA+'_CPTEMP.DBF'
AADD(aStruct,{'TIME   ','C',8,0})
AADD(aStruct,{'CASHIER','C',6,0})
AADD(aStruct,{'MACHINE','N',8,0})
SELECT 200
DBCREATE(cFile,aStruct)
USE (cFile) NEW ALIAS CPTEMP ;ZAP
    CPCombine(aFile)
    INDEX ON FLAG+STR(MACHINE,8)+STR(NORCP,6)         TO (DDATA+'_R_FIN_1')
    INDEX ON TIME+STR(MACHINE,8)+STR(NORCP,6)         TO (DDATA+'_R_HOU_1')
    INDEX ON FLAG+CASHIER+STR(MACHINE,8)+STR(NORCP,6) TO (DDATA+'_R_CAS_1')
    SET INDEX TO (DDATA+'_R_FIN_1'),(DDATA+'_R_HOU_1'),(DDATA+'_R_CAS_1')
RETURN CPTEMP->(LASTREC()#0)
*-----------------------------------------------------------------------------
FUNCTION CPCombine(aCPFile) &&_________________Array File-file Capture
LOCAL nF:=0,nNORCP:=0,cTIME:='',nPRICE:=0 ,cCASHIER:='' ,cM:=' '
FOR nF:=1 TO LEN(aCPFile)
    SELECT CPTEMP
    IF !NNetLogged() .AND. Select('CP')#0
       CP->(DBCloseArea())
    ENDIF
    APPEND FROM (aCPFile[nF])
NEXT nF
IF Select('CP')=0
   USE (DDATA+SATELITE->CPNO) NEW ALIAS CP
ENDIF
SELECT CPTEMP
GO TOP
DO WHILE !EOF()
   IF FLAG='NEW'
      nNORCP  :=NORCP
      cTIME   :=CODE
      nPRICE  :=PRICE
      cCASHIER:=LEFT(DESC,6)
      @MAXROW(),19 SAY (cM:=Muter(cM)) COLOR "R/W"   &&Buat Tampilan Proses OK
   ELSEIF nNORCP=NORCP
      REPLACE TIME    WITH cTIME
      REPLACE CASHIER WITH cCASHIER
      REPLACE MACHINE WITH nPRICE
   ENDIF
   SKIP
ENDDO
RETURN
*-----------------------------------------------------------------------------
FUNCTION SeekFlag()
LOCAL aFlag:={},aF:={},aA:={},nF:=0
aF:={'D%1','D%2','D%3','DS1','DS2','DS3','STD','TAX',;
     'P/O','CRC','PLU','R/A','VOD','NOS','PCG','RTN','ALV',;
     'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11','T12','T13','T14'}
aA:={_DP1,_DP2,_DP3,_DA1,_DA2,_DA3,_STD,_TAX,;
     _PO,_CRC,_PLU,_RA,_VOD,_NOS,_PCG,_RTN,_ALV,;
     _T01,_T02,_T03,_T04,_T05,_T06,_T07,_T08,_T09,_T10,_T11,_T12,_T13,_T14}
AADD(aFlag,aF)  &&__________aFlag[1]
AADD(aFlag,aA)  &&__________aFlag[2]
AADD(aFlag,{})  &&__________aFlag[3]
FOR nF:=1 TO LEN(aFlag[2])
    SELECT TOMBOL
    LOCATE FOR ASSIGN=aFlag[2][nF]
    AADD(aFlag[3],ASGNNM)
NEXT nF
RETURN aFlag
*-----------------------------------------------------------------------------
FUNCTION F_TO_S(aFCap)
LOCAL acSatelite:={},cS:='',cD:='',nS:=0,nM:=0
FOR nC:=1 TO LEN(aFCap)
    cS:=SUBSTR(aFCap[nC],AT('CP',UPPER(aFCap[nC]))+2,2)
    cD:=SUBSTR(aFCap[nC],AT('CP',UPPER(aFCap[nC]))+6,2)+'/'+;
        SUBSTR(aFCap[nC],AT('CP',UPPER(aFCap[nC]))+4,2)
    nS:=0
    IF lGlan
//     DLL->(DBGoto(nStl))                               //Dar 5/11
       DLL->(DBGoto(SATELITE->(VAL(SUBS(CPNO,3,2)))))    //Dar 5/11
       nS:=DLL->TRESET
       nM:=DLL->MCHNID                                   //Dar 5/11
    ELSEIF SATELITE->(SUBS(CPNO,3,2))=cS                 //Dar 5/11VALnC
       nS:=SATELITE->TRESET
       nM:=SATELITE->MCHNID                              //Dar 5/11
    ENDIF
    AADD(acSatelite,{cS+' <'+cD+'>',nS,nM})
NEXT nC
RETURN acSatelite
*-----------------------------------------------------------------------------
