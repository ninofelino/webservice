#include "hmg.ch"
PROCEDURE JINFAK(cTTL)
 PRIVATE cPATH,cFITXT:='TXT\IFA'
 PRIVATE cDEPT:=SPACE(03),nPAGE:=1,cJDL:=cTTL
 PRIVATE aDB1:={},aDB2:={},dS:=DATE(),dE:=DATE(),cT1:=SPACE(02),cT2:=SPACE(02)

 IF lGLan
    DO CASE
       CASE cTTL='READ'
            cPATH :='F:\WPI\DLL\'
       CASE cTTL='RESET'
            cPATH:='F:\WPI\EOD\'
    ENDCASE
 ELSE
    DO CASE
       CASE cTTL='READ'
            cPATH:='C:\KASIR\DAT\'
       CASE cTTL='RESET'
            cPATH:='C:\KASIR\EOD\'
    ENDCASE
 ENDIF

 IF !lGLAN .AND. cTTL='READ'
    cT1:=SUBST(SATELITE->CPNO,3,2)
    cT2:=SUBST(SATELITE->CPNO,3,2)
    SELECT CP
    COPY STRU TO 'C:IFA'
    USE C:IFA NEW ALIAS IFATMP
    INDEX ON DTOS(DDATE) TO 'C:IFATMP_1.NTX'
    SET INDEX TO 'C:IFATMP_1.NTX'

    SELECT CP;DBGOTOP()
    DO WHILE !EOF()
       IF FLAG='IFA'
          IFATMP->(DBAPPEND())
          FOR n = 1 TO FCOUNT()
              cFNAME:=FIELDNAME(n)
              IFATMP->&cFNAME:=CP->&cFNAME
          NEXT
       ENDIF
       SKIP
    ENDDO
 ELSE
    SETCURSOR(1)
    DO WHILE .T.
       SAVE SCREEN TO cSJR
       DO CASE
          CASE cTTL='READ'
               Box(17,10,19,31)
   *                     1         2         3         4         5         6         7         8         9
   *           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
               @18,12 SAY 'NO.TM#:    S/D   '
               @18,20 GET cT1
               @18,27 GET cT2
          CASE cTTL='RESET'
               Box(17,03,19,55)
          *                     1         2         3         4         5         6         7         8         9
          *           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
               @18,05 SAY 'NO.TM#:    S/D     TGL:            S/D          '
               @18,13 GET cT1
               @18,20 GET cT2
               @18,29 GET dS
               @18,44 GET dE
       ENDCASE
       READ
       IF LASTKEY()=27 .OR. EMPTY(cT1)
          RESTORE SCREEN FROM cSJR; RETURN
       ENDIF
       IF VAL(ALLTRIM(cT1)) > VAL(ALLTRIM(cT2))
          TONE(3000,4);cT1:=SPACE(02);cT2:=SPACE(02)
          dS:=DATE();dE:=DATE();cDP1:=SPACE(03);cDP2:=SPACE(03)
          LOOP
       ENDIF
       cT1:=RIGHT('00'+ALLTRIM(cT1),2);cT2:=RIGHT('00'+ALLTRIM(cT2),2)
       nT1:=VAL(cT1);nT2:=VAL(cT2)

       DO CASE
          CASE cTTL='READ'
               aDB1:=DIRECTORY(cPATH+'CP??0000.DBF')
          CASE cTTL='RESET'
               aDB1:=DIRECTORY(cPATH+'CP??????.DBF')
               nDS:=VAL(DTOS(dS));nDE:=VAL(DTOS(dE))
       ENDCASE

       IF LEN(aDB1)=0
          WARNING(' FILE TRANSAKSI TIDAK ADA !! ')
          RESTORE SCREEN FROM cSJR
          RETURN
       ENDIF
       EXIT
    ENDDO

    DO CASE
       CASE cTTL='READ'
            FOR nI = 1 TO LEN(aDB1)
                nDZ:=VAL(SUBS(aDB1[nI][1],3,2))
                IF nDZ>=nT1 .AND. nDZ<=nT2
                   AADD(aDB2,aDB1[nI])
                ENDIF
            NEXT
       CASE cTTL='RESET'
            FOR nI = 1 TO LEN(aDB1)
                nTZ:=VAL(SUBS(aDB1[nI][1],3,2))
                nDZ:=VAL(SUBS(DTOS(aDB1[nI][3]),1,4)+SUBS(aDB1[nI][1],5,4))
                IF nDZ>=nDS .AND. nDZ<=nDE
                   IF nTZ>=nT1 .AND. nTZ<=nT2
                      AADD(aDB2,aDB1[nI])
                   ENDIF
                ENDIF
            NEXT
    ENDCASE

    IF LEN(aDB2)=0
       WARNING(' FILE TRANSAKSI DALAM RANGE TIDAK ADA !! ')
       RESTORE SCREEN FROM cSJR
       RETURN
    ENDIF

    USE (cPATH+aDB2[1][1]) NEW SHARE
    aSTRUCT:=DBSTRUCT()
    USE
    DBCREATE('C:IFA',aSTRUCT)
    USE C:IFA NEW ALIAS IFATMP
    INDEX ON DTOS(DDATE) TO 'C:IFATMP_1.NTX'
    SET INDEX TO 'C:IFATMP_1.NTX'

    FOR nI = 1 TO LEN(aDB2)
        USE (cPATH+aDB2[nI][1]) NEW SHARE ALIAS IFACP
        DBGOTOP()
        DO WHILE !EOF()
           IF FLAG='IFA'
              IFATMP->(DBAPPEND())
              FOR n = 1 TO FCOUNT()
                  cFNAME:=FIELDNAME(n)
                  IFATMP->&cFNAME:=IFACP->&cFNAME
              NEXT
           ENDIF
           SKIP
        ENDDO
        CLOSE IFACP
    NEXT
 ENDIF

 cDDATE:=SPACE(10);nTOTAL:=0;nSUBTTL:=0

 nTGT:=PRNTGT(cFITXT)
 IF nTGT > 0
    SELECT IFATMP

    JUDUL(cT1,cT2,dS,dE)
    DBGOTOP()
    cDDATE:=DTOC(DDATE)
    DO WHILE !EOF()
       IF cDDATE=DTOC(DDATE)
          nSUBTTL+=PRICE
       ELSE
          @PROW()+1,00 SAY cDDATE
          @PROW()  ,31 SAY TRANS(nSUBTTL,'99,999,999')
          cDDATE:=DTOC(DDATE);nSUBTTL:=0
       ENDIF
       nTOTAL+=PRICE
       DBSKIP()
       IF PRow()>=55 .AND. !Eof()
          @ PROW()+1,00 SAY '컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'
          @ PROW()+1,00 SAY Chr(12)
          nPage++
          JUDUL(cT1,cT2,dS,dE)
       ENDIF
    ENDDO
    @PROW()+1,00 SAY cDDATE
    @PROW()  ,31 SAY TRANS(nSUBTTL,'99,999,999')
    @ PROW()+1,00 SAY '컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'
    @ PRow()+1,00 SAY 'TOTAL'
    @ PRow()  ,31 SAY TRANS(nTOTAL,'99,999,999')
    @ PROW()+1,00 SAY '컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'
    @ PRow()+1,00 SAY Chr(12)

    SET PRINT TO  ;SET PRINT OFF ;SET DEVICE TO SCREEN
    IF nTgt=1 ;DispRep(cFiTxt+'.Prn') ;ENDIF
 ENDIF

 CLOSE IFATMP
 DELETE FILE 'C:IFA.DBF'
 DELETE FILE 'C:IFATMP_1.NTX'
RETURN
*------------------------------------------------------------------------------*
STATIC FUNCTION JUDUL(c1,c2,d1,d2)
SETPRC(0,0)
@ PRow()+1,00 SAY 'PEROLEHAN INFAK ('+cJDL+')'
@ PRow()+2,00 SAY 'TM#: '+c1+' s/d '+c2
@ PRow()+1,00 SAY 'Tgl: '+DTOC(d1)+IF(cJDL='RESET',' s/d '+DTOC(d2),'')
@ PRow()  ,33 SAY 'Hal:'+Str(nPage,4)
@ PRow()+1,00 SAY '컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'
@ PRow()+1,00 SAY 'TANGGAL                            JUMLAH'
@ PRow()+1,00 SAY '컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'

*                  xxxxxxxxxxx                    99,999,999
*                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                            1         2         3         4         5         6         7         8
RETURN
*------------------------------------------------------------------------------*


