#include  "KASSA.CH"
#include  "INKEY.CH"
#include  "ACHOICE.CH"

*------------------------------------------------------------------------------*
PROCEDURE MENU1(Asoy,cTitle)
*------------------------------------------------------------------------------*
LOCAL OldClr := SETCOLOR(), OldScr
LOCAL aDbfList:={}, aDbf:={}, LastItem, i, CurItem, zKey,aDelFl
LOCAL nTop, nLeft, nBottom, nRight, dTgl:=CTOD(' /  /  ')
LOCAL nEl, nRel, nInit,nLenPop:= 0, cDir, nFP:=0
PRIVA PopFile := {}, hScrollBar

OldScr := SaveScreen(0, 0, 24, 79)
USEFILE()

IF Asoy == NIL
   CLOSE ALL
   UseFile()
   RETURN
ENDIF

DO WHILE .T.
   IF lGlan .OR. (!lGlAN .AND. (ASCAN({6,7,8,9,10,11,13,20},Asoy) > 0) )
      IF ASCAN({1,2,3,4,5,12,19},Asoy) > 0
         cDir := NDLL
      ELSE
         IF(lGlan, cDir := NEOD, cDir := DEOD)
      ENDIF

      IF EMPTY(aDbfList := GetDbf(cDir))
         WARNING(' File Tidak Ketemu ... ! ')
         CLOSE ALL
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
                      //nLenPop := 33  //AMaxLen(PopFile ) + 1
      nRight   := nLeft + nLenPop
      nEl      := 1
      nRel     := 1

      Box(nTop-1, nLeft-2, nBottom, nRight+1,'w+/w')
      @ nTop-1, nLeft say IIF(cTitle == NIL ,"Title",'Pilih Terminal '+cTitle) color "N/W"
      @ nTop,nLeft-1 SAY REPLICATE("þ",nLenPop+2) COLOR "W+/W"

      hScrollBar := TabNew( nTop+1, nLeft-1, nBottom-1, "W+/N", 1 )
      TabDisplay( hScrollBar )
      @ 24,0 SAY " <8:Up 2:Dn 9:PgUp 3:PgDn>  [5]-Slc [1]-SlcAll [7]-UnSlcAll [.]-Print [0]-Exit  " COLOR "w/n"

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
         @ 24,0  SAY "  Proses .......  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
         @ 24,19 SAY "*" COLOR "N*/W"
         DO WHILE !PrintReady() .AND. Asoy<>11
            Warning(' Printer Error ... !!  [0] Batal ')
            IF LASTKEY() == ASC("0")
               CLOSE ALL
               RestScreen(0, 0, 24, 79, OldScr)
               SETCOLOR(OldClr)
               UseFile()
               RETURN
            ENDIF
         ENDDO
         IF lGlan

            Do Case
               Case Asoy == 1
                    RpGrp2(aDbf,'<Read>',.F.)
               Case Asoy == 2
                    RpDept2(aDbf,'<Read>',.F.)
               Case Asoy == 3
   // UMUM
                    FOR nFP:=1 TO LEN(aDbf)
                        F_Print({aDbf[nFP]},'<Read>')
                    NEXT
               Case Asoy == 4
                    C_Print(aDbf,'<Read>')
               Case Asoy == 19
                    S_Print1(aDbf,'<Read>')
               Case Asoy == 5
                    H_Print(aDbf,'<Read>')
               Case Asoy == 6
                    RpGrp2(aDbf,'<Reset>')
               Case Asoy == 7
                    RpDept2(aDbf,'<Reset>')
               Case Asoy == 8
                    FOR nFP:=1 TO LEN(aDbf)
                        F_Print({aDbf[nFP]},'<Reset>')
                        F_TXT({aDbf[nFP]})
                    NEXT nFP
               Case Asoy == 9
                    FOR nFP:=1 TO LEN(aDbf)
                       C_Print({aDbf[nFP]},'<Reset>')
                       C_TXT({aDbf[nFP]})
                    NEXT nFP
               Case Asoy == 20
                    FOR nFP:=1 TO LEN(aDbf)
                       S_Print1({aDbf[nFP]},'<Reset>')
                       S_TXT({aDbf[nFP]})
                    NEXT nFP
               Case Asoy ==10
                    H_Print(aDbf,'<Reset>',.T.)
               Case Asoy == 11
                    FOR nFP:=1 TO LEN(aDbf)
                        RPSKU({aDbf[nFP]})    &&___BENTUK SKUTXT GAB ON LINE
                    NEXT nFP
               Case Asoy == 12                &&___Cetak ke printer
                    RPPLUC2(aDbf,'<Read>')
               Case Asoy == 13                &&___Cetak ke printer
                    RPPLUC2(aDbf,'<Reset>')
            Endc
         ELSE

            DO CASE
               CASE Asoy == 6
                    RpGrp1(aDbf,'<Reset>')
               CASE Asoy == 7
                    RpDept1(aDbf,'<Reset>')
               CASE Asoy == 8
                    F_Print(aDbf,'<Reset>')
                    F_TXT(aDbf)
               CASE Asoy == 9
                    C_Print(aDbf,'<Reset>')
                    C_TXT(aDbf)
               CASE Asoy == 20
                    S_Print1(aDbf,'<Reset>')
                    S_TXT(aDbf)
               CASE Asoy == 10
                    H_Print(aDbf,'<Reset>',.T.)
               CASE Asoy == 11
                    RPSKU(aDbf)                   // BENTUK TXT MESIN TSB OFF LINE
               CASE Asoy == 13
                    RPPLUC1(aDbf,'<Reset>')
            ENDCASE
         ENDIF
        *WARNING(' Selesai ... ! ')
      ENDIF

   ELSE
      IF ASCAN({1,2,3,4,5,12,19},Asoy) > 0 .AND. FILE(DDATA+(SATELITE->CPNO+".DBF"))
         TONE(1000,3)
         @ 24,0  SAY "  Proses .......  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
         @ 24,19 SAY "*" COLOR "N*/W"
         DO WHILE !PrintReady()
            Warning(' Printer Error ... !!  [0] Batal ')
            IF LASTKEY() == ASC("0")
               CLOSE ALL
               RestScreen(0, 0, 24, 79, OldScr)
               SETCOLOR(OldClr)
               UseFile()
               RETURN
            ENDIF
         ENDDO
         DO CASE
            CASE Asoy == 1
                 RpGrp1({DDATA+SATELITE->CPNO+".DBF"},'<Read>',.f.)
            CASE Asoy == 2
                 RpDept1({DDATA+SATELITE->CPNO+".DBF"},'<Read>',.f.)
            CASE Asoy == 3
                 F_Print({DDATA+SATELITE->CPNO+".DBF"},'<Read>')
            CASE Asoy == 4
                 C_Print({DDATA+SATELITE->CPNO+".DBF"},'<Read>')
            CASE Asoy == 19
                 S_Print1({DDATA+SATELITE->CPNO+".DBF"},'<Read>')
            CASE Asoy == 5
                 H_Print({DDATA+SATELITE->CPNO+".DBF"},'<Read>')
            CASE Asoy == 12
                 RpPLU1({DDATA+SATELITE->CPNO+".DBF"},'<Read>',.f.)
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
RETURN


*------------------------------------------------------------------------------*
FUNCTION cUtil( nStatus, nElement, nRelative )
*------------------------------------------------------------------------------*
LOCAL nReturnValue := AC_CONT    // Set the default handler to continue
LOCAL nEl  := nElement
LOCAL nRel := nRelative,I
DO CASE
   CASE nStatus == AC_IDLE
        TabUpdate( hScrollBar, nElement, LEN( PopFile ) )
   CASE nStatus == AC_HITTOP
        //KEYBOARD CHR( K_CTRL_PGDN )
        TONE(2000,1)
        nReturnValue := AC_CONT
   CASE nStatus == AC_HITBOTTOM
        //KEYBOARD CHR( K_CTRL_PGUP )
        TONE(2000,1)
        nReturnValue := AC_CONT
   CASE nStatus == AC_EXCEPT
        nReturnValue := AC_CONT
        DO CASE
           CASE LASTKEY() == ASC("0")  //K_ESC
                //KEYBOARD CHR( K_ESC )
                nReturnValue := AC_ABORT
           CASE LASTKEY() == ASC(".")  //K_F10
                nReturnValue := AC_SELECT
           CASE LASTKEY() == ASC("7")  //K_HOME
                FOR i=1 TO LEN(PopFile)
                    PopFile[i] := Stuff(PopFile[i], 3, 1, " ")
                NEXT
                nReturnValue := AC_ABORT

           CASE LASTKEY() == ASC("1")  //K_END
                i:=nEl
                FOR nX=1 TO LEN(PopFile)
 		    nI:=AScan(PopFile,{|c|SubStr(c,3,1) == "û"})
	  	    IF nI>0
                       cF:=POPFile[nI]
                       cD:=SUBSTR(cF,Rat("<",cF))
                       cF:=POPFile[i]
                       IF  SUBSTR(cF,Rat("<",cF))=cD
                           PopFile[i] := Stuff(PopFile[i], 3, 1, "û")
		       ENDIF
	            ELSE
                       PopFile[i] := Stuff(PopFile[i], 3, 1, "û")
		    ENDIF
		    i++
		    IF i>LEN(PopFile)
		       i:=1
		    ENDIF
                NEXT
                nReturnValue := AC_SELECT

           CASE LASTKEY() == ASC("9")  //K_PGUP
                KEYBOARD CHR( K_PGUP )
           CASE LASTKEY() == ASC("3")  //K_PGDN
                KEYBOARD CHR( K_PGDN )
           CASE LASTKEY() == ASC("8")  //K_UP
                KEYBOARD CHR( K_UP )
           CASE LASTKEY() == ASC("2")  //K_DOWN
                KEYBOARD CHR( K_DOWN )
           CASE LASTKEY() == ASC("4")  //K_LEFT
                KEYBOARD CHR( K_UP )
           CASE LASTKEY() == ASC("6")  //K_RIGHT
                KEYBOARD CHR( K_DOWN )
           CASE LASTKEY() == ASC("5")  //K_SPACE
                 nI:=AScan(PopFile,{|c|SubStr(c,3,1) == "û"})
		IF nI>0
                   cF:=POPFile[nI]
                   cD:=SUBSTR(cF,Rat("<",cF))
                   cF:=POPFile[nEl]
                   IF  SUBSTR(cF,Rat("<",cF))=cD
                       PopFile[nEl] := If(SubStr(PopFile[nEl], 3, 1) == " ", ;
                       Stuff(PopFile[nEl], 3, 1, "û"), ;
                       Stuff(PopFile[nEl], 3, 1, " "))
		   ENDIF
		ELSE
                   PopFile[nEl] := If(SubStr(PopFile[nEl], 3, 1) == " ", ;
                   Stuff(PopFile[nEl], 3, 1, "û"), ;
                   Stuff(PopFile[nEl], 3, 1, " "))
                ENDIF
        ENDCASE
ENDCASE
RETURN (nReturnValue)

*------------------------------------------------------------------------------*
FUNCTION GetDbf(cDir)
*------------------------------------------------------------------------------*
LOCAL aDbfList:={}, aDmy:= {}  //,cD:='',cCP:='',nRec,nLastRec

aDmy:=DIRECTORY(cDir+"CP??????.DBF")
AEVAL(aDmy,{|a| AADD(aDbfList,cDir+a[1])})
ASORT(aDbfList)
RETURN aDbfList

*------------------------------------------------------------------------------*
PROCEDURE Sbox(Top,Left,Bott,Right,Clr1,Clr2,cTitle,cExpl,nSound)
*------------------------------------------------------------------------------*
*> Making Box Shadow By E1
*> Minimum Parmeter Top,Left,Bott,Right --> only making shadow !
*> Parameter :
*> Top,Left,Bott,Right = Coordinat Box
*> Clr1,Clr2           = Color Box , Color Title <if not NIL>
*> cTitle              = Title <if not NIL>
*> cExpl               = Explode <if not NIL>
*> nSound              = Sound <if not NIL>
LOCAL v,h,i
**>save part of screen for shadow
v= savescreen(Top+1,Right+1,Bott+1,Right+2)
h= savescreen(Bott+1,Left+2,Bott+1,Right+2)
**>change color for shadow / making shadow
for i = 2 to len(h) step 2
    h = stuff(h,i,1,chr(7))
next
for i= 2 to len(v) step 2
    v = stuff(v,i,1,chr(7))
next

if !(clr1 == NIL)  // Making Box is Valid <not NIL>
  setcolor(clr1)
  if cExpl == NIL
    @ Top+1,Left clea to Bott,Right
    //@ Top+1,Left to Bott,Right
  else
    for i=1 to (int((Right-Left)/2)-1)
     @ Top,Left+n-i clear to Bott,Left+n+i
    next
  endif
  if !(cTitle == NIL)
    iif (!(clr2 == NIL),setcolor(clr2),setcolor(clr1))
    @ Top,Left clea to Top,Right
    @ Top,(int((Right-Left-len(cTitle))/2)+Left)  say cTitle
  else
    iif (!(clr2 == NIL),setcolor(clr2),setcolor(clr1))
    @ Top,Left clea to Top,Right
  endif
endif

**>display shadow
restscreen(Top+1,Right+1,Bott+1,Right+2,v)
restscreen(Bott+1,Left+2,Bott+1,Right+2,h)
if !(nSound == NIL)
  do case
    case nSound = 1
    case nSound = 2
    otherwise
      tone(200,1)
  endcase
endif
return

