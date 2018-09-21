#include 'inkey.ch'
#include 'kassa.ch'
*-----------------------------------------------------------------------------
PROCEDURE BackU()
LOCAL nI:=0,cD:='',aa
LOCAL cEOD,aEOD,cTXT,aTXT,cHST,aHST
LOCAL nT:=3,nL:=15,nB:=18,nR:=64,oC
LOCAL oB:=TBrowseNew(nT+1,nL+1,nB-2,nR-1)
LOCAL aFOR:={'HOU','DPT','FIN','CAS','CLS','SKU'}
*----------------------------------------
LOCAL cS:=SaveScreen(0,0,MAXROW(),MAXCOL())
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


STORE date() TO dH,dH1
STORE 'A'                                                         TO cDrv
STORE 'BACK'+SubS(DToC(DATE()),4,2)+SubS(DToC(DATE()),1,2)+'.ZIP' TO cFil
@ 24,0 CLEAR TO 24,79
@ 24,0  SAY " Back-Up ke Drv: _, Tgl 11-11-1111 S/D 11-11-1111 ,File Tujuan [            ]" COLOR "w/n"

@ 24,17 GET cDrv PICT "!"             COLOR "W+/n"
@ 24,24 GET dH  PICT "@D" COLOR "W+/n"
@ 24,39 GET dH1 PICT "@D" VALID !Empty(dH) .AND. dH1>=dH .AND. Month(dH)=Month(dH1) COLOR "W+/n"
@ 24,64 GET cFil PICT "!!!!!!!!!!!!"  COLOR "W+/n"
READ
@ 24,0  SAY " BackUp File ...  ³ ³  Wait . . . !!!                                            " COLOR "w/n"
@ 24,19 SAY "*" COLOR "w*/n"

cH :=SubS(DToC(dH),4,2)+SubS(DToC(dH),1,2)
cH1:=SubS(DToC(dH1),4,2)+SubS(DToC(dH1),1,2)

aD:=Directory(cTXT+'???'+Left(cH,2)+'??.*')
aX:=Directory(cEOD+'????'+Left(cH,2)+'??.DBF')
FOR nI:=1 TO Len(aX)
    AAdd(aD,aX[nI])
NEXT
IF Empty(aD)
   Warning(' Tidak ada yang perlu di Back Up ... ! ')
   RETURN
ENDIF
IF !FILE("PKZIP.EXE")
   Warning(' File PKZIP tidak ada ... ! ')
   RETURN
ENDIF

FOR nI:=1 TO Len(aD)
    cD:=aD[nI][1] ;nH:=Val(SubS(cD,5,4))
    IF Right(AllTrim(aD[nI][1]),3)='DBF' .AND. nH>=Val(cH) .AND. nH<=Val(cH1)
       cD:="Pkzip "+cFil+" "+cEOD+aD[nI][1] +" >nul"
    ELSE
       cD:="Pkzip "+cFil+" "+cTXT+aD[nI][1] +" >nul"
    ENDIF
    !(cD)
NEXT
aD:=DIRECTORY(cFil)

IF Empty(aD)
   Warning(' Proses Backup Gagal, File ZIP Tidak Terbentuk ')
   RETURN
ENDIF

IF ChkDrv(aD[1][2])
   FILECOPY(cFil,cDrv+":\"+cFil)
ENDIF

aD:=Directory('*.ZIP')
For nI:=1 TO Len(aD)
    FErase(aD[nI][1])
NEXT

RestScreen(0,0,MAXROW(),MAXCOL(),cS)
RETURN

*----------------------------------------------------------------------------

