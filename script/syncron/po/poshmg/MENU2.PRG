#include "hmg.ch"
#include  "KASSA.CH"
#include  "INKEY.CH"
#include  "ACHOICE.CH"

*------------------------------------------------------------------------------*
PROCEDURE MENU2(Asoy,cTitle)
*------------------------------------------------------------------------------*
LOCAL OldClr := SETCOLOR(), OldScr
LOCAL aDbfList:={}, aDbf:={}, LastItem, i, CurItem, zKey,aDelFl
LOCAL nTop, nLeft, nBottom, nRight, dTgl:=CTOD(' /  /  ')
LOCAL nEl, nRel, nInit,nLenPop:= 0, cDir, nFP:=0,cPr:=cSTPRG
PRIVA PopFile := {}, hScrollBar

OldScr := SaveScreen(0, 0, 24, 79)
USEFILE()

lGRcpt:=.T.
IF Asoy == NIL
   CLOSE ALL
   lGRcpt:=.F.
   UseFile()
   RETURN
ENDIF
DO WHILE .T.
   IF lGlan .OR. (!lGlAN .AND. (ASCAN({6,7,8,9,10,11,14,16,20},Asoy) > 0) )
      IF ASCAN({1,2,3,4,5,12,13,15,19},Asoy) > 0           //___READ
         cDir := NDLL
      ELSE
         IF(lGlan, cDir := NEOD, cDir := DEOD)
      ENDIF

      IF EMPTY(aDbfList := GetDbf(cDir))
         WARNING(' File Tidak Ketemu ... ! ')
         CLOSE ALL
         lGRcpt:=.F.
         UseFile()
         RETURN
      ENDIF
      AEVAL(aDbfList, { |cF| AADD(PopFile," [ ]   Terminal  --> #"+;
                                   SUBSTR(cF,AT("CP",cF)+2,2)+" <"+;
                                   SUBSTR(cF,AT("CP",cF)+6,2)+"/" +;
                                   SUBSTR(cF,AT("CP",cF)+4,2)+">  " ) } )
      CurItem  := 1
      LastItem := CurItem
      nTop     := 4
      nLeft    := 21
      nBottom  := 21           &&  nTop + Len(PopFile ) + 1
      AEVAL(PopFile, { |cF| IIF(LEN(cF) > nLenPop, nLenPop:=LEN(cF)+1, .F.) } )
      nRight   := nLeft + nLenPop
      nEl      := 1
      nRel     := 1

      Box(nTop-1, nLeft-2, nBottom, nRight+1,"W+/W")
      @ nTop-1, nLeft say IIF(cTitle == NIL ,"Title",'Pilih Terminal '+cTitle) color "N/W"
      @ nTop,nLeft-1 SAY REPLICATE("þ",nLenPop+2) COLOR "W+/W"

      hScrollBar := TabNew( nTop+1, nLeft-1, nBottom-1, "W+/N", 1 )
      TabDisplay( hScrollBar )
      @ 24,0 SAY " <8:Up 2:Dn 9:PgUp 3:PgDn>  [5]-Slc [7]-UnSlc [.]-Print [0]-Exit               " COLOR "w/n"

      SETCOLOR("N/W,W+/N,,,R/B")
      DO WHILE .T.
         TabUpdate( hScrollBar, nEl, LEN(PopFile) , .T.)
         CurItem := ACHOICE(nTop+1,nLeft+1,nBottom-1,nRight-1,PopFile,,"cUtil",nEl,nRel)
         nInit  := CurItem
         nEl    := CurItem

         IF LastKey() == ASC("0")  //K_ESC
            SETCOLOR(OldClr)
            RestScreen(0, 0, 24, 79, OldScr)
            CLOSE ALL
            lGRcpt:=.F.
            UseFile()
            RETURN
         ENDIF
         IF LastKey() <> ASC("7") .AND.  LastKey() <> ASC("1")
            EXIT
         ENDIF
      ENDDO

      FOR i=1 TO LEN(PopFile)
          IF SubStr(PopFile[i], 3, 1) == "û"
             AADD(aDbf,aDbfList[i])
          ENDIF
      NEXT

      IF Len(aDbf) > 0
         TONE(1000,3)
         cPil:="1"
         @ 24,00 SAY " Pilihan [1] Layar atau [2] Printer .. ?                                         " COLOR "N/W"
         @ 24,10 SAY "1"                  COLOR "W+*/W"
         @ 24,25 SAY "2"                  COLOR "W+*/W"
         @ 24,41 GET cPil Valid cPil$"12" COLOR "W+*/W"
         READ
         @ 24,0  SAY "  Proses .......  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
         @ 24,19 SAY "*"                  COLOR "N*/W"
         cSTPRG:=''
         IF lGlan
            Do Case
               Case Asoy == 1
                    PGroup28(aDbf,'<Read>',.F.,cPil)
               Case Asoy == 2
                    RPDept28(aDbf,'<Read>',.F.,cPil)
               Case Asoy == 3
                    nPAGE=0
                    FOR nFP:=1 TO LEN(aDbf)
                        F_Print18({aDbf[nFP]},'<Read>',cPil,nPAGE+=1)
                    NEXT nFP
               Case Asoy == 4
                    FOR nFP:=1 TO LEN(aDbf)
                       C_Print18({aDbf[nFP]},'<Read>',cPIL)
                    NEXT nFP
               Case Asoy == 19
                    FOR nFP:=1 TO LEN(aDbf)
                       S_Print18({aDbf[nFP]},'<Read>',cPIL)
                    NEXT nFP
               Case Asoy == 5
                    H_18(aDbf,'<Read>',.F.,cPil)
               Case Asoy == 12
                    RPLU1(aDbf,'<Read>',.F.,cPil)
               Case Asoy == 13
                    RCAP28(aDbf,'<Read>',.F.,cPil)
               Case Asoy == 15
                    R_PO28(aDbf,'<Read>',.F.,cPil)
               Case Asoy == 6
                    PGROUP28(aDbf,'<Reset>',.T.,cPIL)
               Case Asoy == 7
                    RpDept28(aDbf,'<Reset>',.T.,cPIL)
               Case Asoy == 8
                    nPAGE=0
                    FOR nFP:=1 TO LEN(aDbf)
                        F_Print18({aDbf[nFP]},'<Reset>',cPIL,nPAGE+=1)
                    NEXT nFP
               Case Asoy == 9
                    FOR nFP:=1 TO LEN(aDbf)
                       C_Print18({aDbf[nFP]},'<Reset>',cPIL)
                    NEXT nFP
               Case Asoy == 20
                    FOR nFP:=1 TO LEN(aDbf)
                       S_Print18({aDbf[nFP]},'<Reset>',cPIL)
                    NEXT nFP
               Case Asoy ==10
                    H_18(aDbf,'<Reset>',.T.,cPIL)
               Case Asoy == 11
                    RPSKU28(aDbf,'<Reset>',.F.,cPIL)
               Case Asoy == 14
                    RCAP28(aDbf,'<Reset>',.F.,cPil)
               Case Asoy == 16
                    R_PO28(aDbf,'<Reset>',.F.,cPil)
            Endcase
         ELSE
            DO CASE
               CASE Asoy == 6
                    PGROUP18(aDbf,'<Reset>',.F.,cPil)
               CASE Asoy == 7
                    PDEPT18(aDbf,'<Reset>',.F.,cPil)
               CASE Asoy == 8
                    nPAGE=0
                    F_Print18(aDbf,'<Reset>',cPIL,nPAGE+=1)
               CASE Asoy == 9
                   C_Print18(aDbf,'<Reset>',cPIL)
               CASE Asoy == 20
                   S_Print18(aDbf,'<Reset>',cPIL)
               CASE Asoy == 10
                    H_18(aDbf,'<Reset>',.T.,cPIL)
               CASE Asoy == 11
                    RPSKU28(aDbf,'<Reset>',.F.,cPIL)     // CETAK KE PRINTER BESAR
               Case Asoy == 14
                    RCAP28(aDbf,'<Reset>',.F.,cPil)
               Case Asoy == 16
                    R_PO28(aDbf,'<Reset>',.F.,cPil)
            ENDCASE
         ENDIF
        *WARNING(' Selesai ... ! ')
      ENDIF
   ELSE
      IF ASCAN({1,2,3,4,5,12,13,15,19},Asoy) > 0 .AND. FILE(DDATA+(SATELITE->CPNO+".DBF"))
         TONE(1000,3)
         cPil:="1"
         @ 24,00 SAY " Pilihan [1] Layar atau [2] Printer .. ?                                         " COLOR "N/W"
         @ 24,10 SAY "1"                  COLOR "W+*/W"
         @ 24,25 SAY "2"                  COLOR "W+*/W"
         @ 24,41 GET cPil Valid cPil$"12" COLOR "W+*/W"
         READ
         @ 24,0  SAY "  Proses .......  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
         @ 24,19 SAY "*"                  COLOR "N*/W"

         cSTPRG:=''
         DO CASE
            CASE Asoy == 1
                 PGROUP18({DDATA+SATELITE->CPNO+".DBF"},'<Read>',.F.,cPIL)   // .t.)
            CASE Asoy == 2
                 PDEPT18({DDATA+SATELITE->CPNO+".DBF"},'<Read>',.F.,cPIL)    // .t.)
            CASE Asoy == 3
                 nPAGE=0
                 F_Print18({DDATA+SATELITE->CPNO+".DBF"},'<Read>',cPIL,nPAGE+=1)
            CASE Asoy == 4
                 C_Print18({DDATA+SATELITE->CPNO+".DBF"},'<Read>',cPIL)
            CASE Asoy == 19
                 S_Print18({DDATA+SATELITE->CPNO+".DBF"},'<Read>',cPIL)
            CASE Asoy == 5
                 H_18({DDATA+SATELITE->CPNO+".DBF"},'<Read>',.F.,cPIL)
            CASE Asoy == 12
                 PPLUK18({DDATA+SATELITE->CPNO+".DBF"},'<Read>',.F.,cPIL)    // .t.)
            CASE Asoy == 13
                 RCAP28({DDATA+SATELITE->CPNO+".DBF"},'<Read>',.F.,cPIL)    // .t.)
            CASE Asoy == 15
                 R_PO28({DDATA+SATELITE->CPNO+".DBF"},'<Read>',.F.,cPIL)    // .t.)
         ENDCASE
        *WARNING(' Selesai ... ! ')
      ELSE
         WARNING(' File Tidak Ketemu ... ! ')
      ENDIF
   ENDIF
   EXIT
ENDDO
UseFile()
IF FILE(DDATA+"$*.*")
   aDelFl:=Directory(DDATA+'$*.*')
   AEval(aDelFl,{|a|FErase(DDATA+a[1])})
ENDIF
RestScreen(0, 0, 24, 79, OldScr)
SETCOLOR(OldClr)
cSTPRG:=cPR
lGRcpt:=.F.
RETURN

