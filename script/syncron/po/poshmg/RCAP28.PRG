#include "hmg.ch"
PROCEDURE RCAP28(aDbf,cTitle,lTxt,lPrn)
PRIVATE nPage:=1, cTtl:=cTitle

*----------------------------------------------------------- Electronic Journal
IF(lTxt == NIL,lTxt:=.T.,.F.)
IF VALTYPE(aDbf) <> 'A' .OR. EMPTY(aDbf)
   WARNING(' File Belum Dipilih ... ! ')
   RETURN
ENDIF

SET DEVICE TO PRINT
IF lPRN="1"
   SET PRINTER TO $TEMP.TXT
ENDI

IF SELE("CP") > 0
   CLOSE CP
ENDIF

IF SELE("RCP") > 0
   CLOSE RCP
ENDIF

Judul(Right(aDbf[1],12))
FOR nI:=1 TO Len(aDbf)
   USE (aDbf[nI]) NEW SHARE
   DO WHILE !Eof()
      @ PRow()+1,00 SAY FLAG
      @ PRow()  ,06 SAY CODE
      @ PRow()  ,16 SAY Left(DESC,26)
      @ PRow()  ,44 SAY QTY        PICT '9999'
      @ PRow()  ,50 SAY PRICE      PICT IF(FLAG='NEW','Msn:999999','99,999,999')
      @ PRow()  ,62 SAY QTY*PRICE  PICT '99,999,999'
      @ PRow()  ,74 SAY NORCP      PICT '999999'
      SKIP
      IF PRow()>=55 .AND. !Eof()
         @ PRow()+1,00 SAY '컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'
         @ PRow()+1,00 SAY Chr(12)
         nPage++
         Judul(Right(aDbf[nI],12))
      ENDIF
   ENDDO
   USE
NEXT
@ PRow()+1,00 SAY '컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'
@ PRow()+1,00 SAY Chr(12)
SET DEVICE TO SCREEN
SET PRINTER TO
IF lPRN="1"
   LIHATTEKS('$TEMP.TXT',2,0,23,79,'W/N')
ENDIF
DELETE FILE $TEMP.TXT
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE Judul(cDbf)
LOCAL cStl :=SubS(cDbf,3,2) ,cTgl:=SubS(cDbf,5,2)+'/'+SubS(cDbf,7,2)
LOCAL cTgl1:=SubS(DtoS(Date()),5,2)+'/'+SubS(DToS(Date()),7,2)
SETPRC(0,0)
@ PRow()+1,00 SAY 'JOURNAL TRANSAKSI '+cTtl
@ PRow()+2,00 SAY 'Satelite #: '+cStl+'  Tanggal(mm/dd): '+IF(cTgl='00/00',cTgl1,cTgl)
@ PRow()  ,71 SAY 'Hal:'+Str(nPage,4)
@ PRow()+1,00 SAY '컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'
@ PRow()+1,00 SAY 'FLAG  CODE      DESCRIPTION                  QTY       PRICE       TOTAL  NO.RCP'
@ PRow()+1,00 SAY '컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'
*                  xxx   xxxxxxxx  xxxxxxxxx0xxxxxxxxx0xxxxxx  9999  99,999,999  99,999,999  999999
*                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                            1         2         3         4         5         6         7         8
RETURN

*------------------------------------------------------------------------------
