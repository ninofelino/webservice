#include "hmg.ch"
#include 'inkey.ch'
#include 'kassa.ch'
*-----------------------------------------------------------------------------
PROCEDURE Hapus()
LOCAL nI:=0,cD:='',aa,dH,dH1,cH,cH1
LOCAL cEOD,aEOD,cTXT,aTXT,cHST
LOCAL nT:=3,nL:=15,nB:=18,nR:=64,oC
LOCAL oB:=TBrowseNew(nT+1,nL+1,nB-2,nR-1)
LOCAL aFOR:={'HOU','DPT','FIN','CAS','CLS','SKU'}
*----------------------------------------
LOCAL cS:=SaveScreen(0,0,24,79)
LOCAL cM:='',aD,b
LOCAL nD:=0
LOCAL nK:=0
LOCAL aX[4]
LOCAL aR
LOCAL nIdx,nTot
*------------------------
IF lGLan
   cEOD:=NEOD
   cTXT:=NTXT
   cHST:=NHST
ELSE
   cEOD:=DEOD
   cTXT:=DTXT
   cHST:=DHST
ENDIF
*------------------------------

dH :=Date() ;dH1:=Date()
@ 24,0  SAY " Hapus File Tanggal            s/d           ,     Hapus .. ? [0]Tidak  [1]Ya    " COLOR "w/n"
@ 24,20 GET dH  PICT "@D" COLOR "W+/n"
@ 24,35 GET dH1 PICT "@D" VALID !Empty(dH) .AND. dH1>=dH .AND. Month(dH)=Month(dH1) COLOR "W+/n"
READ
@ 24,63 SAY "0" COLOR "w*/n"
@ 24,73 SAY "1" COLOR "w*/n"
DO WHILE .T.                                                       //Dar 22/12
   @ 24,80 SAY 'þ' COLOR "w*/n"                              //Dar 22/12
   i:=InKey(0)                                                     //Dar 22/12
   IF UPPER(CHR(i))$'01'                                           //Dar 22/12
      EXIT                                                         //Dar 22/12
   ENDIF                                                           //Dar 22/12
ENDDO                                                              //Dar 22/12
IF UPPER(CHR(i))$'0'                                               //Dar 22/12
   RestScreen(0,0,24,79,cS)
   RETURN .T.                                                      //Dar 22/12
ENDIF                                                              //Dar 22/12
@ 24,0  SAY " Hapus File ....  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
@ 24,19 SAY "*" COLOR "N*/W"
cH :=SubS(DToC(dH),4,2)+SubS(DToC(dH),1,2)
cH1:=SubS(DToC(dH1),4,2)+SubS(DToC(dH1),1,2)

aD:=Directory(cTXT+'???'+Left(cH,2)+'??.*')
aX:=Directory(cEOD+'????'+Left(cH,2)+'??.DBF')
FOR nI:=1 TO Len(aX)
    AAdd(aD,aX[nI])
NEXT
IF Empty(aD)
   Warning(' Tidak ada yang perlu di hapus ... ! ')
   RETURN
ENDIF

FOR nI:=1 TO Len(aD)
    cD:=aD[nI][1] ;nH:=Val(SubS(cD,5,4))
    IF Right(AllTrim(aD[nI][1]),3)='DBF' .AND. nH>=Val(cH) .AND. nH<=Val(cH1)
       COPY FILE (cEOD+aD[nI][1]) TO (cTXT+aD[nI][1])
       FErase(cHST+aD[nI][1])
       FErase(cEOD+aD[nI][1])
    ELSEIF nH>=Val(cH) .AND. nH<=Val(cH1)
//       FErase(cTXT+aD[nI][1])
    ENDIF
NEXT
RestScreen(0,0,24,79,cS)
RETURN

*--------------------------------
