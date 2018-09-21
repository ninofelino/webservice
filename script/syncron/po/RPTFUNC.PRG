#include "kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION RptFunc(c,n,a)
LOCAL cA:=ALIAS()
LOCAL cKet1,cKet2,nBrs1,nBrs2
LOCAL nDp:=0,nDs:=0,nNORCP := 0, nItem := 0
SELECT TEMP
GO BOTT

DO CASE
CASE TEMP->(LastRec()) > 0
     Warning(' Transaksi Harus Selesai ... ! ')
     RETURN .T.
OTHERWISE
     SELE CP
     CP->(DBGOBOTTOM())
     DO WHILE CP->FLAG <> 'NEW' .AND. !CP->(BOF())
        CP->(DBSKIP(-1))
     ENDDO
     CP->(DBSKIP())
     nNORCP := CP->NORCP

     SET DEVICE TO PRINT
     PHeader()
     SET DEVICE TO SCREEN
     DO WHILE !CP->(EOF())
        DO CASE
        CASE ASCAN({'CRC','PCG'},ALLTRIM(CP->FLAG)) > 0
             CP->(DBSKIP())
             LOOP
        CASE ASCAN({'D%1','D%2','D%3'},ALLTRIM(CP->FLAG))>0
             nDs := CP->PRICE
             IF ALLTRIM(CP->FLAG) = 'D%'
                CP->(DBSKIP(-1))
                nDp:=((nDs*-1)/(CP->PRICE*QTY))*100
                SET DEVICE TO PRINT
                @ PRow()  ,00 SAY _PINIT+_PRCPT
                @ PRow()+1 ,nBrs1  SAY nDp pict '99'
                @ PRow()   ,nBrs1+2  SAY '%'
                CP->(DBSKIP())
                @ PRow()   ,nBrs1+4    SAY LEFT(ALLTRIM(CP->DESC),18)
                @ PRow()   ,nBrs1+31   SAY CP->PRICE   PICT '9,999,999'
                SET DEVICE TO SCREEN
                CP->(DBSKIP(-1))
                CP->(DBSKIP())
             ELSE
                nDp:=0
             ENDIF
             nBrs1:=0
             nBrs2:=29
             cKet1:=IIF(nDp <> 0,TRAN(nDp,'99% '),'')+LEFT(ALLTRIM(CP->DESC),18)
             cKet2:=TRAN(CP->PRICE,'999,999,999')
        CASE ASCAN({'TAX'},ALLTRIM(CP->FLAG))>0
             nDs := CP->PRICE
             IF ALLTRIM(CP->FLAG) = 'TAX'
                CP->(DBSKIP(-1))
                nDp:=((nDs*1)/(CP->PRICE*QTY))*100
                SET DEVICE TO PRINT
                @ PRow()  ,00 SAY _PINIT+_PRCPT
                @ PRow()+1 ,nBrs1  SAY nDp pict '99'
                @ PRow()   ,nBrs1+2  SAY '%'
                CP->(DBSKIP())
                @ PRow()   ,nBrs1+4    SAY LEFT(ALLTRIM(CP->DESC),18)
                @ PRow()   ,nBrs1+31   SAY CP->PRICE   PICT '9,999,999'
                SET DEVICE TO SCREEN
                CP->(DBSKIP(-1))
                CP->(DBSKIP())
             ELSE
                nDp:=0
             ENDIF
             nBrs1:=0
             nBrs2:=29
             cKet1:=IIF(nDp <> 0,TRAN(nDp,'99% '),'')+LEFT(ALLTRIM(CP->DESC),18)
             cKet2:=TRAN(CP->PRICE,'999,999,999')
        CASE ASCAN({'DS1','DS2','DS3'},ALLTRIM(CP->FLAG))>0
             nDs := CP->PRICE
             IF ALLTRIM(CP->FLAG) = 'DS'
                CP->(DBSKIP(-1))
                SET DEVICE TO PRINT
                @ PRow()  ,00 SAY _PINIT+_PRCPT
                CP->(DBSKIP())
                @ PRow()+1 ,nBrs1+4    SAY LEFT(ALLTRIM(CP->DESC),18)
                @ PRow()   ,nBrs1+31   SAY CP->PRICE   PICT '9,999,999'
                SET DEVICE TO SCREEN
                CP->(DBSKIP(-1))
                CP->(DBSKIP())
             ENDIF
             nBrs1:=0
             nBrs2:=29
        CASE ALLTRIM(CP->FLAG) == 'STD'
             nBrs1:=0
             nBrs2:=29
             cKet1:=ALLTRIM(CP->DESC)
             cKet2:=TRAN(CP->PRICE,' 99,999,999')
        OTHERWISE

             DO CASE
             CASE CP->FLAG=='PLU'
                  nItem+=CP->QTY
             CASE CP->FLAG=='RTN'
                  nItem-=CP->QTY
             CASE CP->FLAG=='VOD'
                  nItem+=(ABS(CP->PRICE)/CP->PRICE)*CP->QTY
             ENDCASE

             nBrs1:=0
             nBrs2:=29
             cKet1:=IIF(EMPTY(CP->CODE),LEFT(ALLTRIM(CP->DESC),20),CP->CODE+' '+LEFT(ALLTRIM(CP->DESC),14))
             cKet2:=TRAN(CP->PRICE,' 99,999,999')
        ENDCASE

        SET DEVICE TO PRINT
        @ PRow()  ,00 SAY _PINIT+_PRCPT

        IF CP->FLAG == 'STL'
           @ PRow()+1 ,00  SAY LEFT(ALLTRIM(CP->DESC),18)
           @ PRow()   ,30  SAY CP->PRICE PICT '99,999,999'
        ENDIF
        DO CASE
           CASE CP->FLAG == 'PLU'
                @ PRow()+1 ,nBrs1  SAY cKet1
                @ PRow()+1 ,nBrs1  SAY CP->QTY PICT '999x'
                @ PRow()   ,PCol() SAY cKet2
                @ PRow()   ,nBrs2  SAY CP->PRICE*QTY PICT ' 99,999,999'
                @ PRow()   ,PCol() SAY CHR(13)
           CASE CP->FLAG == 'RTN'
                @ PRow()+1 ,nBrs1  SAY cKet1+'(R)'
                @ PRow()+1 ,nBrs1  SAY CP->QTY PICT '999x'
                @ PRow()   ,PCol() SAY cKet2
                @ PRow()   ,nBrs2  SAY CP->PRICE*QTY PICT ' 99,999,999'
                @ PRow()   ,PCol() SAY CHR(13)
           CASE CP->FLAG == 'VOD'
                @ PRow()+1 ,nBrs1  SAY cKet1+'(V)'
                @ PRow()+1 ,nBrs1  SAY CP->QTY PICT '999x'
                @ PRow()   ,PCol() SAY cKet2
                @ PRow()   ,nBrs2  SAY CP->PRICE*QTY PICT ' 99,999,999'
                @ PRow()   ,PCol() SAY CHR(13)
           OTHERWISE
                IF CP->FLAG == 'TTL'
                   @ PRow()+1 ,nBrs1 SAY PDWidth('TOTAL')
                   @ PRow()   ,nBrs2+12 SAY cKet2
                ENDIF
                @ PRow()   ,PCol() SAY CHR(13)
        ENDCASE
        SET DEVICE TO SCREEN

        CP->(DBSKIP())
     ENDDO
     SET DEVICE TO PRINT
     @ PRow()  ,00 SAY _PINIT+_PRCPT
     @ PRow()+2 ,00 SAY "RPCNO:"+ALLTRIM(TRAN(nNORCP,'999999'))+"þ"+;
                        ALLTRIM(TRAN(nItem,'9999'))+" Items"+"þ"+;
                        "MCHN:"+ALLTRIM(TRAN(SATELITE->MCHNID,'999999'))
     @ PRow()+2 ,02     SAY PDWidth('< **  REPRINT  ** >')
     @ PRow()   ,PCol() SAY CHR(13)
     @ PRow()+2 ,0      SAY Replicate('#',40)
     PCutter()
     SET DEVICE TO SCREEN
ENDCASE

GO BOTT
c:='' ;CLSFunc()
SELECT(cA)
RETURN .T.
*-----------------------------------------------------------------------------
