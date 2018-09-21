#include "hmg.ch"
#include 'inkey.ch'
#include 'kassa.ch'
*-----------------------------------------------------------------------------

PROCEDURE RestTrf(lLan)
LOCAL nI:=0,cD:='',aa
LOCAL cEOD,aEOD,cTXT,aTXT,cHST,aHST
LOCAL nT:=3,nL:=15,nB:=18,nR:=64,oC
LOCAL oB:=TBrowseNew(nT+1,nL+1,nB-2,nR-1)
LOCAL aFOR:={'HOU','DPT','FIN','CAS','CLS','SKU'}
*----------------------------------------
LOCAL cS:=SaveScreen(0,0,24,79)
LOCAL cM:='',aD,b
LOCAL nD:=0
LOCAL nK:=0
// LOCAL aX[4]
LOCAL aR
LOCAL nIdx,nTot

IF Select('SATELITE')=0
   NetUse({{DDATA+'SATELITE',.F.}})
ENDIF

*------------------------
IF lLan
   cEOD:=NEOD
   cTXT:=NTXT
   cHST:=NHST
ELSE
   cEOD:=DEOD
   cTXT:=DTXT
   cHST:=DHST
ENDIF
*------------------------------

STORE date() TO dH
STORE 'A:\                           ' TO cDrv

@ MAXROW(),0  SAY ' Drive:\Directory\ transfer from :'
@ MAXROW(),34 GET cDrv PICT "@!"             COLOR "W+/W"
READ

STORE 'CP01'+SubS(DToC(dH),4,2)+SubS(DToC(dH),1,2)+'.DBF' TO cFil
cDrv:=ALlTrim(cDrv)
IF Empty(cDrv) ;RETURN .T.
ENDIF
cDrv:=IF(Right(cDrv,1)='\',cDrv,cDrv+'\')
aD:=Directory(cDrv+'TRF*.*')

cSele:=Select()
DBCreate('C:TRANSF',{{'FLAG','C',1,0},{'DESC','C',12,0}})
USE C:TRANSF NEW
FOR n=1 TO Len(aD)
   DBAppend()
   FIELD->DESC:=aD[n][1]
NEXT
cScr:=SaveScreen(13,50,24,79)
DBGoBottom()
KeyBoard Chr(32)
@ 13,55 TO 24,72
@ 24,55 SAY '-Move ÄÙ-Select' COLOR 'B/W'
aFld:={'FLAG','DESC'}
DBEdit(14,56,23,71,aFld,'FRest',,'','',' ')
RestScreen(13,50,24,79,cScr)
@ MAXROW(), 0  SAY "Restore File... ³ ³ Wait... !!!                                            " COLOR "N/W"
@ MAXROW(),17 SAY "*" COLOR "N*/W"
DBGoTop()
DO WHILE !Eof()
   IF FLAG='û'
      cD:=cDrv+AllTrim(DESC)
      RestTrans(cD,AllTrim(DESC))
   ENDIF
   SELECT TRANSF
   SKIP
ENDDO
USE ;DELETE FILE C:TRANSF.DBF ;SELECT &cSele

RestScreen(0,0,24,79,cS)
RETURN

*----------------------------------------------------------------------------
FUNCTION FRest()
DO CASE
CASE LastKey()=K_ENTER
     IF FLAG=' ' ;FIELD->FLAG:='û'
     ELSE        ;FIELD->FLAG:=' '
     ENDIF
CASE LastKey()=K_ESC
     RETURN 0
ENDCASE
RETURN 1
*----------------------------------------------------------------------------
STATIC FUNCTION RestTrans(cF,cD)
LOCA cFile,cDrv:=Space(30),cPath,cHst
IF Nnetlogged()
   cPath:=NDATA
   cHst:=NHST
ELSE
   cPath:=DDATA
   cHst:=DHST
ENDIF
cFile:=cF
IF !CekExt(cFile,cHst,cD)
   RETURN
ENDIF
@ 24,00 SAY Space(80)
@ 24,00 SAY 'Update '+cPath+'PRODUK.DBF From '+cFile+'             '

IF File(cFile)
   IF Select('PRODUK')#0
      PRODUK->(DBCloseArea())
   ENDIF
   IF !NetUse({{cPath+'PRODUK.DBF',.t.}})             // .f.
      RETURN
   ENDIF
   IF  !File(cPath+"PRODUK_1.NTX") .OR. !File(cPath+"PRODUK_2.NTX") ;
       .OR. !File(cPath+"PRODUK_3.NTX")
       INDEX ON CODE           TO (cPath+"PRODUK_1.NTX")
       INDEX ON Left(DESC,28)  TO (cPath+"PRODUK_2.NTX")
       INDEX ON REF            TO (cPath+"PRODUK_3.NTX")
   ENDIF
   SET INDEX TO (cPath+"PRODUK_1.NTX"),(cPath+"PRODUK_2.NTX"),(cPath+"PRODUK_3.NTX")
   USE (cFile) NEW ALIAS TO
   DO WHILE !Eof()
      IF PRODUK->(DBSeek(TO->INVCODE))
         PRODUK->(RecLock())
         PRODUK->PRICE :=TO->PRICE        //Baru ditambah 07092000
         PRODUK->STOCK+=TO->QTY
      ELSEIF PRODUK->(AddRec())
         PRODUK->(RecLock())
         PRODUK->CODE    :=INVCODE
         PRODUK->REF     :=ALTCODE
         PRODUK->DESC    :=DESC1
         PRODUK->DEPT    :=DEPNO
         PRODUK->GROUP   :=GRPCODE
         PRODUK->PRICE   :=PRICE
         PRODUK->STOCK   :=QTY
      ENDIF
      PRODUK->(DBCOMMIT())
      PRODUK->(DBUnlock())
      TO->(DBSKip())
   ENDDO
   TO->(DBCloseArea()) ;cTgl:=DToS(Date())
   FileCopy(cFile,cHst+cD)
   PRODUK->(DBCloseArea())
   cPath:=IF(NNetLogged(),NDATA,DDATA)
   IF !NetUse({{cPath+'PRODUK.DBF',.t.}})             // .f.
      RETURN
   ENDIF
ELSEIF !File(cFile)
   Warning(" File "+Upper(cFile)+" doesn`t exist... ")
ENDIF
RETURN


STATIC FUNCTION CekExt(cDrv,cHst,cF)
LOCAL cFile:=cDrv
IF AT('.',cDrv)=0
   Warning(' Harus ada extention kode toko... ')
   RETURN .F.
ELSEIF !File(cFile)
   Warning(' File '+Upper(cFile)+' doesn`t exist... ')
   RETURN .F.
ELSEIF File(cHst+cF)
   Warning(' This Transfer File has already Restored... ')
   RETURN .F.
ELSEIF Right(cFile,3)#SATELITE->CODE
   Warning(' The Transfer File doesn`t belong to this store... ')
   RETURN .F.
ENDIF
RETURN .T.

*---------------------------------------------------------

