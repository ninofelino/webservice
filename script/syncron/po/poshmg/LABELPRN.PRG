#include "hmg.ch"
#include 'inkey.ch'
#include 'setcurs.ch'

*------------------------------------------------------------------------------
PROCEDURE LabelPrint(ngn)
 LOCAL nBU, nInkey:=0, cDrive:=' ' ,cOldCol:=SetColor()  //,cDat,cZip
 LOCAL cTarget, nExt, aDbf:={}, cRepl:='N', nSw:=1, cScr:=SaveScreen(0,0,24,79)
 PRIVATE cCO:='',cNC:='',c12:='M',c10:='P',cBO:='E',cNB:='F',cS8:='0',cS6:='6',cBigBold,cBig,cNormal
 PRIVATE cNo, nn,cWidth:=8
 PRIVATE nCom:=1, cSele
 ngn :=IF(ngn=NIL,1,ngn)
 nCom:=ngn
 nBu :=1
 IF(lGLan,cPATH:=NDATA,cPATH:=DDATA)
 SetColor(cOldCol)
 CreaTemp()
 IF SELECT('PRODUK')=0
    IF !NetUse({{cPATH+'PRODUK.DBF',.T.}})             // .f.
       RETURN
    ENDIF
 ENDIF
 SET INDEX TO (cPATH+"PRODUK_1.NTX"),(cPATH+"PRODUK_2.NTX"),(cPATH+"PRODUK_3.NTX")
 PRODUK->(LblPrt())
 IF Select('_TEMP')#0 ;_TEMP->(DBCloseArea()) ;ENDIF
 SetColor(cOldCol)
RETURN

*------------------------------------------------------------------------------
PROCEDURE LblPrt()
 LOCAL   nCetak
 PRIVATE aCode[8], aName[8], aName2[8], aPric[8]
 PRIVATE SS:=0, cBLogo:=Space(11),cBLogo1:=1
 IF File('DAT\LOGO.MEM')
    RESTORE FROM DAT\LOGO.MEM ADDI
 ENDIF
 nCom:=IF(Empty(cBLogo1),nCom,cBLogo1)
 //SetClearB()
 CLS
 @ 1 ,0 TO 22,79
 @ 2 ,1 CLEAR TO 21,78
 @ 20,1 TO 20,78            //DOUB
 STORE SPACE(03) TO cCetak
 Tengahin(SATELITE->(AllTrim(DESC)),0,0,79,'W+')
 @ 23,00 Say 'Port: '+IF(nCom=3,'LPT1','COM'+Str(nCom,1)) COLOR 'W'
 @ 23,11 Say 'þ 452 þþþ Master Data Produk 'COLOR 'W'
 @ 23,58 Say 'þþþ Logo: '+cBLogo         COLOR 'W'
 @ 21, 2 SAY "[     ]-Select  [   ]-Edit  [  ]-Search  [  ]-Set  [   ]-Print  [   ]-Quit "
 *            2345678901234567890123456789012345678901234567890123456789012345678901234567890
 @ 21, 3 SAY "SPACE"  COLOR "W+"
 @ 21,19 SAY "ÄÙ"    COLOR "W+"
 @ 21,31 SAY "F8"     COLOR "W+"
 @ 21,44 SAY "F9"     COLOR "W+"
 @ 21,54 SAY "F10"    COLOR "W+"
 @ 21,67 SAY "ESC"    COLOR "W+"
 Field:={'FLAG','Left(CODE,cWidth)','DESC','REF','JCET','Trans(PRICE,"@E 99,999,999")'}
 Judul:={' ','CODE ','DESCRIPTION','BARCODE','JmlCet','PRICE'}
 DBEdit(2,1,19,78,Field,'PrFunc',,Judul,'Ä')
RETURN

*------------------------------------------------------------------------------
FUNCTION PrFunc(nMod,nFiel)
LOCAL cSc
 cField:=Field[nFiel]
 IF LastKey()=K_ESC
    RETURN 0
 ELSEIF LastKey()=32
    IF FLAG=' '
       IF RecLock() ;REPLACE FLAG WITH 'û'
                     _TEMP->(AddRec())
                     _TEMP->FLAG   :=FLAG
                     _TEMP->CODE   :=CODE  //___ALTCODE
                     _TEMP->DESC   :=DESC
                     _TEMP->DEPT   :=AllTrim(DEPT)
                     _TEMP->PRICE  :=PRICE
                     _TEMP->JCET   :=JCET
                     KeyBoard CHR(K_HOME)+CHR(4)+CHR(4)+CHR(4)+CHR(4)+CHR(13)
       ENDIF
    ELSE        ;IF RecLock() ;REPLACE FLAG WITH ' ' ;ENDIF
                 IF _TEMP->(DBSeek(PRODUK->CODE)) ;_TEMP->(DBDelete()) ;ENDIF
    ENDIF
    DBCOMMIT()
    UnLock
 ELSEIF LastKey()=K_F8
    F8Search()
 ELSEIF LastKey()=K_F9
    cSc:=SaveScreen(15,40,22,79)
    SetCursor(1)
    @ 19,53 CLEAR TO 22,79 ;@ 19,53 TO 22,79
    @ 20,54 SAY 'Prn Port:' GET cBLogo1 PICT '9'  RANGE 1,3
    @ 21,54 SAY '    Logo:' GET cBLogo  PICT '@!'
    READ
    SAVE ALL LIKE cBLogo* TO DAT\LOGO.MEM
    nCom:=IF(Empty(cBLogo1),nCom,cBLogo1)
    @ 23,00 Say 'Port: '+IF(nCom=3,'LPT1','COM'+Str(nCom,1)) COLOR 'W'
    @ 23,58 Say 'þþþ Logo: '+cBLogo     COLOR 'W'
    RestScreen(15,40,22,79,cSc) ;SetCursor(0)
 ELSEIF LastKey()=K_F10
    CetakL() ;RETURN 2
 ELSEIF LastKey()=K_ENTER .AND. nFiel=5
    RecLock() ;SetCursor(1)
    @ Row(),Col() GET &cField PICT '9999'
    READ
    DBCOMMIT() ;UnLock
    IF _TEMP->(DBSeek(PRODUK->CODE)) ;_TEMP->JCET:=JCET ;ENDIF
    SetCursor(0)
 ENDIF
 RETURN 1

*----------------------------------------------------------------------------------*
STATIC FUNCTION CetakL()
LOCAL cSv:=SaveScreen(2,0,24,79), cSel:=Select()
 nS:=0 ;nE:=0 ;nC:=0
 @ 21, 1 SAY ' Press ÄÙ to Printed Out Data with `û`  mark - [ESC] to Cancel               '
 @ 21,38 SAY 'û' COLOR 'W+*/N'
 Inkey(0)
 IF LastKey()=K_ESC
    SetColor("W/N")
    @ 21,1 CLEAR TO 17,78
    TONE(2000,3) ;TONE(1000,3) ;RETURN
 ENDIF
 SELECT _TEMP ;PACK
 nLabel:=LabelT()                           &&___0,1,2 atau 3
 IF nLabel=0
    @ 23,1 CLEAR TO 23,78
    SELECT &cSel ;KeyBoard Chr(1)
    RestScreen(2,0,24,79,cSv) ;RETURN
 ENDIF
 DO CASE
    CASE nLabel=1
         ESC :=CHR(27)
         LF  :=CHR(10)
         NUL :=CHR(0)
         SET CONS OFF
         SET DEVICE TO PRINT
         IF nCom=3
            SET PRINTER TO ('LPT1')
         ELSE
            SET PRINTER TO ('COM'+Str(nCom,1))
         ENDIF
         SET PRINT ON
         ?? ESC + "D0200,0960,0180"            +LF+NUL
         IF SS=0  ;?? ESC + "T20C52"           +LF+NUL
                   SS=1
         ENDI
         ?? ESC + "C"                          +LF+NUL
         Count To nJR FOR FLAG='û'
         Sum JCET TO nJc FOR FLAG='û'
         nI:=0 ;nR:=0 ;DBGOTop()
         DO WHILE !Eof()
            IF FLAG=' ' ;SKIP ;LOOP ;ENDIF
            nR++
            cPrin:=JCET
            IF nJR=nR .AND. (nJC%3)#0
               IF nJR=1 ;cPrin=cPrin+(3-(cPrin%3))
               ELSE     ;cPrin=cPrin+(cPrin%3)+(3-(cPrin%3))
               ENDIF
            ENDIF
            FOR i = 1 TO cPrin ;nI++
                nLCode:=Len(Alltrim(CODE))+1
                aCode[nI]:=CODE
                aName[nI]:=DESC
                aName2[nI]:=' '
                aPric[nI]:=PRICE
                IF nI=3 ;Cetak(aCode,aName,aName2,aPric,nLabel)
                   nI:=0;LOOP
                ENDIF
            NEXT
            SKIP
         ENDDO
         SET PRINT TO
         SET PRINT OFF
         SET DEVICE TO SCREEN
         SET CONSOLE OFF
    CASE nLabel=2
         ESC :=CHR(27)
         LF  :=CHR(10)
         NUL :=CHR(0)
         SET CONS OFF
         SET DEVICE TO PRINT
         IF nCom=3
            SET PRINTER TO ('LPT1')
         ELSE
            SET PRINTER TO ('COM'+Str(nCom,1))
         ENDIF
         SET PRINT ON
         ?? ESC + "D0180,0960,0180"            +LF+NUL
         IF SS=0  ;?? ESC + "T10C52"           +LF+NUL
                   SS=1
         ENDI
         ?? ESC + "C"                                                        + LF + NUL
         Count To nJR FOR FLAG='û'
         Sum JCET TO nJc FOR FLAG='û'
         nI:=0 ;nR:=0 ;DBGOTop()
         DO WHILE !Eof()
             IF FLAG=' ' ;SKIP ;LOOP ;ENDIF
             nR++
             cPrin:=JCET
             IF nJR=nR .AND. (nJC%3)#0
                IF nJR=1 ;cPrin=cPrin+(3-(cPrin%3))
                ELSE     ;cPrin=cPrin+(cPrin%3)+(3-(cPrin%3))
                ENDIF
             ENDIF
             FOR i = 1 TO cPrin ;nI++
                 nLCode:=Len(Alltrim(CODE))+1
                 aCode[nI]:=CODE
                 aName[nI]:=DESC
                 aName2[nI]:=' '
                 aPric[nI]:=PRICE
                 IF nI=3 ;Cetak(aCode,aName,aName2,aPric,nLabel)
                    nI:=0;LOOP
                 ENDIF
             NEXT
             SKIP
         ENDDO
         SET PRINT TO
         SET PRINT OFF
         SET DEVICE TO SCREEN
         SET CONSOLE OFF

    CASE nLabel=3
         ESC :=CHR(27)
         LF  :=CHR(10)
         NUL :=CHR(0)
         SET CONS OFF
         SET DEVICE TO PRINT
         IF nCom=3
            SET PRINTER TO ('LPT1')
         ELSE
            SET PRINTER TO ('COM'+Str(nCom,1))
         ENDIF
         SET PRINT ON
         ?? ESC + "D0380,0900,0360"            +LF+NUL
         IF SS=0  ;?? ESC + "T10C52"           +LF+NUL
                   SS=1
         ENDI
        *?? ESC + "C"                                                        + LF + NUL
         Count To nJR FOR FLAG='û'
         Sum JCET TO nJc FOR FLAG='û'
         nI:=0 ;nR:=0 ;DBGOTop()
         DO WHILE !Eof()
             IF FLAG=' ' ;SKIP ;LOOP ;ENDIF
             nR++
             cPrin:=JCET
             FOR i = 1 TO cPrin
                 aCode[1]:=CODE
                 aName[1]:=DESC
                 aName2[1]:=' '
                 aPric[1]:=PRICE
                 Cetak(aCode,aName,aName2,aPric,nLabel)
             NEXT
             SKIP
         ENDDO
         SET PRINT TO
         SET PRINT OFF
         SET DEVICE TO SCREEN
         SET CONSOLE OFF

    CASE nLabel=4
         SET CONS OFF
         //IF !ChkPrinter('LPT1') ;SELECT &cFile ;RETURN
         //ENDIF
         @ PRow(),00 SAY Chr(27)+'@'+Chr(27)+'x'+Chr(0)

         nJR:=LastRec()
         Sum JCET TO nJc FOR FLAG='û'
         nI:=0 ;nR:=0 ;DBGOTop()
         DO WHILE !Eof()
             IF FLAG=' ' ;SKIP ;LOOP ;ENDIF
             nR++
             cPrin:=JCET
             IF nJR=nR .AND. (nJC%8)#0
                IF nJR=1 ;cPrin=cPrin+(8-(cPrin%8))
                ELSE     ;cPrin=cPrin+(cPrin%8)+(8-(cPrin%8))
                ENDIF
             ENDIF
             FOR i = 1 TO cPrin ;nI++
                 aCode[nI]:=Left(CODE,9)+Space(8)    //+'/'+DEPNO+Space(8)
                 aName[nI]:=Left(DESC,IF(nLabel=3,16,15))
                 aPric[nI]:=PRICE
                 IF nI=8 ;Cetak(aCode,aName,,aPric,nLabel)
                    nI:=0;LOOP
                 ENDIF
             NEXT
             SKIP
         ENDDO
         SET PRINT OFF
         SET DEVICE TO SCREEN
         SET CONSOLE OFF
    CASE nLabel=5
         SET CONS OFF
         //IF !ChkPrinter('LPT1') ;SELECT &cFile ;RETURN
         //ENDIF
         @ PRow(),00 SAY Chr(27)+'@'+Chr(27)+'x'+Chr(1)

         nJR:=LastRec()
         Sum JCET TO nJc FOR FLAG='û'
         nI:=0 ;nR:=0 ;DBGOTop()
         DO WHILE !Eof()
             IF FLAG=' ' ;SKIP ;LOOP ;ENDIF
             nR++
             cPrin:=JCET
             IF nJR=nR .AND. (nJC%2)#0
                IF nJR=1 ;cPrin=cPrin+(2-(cPrin%2))
                ELSE     ;cPrin=cPrin+(cPrin%2)+(2-(cPrin%2))
                ENDIF
             ENDIF
             FOR i = 1 TO cPrin ;nI++
                 aCode[nI]:=Left(CODE,9)+Space(8)    //+'/'+DEPNO+Space(8)
                 aName[nI]:=Left(DESC,IF(nLabel=4,30,15))
                 aPric[nI]:=PRICE
                 IF nI=2 ;Cetak(aCode,aName,,aPric,nLabel)
                    nI:=0;LOOP
                 ENDIF
             NEXT
             SKIP
         ENDDO
         SET PRINT OFF
         SET DEVICE TO SCREEN
         SET CONSOLE OFF
    CASE nLabel=6
         SET CONS OFF
         //IF !ChkPrinter('LPT1') ;SELECT &cFile ;RETURN
         //ENDIF
         nJR:=LastRec()
         Sum JCET TO nJc FOR FLAG='û'
         nI:=0 ;nR:=0 ;DBGOTop()
         DO WHILE !Eof()
             IF FLAG=' ' ;SKIP ;LOOP ;ENDIF
             nR++
             cPrin:=JCET
             IF nJR=nR .AND. (nJC%2)#0
                IF nJR=1 ;cPrin=cPrin+(2-(cPrin%2))
                ELSE     ;cPrin=cPrin+(cPrin%2)+(2-(cPrin%2))
                ENDIF
             ENDIF
             FOR i = 1 TO cPrin ;nI++
                 aCode[nI]:=Left(CODE,9)+Space(8)    //+'/'+DEPNO+Space(8)
                 aName[nI]:=Left(DESC,21)      //IF(nLabel=4,30,15))
                 aPric[nI]:=PRICE
                 IF nI=2
                    Cetak(aCode,aName,,aPric,nLabel,i,cPrin)
                    nI:=0;LOOP
                 ENDIF
             NEXT
             SKIP
         ENDDO
         SET PRINT OFF
         SET DEVICE TO SCREEN
         SET CONSOLE ON
 ENDCASE
 PRODUK->(DBSetOrder(1))
 SELECT _Temp
 DBGoTop()
 DO WHILE !Eof()
    cCode:=CODE
    IF PRODUK->(DBSeek(cCode))
       PRODUK->(RecLock())
       REPLACE PRODUK->FLAG WITH ' '
       PRODUK->(DBUnLock())
    ENDIF
    DBSkip()
 ENDDO
 PRODUK->(DBCommit())
 ZAP                    //-->_Temp
 SELECT PRODUK
 SetColor("W/N")
 @ 21,1 CLEAR TO 21,78
 RestScreen(2,0,24,79,cSv)
KeyBoard Chr(K_UP)
RETURN

*------------------------------------------------------------------------------
STATIC FUNCTION LabelT()
 LOCAL Sc00,nL
 Save Screen To Sc00
 OldColor:=SetColor()
 SetColor('W+/N,N/W*')
 @ 16,64 TO 23,78
 aPilih:={' KPL-1830  ',' KPT-1830  ',' KPL-3045  ',' 80 Col-1824 ',' 80 Col-3070 ',' 80 Col-4090 '}
 nPilih:=aChoice(17,65,22,77,aPilih)

 IF nPilih=3
    cS8:='0'
    cS6:='2'
    cCO:=''
    cNC:=''
    c12:=':'
    c10:=''
 ELSEIF nPilih>=4 .and. nPilih<6
    cS8:='0'
    cS6:='2'
    cCO:=''
    cNC:=''
//  c12:='M'
//  c10:='P'
    cBO:='E'
    cNB:='F'
 ELSEIF nPilih=6
    cBigBold:=Chr(27)+'!'+Chr(41)
    cBig    :=Chr(27)+'!'+Chr(33)
    cNormal :=Chr(27)+'!'+Chr(0)
 ENDIF

 Rest Screen From Sc00
 SetColor(OldColor)
RETURN nPilih

*-----------------------------------------------------------------------------
FUNCTION CETAK(aCode,aName,aName2,aPric,nLabel,nNo,nPrn)
*----------------------------------------------------------------------------------*
LOCAL cQty
 DO CASE
    CASE nLabel=1
         Form1(aCode[1],aName[1],aPric[1])
         Form2(aCode[2],aName[2],aPric[2])
         Form3(aCode[3],aName[3],aPric[3])
         ?? ESC + "XS;I," + '0001' + ",0002C5200"                    + LF + NUL
    CASE nLabel=2
         Form1(aCode[1],aName[1],aPric[1])
         Form2(aCode[2],aName[2],aPric[2])
         Form3(aCode[3],aName[3],aPric[3])
         ?? ESC + "XS;I," + '0001' + ",0001C5200"                    + LF + NUL
    CASE nLabel=3
         Form4(aCode[1],aName[1],aName2[1],aPric[1])
         * Form5(aCode[2],aName[2],aName2[2],aPric[2])
         * Form6(aCode[3],aName[3],aName2[3],aPric[3])
         ?? ESC + "XS;I," + '0001' + ",0001C5200"                    + LF + NUL
    CASE nLabel=4
         Form10(aCode,aName,aPric)
    CASE nLabel=5
         Form11(aCode,aName,aPric)
    CASE nLabel=6
         Form12(nNo,nPrn)
 ENDCASE
RETURN NIL

*-----------------------------------------------------------------------------
STATIC FUNCTION Form1()
 **-- Format Label I
 ?? ESC + "PC00;0035,0170,05,10,A,+01,33,B,J0201"                    +LF+NUL &&_M-Studio
 ?? ESC + "PC01;0070,0050,05,10,A,-01,00,B,J0201"                    +LF+NUL
 IF nLabel=1
    ?? ESC + "PC02;0070,0165,10,15,A,-01,00,B,J0202"                 +LF+NUL && cPrice_
    ?? ESC + "XB01;0070,0055,9,1,03,0,0050,-0000000000,020,1,00"     +LF+NUL
 ELSEIF nLabel=2
    ?? ESC + "PC02;0070,0150,10,10,A,-01,00,B,J0202"                 +LF+NUL && cPrice_
    ?? ESC + "XB01;0070,0055,9,1,03,0,0040,-0000000000,020,1,00"     +LF+NUL
 ENDIF
 **-- Data Label I
 ?? ESC + "RC00;"+cBLogo                                             +LF+NUL
 ?? ESC + "RC01;" + aName[1]                                         +LF+NUL
 ?? ESC + "RC02;Rp." + Tran(aPric[1],"@E 999,999,999")               +LF+NUL
 ?? ESC + "RB01;" + AllTrim(aCode[1])                                +LF+NUL
RETURN 1

*-----------------------------------------------------------------------------
STATIC FUNCTION Form2()
 **-- Format Label II
 ?? ESC + "PC10;0355,0170,05,10,A,+01,33,B,J0201"                    + LF + NUL &&_M-Studio
 ?? ESC + "PC11;0390,0050,05,10,A,-01,00,B,J0201"                    + LF + NUL
 IF nLabel=1
    ?? ESC + "PC12;0390,0165,10,15,A,-01,00,B,J0202"                 + LF + NUL && cPrice_
    ?? ESC + "XB11;0390,0055,9,1,03,0,0050,-0000000000,020,1,00"     + LF + NUL
 ELSEIF nLabel=2
    ?? ESC + "PC12;0390,0150,10,10,A,-01,00,B,J0202"                 + LF + NUL && cPrice_
    ?? ESC + "XB11;0390,0055,9,1,02,0,0040,-0000000000,020,1,00"     + LF + NUL
 ENDIF
 **-- Data Label II
 ?? ESC + "RC10;"+cBLogo                                             + LF + NUL
 ?? ESC + "RC11;" + aName[2]                                         + LF + NUL
 ?? ESC + "RC12;Rp." + Tran(aPric[2],"@E 999,999,999")               + LF + NUL
 ?? ESC + "RB11;" + AllTrim(aCode[2])                                + LF + NUL
RETURN 1

*-----------------------------------------------------------------------------
STATIC FUNCTION Form3()
 **-- Format Label III
 ?? ESC + "PC20;0675,0170,05,10,A,+01,33,B,J0201"                    + LF + NUL &&_M-Studio
 ?? ESC + "PC21;0710,0050,05,10,A,-01,00,B,J0201"                    + LF + NUL
 IF nLabel=1
    ?? ESC + "PC22;0710,0165,10,15,A,-01,00,B,J0202"                 + LF + NUL && cPrice_
    ?? ESC + "XB21;0710,0055,9,1,03,0,0050,-0000000000,020,1,00"     + LF + NUL
 ELSEIF nLabel=2
    ?? ESC + "PC22;0710,0150,10,10,A,-01,00,B,J0202"                 + LF + NUL && cPrice_
    ?? ESC + "XB21;0710,0055,9,1,02,0,0040,-0000000000,020,1,00"     + LF + NUL
 ENDIF
 **-- Data Label III
// ?? ESC + "RC20;SELAMAT"                                           + LF + NUL
 ?? ESC + "RC20;"+cBLogo                                             + LF + NUL
 ?? ESC + "RC21;" + aName[3]                                         + LF + NUL
 ?? ESC + "RC22;Rp." + Tran(aPric[3],"@E 999,999,999")               + LF + NUL
 ?? ESC + "RB21;" + AllTrim(aCode[3])                                + LF + NUL
RETURN 1

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
STATIC FUNCTION Form4()
 **-- Format Label I
 ?? ESC + "PC04;0040,0330,10,10,B,+00,33,B,J0101"                      +LF+NUL &&_M-Studio
 ?? ESC + "PC05;0070,0110,10,20,D,+01,00,B"                            +LF+NUL
 ?? ESC + "PC06;0070,0180,10,20,D,+01,00,B"                            +LF+NUL
 ?? ESC + "PC07;0070,0290,20,20,E,-01,00,B,J0101"                      +LF+NUL
 **-- Data Label I
 ?? ESC + "RC04;"+cBLogo                                               +LF+NUL
 ?? ESC + "RC05;" + aName[1]                                           +LF+NUL
 ?? ESC + "RC06;" + aName2[1]                                          +LF+NUL
 ?? ESC + "RC07;Rp. " + ALlTrim(Tran(aPric[1],"@E 999,999,999"))+" ,-" +LF+NUL
RETURN 1

*-----------------------------------------------------------------------------
STATIC FUNCTION Form5()
 **-- Format Label II
 ?? ESC + "PC14;0550,0400,10,10,A,+00,22,B"                            + LF + NUL &&_M-Studio
 ?? ESC + "PC15;0390,0350,10,10,B,-04,33,B"                            + LF + NUL
 ?? ESC + "PC16;0430,0350,10,10,B,-04,33,B"                            + LF + NUL
 ?? ESC + "PC17;0540,0350,10,20,B,-01,33,B,J0101"                      + LF + NUL && cPrice_
 **-- Data Label II
 ?? ESC + "RC14;"+cBLogo                                               + LF + NUL
 ?? ESC + "RC15;" + aName[2]                                           + LF + NUL
 ?? ESC + "RC16;" + aName2[2]                                          + LF + NUL
 ?? ESC + "RC17;Rp. " + AllTrim(Tran(aPric[2],"@E 999,999,999"))+" ,-" + LF + NUL
RETURN 1

*-----------------------------------------------------------------------------
STATIC FUNCTION Form6()
 **-- Format Label III
 ?? ESC + "PC24;0850,0400,10,10,A,+00,22,B"                            + LF + NUL &&_M-Studio
 ?? ESC + "PC25;0690,0350,10,10,B,-04,33,B"                            + LF + NUL
 ?? ESC + "PC26;0730,0350,10,10,B,-04,33,B"                            + LF + NUL
 ?? ESC + "PC27;0840,0350,10,20,B,-01,33,B,J0101"                      + LF + NUL && cPrice_
 **-- Data Label III
 ?? ESC + "RC24;"+cBLogo                                               + LF + NUL
 ?? ESC + "RC25;" + aName[3]                                           + LF + NUL
 ?? ESC + "RC26;" + aName2[3]                                          + LF + NUL
 ?? ESC + "RC27;Rp. " + AllTrim(Tran(aPric[3],"@E 999,999,999"))+" ,-" + LF + NUL
RETURN 1

*-----------------------------------------------------------------------------
STATIC FUNCTION Form10()                        //__80 Col-1832
 @ PRow()  ,00  SAY  cS8+c10+cCon+aCode[1]
 @ PRow()  ,16  SAY  aCode[2]
 @ PRow()  ,33  SAY  aCode[3]
 @ PRow()  ,49  SAY  aCode[4]
 @ PRow()  ,65  SAY  aCode[5]
 @ PRow()  ,81  SAY  aCode[6]
 @ PRow()  ,98  SAY  aCode[7]
 @ PRow()  ,114 SAY  aCode[8]

 cN1:=AllTrim(aName[1])
 cN2:=AllTrim(aName[2])
 cN3:=AllTrim(aName[3])
 cN4:=AllTrim(aName[4])
 cN5:=AllTrim(aName[5])
 cN6:=AllTrim(aName[6])
 cN7:=AllTrim(aName[7])
 cN8:=AllTrim(aName[8])

 nn:=IF(nLabel=3,15,16)
 IF nLabel=3
    @ PRow()+1,00  SAY  cNBold+c12+cCon+ cN1+Space(nn-Len(cN1))
    @ PRow()  ,19  SAY  cN2+Space(nn-Len(cN2))
    @ PRow()  ,39  SAY  cN3+Space(nn-Len(cN3))
    @ PRow()  ,57  SAY  cN4+Space(nn-Len(cN4))
    @ PRow()  ,76  SAY  cN5+Space(nn-Len(cN5))
    @ PRow()  ,95  SAY  cN6+Space(nn-Len(cN6))
    @ PRow()  ,114 SAY  cN7+Space(nn-Len(cN7))
    @ PRow()  ,133 SAY  cN8+Space(nn-Len(cN8))
 ELSE
    @ PRow()+1,00  SAY  cNBold+c12+cCon+ cN1+Space(nn-Len(cN1))
    @ PRow()  ,16  SAY  cN2+Space(nn-Len(cN2))
    @ PRow()  ,33  SAY  cN3+Space(nn-Len(cN3))
    @ PRow()  ,49  SAY  cN4+Space(nn-Len(cN4))
    @ PRow()  ,65  SAY  cN5+Space(nn-Len(cN5))
    @ PRow()  ,81  SAY  cN6+Space(nn-Len(cN6))
    @ PRow()  ,98  SAY  cN7+Space(nn-Len(cN7))
    @ PRow()  ,114 SAY  cN8+Space(nn-Len(cN8))

 ENDIF

 cP1:=AllTrim(Trans(aPric[1],'@E 99,999,999'))
 cP2:=AllTrim(Trans(aPric[2],'@E 99,999,999'))
 cP3:=AllTrim(Trans(aPric[3],'@E 99,999,999'))
 cP4:=AllTrim(Trans(aPric[4],'@E 99,999,999'))
 cP5:=AllTrim(Trans(aPric[5],'@E 99,999,999'))
 cP6:=AllTrim(Trans(aPric[6],'@E 99,999,999'))
 cP7:=AllTrim(Trans(aPric[7],'@E 99,999,999'))
 cP8:=AllTrim(Trans(aPric[8],'@E 99,999,999'))

 @ PRow()+1,00  SAY  c10+cCon +'Rp. '+cP1+Space(13-Len(cP1))
 @ PRow()  ,16  SAY  'Rp. '+cP2+Space(13-Len(cP2))
 @ PRow()  ,33  SAY  'Rp. '+cP3+Space(13-Len(cP3))
 @ PRow()  ,49  SAY  'Rp. '+cP4+Space(13-Len(cP4))
 @ PRow()  ,65  SAY  'Rp. '+cP5+Space(13-Len(cP5))
 @ PRow()  ,81  SAY  'Rp. '+cP6+Space(13-Len(cP6))
 @ PRow()  ,98  SAY  'Rp. '+cP7+Space(13-Len(cP7))
 @ PRow()  ,114 SAY  'Rp. '+cP8+Space(13-Len(cP8))
 
 @ PRow()+2  ,00 SAY c10+cNB+cNC+cS6
 @ PRow()+1  ,00 SAY Chr(13)
RETURN 1

*------------------------------------------------------------------------------
STATIC FUNCTION Form11()                        //__80 Col-1824
 @ PRow()  ,00  SAY  c10+aCode[1]
 @ PRow()  ,30  SAY  aCode[2]

 cN1:=AllTrim(aName[1])
 cN2:=AllTrim(aName[2])

 nn:=IF(nLabel=4,25,16)
 IF nLabel=4
    @ PRow()+2,00  SAY  c12+ cN1+Space(nn-Len(cN1))
    @ PRow()  ,36  SAY  cN2+Space(nn-Len(cN2))
 ELSE
    @ PRow()+2,00  SAY  c12+ cN1+Space(nn-Len(cN1))
    @ PRow()  ,30  SAY  cN2+Space(nn-Len(cN2))

 ENDIF

 cP1:=AllTrim(Trans(aPric[1],'@E 99,999,999'))
 cP2:=AllTrim(Trans(aPric[2],'@E 99,999,999'))

 @ PRow()+2,00  SAY  c10+ 'Rp. '+cP1+Space(13-Len(cP1))
 @ PRow()  ,30  SAY  'Rp. '+cP2+Space(13-Len(cP2))
 
 @ PRow()+2  ,00 SAY c10+cNB+cNC+cS6
 @ PRow()+1  ,00 SAY Chr(13)
RETURN 1

*------------------------------------------------------------------------------
STATIC FUNCTION Form12(nNo,nPrn)                        //__80 Col-1824
 nn :=21
 cC1:=AllTrim(aCode[1])
 cC2:=AllTrim(aCode[2])
 cN1:=AllTrim(aName[1])
 cN2:=AllTrim(aName[2])
 cP1:='Rp. '+AllTrim(Trans(aPric[1],'@E 99,999,999'))
 cP2:='Rp. '+AllTrim(Trans(aPric[2],'@E 99,999,999'))
 IF nNo=2
    @ PRow()+1,00  SAY cBig+'Ã'+Repl('Ä',nn)+'Å'+Repl('Ä',nn)+'´'
 ENDIF
 @ PRow()+1,00  SAY '³'+Space(nn)+'³'+Space(nn)+'³'
 @ PRow()+1,00  SAY '³'+cC1+Space(nn-Len(cC1)) + '³'+cC2+Space(nn-Len(cC2))+'³'
 @ PRow()+1,00  SAY '³'+Space(nn)+'³'+Space(nn)+'³'
 @ PRow()+1,00  SAY '³'+cN1+Space(nn-Len(cN1)) + '³'+cN2+Space(nn-Len(cN2))+'³'
 @ PRow()+1,00  SAY '³'+Space(nn)+'³'+Space(nn)+'³'
 @ PRow()+1,00  SAY '³'+cBigBold+cP1+Space(nn-Len(cP1))+cBig+ '³'+cBigBold+cP2+Space(nn-Len(cP2))+cBig+'³'
 @ PRow()+1,00  SAY '³'+Space(nn)+'³'+Space(nn)+'³'
 @ PRow()+1,00  SAY cBig+'Ã'+Repl('Ä',nn)+'Å'+Repl('Ä',nn)+'´'

RETURN 1

*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
STATIC FUNCTION CreaTemp()
LOCAL aDBF:={{'FLAG'   ,'C',01,0},;
             {'CODE'   ,'C',13,0},;
             {'DESC'   ,'C',30,0},;
             {'DEPT'  ,'C',02,0},;
             {'PRICE'  ,'N',08,0},;
             {'JCET'   ,'N',04,0},;
             {'UNIT'   ,'C',05,0}}
LOCAL cSel:=Select()
IF !File('_TEMP.DBF')
   DBCreate('_TEMP',aDBF)
ENDIF
USE _TEMP NEW
IF !File('_TEMP.NTX')
   INDEX ON CODE TO _TEMP
ENDIF
SET INDEX TO _TEMP
Select(cSel)
RETURN

*-----------------------------------------------------------------------------
STATIC PROCEDURE F8Search()
LOCAL cSvScreen:=SaveScreen(21,0,24,79)
LOCAL aF:={{'CODE'        ,'CODE'    };
          ,{'DESCRIPTION' ,'DESC'    };
          ,{'DEPT'        ,'DEPT'    };
          ,{'COST'        ,'CPRICE'  };
          ,{'PRICE'       ,'PRICE'   }}
DBLook(aF,'[List Inv]',2)
RestScreen(21,0,24,79,cSvScreen)
KeyBoard Chr(128)
GetList:={}
RETURN

*-----------------------------------------------------------------------------
PROCEDURE DBLook(aField,cJdl,nIdx)
LOCAL cScr:=SaveScreen(11,0,27,79)
PRIVATE cKey:='', aFi:={}, aHe:={}, nNtx
cJdl:=IF(cJdl=NIL,'Tabel Data',cJdl)
nNtx:=IF(nIdx=NIL.OR.ValType(nIdx)#'N',IndexOrd(),nIdx)
FOR n=1 TO Len(aField)
   AADD(aHe,aField[n][1])
   AADD(aFi,aField[n][2])
NEXT
SetCursor(0)
Box(11,00,27,79)
ColorSelect(1)
@ 26,43 SAY Space(30) ;ColorSelect(0)
@ 11,01 SAY cJdl
@ 25,01 SAY Repl('Ä',78)
@ 26,01 SAY '[][PgUp][PgDn]-SelectÛ[ESC]-ExitÛSearch:'
DBEDIT(12,1,24,78,aFi,'FLook',,aHe,'Ä')
RestScreen(11,0,27,79,cScr)
RETURN

*-------------------------
FUNCTION FLook(nMode,nFld)
LOCAL nInkey:=LastKey(), cField:=aFi[nFld], nOrder:=IndexOrd()
DO CASE
CASE nInkey>=K_SPACE .AND. Len(cKey)<30
     cKey+=Upper(Chr(nInkey))
     ColorSelect(1)   ;@ 26,43 SAY Upper(cKey) ;ColorSelect(0)
     IF !DBSeek(cKey)
        DBSetOrder(nNtx) ;DBSeek(cKey)
     ENDIF
     DBSetOrder(nOrder)
     KeyBoard Chr(1)
CASE nInkey=K_BS
     IF !Empty(cKey)
        cKey:=Left(cKey,Len(cKey)-1)
        ColorSelect(1) ;@ 26,43 SAY Upper(cKey)+' ' ;ColorSelect(0)
        IF !DBSeek(cKey)
           DBSetOrder(nNtx) ;DBSeek(cKey)
        ENDIF
        DBSetOrder(nOrder)
        KeyBoard Chr(1)
     ENDIF
CASE nInkey=K_ESC .OR. nInkey=K_ENTER
     RETURN 0
ENDCASE
RETURN 1

*------------------------------------------------------------------------------

