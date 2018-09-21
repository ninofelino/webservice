#include "hmg.ch"
#include "Kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION ALVFunc(c,n,a)
LOCAL nX:=0 ,nChoice:=0, nFile:=0 ,cFileHold:='' ,cFileTemp:=''
DO CASE
   CASE LASTREC()=0
	Warning(' Tidak Bisa ALL VOID, Belum ada Transaksi ... ! ') ;RETURN .T.
   CASE LASTREC()>0
        SELECT TEMP
        TEMP->(DBGOTOP())
	DO WHILE TEMP->(!EOF())   &&______Copy File Temporary Ke File Capture
	   cD:=TEMP->FLAG
	   IF cD='D%'.OR.cD='DP' 
	      TEMP->QTY:=0
	   ENDIF 

           IF _ICS#1
              DO CASE
                 CASE (TEMP->FLAG='PLU')
                      IF (PRODUK->(DBSEEK(TEMP->CODE)))
                         PRODUK->(RecLock())
                         PRODUK->STOCK +=TEMP->TJQTY
                         PRODUK->QTYSELL -=TEMP->TJQTY
                         PRODUK->(DBUnlock())
                      ENDIF
                 CASE (TEMP->FLAG='RTN'.OR. TEMP->FLAG='VOD')
                      IF (PRODUK->(DBSEEK(TEMP->CODE)))
                         PRODUK->(RecLock())
                         PRODUK->STOCK -= TEMP->TJQTY
                         PRODUK->QTYSELL +=TEMP->TJQTY
                         PRODUK->(DBUnlock())
                     ENDIF
              ENDCASE
           ENDIF

           TEMP->FLAG:=IF(cD#'NEW',IF(cD='PCG' .OR. cD='STL'.OR. cD='TTL','þþþ','ALV'),cD)
           TEMP->(DBSKIP(1))
        ENDDO
        ResetMem(@a)
	CapTransfer()
        SELECT TEMP
	ClearEntry()
        AllView()
	c:=''
	CLSFunc()
        ALVMess("**    ALL VOID    **")

	nCash:= NIL
	lGBarCode:=.F.
	nGKeyLock:=0
	lGVod:=.F.
	lGRtn:=.F.
	lGStl:=.F.
	cGDFlag:=''
	cGDDesc:=''
	nGDisc:=0
	nGStl:=0
	ViewTrn(0)
	ClearEntry()
        nGBrs:=8

        ResetKey(@a)
        RETURN .T.
ENDCASE
c:=''
CLSFunc()
RETURN .T.

*-----------------------------------------------------------------------------
STATIC PROCEDURE ALVMess(cHead)
SET DEVI TO PRINT
cGDFlag:='' ;cGDDesc:='' ;cGKey:=''
nGDisc:=0   ;nGStl:=0    ;nGPFlag:=0
@ PROW()+02,00 SAY REPL('Ä',39)
JPrint(PROW(),40,REPL('Ä',39))
IF lGJour ;@ PROW()+01,00 SAY PDWidth(Left(cHead+space(20),20)+cHead)
ELSE      ;@ PROW()+01,00 SAY PDWidth(Left(cHead+space(20),20))
ENDIF
@ PROW()+01,01 SAY DTOC(DATE())+'þ'+TIME()
JPrint(PROW(),40,DTOC(DATE())+'þ'+TIME())
@ PROW()+01,00 SAY REPL('Ä',39)
JPrint(PROW(),40,REPL('Ä',39))
PCutter()
SET DEVI TO SCREEN
RETURN                            // ini sudah ok 40 kolom

*-----------------------------------------------------------------------------
STATIC PROCEDURE AllView()
lGStl:=.F. ;nGStl:=0 ;nGBrs:=8
aDSC:={'STD','D%1','D%2','D%3','DS1','DS2','DS3'}
SELECT TEMP
FOR nD:=1 TO LastRec()
    GO nD
    DO CASE
       CASE FLAG='STD'
            nGStl+=PRICE
            ViewTrn(1)
       CASE AScan(aDSC,FLAG)>0
            nGStl+=PRICE
            ViewTrn(0)
       CASE AScan({'PLU','VOD','RTN','P/O','R/A'},FLAG)>0
            nGStl+=PRICE*QTY 
            ViewTrn(1)
    ENDCASE 
NEXT
RETURN

*-----------------------------------------------------------------------------
