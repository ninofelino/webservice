PROCEDURE R_PO28(aDbf,cTitle,lTxt,lPrn)
LOCAL nTPRICE:=0, nNo:=0
PRIVATE nPage:=1, cTtl:=cTitle

*----------------------------------------------------------- Electronic Journal
IF(lTxt == NIL,lTxt:=.T.,.F.)
IF VALTYPE(aDbf) <> 'A' .OR. EMPTY(aDbf)
   WARNING(' File Belum Dipilih ... ! ')
   RETURN
ENDIF
IF lPRN="1"
   SET PRINTER TO $TEMP.TXT
ENDI
SET DEVICE TO PRINT

IF SELE("CP") > 0
   CLOSE CP
ENDIF

IF SELE("RCP") > 0
   CLOSE RCP
ENDIF

Judul(Right(aDbf[1],12))
FOR nI:=1 TO Len(aDbf)
   USE (aDbf[nI]) NEW
   nNo:=0 ;nTPRICE:=0
   DO WHILE !Eof()
      IF FLAG='P/O'
         nTPRICE+=Abs(PRICE)
         nNo++
         @ PRow()+1,00 SAY Str(nNo,3)+'.'
         @ PRow()  ,06 SAY DDATE
         @ PRow()  ,18 SAY Left(CODE,8)
         @ PRow()  ,28 SAY DESC
         @ PRow()  ,60 SAY Abs(PRICE)  PICT '99,999,999'
         @ PRow()  ,72 SAY NORCP       PICT '999999'
      ENDIF
      SKIP
      IF PRow()>=55 .AND. !Eof()
         @ PRow()+1,00 SAY '=============================================================================='
         @ PRow()+1,00 SAY Chr(12)
         nPage++
         Judul(Right(aDbf[nI],12))
      ELSEIF Eof() .AND. nNo>0
         @ PRow()+1,00 SAY '=============================================================================='
         @ PRow()+1,28 SAY 'TOTAL'
         @ PRow()  ,60 SAY nTPRICE    PICT '99,999,999'
         @ PRow()+1,00 SAY '=============================================================================='
         @ PRow()+1,00 SAY Chr(12)
      ENDIF
   ENDDO
   USE
NEXT
IF nNo=0
   @ PRow()+1,00 SAY Chr(12)
ENDIF
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
@ PRow()+1,00 SAY 'TRANSAKSI PENGELUARAN (P/O) '+cTtl
@ PRow()+2,00 SAY 'Satelite#: '+cStl           //+'  Tanggal(mm/dd): '+IF(cTgl='00/00',cTgl1,cTgl)
@ PRow()  ,70 SAY 'Hal:'+Str(nPage,3)
@ PRow()+1,00 SAY '=============================================================================='
@ PRow()+1,00 SAY ' NO.  TANGGAL      J A M    KETERANGAN                          JUMLAH  NO.RCP'
@ PRow()+1,00 SAY '=============================================================================='
*                  123.  xx/xx/xxxx  xx:xx:xx  xxxxxxxxx0xxxxxxxxx0xxxxxxxxx0  99,999,999  999999
*                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                            1         2         3         4         5         6         7         8
RETURN

*------------------------------------------------------------------------------
