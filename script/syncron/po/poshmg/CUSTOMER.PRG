#include "hmg.ch"
#include 'box.ch'
#include 'inkey.ch'
#include 'setcurs.ch'
*------------------------------------------------------------------------------
PROCEDURE Customer(l)
PRIVATE cHOMEPHONE
PRIVATE cHANDPHONE
PRIVATE cFAX
PRIVATE cNAME
PRIVATE cADD1
PRIVATE cADD2
PRIVATE cCITY
PRIVATE cCODE
PRIVATE cCARDNO
PRIVATE cCLASS
PRIVATE cIDCARD
PRIVATE cEMAIL
PRIVATE dTGLAHIR
PRIVATE dVALID
PRIVATE nDISCOUNT
PRIVATE cZIP
PRIVATE cCOMENT1
PRIVATE cCOMENT2
PRIVATE cCOMENT3
PRIVATE dDATEMEMBE
PRIVATE cREFERENCE
PRIVATE nTTLPURCH
PRIVATE nLYEARPURC
PRIVATE dLASTPURCH
PRIVATE nVALLPURCH
PRIVATE lACTIVE
PRIVATE nTTLPOINT
PRIVATE nMINPOINT
PRIVATE lF4:=.F.
PRIVATE cCon:=Chr(15),cNCon:=Chr(18)

IF SELECT('CUS')=0
   IF NNETLOGGED()
      USE (NDATA+"CUS") NEW SHARED
      SELECT CUS
      SET INDEX TO (NDATA+"CUS____1.NTX"),(NDATA+"CUS____2.NTX")
  ELSE
     USE (DDATA+"CUS") NEW SHARED
     SET INDEX TO (DDATA+"CUS____1.NTX"),(DDATA+"CUS____2.NTX")
  ENDIF
ENDIF
IF SELECT('CUSDET')=0
   IF NNETLOGGED()
      USE (NDATA+"CUSDET") NEW SHARED
      SELECT CUS
      SET INDEX TO (NDATA+"CUSDET_1.NTX"),(NDATA+"CUSDET_2.NTX")
  ELSE
     USE (DDATA+"CUSDET") NEW SHARED
     SET INDEX TO (DDATA+"CUSDET_1.NTX"),(DDATA+"CUSDET_2.NTX")
  ENDIF
ENDIF
SELECT CUS
Show()
Proses()
SET DELE ON
SET KEY K_ESC TO
UseFile()
RETURN
*------------------------------------------------------------------------------
STATIC PROCEDURE Proses()
aFiel:={'CODE','NAME','ADD1','HOMEPHONE','FAX','CITY','ZIP',;
       'REFERENCE','TTLPURCH','COMENT1','COMENT2'}
aHead:={'KODE','NAMA','ALAMAT','PHONE','FAX','KOTA',;
        'KDPOS','REFERENSI','TTL TRANSAKSI','NOTE1','NOTE2'}
OldColor:=SetColor()
Screen()
DBEDIT(2,1,22,78,aFiel,'CusKey',,aHead,'Ä')
SetColor(OldColor)
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE Screen()
@ 01,00 CLEAR TO 24,79
@ 01,00 TO 23,79
TENGAHIN('         FILE MASTER MEMBER         ',0,0,79,'N/W')
@ 24,0 SAY 'F2-EditF3-CariF4-TambahF5-HapusF6-LihatF7-HistoryF8-PrtF9-PoinESC-Keluar' COLOR '/w'
//          012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                    1         2         3         4         5         6         7
RETURN

*------------------------------------------------------------------------------
FUNCTION CusKey(nMode,nFld)
LOCAL  nInKey,nRetVal:=1
 IF Deleted() ;@ 01,73 SAY 'DELETE' COLOR 'w+*'      //;KeyBoard Chr(32)
 ELSE         ;@ 01,73 SAY 'ÄÄÄÄÄÄ' COLOR 'w'   //;KeyBoard Chr(32)
 ENDIF        ;GetList:={}
 cField:=aFiel[nFld]
 SAVE SCREEN TO cScr
 SetCursor(SC_NONE)
 nInKey:=LastKey()
 DO CASE
 CASE nInKey=K_F2   ;F2Edit()              //Edit......
 CASE nInKey=K_F3   ;F3Search()            //Search....
 CASE nInKey=K_F4   ;F4Add() ;KeyBoard Chr(1)           //Add.......
 CASE nInKey=K_F5                          //Delete....
      DO CASE
      CASE Delete() ;Reclock() ;RECALL
      CASE RecLock();DELETE
      ENDCASE
      UNLOCK
      nRetVal:=2
 CASE nInKey=K_F6   ;F6Display()
 CASE nInKey=K_F7   ;Rn:=Recno();F7Hist(Rn)
 CASE nInKey=K_F8   ;F8Print() ;KeyBoard Chr(32)
 CASE nInKey=K_F9   ;F9Point()
 CASE nInKey=K_ESC  ;nRetVal:=0            //Quit......
 ENDCASE
 REST SCREEN FROM cScr
 IF Deleted() ;@ 01,73 SAY 'DELETE' COLOR 'w+*/w'      //;KeyBoard Chr(32)
 ELSE         ;@ 01,73 SAY '      ' COLOR '/w'
 ENDIF
 SetCursor(SC_NONE)

 SetColor()
RETURN nRetVal

*------------------------------------------------------------------------------
STATIC PROCEDURE Show()
@ 01,0 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 02,0 SAY '³                                  DATA MEMBER                                 ³'
@ 03,0 SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 04,0 SAY '³ K o d e                               ³ Tg.Lahir                             ³'
@ 05,0 SAY '³ N a m a                               ³ No. KTP/SIM                          ³'
@ 06,0 SAY '³                                       ³                                      ³'
@ 07,0 SAY '³ Alamat                                ³ HomePh                               ³'
@ 08,0 SAY '³                                       ³ HandPh                               ³'
@ 09,0 SAY '³ K o t a                               ³ Fax.                                 ³'
@ 10,0 SAY '³ Kode Pos                              ³                                      ³'
@ 11,0 SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 12,0 SAY '³ Anggota Sejak            (DD/MM/YYYY) ³ Total Transaksi                      ³'
@ 13,0 SAY '³ Berlaku s/d              (DD/MM/YYYY) ³                                      ³'
@ 14,0 SAY '³ Discount                              ³ Tg.Terakhir Trans                    ³'
@ 15,0 SAY '³ Activ                                 ³ Nilai Trans Terakhir                 ³'
@ 16,0 SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ Ttl Trans Thn lalu                   ³'
@ 17,0 SAY '³ Catatan                               ³                                      ³'
@ 18,0 SAY '³                                       ³ Total Point/Kupon                    ³'
@ 19,0 SAY '³                                       ³ Point/Kupon dipakai                  ³'
@ 20,0 SAY '³                                       ³ Sisa Point/Kupon                     ³'
@ 21,0 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
//          0123456789012345678901234567890123456789012345678901234567890123456748901234567890
//                    1         2         3         4         5         6          7         8
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE Say()
LOCAL cOld:=SetColor('w+')
@ 01,73 SAY If(Deleted(),'DELETE','      ') COLOR If(Deleted(),'w+','/w')
@ 04,14 SAY CODE        PICT '@!'
@ 05,14 SAY NAME        PICT '@!'
@ 07,14 SAY ADD1        PICT '@!'
@ 08,14 SAY ADD2        PICT '@!'
@ 09,14 SAY CITY        PICT '@!'
@ 10,14 SAY ZIP         PICT '99999'
@ 04,55 SAY TGLAHIR
@ 05,55 SAY IDCARD      PICT '@!'
@ 07,55 SAY HOMEPHONE   PICT '@!'
@ 08,55 SAY HANDPHONE   PICT '@!'
@ 09,55 SAY FAX         PICT '@!'
@ 12,16 SAY DATEMEMBER  PICT '@D'
@ 13,16 SAY VALID
@ 14,16 SAY DISCOUNT    PICT '@E 99.99'
@ 15,16 SAY ACTIVE      PICT 'Y'
@ 17,10 SAY COMENT1
@ 18,10 SAY COMENT2
@ 12,65 SAY TTLPURCH    PICT '@E 9,999,999,999'
@ 14,68 SAY LASTPURCH   PICT '@D'
@ 15,65 SAY VALLPURCH   PICT '@E 9,999,999,999'
@ 16,65 SAY LYEARPURCH  PICT '@E 9,999,999,999'
@ 18,65 SAY TTLPOINT    PICT '@E 99,999'
@ 19,65 SAY MINPOINT    PICT '@E 99,999'
@ 20,65 SAY TTLPOINT-MINPOINT   PICT '@E 99,999'
SetColor(cOld)
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE GetVar()
GetList:={}
SetCursor(1)
@ 04,14 GET cCODE        PICT '@!'
@ 05,14 GET cNAME        PICT '@!'
@ 07,14 GET cADD1        PICT '@!'
@ 08,14 GET cADD2        PICT '@!'
@ 09,14 GET cCITY        PICT '@!'
@ 10,14 GET cZIP         PICT '99999'
@ 04,55 GET dTGLAHIR
@ 05,55 GET cIDCARD      PICT '@!'
@ 07,55 GET cHOMEPHONE   PICT '@!'
@ 08,55 GET cHANDPHONE   PICT '@!'
@ 09,55 GET cFAX         PICT '@!'
@ 12,16 GET dDATEMEMBER  PICT '@D'      VALID !Empty(dDATEMEMBER)
@ 13,16 GET dVALID                      VALID !Empty(dVALID)
@ 14,16 GET nDISCOUNT    PICT '@E 99.99'
@ 15,16 GET lACTIVE      PICT 'Y'
@ 17,10 GET cCOMENT1     PICT '@!'
@ 18,10 GET cCOMENT2     PICT '@!'      VALID LastKey()=K_UP
RETURN

*------------------------------------------------------------------------------
STATIC FUNCTION TypeFunc()
@ 18,27 SAY IF(cTYPE='1','(PLATINUM)',IF(cTYPE='2','(GOLD)    ',IF(cTYPE='3','(SILVER)  ','          '))) COLOR 'w+'
RETURN .T.

*------------------------------------------------------------------------------
STATIC FUNCTION CekDisc(cD,l)
LOCAL lR:=.F.
l:=IF(l=NIL,.F.,l)
IF DISC->(DBSeek(cD)) ;lR:=.T.
ENDIF
@ 19,32 SAY DISC->DISC  PICT '@E 999.99%'
RETURN IF(l.AND.Val(cD)#0,lR,.T.)

*------------------------------------------------------------------------------
STATIC PROCEDURE SetVar(lAdd)
LOCAL cDate
lAdd:=IF(lAdd=NIL,.F.,lAdd)
IF !lAdd
   cCODE      := CODE
   cNAME      := NAME
   cADD1      := ADD1
   cADD2      := ADD2
   cCITY      := CITY
   cZIP       := ZIP
   cIDCARD    := IDCARD
   dTGLAHIR   := TGLAHIR
   cHOMEPHONE := HOMEPHONE
   cHANDPHONE := HANDPHONE
   cFAX       := FAX
   dDATEMEMBER:= DATEMEMBER
   dVALID     := VALID
   nDISCOUNT  := DISCOUNT
   lACTIVE    := ACTIVE
   cCOMENT1   := COMENT1
   cCOMENT2   := COMENT2
   nTTLPURCH  := TTLPURCH
   dLASTPURCH := LASTPURCH
   nVALLPURCH := VALLPURCH
   nLYEARPURCH:= LYEARPURCH
ELSE
   cDate:=SubS(DTos(Date()),7,2)+'/'+SubS(DTos(Date()),5,2)+'/'+Str(Year(Date())+1,4)
// SubS(DTos(Date()),1,4)
// Right('00'+AllTrim(Str(Month(Date()),2)))+'/'+;
//        Right('00'+AllTrim(Str(Day(Date()),2)))+'/'+;

   cCODE      := Blank(CODE,.T.)
   cNAME      := Blank(NAME,.T.)
   cADD1      := Blank(ADD1,.T.)
   cADD2      := Blank(ADD2 ,.T.)
   cCITY      := Blank(CITY,.T.)
   cZIP       := Blank(ZIP,.T.)
   cIDCARD    := Blank(IDCARD,.T.)
   dTGLAHIR   := CToD('  /  /    ')
   nDISCOUNT  := 0.00
   cHOMEPHONE := Blank(HOMEPHONE,.T.)
   cHANDPHONE := Blank(HANDPHONE,.T.)
   cFAX       := Blank(FAX,.T.)
   dDATEMEMBER:= Date()
   dVALID     := CToD(cDate)
   cREFERENCE := Blank(REFERENCE,.T.)
   lACTIVE    := .T.
   cCOMENT1   := Blank(COMENT1,.T.)
   cCOMENT2   := Blank(COMENT2,.T.)
   nTTLPURCH  := Blank(TTLPURCH,.T.)
   dLASTPURCH := Blank(LASTPURCH,.T.)
   nVALLPURCH := Blank(VALLPURCH,.T.)
   nLYEARPURCH:= Blank(LYEARPURCH,.T.)
ENDIF
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE Write()
FIELD->CODE      := cCODE
FIELD->NAME      := cNAME
FIELD->ADD1      := cADD1
FIELD->ADD2      := cADD2
FIELD->CITY      := cCITY
FIELD->ZIP       := cZIP
FIELD->IDCARD    := cIDCARD
FIELD->TGLAHIR   := dTGLAHIR
FIELD->HOMEPHONE := cHOMEPHONE
FIELD->HANDPHONE := cHANDPHONE
FIELD->FAX       := cFAX
FIELD->DATEMEMBER:= dDATEMEMBER
FIELD->VALID     := dVALID
FIELD->DISCOUNT  := nDISCOUNT
FIELD->ACTIVE    := lACTIVE
FIELD->COMENT1   := cCOMENT1
FIELD->COMENT2   := cCOMENT2
FIELD->TTLPURCH  := nTTLPURCH
FIELD->LASTPURCH := dLASTPURCH
FIELD->VALLPURCH := nVALLPURCH
FIELD->LYEARPURCH:= nLYEARPURCH
UNLOCK ALL
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE F2Edit()
LOCAL  cSvScreen
cSvScreen:=SaveScreen(27,0,27,79)
Show()
@ 24,00 CLEAR TO 24,79
@ 24,00 SAY 'F2-SimpanESC-Batal' COLOR '/w'
SetKey(K_F2 ,{||SF2ASave( .F.)})  //SubF2AddSave(.T.<ADD>/.F.<NOT ADD>>)
SetKey(K_ESC,{||SF10AQuit(.F.)})

SetVar(.F.)
GetVar()
READ

SET KEY K_F2  TO
SET KEY K_ESC TO
RestScreen(27,0,27,79,cSvScreen)
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE F3Search()
LOCAL  GetList:={},aF
LOCAL  cSvScreen,nLstRec,nInkey
LOCAL  cSearch:=Space(Len(CODE))
PRIVATE cTeks,bField,xGet

cSvScreen:=SaveScreen(18,0,24,79)
@ 20,00 CLEAR TO 23,79
@ 20,00 TO 23,79
@ 22,02 SAY 'F2-KodeF3-NamaESC-Batal' COLOR '/w'
@ 21,02 SAY 'Pilih Tipe Pencarian:'

DO WHILE .T.
   nInkey:=Inkey(0)
   DO CASE
      CASE nInkey=K_F2
           aF:={{'KODE'       ,'CODE'     };
               ,{'NAMA'       ,'NAME'     };
               ,{'TTL TRANS.' ,'TTLPURCH' };
               ,{'TG.MEMBER'  ,'DATEMEMBER'}}
           DBSetOrder(1)
           TBLook(aF,{|xD|DBSeek(xD)},'[Cust. List]')
      CASE nInkey=K_F3
           aF:={{'NAMA'       ,'NAME'      };
               ,{'KODE'       ,'CODE'      };
               ,{'TTL TRANS.' ,'TTLPURCH'  };
               ,{'TG.MEMBER'  ,'DATEMEMBER'}}
           DBSetOrder(2)
           TBLook(aF,{|xD|DBSeek(xD)},'[Cust. List]')
      CASE nInkey=K_ESC
           RestScreen(21,0,27,79,cSvScreen)
           RETURN
      OTHER ;LOOP
   ENDCASE
   EXIT
ENDDO
RestScreen(18,0,24,79,cSvScreen)
DBSetOrder(1)
SetVar(.F.)
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE F4Add()
LOCAL  cSvScreen:=SaveScreen(24,0,24,79)
Show()
@ 24,00 CLEAR TO 24,79
@ 24,00 SAY 'F2-SimpanESC-Batal' COLOR '/w'
SetKey(K_F2 ,{||SF2ASave( .T.)})
SetKey(K_ESC,{||SF10AQuit(.T.)})
lF4:=.T.
SetVar(.T.)
GetVar()
READ
lF4:=.F.

SET KEY K_F2  TO
SET KEY K_ESC TO
RestScreen(24,0,24,79,cSvScreen)
RETURN

*===============================================================================
STATIC PROCEDURE F6Display()
LOCAL lLoop:=.T., nInkey
 SetCursor(0)
 Show()
 @ 24,0 SAY Space(80)
 @ 24,0 SAY '-Maju-MundurHome-AwalEnd-AkhirF2-Edit' COLOR '/W'
 DO WHILE lLoop
    Say()
    nInkey:=Inkey(0)
    lLoop:=Skipping()
    IF nInkey=K_F2 ;SetCursor(1)
       F2Edit()    ;SetCursor(0)
    ENDIF
 ENDDO
 KeyBoard Chr(32) ;SetCursor(1)
RETURN

*===============================================================================
STATIC FUNCTION SF2ASave(lAdd)
LOCAL nLstRec:=RecNo()
IF !Empty(cCODE)
   SEEK cCODE
   IF lAdd
      IF Found() .OR. !AddRec();SetVar();GetVar()
         Warning(' Kode tersebut sudah ada...')
         RETURN .F.
       ENDIF
   ELSE
      IF Found() .AND. nLstRec<>RecNo();SetVar();GetVar()
         Warning(' Kode tersebut sudah ada...')
         RETURN .F.
      ENDIF
      GO nLstRec
      IF !RecLock()
         Warning(' Record tidak dapat dikunci')
         RETURN .F.
      ENDIF
   ENDIF
ELSE
   IF !RecLock()
         Warning(' Record tidak dapat dikunci')
      RETURN .F.
   ENDIF
ENDIF
CLEAR GETS //keluar dari READ...
Write()
//@ 24,78 SAY ladd //;inkey(.1)
KeyBoard Chr(27)+'1'+Chr(13)+IF(lAdd,Chr(27),Chr(1))
UNLOCK
RETURN .T.

*===============================================================================
STATIC PROCEDURE SF10AQuit(lAdd)
SET KEY K_ESC TO
IF LastKey()#K_ESC ;RETURN
ENDIF
IF YNQuit()
   lX:=.T. ;CLEAR GETS //keluar dari READ...
   //IF !lAdd
      KeyBoard Chr(27)
   //ENDIF
   SET KEY K_ESC TO
ELSE
   SetKey(K_ESC,{||SF10AQuit(lAdd)})
ENDI
RETURN

*===============================================================================
STATIC PROCEDURE F7Hist()
LOCAL cS,Opt,cCol:=SetColor()
cS:=SaveScreen(13,0,24,79)
POHist()              &&___PrintLabel
SetColor(cCol)
RestScreen(13,0,24,79,cS)
RETURN

*******************************************************************************
STATIC PROCEDURE POHist()
LOCAL cS, cOld:=SetColor(), cA:=Alias()
cC:=CODE
cS:=SaveScreen(5,0,24,79)
@ 09,0 TO 23,79
@ 24,00 SAY Space(80) COLOR 'W/N'
@ 24,00 SAY '  PgDn PgUp-PointerF3-CariF5-CetakESC-Keluar' COLOR '/w'
SELECT CUSDET
SET FILTER TO CODE=cC ;DBGoTop()
TENGAHIN(' '+AllTrim(CODE)+' / '+AllTrim(NAME)+' ',12,1,79,'b/w')
aFields:={'DATE','RCPTNO','QTY','TOTAL','REMARK'}
aHeader:={'TANGGAL','NO.RCPT','QTY','TOTAL','MEDIA'}
aPict  :={'@D','999999','999','@E 99,999,999','@!'}
DBEDIT(10,1,22,78,aFields,'CHstFunc',aPict,aHeader,'Ä')
SET FILT TO
SELECT &cA
SetColor(cOld)
RestScreen(5,0,24,79,cS)
RETURN
*===============================================================================
STATIC PROCEDURE F9Point()
LOCAL nPoint:=0,nPakai:=0,lYn:=.F.
Setcursor(1)
@ 05,0 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 06,0 SAY '³                              PENUKARAN KUPON                                 ³'
@ 07,0 SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 08,0 SAY '³ K o d e                               ³ Tg.Lahir                             ³'
@ 09,0 SAY '³ N a m a                               ³ No. KTP/SIM                          ³'
@ 10,0 SAY '³                                       ³                                      ³'
@ 11,0 SAY '³ Alamat                                ³ HomePh                               ³'
@ 12,0 SAY '³                                       ³ HandPh                               ³'
@ 13,0 SAY '³ K o t a                               ³ Fax.                                 ³'
@ 14,0 SAY '³ Kode Pos                              ³                                      ³'
@ 15,0 SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 16,0 SAY '³ Anggota Sejak            (DD/MM/YYYY) ³ Total Point/Kupon                    ³'
@ 17,0 SAY '³ Berlaku s/d              (DD/MM/YYYY) ³ Point/Kupon dipakai                  ³'
@ 18,0 SAY '³ Activ                                 ³ Sisa Point/Kupon                     ³'
@ 19,0 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
//          0123456789012345678901234567890123456789012345678901234567890123456748901234567890
//                    1         2         3         4         5         6          7         8
nPoint:=TTLPOINT-MINPOINT
@ 08,14 SAY CODE        PICT '@!'
@ 09,14 SAY NAME        PICT '@!'
@ 11,14 SAY ADD1        PICT '@!'
@ 12,14 SAY ADD2        PICT '@!'
@ 13,14 SAY CITY        PICT '@!'
@ 14,14 SAY ZIP         PICT '99999'
@ 08,55 SAY TGLAHIR
@ 09,55 SAY IDCARD      PICT '@!'
@ 11,55 SAY HOMEPHONE   PICT '@!'
@ 12,55 SAY HANDPHONE   PICT '@!'
@ 13,55 SAY FAX         PICT '@!'
@ 16,16 SAY DATEMEMBER  PICT '@D'
@ 17,16 SAY VALID
@ 18,16 SAY ACTIVE      PICT 'Y'
@ 16,65 SAY TTLPOINT    PICT '@E 99,999'
@ 17,65 SAY MINPOINT    PICT '@E 99,999'
@ 18,65 SAY nPoint      PICT '@E 99,999'

DO WHILE !lYn
   nPakai:=0
   @ 20,36 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 21,36 SAY '³  Jumlah Point/Kupon dipakai:        ³'
   @ 22,36 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 21,67 GET nPakai PICT '9999' VALID nPakai<=nPoint .AND. nPakai>=0
   READ
   IF Lastkey()=27 .OR. nPakai=0
      EXIT
   ENDIF
   @ 22,39 SAY '                          '
   @ 22,39 SAY 'Data sudah benar (Y/N)?' GET lYn PICT 'Y'
   READ
ENDDO
IF Lastkey()#27 .AND. nPakai>0
   Reclock()
   FIELD->MINPOINT+=nPakai
   DBUnLock()
ENDIF
Setcursor(0)
RETURN
*===============================================================================
FUNCTION CHstFunc()
LOCAL cScr:=SaveScreen(3,0,24,79), nPO:=0
IF LastKey()=K_ESC
   KeyBoard Chr(32)
   RETURN 0
ELSEIF LastKey()=K_F3
   @ 24,00 SAY Space(80)
   @ 24,00 SAY 'No. Receipt:' GET nPO PICT '999999'
   READ
   IF Empty(nPO) .OR. LastKey()=K_ESC
   ELSE
//    cPO:=Right('000000'+AllTrim(cPO),8)
      DBSeek(cC+Str(nPO,6))
   ENDIF
ELSEIF LastKey()=K_F5
   GO TOP ;HstPrn()
ENDIF
RestScreen(3,0,24,79,cScr)
RETURN 1

*===============================================================================
STATIC PROCEDURE HstPrn(cC1,cC2,dC1,dC2)
LOCAL nP:=1, nTOTAL:=0,nTQTY:=0,nTTLPD:=0, cFi:='C:\HstPrn.Txt',nSw:=1,nNo:=0
IF cC1#NIL .AND. !Empty(cC1)
   IF !DBSeek(cC1)
      Warning(' Member: '+Alltrim(cC1)+' tidak ada... ')
      RETURN
   ENDIF
ENDIF
cC1:=IF(cC1=NIL,cC,cC1)
cC2:=IF(cC2=NIL,cC,cC2)
dC1:=IF(dC1=NIL.OR.Empty(dC1),CToD('01/01/2000'),dC1)
dC2:=IF(dC2=NIL,Date(),dC2)
nTgt:=PrnTgt(cFi)
IF nTgt=0 ;RETURN
ENDIF
SetPrc(0,0)
DO WHILE !Eof() .AND. CODE>=cC1 .AND. CODE<=cC2
   IF DATE>=dC1 .AND. DATE<=dC2
      IF TOTAL>0
         IF nSw=1
            cCOD:=CODE
            SetPrc(0,0)
            HstHdr(nP,cCOD) ;nSw:=2
         ENDIF
         IF CODE#cCOD .AND. !Eof()
            @ PRow()+1,00 SAY '--------------------------------------------------------------'
            @ PRow()+1,21 SAY nTQTY          PICT '@E 999,999'
            @ PRow()  ,30 SAY nTOTAL         PICT '@E 9,999,999,999'
            @ PRow()+1,00 SAY '=============================================================='
            @ PRow()+1,00 SAY Chr(12)
            nTOTAL:=0 ;nTQTY:=0 ;nTTLPD:=0
            SetPrc(0,0) ;cCOD:=CODE
            nP++ ;HstHdr(nP,cCOD)
         ENDIF
         nTOTAL+=TOTAL
         nTQTY +=QTY
         @ Prow()+1, 0 SAY DATE
         @ Prow()  ,12 SAY RCPTNO
         @ Prow()  ,21 SAY QTY        PICT '@E 999,999'
         @ Prow()  ,30 SAY TOTAL      PICT '@E 9,999,999,999'
         @ Prow()  ,46 SAY REMARK     PICT '@!'
         nNo++
      ENDIF
   ENDIF
   IF PRow()>55 .AND. !Eof()
      @ PRow()+1,0 SAY '==============================================================='
      @ PRow()+1,0 SAY Chr(12)
      SetPrc(0,0)
      nP++ ;HstHdr(nP)
   ENDIF
   SKIP
ENDDO
IF nNo#0
   @ PRow()+1, 0 SAY '--------------------------------------------------------------'
   @ PRow()+1,21 SAY nTQTY          PICT '@E 999,999'
   @ PRow()  ,30 SAY nTOTAL         PICT '@E 9,999,999,999'
   @ PRow()+1, 0 SAY '=============================================================='+Chr(12)
ENDIF
SET PRINT TO ;SET PRINT OFF ;SET DEVICE TO SCREEN
IF nTgt=1 ;LIHATTEKS(cFi,2,0,23,79,'W/N')
ENDIF
KeyBoard Chr(32)
RETURN

*===============================================================================
STATIC PROCEDURE HstHdr(nP,cT)
@ PRow()+1, 0 SAY 'MEMBER SUMMARY REPORT'
@ PRow()+1, 0 SAY AllTrim(CODE)+' - '+CUSDET->NAME                                                        // Hal:999
@ PRow()  ,78 SAY 'Hal :'+Str(nP,3)
@ PRow()+1, 0 SAY '=============================================================='
@ PRow()+1, 0 SAY 'TANGGAL     NO.RCPT      QTY          TOTAL   KETERANGAN      '
@ PRow()+1, 0 SAY '--------------------------------------------------------------'
//                 11/11/1111  123456   112,456  1,111,111,111   xxxxxxxxx0xxxxx
//                 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//                           1         2         3         4         5         6         7         8         9
RETURN
*===============================================================================
STATIC PROCEDURE CusPrn()
LOCAL nP:=1,nCRT:=0,nPUR:=0,nPAY:=0,cFi:='C:\CusLst.Txt',nTgt:=1
nTgt:=PrnTgt(cFi)
IF nTgt=0 ;RETURN
ENDIF
CusHdr(nP)
DO WHILE !Eof()
   nPUR+=TTLPURCH
   @ PRow()+1, 01 SAY CODE
   @ PRow()  , 28 SAY ADD1
   @ PRow()  , 55 SAY Left(CITY,15)
   @ PRow()  , 72 SAY HOMEPHONE
   @ PRow()  , 88 SAY DATEMEMBER
   @ PRow()  ,100 SAY TTLPURCH   PICT '@E 9,999,999,999'
   @ PRow()+1, 01 SAY NAME
   @ PRow()  , 28 SAY ADD2
   @ PRow()  , 55 SAY ZIP
   @ PRow()  , 72 SAY HANDPHONE
   @ PRow()  , 88 SAY VALID
   @ PRow()+1, 00 SAY ' '
   IF PRow()>55 .AND. !Eof()
      @ PRow()+1, 0 SAY '=================================================================================================================='+Chr(12)
      nP++ ;CusHdr(nP)
   ENDIF
   SKIP
ENDDO
@ PRow()+1, 0 SAY '------------------------------------------------------------------------------------------------------------------'
@ PRow()+1, 98 SAY nPUR       PICT '@E 999,999,999,999'
@ PRow()+1, 0 SAY '=================================================================================================================='
@ PRow()+1,0 SAY cNCon+Chr(12)
SET PRINT TO ;SET PRINT OFF ;SET DEVICE TO SCREEN
IF nTgt=1 ;LihatTeks(cFi,2,0,24,79,'W/N')
ENDIF
DELETE FILE C:\CUSLST.TXT
RETURN
*===============================================================================
STATIC PROCEDURE CusHdr(nP)
SetPrc(0,0)
@ PRow()+1 ,00 SAY cCon+cJdl
@ PRow()+2,103 SAY DTOC(Date())
@ PRow()+1, 00 SAY 'DAFTAR CUSTOMER/MEMBER'
@ PRow()  ,105 SAY 'Hal :'+Str(nP,3)                                                                                     //      Hal:999
@ PRow()+1, 00 SAY '=================================================================================================================='
@ PRow()+1, 00 SAY ' KODE                       ALAMAT                     KOTA             HOMEPHONE       SEJAK        TTL TRANSAKSI'
@ PRow()+1, 00 SAY ' NAMA                                                  KODE POS         HANDPHONE       S / D                     '
@ PRow()+1, 00 SAY '------------------------------------------------------------------------------------------------------------------'
//                   1234567890123456789012345
//                   1234567890                 1234567890123456789012345  123456789012345  12345678901234  11/11/1111  1,234,567,890
//                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                           1         2         3         4         5         6         7         8         9         10        11        12
RETURN

*===============================================================================
STATIC FUNCTION F8Print()
LOCAL cScr:=SaveScreen(13,40,24,79),cSel:=Select()
LOCAL cC1:=Space(10),cC2:=Space(10),dC1:=CToD('  /  /    '),dC2:=Date()
PRIVATE cC:=CODE
SET WRAP ON
Box(19,55,23,74)
@ 20,56 PROMPT ' Daftar Customer  '
@ 21,56 PROMPT ' Rekap Transaksi  '
@ 22,56 PROMPT ' Detail Transaksi '
MENU TO nPil
@ 24,00 SAY Space(80)
SetCursor(1)
DO CASE
CASE nPil=1
     @ 15,57 CLEA TO 18,68
     @ 15,57 TO 18,68
     @ 15,58 SAY    'Diurutkan:'
     @ 16,58 PROMPT ' Kode     '
     @ 17,58 PROMPT ' Nama     '
     MENU TO nPil2
     IF nPil2#0
        DBSetOrder(nPil2)
        GO TOP
        CusPrn(nPil2)
        DBSetOrder(1)
     ENDIF
CASE nPil=2 ;SELECT CUSDET
     @ 24,00      SAY 'Kode:'    GET cC1  PICT '@!'
     @ 24,Col()+1 SAY 's/d'      GET cC2  PICT '@!'  VALID cC2>=cC1
     @ 24,Col()+5 SAY 'Tanggal:' GET dC1
     @ 24,Col()+1 SAY 's/d'       GET dC2  VALID dC2>=dC1
     READ
     cC2:=IF(Empty(cC2),'ZZZZZZZZZZZZZZ',cC2)
     dC1:=IF(Empty(dC1),CToD('01/01/2000'),dC1)
     IF LastKey()#K_ESC
        GO TOP
        HstPrn(cC1,cC2,dC1,dC2)
     ENDIF
CASE nPil=3 ;SELECT CUSDET
     @ 24,00      SAY 'Kode:'    GET cC1  PICT '@!'
     @ 24,Col()+1 SAY 's/d'      GET cC2  PICT '@!'  VALID cC2>=cC1
     @ 24,Col()+5 SAY 'Tanggal:' GET dC1
     @ 24,Col()+1 SAY 's/d'      GET dC2  VALID dC2>=dC1
     READ
     cC2:=IF(Empty(cC2),'ZZZZZZZZZZZZZZ',cC2)
     IF LastKey()#K_ESC
        GO TOP
        DetPrn(cC1,cC2,dC1,dC2)
     ENDIF
ENDCASE
SetCursor(0)
SELECT &cSel
RestScreen(12,40,24,79,cScr)
RETURN
*******************************************************************************
STATIC PROCEDURE DetPrn(cC1,cC2,dDC1,dDC2)
LOCAL nP:=1, nTOTAL:=0,nTQTY:=0,nTAMT:=0,nDSC:=0,nTDSC:=0
LOCAL cFi:='C:\HstPrn.Txt',nSw:=1,nNo:=0
PRIVATE dC1,dC2
IF cC1#NIL .AND. !Empty(cC1)
   IF !DBSeek(cC1)
      Warning(' Member: '+Alltrim(cC1)+' tidak ada... ')
      RETURN
   ENDIF
ENDIF
cC1:=IF(cC1=NIL,cC,cC1)
cC2:=IF(cC2=NIL,cC,cC2)
dC1:=IF(dDC1=NIL.OR.Empty(dDC1),CToD('01/01/2000'),dDC1)
dC2:=IF(dDC2=NIL,Date(),dDC2)
nTgt:=PrnTgt(cFi)
IF nTgt=0 ;RETURN
ENDIF
SetPrc(0,0)
DO WHILE !Eof() .AND. CODE>=cC1 .AND. CODE<=cC2
   IF DATE>=dC1 .AND. DATE<=dC2
      IF TOTAL>0
         IF nSw=1
            cCOD:=CODE
            SetPrc(0,0)
            DetProc(cCOD,dC1,dC2) ;DetHdr(nP,dDC1,dDC2)
            nSw:=2
         ENDIF
// 1234567890123 123456789012345678901234567890  123,567 1,345,789,123 123,567,890 1,345,789,012
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          1         2         3         4         5         6         7         8         9
         IF CODE#cCOD .AND. !Eof()
            @ PRow()+1,00 SAY '-----------------------------------------------------------------------------------------------'
            @ PRow()+1,47 SAY nTQTY          PICT '@E 999,999'
            @ PRow()  ,55 SAY nTAMT          PICT '@E 9,999,999,999'
            @ PRow()  ,69 SAY nTDSC          PICT '@E 999,999,999'
            @ PRow()  ,81 SAY nTOTAL         PICT '@E 9,999,999,999'
            @ PRow()+1,00 SAY '==============================================================================================='
            @ PRow()+1,00 SAY Chr(12)
            nTOTAL:=0 ;nTQTY:=0 ;nTAMT:=0 ;nTDSC:=0
            SetPrc(0,0) ;cCOD:=CODE
            nP++
            DetProc(cCOD,dC1,dC2) ;DetHdr(nP,dDC1,dDC2)
         ENDIF
         DO WHILE !TEMPM->(Eof())
            cINVCODE:=TEMPM->CODE
            cDESC   :=TEMPM->DESC
            nAMT:=0 ;nQTY:=0 ;nDSC:=0
            DO WHILE TEMPM->CODE=cINVCODE .AND. !TEMPM->(Eof())
               IF TEMPM->FLAG#'D'
                  nTAMT +=TEMPM->PRICE
                  nTQTY +=(TEMPM->QTY*IF(TEMPM->FLAG='PLU',1,-1))
                  nAMT  +=TEMPM->PRICE
                  nQTY  +=(TEMPM->QTY*IF(TEMPM->FLAG='PLU',1,-1))
               ELSE
                  nDSC  +=(TEMPM->PRICE*-1)
                  nTDSC +=(TEMPM->PRICE*-1)
               ENDIF
               TEMPM->(DBSkip())
            ENDDO
            nTOTAL+=(nAMT-nDSC)
            @ Prow()+1, 1 SAY cINVCODE
            @ Prow()  ,15 SAY cDESC
            @ Prow()  ,47 SAY nQTY      PICT '@E 999,999'
            @ Prow()  ,55 SAY nAMT      PICT '@E 9,999,999,999'
            @ PRow()  ,69 SAY nDSC      PICT '@E 999,999,999'
            @ PRow()  ,81 SAY nAMT-nDSC PICT '@E 9,999,999,999'
         ENDDO
         nNo++
      ENDIF
   ENDIF
   IF PRow()>55 .AND. !Eof()
      @ PRow()+1,0 SAY '================================================================================================'
      @ PRow()+1,0 SAY Chr(12)
      SetPrc(0,0)
      nP++ ;DetHdr(nP,dDC1,dDC2)
   ENDIF
   SKIP
ENDDO
IF nNo#0
   @ PRow()+1, 0 SAY '-----------------------------------------------------------------------------------------------'
   @ PRow()+1,47 SAY nTQTY      PICT '@E 999,999'
   @ PRow()  ,55 SAY nTAMT      PICT '@E 9,999,999,999'
   @ PRow()  ,69 SAY nTDSC      PICT '@E 999,999,999'
   @ PRow()  ,81 SAY nTOTAL     PICT '@E 9,999,999,999'
   @ PRow()+1, 0 SAY '==============================================================================================='+Chr(27)+'P'+Chr(12)
ENDIF
SET PRINT TO ;SET PRINT OFF ;SET DEVICE TO SCREEN
IF nTgt=1 ;LIHATTEKS(cFi,2,0,23,79,'W/N')
ENDIF
KeyBoard Chr(32)
RETURN
*===============================================================================
STATIC PROCEDURE DetHdr(nP,dDC1,dDC2)
@ PRow()+1, 0 SAY Chr(27)+'M'+'MEMBER DETAIL REPORT'
@ PRow()+1, 0 SAY AllTrim(CODE)+' - '+CUSDET->NAME                                                        // Hal:999
@ PRow()+1, 0 SAY 'Tanggal: '+DToC(dDC1)+' To '+DToC(dDC2)
@ PRow()  ,87 SAY 'Hal:'+Str(nP,3)
@ PRow()+1, 0 SAY '==============================================================================================='
@ PRow()+1, 0 SAY ' KODE          DESKRIPSI                           QTY        AMOUNT    DISCOUNT         TOTAL '
@ PRow()+1, 0 SAY '-----------------------------------------------------------------------------------------------'
//                 01234567890123 123456789012345678901234567890  111,111 1,111,111,111 111,111,111 1,111,111,111
//                 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                           1         2         3         4         5         6         7         8         9
RETURN
*******************************************************************************
STATIC PROCEDURE DetProc(cCOD,dC1,dC2)
LOCAL cSel:=Select(),cCons:='',cPHST:=IF(NNetLogged(),NEOD,DEOD)
IF SELECT('TEMPM')#0
   TEMPM->(DBCloseArea())
ENDIF
DBCreate('C:\DOS\MEMTEMP.DBF',{{'FLAG'    ,'C',03,0};
                              ,{'CODE'    ,'C',13,0};
                              ,{'DESC'    ,'C',30,0};
                              ,{'QTY'     ,'N',06,0};
                              ,{'PRICE'   ,'N',12,0};
                              ,{'DDATE'   ,'D',08,0};
                              ,{'NORCP'   ,'N',06,0};
                              ,{'CUSCODE' ,'C',14,0}})
USE ('C:\DOS\MEMTEMP.DBF') NEW ALIAS TEMPM
ZAP ;INDEX ON CODE TO ('C:\DOS\MEMTEMP.NTX')
SELECT &cSel
DO WHILE !Eof() .AND. CODE=cCOD
   IF DATE>=dC1 .AND. DATE<=dC2
      aDir:=Directory(cPHST+'CP??'+Right(CPEOD,4)+'.DBF')
      IF Len(aDir)>0
         SELECT TEMPM
         FOR n=1 TO Len(aDir)
            cCons:=aDir[n][1]   //'CONS'+Right(CPEOD,4)
            IF File(cPHST+cCons)
               APPE FROM (cPHST+cCons) FOR (FLAG='PLU' .OR. FLAG='RTN' .OR. FLAG='VOD' .OR. FLAG='D') .AND. CUSCODE=cCOD .AND. NORCP=CUSDET->RCPTNO
            ENDIF
         NEXT
         SELECT &cSel
      ENDIF
   ENDIF
   SKIP
ENDDO
SKIP -1
TEMPM->(DBGoTop())
RETURN
*******************************************************************************
STATIC PROCEDURE TagPrn(cSales)
LOCAL cDD,cScr:=SaveScreen(24,00,24,79)
PRIVATE aTGL:={},aPLU1:={}, aPLU2:={} ,aPLU3:={}, aPLU4:={}, nDISC:=0, nTTL:=0, nTOTAL:=0
PRIVATE cNAME:=CUS->NAME,cADD1:=CUS->ADD1,cADD2:=CUS->ADD2
PRIVATE cPH:=CUS->HOMEPHONE,cINVO,cTGL,cP:=IF(NNetLogged(),NEODK,DEODK)

cDD     := DToS(Date())
cTgl    := DToC(Date())
cINVO   := '        '  //Right('000000'+Alltrim(Str(NORCP)),6)+'/'+Right(cDD,2)+SubStr(cDD,5,2)+Left(cDD,4)
@ 24,00 SAY Space(80)
@ 24,00 SAY 'No. Nota:' GET cINVO PICT '@!'
READ
RestScreen(24,00,24,79,cScr)
cFi :=DTXT+'Faktur.Txt'
IF IsiArr()
   nTgt:=PrnTgt(cFi)
   IF nTgt>0
      PrintInv(cSales)
   ELSE  ;RETURN
   ENDIF
ENDIF
SELECT CUSDET
RETURN
********************************************************************************
STATIC PROCEDURE PrintInv(cSales)
LOCAL nNo:=1,nPage:=1, cSel:=Select()
LOCAL cNo, cPLU, lHabis:=.F., n, nn, nLoop
nLoop:=IF(Len(aPLU1)>23,23,Len(aPLU1))
PHeader(nPage)
DO WHILE nNo<=Len(aPLU1)
//³ No ³ Tanggal    ³ Kode     ³         Nama Barang            ³ Qty  ³ Harga/Unit ³  Jumlah    ³'
//  11   1234567890   12345678   123456789012345678901234567890  1,234  123,456,789  123,456,789
//  11.   1234567890   12345678       123456789012345678901234567890   1,234   123,456,789   123,456,789
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          1         2         3         4         5         6         7         8         9         0
   FOR n=1 TO nLoop
      cNo:=Right('00'+AllTrim(Str(nNo,2)),2)
      cPLU:=aPLU1[n]
      IF aPLU3[n]#0
         @ PRow()+1,00 SAY  '³ '+cNo
         @ PRow()  ,04 SAY ' ³ '+DToC(aTGL[n])
         @ PRow()  ,17 SAY ' ³ '+cPLU
         @ PRow()  ,28 SAY ' ³ '+aPLU2[n]
         @ PRow()  ,61 SAY ' ³'+Trans(aPLU3[n],'@E 9,999')
         @ PRow()  ,68 SAY ' ³'+Trans(aPLU4[n],'@E 999,999,999')
         @ PRow()  ,81 SAY ' ³'+Trans(aPLU3[n]*aPLU4[n],'@E 999,999,999')+' ³'
         nNo++
      ENDIF
      IF nNo>Len(aPLU1)
         lHabis:=.T. ;EXIT
      ENDIF
   NEXT
   IF !lHabis ;nPage++ ;PHeader(nPage)
   ENDIF
   IF n<24
      FOR nn=1 TO 23-n
         @ PRow()+1,00 SAY '³    ³            ³          ³                                ³      ³            ³            ³'
      NEXT
   ENDIF
   @ PRow()+1,00 SAY 'ÃÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄ´'
ENDDO
SELECT &cSel
nTTLNET:=nTTL-nDISC
cBil   :='#'+Terbilang(nTTLNET,0)+' rupiah#'
cBil1  :=cBil
cBil2  :=Space(50)
cBil3  :=Space(50)
IF Len(cBil)>50 .AND. Len(cBil)<99
   cBil1:=Left(cBil,50)
   nRAT:=RAT(' ',cBil1)
   cBil1:=Left(cBil1,nRAT)
   cBil2:=Left(SubS(cBil,nRAT+1),50)
ELSEIF Len(cBil)>99
   cBil1:=Left(cBil,50)
   nRAT :=RAT(' ',cBil1)
   cBil1:=Left(cBil1,nRAT)
   cBil2:=SubS(cBil ,51,50)
   nRAT :=RAT(' ',cBil2)
   cBil3:=Left(SubS(cBil,nRAT+1),50)
ENDIF
@ PRow()+1,00 SAY '³                                                                    ³ Total      ³'+Trans(nTOTAL,'@E 999,999,999')+' ³'
@ PRow()+1,00 SAY '³ Terbilang: '+cBil1
@ PRow()  ,65 SAY                                                                  '    ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ PRow()+1,00 SAY '³            '+cBil2
@ PRow()  ,65 SAY                                                                  '    ³ Discount   ³'+Trans(nDISC,'@E 999,999,999')+' ³'
@ PRow()+1,00 SAY '³            '+cBil3
@ PRow()  ,65 SAY                                                                  '    ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ PRow()+1,00 SAY '³                                                                    ³ PPN        ³            ³'
@ PRow()+1,00 SAY '³                                                                    ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ PRow()+1,00 SAY '³                                                                    ³ Net Total  ³'+Trans(nTTLNET,'@E 999,999,999')+' ³'
@ PRow()+1,00 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÙ'//+c10
@ PRow()+2,00 SAY '                                                       ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ PRow()+1,00 SAY '                                                       ³     Customer      ³    Authorizer     ³'
@ PRow()+1,00 SAY '                                                       ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ PRow()+1,00 SAY '                                                       ³                   ³                   ³'
@ PRow()+1,00 SAY '                                                       ³                   ³                   ³'
@ PRow()+1,00 SAY '                                                       ³                   ³                   ³'
@ PRow()+1,00 SAY '                                                       ³                   ³                   ³'
@ PRow()+1,00 SAY '                                                       ³(.................)³(.................)³'
@ PRow()+1,00 SAY '                                                       ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
@ PRow()+1,00 SAY CHR(12)
SET PRINT TO ;SET PRINT OFF ;SET DEVICE TO SCREEN
IF nTgt=1
   LIHATTEKS(cFi,1,0,27,79,'W/N')
ENDIF
RETURN
********************************************************************************
STATIC PROCEDURE PHeader(nPage)
@ PRow()+3,00 SAY 'E'+SYSTEM->DESC+'F'
@ PRow()+1,00 SAY Chr(27)+'M'+SYSTEM->ADD1
@ PRow()+1,00 SAY SYSTEM->ADD2
@ PRow()  ,54 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ PRow()+1,00 SAY 'Telp. : '+SYSTEM->TELP
@ PRow()  ,54 SAY '³                          ³'
@ PRow()+1,54 SAY '³  EF A K T U RF  ³'
@ PRow()+1,54 SAY '³                          ³'
@ PRow()+1,54 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
@ PRow()+1,00 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ PRow()+1,00 SAY '³ Pelanggan: '+cNAME                +'      ³'+'E'+'         NO. NOTA       : '+cINVO+'F'
@ PRow()+1,00 SAY '³            '+cADD1                +'      ³                                '
@ PRow()+1,00 SAY '³            '+cADD2                +'      ³'
@ PRow()+1,00 SAY '³ No. Telp.: '+cPH       +'                 ³'
@ PRow()+1,00 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
@ PRow()+2,00 SAY 'ÚÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ PRow()+1,00 SAY '³ No ³ Tanggal    ³ Kode     ³         Nama Barang            ³  Qty ³ Harga/Unit ³  Jumlah    ³'
@ PRow()+1,00 SAY 'ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄ´'
//                   11   1234567890   12345678   123456789012345678901234567890  1,234  123,456,789  123,456,789
//                 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                           1         2         3         4         5         6         7         8         9         0
//                   11.   1234567890   12345678       123456789012345678901234567890   1,234   123,456,789   123,456,789
RETURN
********************************************************************************
STATIC FUNCTION  Terbilang(nBil,nDec) &&___________________nBil:=43213545.12, nDec:=2
*--------------------
LOCAL nInt,nLen,cBil,cX,nI,nX,nZ,cRtn,acBil[9],acBK3[9]
acBK3[1]:='ribu '
acBK3[2]:='juta '
acBK3[3]:='milyard '
acBK3[4]:='trilyun '
acBK3[5]:='cublyun '
acBK3[6]:='panlyun '
acBK3[7]:='enmlyun '
acBK3[8]:='tujlyun '
acBK3[9]:='laplyun '
acBil[1]:='satu '
acBil[2]:='dua '
acBil[3]:='tiga '
acBil[4]:='empat '
acBil[5]:='lima '
acBil[6]:='enam '
acBil[7]:='tujuh '
acBil[8]:='delapan '
acBil[9]:='sembilan '
cRtn:=''
nDec:=IF(PCOUNT()>1,nDec,0) &&_________________________________________nDec:=2
cBil:=LTRIM(STR(nBil,30,nDec)) &&__________________________cBil:='43213545.12'
nLen:=IF(nDec=0,LEN(cBil),AT('.',cBil)-1) &&___________________________nLen:=8
nInt:=INT((nLen-1)/3) &&_______________________________________________nInt:=2
FOR nI:=nInt TO 0 STEP -1 &&________________________________________Looping 2x
    cX:=LEFT(cBil,nLen-nI*3) &&___________cX1:=Left('43213534.12',8-6) -> '43'
    cX:=IF(LEN(cX)>3,RIGHT(cX,3),cX) &&______________________________cX1:='43'
    nZ:=VAL(cX)  &&_____________________________________________________nZ:=43
    nX:=nZ%100 &&_______________________________________________________nX:=43
    cRtn+=IF(nZ>99,IF(nZ<200,'se',acBil[nZ/100])+'ratus ','')
    IF nX>10 .AND. nX<20
       cRtn+=IF(nX=11,'se',acBil[nX%10])+'belas '
    ElseIf nX>9
       cRtn+=IF(nX=10  ,'se',acBil[nX/10])+'puluh '
       cRtn+=IF(nX%10=0,''  ,acBil[nX%10]) &&_________cRtn+='empat puluh tiga'
    ElseIf nX>0
       cRtn+=IF(nZ=1 .AND. nI=1,'se',acBil[nX])
    ENDIF
    cRtn+=IF(nI>0 .AND. nZ>0,acBK3[nI],'') &&_____________________cRtn+='juta'
NEXT
cRtn:=ALLTRIM(cRtn)
cRtn:=IF(RIGHT(cRtn,1)#'.',cRtn,LEFT(cRtn,LEN(cRtn)-1))
IF nDec#0
   cBil:=SUBS(cBil,nLen+2)  &&_Dec Char
   nLen:=LEN(cBil)          &&_Len Dec Char
   cX:='';nZ:=1
   FOR nI:=nLen TO 1 STEP -1
       nZ:=IF((nX:=VAL(SUBS(cBil,nI,1)))=0,nZ,0)
       cX:=IF(nX=0,IF(nZ#0,'','nol '),acBil[nX])+cX
   NEXT
   cRtn+=IF(nZ=0,' koma '+RTRIM(cX),'')
ENDIF
RETURN cRtn
*-----------------------------------------------------------------------------*
STATIC PROCEDURE IsiArr()
LOCAL cDbf:=DDAT+'___TEMP.DBF'
LOCAL aDbf :={{'FLAG'  ,'C', 3,0};
            ,{'CODE'   ,'C',13,0};
            ,{'DESC'   ,'C',30,0};
            ,{'QTY'    ,'N', 4,0};
            ,{'PRICE'  ,'N', 9,0};
            ,{'NORCP'  ,'N', 6,0};
            ,{'CUSCODE','C',10,0}}
SELECT CUSDET
DO WHILE !Eof() .AND. CODE=cC
   SELECT CUSDET
   cCP:='CP'+STL+Right(DToS(DATE),4)
   nNR:=RCPTNO
   IF File(cP+cCP+'.DBF')
      USE (cP+cCP) NEW
      LOCATE FOR NORCP=nNR
      IF !Found()
         Warning(' No. Receipt '+Alltrim(Str(nNR))+' di transaksi tgl. '+DToC(DATE)+' tidak ditemukan... ')
         USE  ;SELECT CUSDET
         SKIP ;LOOP
      ENDIF
      cTGL:=CUSDET->DATE
   ELSE
      Warning(' Transaksi Tgl. '+DToC(DATE)+' tidak ditemukan... ')
      SELECT CUSDET ;SKIP ;LOOP
   ENDIF

   DO WHILE NORCP=nNR .AND. !Eof()
      IF FLAG='TTL'
         nTOTAL +=PRICE
      ELSEIF FLAG='D'
         nDisc+=(Abs(PRICE))
      ELSEIF FLAG='PLU' .OR. FLAG='RTN'
         AADD(aTGL,cTGL)
         AADD(aPLU1,CODE)
         AADD(aPLU2,IF(FLAG='RTN',Left(DESC,25)+'(RTN)',DESC))
         AADD(aPLU3,QTY)
         AADD(aPLU4,PRICE)
         nTTL+=(QTY*PRICE)
      ELSEIF FLAG='VOD'
         nA:=ASCAN(aPLU1,CODE)
         IF nA>0
            aPLU3[nA]-=QTY
            nTTL+=(QTY*PRICE)
         ENDIF
      ENDIF
      SKIP
   ENDDO
   USE
   SELECT CUSDET
   SKIP
ENDDO
nTOTAL-=nDisc
RETURN .T.
********************************************************************************
PROCEDURE ErrMsg(cMsg1,cMsg2)
LOCAL nL1,nL2,nL3,cMsg3,aBox,nP, cScr:=SaveScreen(15,00,24,79),cCol:=SetColor()

cMsg3:='Tekan sembarang tombol'
nL1  := Len(cMsg1)    ;nL2 := Len(cMsg2)
nL3  := Len(cMsg3)    ;nP  := nL2
IF nL1>nL2 ;nP := nL1 ;ENDIF
IF nL3>nP  ;nP := nL3 ;ENDIF
nL   := (80-nP+5)/2-6 ;nR  := nL+nP+6
nT   := IF(Empty(cMsg2),4,5)

aBox:=Box(24-nT,nL,24,nR,'R')
TENGAHIN(cMsg1,24-nT+1,nL-3,nR,'W+/R')
IF !Empty(cMsg2)
   TENGAHIN(cMsg2,24-nT+2,nL-3,nR,'W+/R')
   TENGAHIN(cMsg3,24-nT+4,nL-3,nR,'GR+/R')
ELSE
   TENGAHIN(cMsg3,24-nT+3,nL-3,nR,'GR+/R')
ENDIF
Inkey(0)
SetColor(cCol)
RestScreen(15,0,24,79,cScr)
RETURN
*===============================================================================
FUNCTION YNQuit()
LOCAL  nTop:=9,nLeft:=24
LOCAL  nYN:=0  ,GetList:={}
LOCAL  cSvScreen, cOldCol:=SetColor()
SetColor('W+/R,W/N')
cSvScreen:=SaveScreen(0,0,24,79)
@ nTop+00,nLeft SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ nTop+01,nLeft SAY '³             PEMBATALAN              ³'
@ nTop+02,nLeft SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ nTop+03,nLeft SAY '³   [1] - BATAL, [0] - LANJUT EDIT    ³'
@ nTop+04,nLeft SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ nTop+05,nLeft SAY '³              Pilihan   0            ³'
@ nTop+06,nLeft SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
DO WHILE .T.
   @ nTop+05,nLeft+25 GET nYN PICT '9'
   READ
   IF LastKey()=K_ENTER
      EXIT
   ENDIF
ENDDO
KEYBOARD ' ';InKey(0) //;KEYBOARD Chr(32)
RestScreen(0,0,24,79,cSvScreen)
SetColor(cOldCol)
RETURN nYN==1
*===============================================================================
FUNCTION Skipping()
 DO CASE
 CASE LastKey()=K_DOWN ;SKIP         //Next......
      IF Eof()         ;SKIP -1
      ENDIF
 CASE LastKey()=K_UP   ;SKIP -1      //Previus...
 CASE LastKey()=K_HOME ;DBGoTop()    //Top Record...
 CASE LastKey()=K_END  ;DBGoBottom() //Bottom Record...
 CASE LastKey()=K_ESC  ;RETURN .F.   //Bottom Record...
 ENDCASE
RETURN .T.
*------------------------------------------------------------------------------
FUNCTION TBLook(aF,bSeek,cTtl)
LOCAL oB,oC,nX:=0,nK:=0,bX,nCol
LOCAL cS:=SaveScreen(0,0,24,79)
LOCAL cO:=SetColor(),cGet:=Space(22)
GETLIST:={}
Scroll(9,1,23,78)
@ 8,0 TO 24,79
oB:=TBrowseDB(9,1,22,78)
oB:ColSep:='³'
oB:HeadSep:='ÂÄ'
oB:AutoLite:=.f.
*------------------------------
@ oB:nTop-1,oB:nLeft+1 SAY cTtl
@ oB:nBottom+1,oB:nLeft SAY '['+Chr(24)+Chr(25)+']'
DispOut('[ENTER]-Select[ESC]-Batal, Search : ');nCol:=col()
@ oB:nBottom+1,nCol Get cGet Pict '@!'
@ oB:nBottom+1,nCol SAY 'Ä' COLOR '*/w'
GETLIST[1]:SetFocus()
FOR nK:=1 TO Len(aF)
    oC:=TBColumnNew(aF[nK][1],FieldBlock(aF[nK][2]))
    oC:FootSep:='ÁÄ'
    oB:AddColumn(oC)
NEXT
*--------------------------------------
DO While .T.
   IF !oB:Stabilize()
      LOOP
   ENDIF
   oB:ColorRect({oB:RowPos,1,oB:RowPos,oB:ColCount},{2,1})
    oB:RefreshCurrent();SetPos(oB:nBottom+1,nCol)
   nK:=InKey(0)
   DO CASE
   CASE nK=K_ENTER ;EXIT
   CASE nK=K_ESC   ;EXIT
   CASE nK=K_UP    ;oB:Up()
   CASE nK=K_DOWN  ;oB:Down()
   CASE nK=K_PGUP  ;oB:PageUp()
   CASE nK=K_PGDN  ;oB:PageDown()
   CASE nK=K_RIGHT ;GetList[1]:Right()
   CASE nK=K_LEFT  ;GetList[1]:Left()
   CASE nK=K_BS
        If(GetList[1]:TypeOut,GetList[1]:delete(),GetList[1]:backSpace())
        GetList[1]:Assign()
        nCol:=Col()
        Eval(bSeek,Rtrim(cGet))
        oB:RefreshAll()
   CASE (nK>=32 .AND. nK<=255);cChr:=Chr(nK)
        IF Set( _SET_INSERT )
           GetList[1]:insert( cChr )
        ELSE
           GetList[1]:overstrike( cChr )
        ENDIF
        GetList[1]:Assign()
        IF GetList[1]:typeOut
           IF Set( _SET_BELL )
              ??Chr(7)
           ENDIF
        ENDIF
        nCol:=Col()
        Eval(bSeek,Rtrim(cGet))
        oB:RefreshAll()
   ENDCASE
ENDDO
RestScreen(0,0,24,79,cS)
RETURN .T.
*-----------------------------------------------------------------------------
FUNCTION Locate(bX,cX)
LOCATE FOR Eval(bX)=cX
RETURN Found()
*==============================================================================
