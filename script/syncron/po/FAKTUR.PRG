#include 'inkey.ch'
#include 'kassa.ch'
*-----------------------------------------------------------------------------*
PROCEDURE FakturF(c,n,a)
LOCAL cScr:=SaveScreen(10,15,15,65), cA:=ALIAS(), nD:=0
STATIC nCash
PRIVATE aPLU1:={}, aPLU2:={} ,aPLU3:={}, aPLU4:={}, nDISC:=0, nTTL:=0, nTOTAL:=0, nItem:=0, nIt:=0, nIte:=0
PRIVATE cNAME,cADD1,cADD2,cPH,cINVO,cTGL,cSales:='',cDD
SetCursor(0)
RestScreen(10,15,15,65,cScr)
IF LastKey()=27
   SELECT TEMP
   RETURN .T.
ENDIF
SET DEVICE TO PRINT
cFi :='TXT\Faktur.Txt'
IF IsiArr()
   Set(20,"PRINTER")
   PrintInv(cSales)
ENDIF
c:='' ;SELECT TEMP ;GO BOTT
RETURN .T.
********************************************************************************
STATIC PROCEDURE PrintInv(cSales)
LOCAL _POPEN := chr(27)+chr(64)+CHR(27)+'p'+CHR(0)+CHR(15)+CHR(60)
STATIC nCash
LOCAL nNo:=1,nPage:=1, cA:=ALIAS(), cSel:=Select()
LOCAL cNo, cPLU, lHabis:=.F., nI, nn, nLoop, nNORCP
PRIVATE nITEMPCS:=0
nNORCP:=SATELITE->NORCP
nLoop:=IF(Len(aPLU1)>23,23,Len(aPLU1))
PHeader(nPage)

DO WHILE nNo<=Len(aPLU1)
   FOR nI=1 TO nLoop
      cNo:=Right('00'+AllTrim(Str(nNo,2)),2)+'.'
      cPLU:=aPLU1[nI]
      IF aPLU3[nI]#0
         @ PRow()+1,00 SAY Trans(aPLU3[nI],'999')
         @ PRow()  ,04 SAY PRODUK->UNIT
         @ PRow()  ,08 SAY Trans(aPLU2[nI],'@!')
         @ PRow()  ,22 SAY Trans(aPLU4[nI],'9999999')
         @ PRow()  ,30 SAY Trans(aPLU3[nI]*aPLU4[nI],'99,999,999')
         nNo++
      ENDIF
   NEXT
ENDDO
nTTLNET:=nTTL-nDISC
@ PRow()+1,00 SAY '----------------------------------------'
nCash:=TEMP->PRICE
@ PRow()+1,00 SAY 'SUBTOTAL'
@ PRow()  ,30 SAY Trans(nTOTAL,'99,999,999')
@ PRow()+1,00 SAY 'DISCOUNT'
@ PRow()  ,30 SAY Trans(nDISC,'99,999,999')
@ PRow()+1,00 SAY 'TOTAL'
@ PRow()  ,30 SAY Trans(nTTLNET,'99,999,999')
@ PRow()+2 ,00  SAY "No. Nota: "+RIGHT('000000'+ALLTRIM(STR(nNORCP)),6)
@ PRow()  ,25 SAY "Jumlah: "+Trans(nItem,'999')+" Pcs"
@ PRow()+4,00 SAY _POPEN  //''
@ PRow()+1  ,(41-Len(cJDL))/2 SAY cJDL ;@ PRow()+1,0 SAY SATELITE->STO2
@ PRow()+1  ,0 SAY SATELITE->STO3 ;@ PRow()+1,0 SAY SATELITE->STO4
SET PRINT TO ;SET PRINT OFF ;SET DEVICE TO SCREEN
********************************************************************************
STATIC PROCEDURE PHeader(nPage)
LOCAL cD:=CASHIER->(Left(DESC,13))+' '+DToC(Date())+' ('+ Left(Time(),5)+')' +;
          ' POS:'+SATELITE->(SubS(CPNO,3,2)) //+' M#:'+RIGHT('000000'+ALLTRIM(STR(SATELITE->MCHNID)),6)
@ PRow()+1,00 SAY cD
IF !Empty(cGCCN)
//   @ PRow()+1,00 SAY 'Pelanggan : '+AllTrim(cGCCN)+' þ '+Left(cGNm,17)
   @ PRow()+1,00 SAY 'PELANGGAN : '+Left(cGNm,20)
ENDIF
@ PRow()+2,00 SAY '----------------------------------------'
@ PRow()+1,00 SAY 'Qty Unt Nama Barang     Harga      Total'
@ PRow()+1,00 SAY '----------------------------------------'
RETURN
*-----------------------------------------------------------------------------*
STATIC PROCEDURE IsiArr()
LOCAL cDbf:=DDATA+'___TEMP.DBF'
LOCAL aDbf :={{'FLAG'  ,'C', 3,0};
            ,{'CODE'   ,'C',13,0};
            ,{'DESC'   ,'C',30,0};
            ,{'QTY'    ,'N', 3,0};
            ,{'UNIT'   ,'N', 3,0};
            ,{'PRICE'  ,'N', 9,0};
            ,{'NORCP'  ,'N', 6,0};
            ,{'CUSCODE','C',10,0}}
DBCreate(DDATA+"CPNGN",aDbf)
USE (DDATA+"CPNGN") NEW
cDbf:=DDATA+'___TEMP'

SELECT CP
GO BOTT
DO WHILE FLAG#'NEW'
   SKIP -1
ENDDO
DO WHILE !Eof()
   IF FLAG='NEW' .OR. FLAG='PLU' .OR. FLAG='D' .OR. FLAG='RTN' .OR. FLAG='VOD' .OR. FLAG='TTL'
      CPNGN->(AddRec())
      CPNGN->FLAG   :=FLAG
      CPNGN->CODE   :=CODE
      CPNGN->DESC   :=DESC
      CPNGN->QTY    :=QTY
      CPNGN->PRICE  :=PRICE
      CPNGN->NORCP  :=NORCP
   ENDIF
   SKIP
ENDDO
GO BOTT
SELECT CPNGN
GO TOP
DO WHILE !Eof()
   DO WHILE FLAG='NEW' .OR. LEFT(FLAG,1)='T' .OR. FLAG='STL'
      IF FLAG='TTL'
         nTOTAL :=PRICE
      ENDIF
      SKIP
   ENDDO
   IF FLAG='D'
      nDisc+=(Abs(PRICE))
   ELSEIF FLAG='PLU' .OR. FLAG='RTN'
      AADD(aPLU1,CODE)
      AADD(aPLU2,IF(FLAG='RTN',Left(DESC,11)+'(R)',Left(DESC,14)))
      AADD(aPLU3,QTY)
      AADD(aPLU4,PRICE)
      nTTL+=(QTY*PRICE)
      nIt+=Qty
   ELSEIF FLAG='VOD'
      nA:=ASCAN(aPLU1,CODE)
      IF nA>0
         aPLU3[nA]-=QTY
         nTTL+=(QTY*PRICE)
         nIte+=QTY
      ENDIF
   ENDIF
   nItem:=(nIt-nIte)
   SKIP
ENDDO
nTOTAL+=nDisc
CLOSE
RETURN .T.
*-----------------------------------------------------------------------------*
