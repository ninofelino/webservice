#include "inkey.ch"
#include "box.ch"
*-----------------------------------------------------------------------------
FUNCTION CusFunc(c,n,a)
   LOCAL lSv:=.F., cSel:=Select(),cCol:=SetColor()
   LOCAL cSv:=SaveScreen(0,0,24,79),dDue
   LOCAL cD:=SATELITE->(Left(CPNO,4))
   SET CONFIRM ON
   nT:=0
   nNORCPT2:=0
   SELECT CUS
   lLO:=.t.
   SetColor('n/w,w/n')
   DO WHILE lLO
      cPh    :=SPACE(LEN(HOMEPHONE))  &&__Phone
      cGNm   :=SPACE(LEN(NAME))       &&__Customer Name
      cAd1   :=SPACE(LEN(ADD1))       &&__Cust. Address1
      cAd2   :=SPACE(LEN(ADD2))       &&__Cust. Address2
      dLp    :=DATE()                 &&__Last Purchase Date
      cGCCn  :=SPACE(LEN(CODE))       &&__Code Number
      cKot   :=SPACE(LEN(CITY))       &&__Kota Customer
      nPoint :=0
      dGValid:=CToD('  /  /    ')
      lGAct  :=.F.
      nGDsc :=0
      Box(09,20,22,64,'w+/w')
      @ 22,22 SAY 'Tekan [SIGN ON/ESC] - Batal'
      @ 09,21 SAY '®®  MEMBER ENTRY  ¯¯'
      @ 11,22 SAY '        Kode: '
      @ 12,22 SAY '        Nama: '
      @ 13,22 SAY '      Alamat: '
      @ 14,22 SAY '              '
      @ 15,22 SAY '        Kota: '
      @ 16,22 SAY ' Nomor Telp.: '
      @ 17,22 SAY ' Tgl. Member: '
      @ 18,22 SAY ' Berlaku s/d: '
      @ 19,22 SAY 'Total Trans.: '
      @ 20,22 SAY 'Sisa Point  : '

      @ 11,37 GET  cGCCn  PICT '@!' VALID CekCus(cGCCn)
      READ

      IF LASTKEY()=27
         cGCCN:=' '
         SAVE TO (DDATA+cD+'TEMP.MEM') ALL LIKE ?G*
         lNewM:=.F. ;EXIT
      ENDIF

      IF !DBSeek(cGCCn)
          Warning(' Data Customer/member tidak ada.. ! ')
          RESTSCREEN(0,0,24,79,cSV)
          Select(cSel) ;SetColor(cCol)
          cGCCN:=' '
          SAVE TO (DDATA+cD+'TEMP.MEM') ALL LIKE ?G*
          RETURN .T.
      ELSE
          IF !CUS->ACTIVE
             Warning(' Member sudah tidak aktif... ')
             Warning(' Member sudah tidak aktif... ')
             cGCCn:=SPACE(LEN(CODE))
             cGNm:=SPACE(LEN(NAME))
             cCSts:=.F.
             dGValid:=CToD('  /  /    ')
             nGDsc  :=0
             nPOint :=0
             lGAct  :=.F.
             RESTSCREEN(0,0,24,79,cSV)
             Select(cSel) ;SetColor(cCol)
             RETURN .T.
          ENDIF
          cGCCn  :=CODE
//        cGCn   :=CARDNO
          cPh    :=HOMEPHONE
          cGNm   :=NAME
          cAd1   :=ADD1
          cAd2   :=ADD2
          cKot   :=CITY
          dLp    :=DATE()
          dDm    :=DATEMEMBER
          dGValid:=VALID
          nGDsc  :=DISCOUNT
          lGAct  :=ACTIVE
          nLy    :=LYEARPURCH
          nCPu   :=TTLPURCH
          cInv   :=TEMP->NORCP
          nPoint :=TTLPOINT-MINPOINT
          @ 12,37 SAY  cGNm
          @ 13,37 SAY  cAd1
          @ 14,37 SAY  cAd2
          @ 15,37 SAY  cKot
          @ 16,37 SAY  cPh
          @ 17,37 SAY  dDm
          @ 18,37 SAY  dGValid    PICT 'Y'
          @ 19,37 SAY  nCPu       PICT '9,999,999,999'
          @ 20,37 SAY  nPoint     PICT '999,999'
          READ
      ENDIF
      @ 22,21 SAY 'Tekan [SIGN ON/ESC]-Ulangi ; [ENTER]-Lanjut'
      Inkey(0)
      IF Lastkey()=K_ESC
         lLO:=.T.
         SAVE TO (DDATA+cD+'TEMP.MEM') ALL LIKE ?G*
      ELSE
         lLO:=.F.
         SAVE TO (DDATA+cD+'TEMP.MEM') ALL LIKE ?G*
      ENDIF

   ENDDO
   lNewM:=.F.
   RESTSCREEN(0,0,24,79,cSV)
//   IF !Empty(cGCCn)
//      @ 00,00 SAY 'MEMBER: '+Alltrim(cGCCn)+' '+Upper(Left(cGNm,20))+Space(10) COLOR 'w/n'
//   ENDIF
   Select(cSel) ;SetColor(cCol)
RETURN .T.

*-----------------------------------------------------------------------------*
STATIC PROCEDURE CekCus()
LOCAL cSvScreen:=SaveScreen(10,0,24,79),cCol:=SetColor()
LOCAL aF:={{'KODE ANGG'    ,'CODE'     };
          ,{'NAMA'         ,'NAME'     }; //;
          ,{'PEMBELIAN'    ,'TTLPURCH' }}
lSeek:=DBSeek(cGCCn)
IF !lSeek
   Warning(' Data Customer tidak ada.. ! ')
ELSEIF lSeek
   IF !CUS->ACTIVE
      Warning(' Member sudah tidak aktif... ')
      Warning(' Member sudah tidak aktif... ')
      cCSts:=.F.
      cGCCn:=SPACE(LEN(CODE))      &&__Code Number
      dGValid:=CToD('  /  /    ')
      nGDsc  :=0
      lGAct  :=.F.
      RETURN .F.
   ENDIF
   cGCCn  :=CUS->CODE
   cGNm   :=CUS->NAME
   dGValid:=CUS->VALID
   nGDsc  :=CUS->DISCOUNT
   lGAct  :=CUS->ACTIVE
   nCPu   :=CUS->TTLPURCH
   nPoint :=CUS->TTLPOINT-CUS->MINPOINT
   cCsts:=.T.
   RETURN .T.
ENDIF
DBSetOrder(2) ;DBGoTop() ;SetColor('w/n,n/w')
TBLook(aF,{|xD|DBSeek(xD)},'[Daftar Customer]')
IF LastKey()=K_ENTER
   cGCCn  :=CUS->CODE
   cGNm   :=CUS->NAME
   dGValid:=CUS->VALID
   nGDsc  :=CUS->DISCOUNT
   lGAct  :=CUS->ACTIVE
   nCPu   :=CUS->TTLPURCH
   nPoint :=CUS->TTLPOINT-CUS->MINPOINT
   cCsts  :=.T.
ELSE
   Keyboard CHR(13)
   SetColor('n/w,w/n')
   RestScreen(10,0,24,79,cSvScreen)
   cPh    :=SPACE(LEN(HOMEPHONE))  &&__Phone
   cGNm   :=SPACE(LEN(NAME))       &&__Customer Name
   cAd1   :=SPACE(LEN(ADD1))       &&__Cust. Address1
   cAd2   :=SPACE(LEN(ADD2))       &&__Cust. Address2
   dLp    :=DATE()                 &&__Last Purchase Date
   cGCCn  :=SPACE(LEN(CODE))      &&__Code Number
   dGValid:=CToD('  /  /    ')
   nGDsc  :=0
   nPoint :=0
   lGAct  :=.F.
   cKot   :=SPACE(LEN(CITY))       &&__Kota Customer
   cCsts  :=.T.
ENDIF
SetColor(cCol) ;DBSetOrder(1)
RestScreen(10,0,24,79,cSvScreen)
RETURN .T.
*------------------------------------------------------------------------------
STATIC Function CekNor()
LOCAL nRec:=Recno()
IF !CUSDET->(DBSeek(cGCCn+Str(nNorCpT2,6)))
   DBGoTo(nRec)
   Warning('NO NOTA YG DI RETURN SALAH/TIDAK ADA')
   RETURN .F.
ENDIF
RETURN .T.
