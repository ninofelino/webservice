#include "kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION NumToChar(cC,nN)
LOCAL cD:=ALLTRIM(STR(ABS(nN))) ;LOCAL nD:=LEN(cD) ;LOCAL nS:=(LEN(cC)-nD+1)
RETURN cD:=STUFF(cC,nS,nD,cD)
*-----------------------------------------------------------------------------
FUNCTION PosNeg(nN)
RETURN IF(ABS(nN)=nN,'1','0')
*-----------------------------------------------------------------------------
FUNCTION TXTHeader(anStl,cRep,cMcn)
LOCAL cH:=(REPL('00,',98)+'00') ,aH[6] ,nStl:=0 ,cStl:='',cRepFrom:=''
LOCAL cD:=Str(Year(Date()),4)+SubStr(anStl[1],At('CP',anStl[1])+4,4)
SET CENTURY ON
anStl:=ACLONE(anStl)
cRepFrom:='STORE:'+SATELITE->CODE+','+cRep+','+cD+','+TIME()+','+cMcn

FOR nS:=1 TO LEN(anStl)
    anStl[nS]:=VAL(SUBSTR(anStl[nS],AT('CP',anStl[nS])+2,2))
NEXT nS
FOR nStl:=1 TO 99
    cStl:=NumToChar('00',IF(ASCAN(anStl,nStl)>0,nStl,0))
    nS:=((nStl*3)+1)-3
    cH:=STUFF(cH,IF(nStl=1,1,nS),2,cStl)
NEXT nStl
FOR nStl:=1 To 5
    aH[nStl]:=SUBSTR(cH,(nStl*60)-59,60)
NEXT nStl
aH[nStl]:=cRepFrom
*AADD(aH,SUBSTR(cH,001,60)) ;AADD(aH,SUBSTR(cH,061,60)) &&__Jangan Dipakai
*AADD(aH,SUBSTR(cH,121,60)) ;AADD(aH,SUBSTR(cH,181,60)) &&__Ada kesalahan
*AADD(aH,SUBSTR(cH,241))    ;AADD(aH,cRepFrom)          &&__Proses pada AADD()
SET CENTURY OFF
RETURN aH
*-----------------------------------------------------------------------------
FUNCTION TXTFooter(anStl)
LOCAL cF:=(REPL('0000,',98)+'0000') ,aF[9] ,nStl:=0 ,cStl:='',nS:=0
anStl:=ACLONE(anStl)
FOR nS:=1 TO LEN(anStl)
    anStl[nS]:=VAL(SUBSTR(anStl[nS],AT('CP',anStl[nS])+2,2))
NEXT nS
FOR nStl:=1 TO 99
    IF ASCAN(anStl,nStl)=0 ;LOOP ;ENDIF
    IF lGlan
       DLL->(DBGoto(nStl))
       cStl:=NumToChar('0000',DLL->TRESET)
    ELSEIF SATELITE->(VAL(SUBS(CPNO,3,2)))=nStl
       cStl:=NumToChar('0000',SATELITE->TRESET)
    ELSE
       cStl:='0000'
    ENDIF
    nS:=((nStl*5)+1)-5
    cF:=STUFF(cF,IF(nStl=1,1,nS),4,cStl)
NEXT nStl
FOR nStl:=1 To 9
    aF[nStl]:=SUBSTR(cF,(nStl*60)-59,60)
NEXT nStl
*AADD(aF,SUBSTR(cF,001,60)) ;AADD(aF,SUBSTR(cF,061,60)) &&__Jangan Dipakai
*AADD(aF,SUBSTR(cF,121,60)) ;AADD(aF,SUBSTR(cF,181,60)) &&__Ada kesalahan
*AADD(aF,SUBSTR(cF,241,60)) ;AADD(aF,SUBSTR(cF,301,60)) &&__Proses pada 
*AADD(aF,SUBSTR(cF,361,60)) ;AADD(aF,SUBSTR(cF,421,60)) &&__AADD() Ok..!!!
*AADD(aF,SUBSTR(cF,481   ))
RETURN aF
*-----------------------------------------------------------------------------
