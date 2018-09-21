#include "hmg.ch"
#Include 'KASSA.CH'

*------------------------------------------------------------------------------
FUNCTION EKMFunc(c,n,a)
LOCAL nBANYAK:=0,nSISA:=0,nSISANYA:=0,nNORCP:=0,nTOTAL:=0, nTTOTAL:=0,lEkm
LOCAL aKEKM:={'T01','T02','T03','T04','T05','T06','T07','T08','T09','T10','T11','T12','T13','T14'}
IF TEMP->(LASTREC())#0 .AND. LEN(c)=0
   WARNING('Tidak Dapat DILAKUKAN - Sedang Transaksi ... !')
   RETURN .T.
ENDIF
nManKpn:=0
nManKpn:=val(c)   // untuk input kupon manual
IF c='Î'
   lEkm:=c
ENDIF
cD:=ALIAS()
SELECT CP
CP->(DBGOBOTTOM())
DO WHILE !CP->(BOF()) .AND. CP->FLAG#'TTL'
   IF ASCAN(aKEKM,CP->FLAG)>0
      nTOTAL:=CP->PRICE
      nNORCP:=CP->NORCP

      SELECT TOMBOL
      GO TOP
      LOCATE FOR FLAG==CP->FLAG

      IF FOUND()
         nREC:=TOMBOL->(RECNO())
         SELECT TOMBOL
         GO TOP
         LOCATE FOR ASSIGN=nREC
         IF FOUND() .AND. TOMBOL->DCR
            nTTOTAL+=nTOTAL
         ENDIF
       ENDIF
   ENDIF
   CP->(DBSKIP(-1))
ENDDO
// BARU CETAK
IF nTTOTAL > 0
  nBANYAK:=INT(nTTOTAL/SATELITE->KUPON)
   nSisa:=MOD(nTTOTAL,SATELITE->KUPON)
   nSisanya:=SATELITE->KUPON - nSisa
   IF(nSisanya<=SATELITE->TLR,nBANYAK+=1,nBANYAK)
   IF nBANYAK > 0
      SET DEVICE TO PRINTER
      IF nManKpn#0
         nBANYAK:=nManKpn
      ENDIF
      PCUPON(nNORCP,nTTOTAL,nBANYAK,lEkm)
   ENDIF
ELSE
   WARNING('Tombol MEDIA Tidak ada yang di SET sebagai Kupon ... !')
ENDIF
SELECT (cD)
   lGBarCode:=.F.
   nGKeyLock:=0
   lGVod:=.F.
   lGRtn:=.F.
   lGStl:=.F.
   cGDFlag:=''
   cGDDesc:=''
   nGDisc:=0
   nGStl:=0
//   ViewTrn(0)
   nGBrs:=5
   c:=''; CLSFunc()
RETURN .T.
*-----------------------------------------------------------------------------
