#include "hmg.ch"
#include 'inkey.ch'
#include 'kassa.ch'
*------------------------------------------------------------------------------*
PROCEDURE CpCopy()
LOCAL i,cFile,cFile2,cP
LOCAL aDBF:={{'FLAG','C',01,0};
            ,{'DESC','C',12,0}}
PRIVATE aDir:={},aTgl:={},cPEOD,nJF:=0 ,cCurDir:=DiskName()+':'+DirName()
 KeyBoard Chr(32)
 DBCreate('C:TEMPEOD.DBF',aDBF)
 USE C:TEMPEOD NEW ALIAS FEOD
 INDEX ON SubS(DESC,3,2)+SubS(DESC,5,4) TO C:TEMPEOD
 IF NNetLogged() ;cPEOD:=NEOD
 ELSE            ;cPEOD:=DEOD
 ENDIF
 aDir:=Directory(cPEOD+'*.dbf')
 FOR i=1 TO Len(aDir)
    cFile:=Upper(aDir[i][1])
    APPEND BLANK
    FIELD->DESC:=cFile
 NEXT
 SetColor('N/W,W/N')
 Box(3,20,20,57,'w+/w')
 @  3,22 SAY 'Pilih Terminal <EOD COPY>'
 @  4,21 SAY Repl('Ä',36) COLOR 'W+/W'
 @ 24,00 SAY Space(80)
 @ 24,0 SAY ' [5]-Select  [1]-SelectAll  [7]-UnSelectAll  [.]-Proses  [0]-Exit'
 DBGoTop()
 aFld:={'"["+FLAG+"]"','"Terminal  --> #"+SubS(DESC,3,2)+" <"+SubS(DESC,7,2)+"/"+SubS(DESC,5,2)+">"'}
 aJdl:={'',''}
 DBEdit(5,21,19,56,aFld,'EodProc',,aJdl,'','   ','','')
 FEOD->(DBCloseArea())
 DELETE FILE C:TEMPEOD.DBF
 DELETE FILE C:TEMPEOD.NTX
 RETURN


PROCEDURE EodProc(nMod,nFld)
LOCAL cTgl:=Space(4)
DO CASE
CASE Chr(LastKey())='0'
   RETURN 0
CASE Chr(LastKey())='5' .AND. nFld=1
   IF !Empty(FLAG)
      FIELD->FLAG:=' '  ;nJF--
      IF nJF=0 ;aTgl:={}
      ENDIF
   ELSEIF Len(aTgl)=0
      FIELD->FLAG:='û'
      AADD(aTgl,SubS(DESC,5,4))
      nJF++
   ELSEIF SubS(DESC,5,4)=aTgl[1]
      FIELD->FLAG:='û' ;nJF++
   ENDIF
CASE Chr(LastKey())='1'
   IF Len(aTgl)=0
      cTgl:=SubS(DESC,5,4)
      IsiFlag(cTgl)
   ELSE
      IsiFlag(aTgl[1])
   ENDIF
   KeyBoard Chr(32)
   RETURN 2
CASE Chr(LastKey())='7'
   nRec:=Recno()
   REPL ALL FLAG WITH ' ' ;aTgl:={}
   KeyBoard Chr(32)
   nJF:=0 ;DBGoTo(nRec)
   RETURN 2
CASE Chr(LastKey())='.'
   @ 24,0 SAY Space(80) ;CopyCp()
   RETURN 0
ENDCASE
ColorSelect(1)
@ Row(),22 SAY ' '+"["+FLAG+"]   "
@ Row(),29 SAY "Terminal  --> #"+SubS(DESC,3,2)+" <"+SubS(DESC,7,2)+"/"+SubS(DESC,5,2)+">  "
nKey:=Inkey(0)
KeyBoard Chr(nKey)
ColorSelect(0)
RETURN 1


STATIC PROCEDURE CopyCp()
LOCAL cToko :=SATELITE->CODE, cSel:=Select(), cDir:=Space(35)
LOCAL cFile2:='C'+cToko+SubS(DESC,5,4), nSw:=1, cScr:=SaveScreen(23,00,24,79)
SET DELI TO '[]' ;SET DELI ON ;SetCursor(1) ;SetColor('N/W,N/W')
@ 24,00 SAY Space(79)
@ 24,00 SAY 'Drive & Directory tujuan ( drv:\path1 ) ' GET cDir PICT '@!' VALID CekDir(cDir)
READ
SET DELI OFF ;SetCursor(0) ;SetColor('N/W,W/N')
IF LastKey()=K_ESC .OR. Empty(cDir)
   RETURN
ENDIF
RestScreen(23,00,24,79,cScr)
cDir:=AllTrim(cDir) ;cDir:=IF(Right(cDir,1)='\',Left(cDir,Len(cDir)-1),cDir)
cDir:=cDir+'\'
cFile2:=cDir+cFile2
IF DirChange(cDir) == 0
   DirChange(cCurDir)
   IF Left(cDir,1)$'AB' .AND. !ChkDiskWr(Left(cDir,1))
      RETURN
   ENDIF
   FOR i=1 TO Len(aDir)
      cFile:=Upper(aDir[i][1])
      LOCATE FOR DESC=cFile
      IF Found() .AND. FLAG='û'
         IF nSw=1 ;nSw=2
            USE (cPEOD+cFile) NEW
            aStru:=DBStruct()
            DBCreate(cFile2,aStru)
            DBCloseArea()
            USE (cFile2) NEW ALIAS FTGT
         ENDIF
         IF Select('FTGT')#0
            SELECT FTGT
         ELSE ;USE (cFile2) NEW ALIAS FTGT
         ENDIF
         cP:=13-Len(cFile)
         @ 24,00 SAY ' Gabung '+cPEOD+cFile+Space(cP)+' KE ==> '+cFile2
         APPEND FROM (cPEOD+cFile)
         inkey(.2)
         SELECT &cSel
      ENDIF
   NEXT
   IF Select('FTGT')#0
      FTGT->(DBCloseArea())
   ENDIF
   SELECT &cSel
ELSE
   Warning(' Directory tersebut tidak ada  atau  disket belum siap.... ')
ENDIF
RETURN


STATIC PROCEDURE IsiFlag(cTgl)
LOCAL nRec:=RecNo()
DBGoTop()
DO WHILE !Eof()
   IF SubS(DESC,5,4)=cTgl .AND. FLAG=' '
      FIELD->FLAG:='û'
      nJF++
      AADD(aTgl,SubS(DESC,5,4))
   ENDI
   SKIP
ENDDO
DBGoTo(nRec)
RETURN

STATIC FUNCTION CekDir(cD)
IF LastKey()#K_ESC .AND. AT(':',cD)=0
   Warning(' Nama drive harus diketikan. Contoh: C:\KASIR\DAT ')
   RETURN .F.
ENDIF
RETURN .T.

