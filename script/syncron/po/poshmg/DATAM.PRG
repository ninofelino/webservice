#include "hmg.ch"
#include 'inkey.ch'
#include 'kassa.ch'
*-----------------------------------------------------------------------------
PROCEDURE DataM()
LOCAL nI:=0,cD:='',cTXT,aTXT,aa
LOCAL nT:=3,nL:=15,nB:=18,nR:=64,oC
LOCAL oB:=TBrowseNew(nT+1,nL+1,nB-2,nR-1)
LOCAL aFOR:={'HOU','DPT','FIN','CAS','CLS','SKU'}
*----------------------------------------
LOCAL cS:=SaveScreen(0,0,24,79)
LOCAL cM:='',aD,b
LOCAL nD:=0
LOCAL nK:=0
LOCAL aX[4]
LOCAL aR
LOCAL nIdx,nTot
*------------------------
cTXT:=If(lGLan,NTXT,DTXT)
WOGrow(nT,nL,nB,nR,'/bg',.01)
@ nT,nL+2 SAY '[ ]' COLOR '/bg'
*------------------------------
aD:=Directory(cTXT+'*.*')
IF Empty(aD)
   RETURN
ENDIF
APro(aD)
nIdx:=1
nTot:=Len(aD)
oB:ColSep:='Ё'
oB:HeadSep:='ям'
oB:AutoLite:=.f.
oB:GoTopBlock:={||nIdx:=1}
oB:GoBottomBlock:={||nIdx:=nTot}
oB:ColorSpec:='/bg,w+/b,gr+/w,b/bg,w/r,/g'
oB:SkipBlock:={|n|TASkip(n,@nIdx,nTot,aD,@aR)}
*---------------------------------------------
oC:=TBColumnNew('No.',{||Str(nIdx,3)})
oC:FootSep:='ад';oB:AddColumn(oC)
*--------------------------------------------------
oC:=TBColumnNew(' File Data M.I.S. ',{||NMFile(aD,nIdx)})
oC:FootSep:='ад';oB:AddColumn(oC)
*-----------------------------------------------------------------------
b:={||If(aD[nIdx][5]='D','   <DIR>  ' ,If(aD[nIdx][5]='V','   <VOL>  ',;
TransForm(aD[nIdx][2],'99,999,999')))};oC:=TBColumnNew('  Besarnya',b)
oC:FootSep:='ад';oB:AddColumn(oC)
*--------------------------------
FOR nI:=1 TO oB:ColCount
    oC:=oB:GetColumn(nI)
    oC:ColorBlock:={||aR}
NEXT
@ MAXROW(),0 SAY " <8:Up 2:Dn 9:PgUp 3:PgDn>  [5]-Slc [1]-SlcAll [7]-UnSlcAll [.]-Copy [0]-Exit   " COLOR "N/W"
DO While nK#Asc('0') ;cM:=Muter(cM)
   @ oB:nTop-1,oB:nLeft+2 SAY cM COLOR '/bg'
   IF oB:Stabilize()
      nK:=Light(oB,nIdx,@aR)
      ELSEIF (nK:=InKey())=0
      LOOP
   ENDIF
   If (b:=SetKey(nK))<>NIL                          // check for SET KEY first
      Eval(b,ProcName(),ProcLine(),ReadVar())
      LOOP
   End
   DO CASE
   CASE TKey(oB,nK)
   CASE nK=Asc('8') ;oB:Up()
   CASE nK=Asc('2') ;oB:Down()
   CASE nK=Asc('9') ;oB:PageUp()
   CASE nK=Asc('3') ;oB:PageDown()
   CASE nK=Asc('5') .AND. 'A'=aD[nIdx][5]
      cD:=aD[nIdx][6];oB:RefreshCurrent()
      aD[nIdx][6]:=If(cD#'Ш','Ш',' ')
   CASE nK=Asc('1')                                        //  ;oB:RefreshAll()
      AEval(aD,{|a|a[6]:=If(a[6]#'Ш','Ш',' ')})
      cTgl:=SubST(aD[nIdx][1],4,4)                         //  13/2/96 kur Sir0136
      FOR nI:=1 TO Len(aD)                                 //  13/2/96 kur Sir0136
         IF aD[nI][6]='Ш'.AND. Subst(aD[nI][1],4,4)=cTgl   //  13/2/96 kur Sir0136
             aD[nI][6]='Ш'                                 //  13/2/96 kur Sir0136
         ELSE                                              //  13/2/96 kur Sir0136
             aD[nI][6]=' '                                 //  13/2/96 kur Sir0136
         ENDIF                                             //  13/2/96 kur Sir0136
      NEXT                                                 //  13/2/96 kur Sir0136
      oB:RefreshAll()                                      //  13/2/96 kur Sir0136
   CASE nK=Asc('7') ;oB:RefreshAll()
      AEval(aD,{|a|a[6]:=' '})
   CASE nK=Asc('.')
      FOR nI:=1 TO Len(aD)
          IF aD[nI][6]='Ш'.AND.ChkDrv(aD[nI][2])
             FILECOPY(cTXT+aD[nI][1],"A:\"+aD[nI][1])
          ENDIF
      NEXT
      EXIT
   ENDCASE
ENDDO
RestScreen(0,0,24,79,cS)
RETURN

*-----------------------
Static Function APro(aD)
AEval(aD,{|a|AAdd(a,' ')})
ASort(aD,,,{|x,y|SubS(x[1],4,4)>SubS(y[1],4,4)})
RETURN aD
*----------------------------
STATIC Function NMFile(aD,nI)
LOCAL cD:=aD[nI][1],nD
nD:=At('.',cD)
DO CASE
CASE cD='FIN' ;cX:='Financial'
CASE cD='CAS' ;cX:='Cashier  '
CASE cD='HOU' ;cX:='Hourly   '
CASE cD='CLS' ;cX:='Class    '
CASE cD='DPT' ;cX:='Dept     '
CASE cD='SKU' ;cX:='SKU      '
OTHERWISE ;RETURN  '?'+Space(20)
ENDCASE
IF !(nD>1 .AND. SubS(cD,nD)='.GAB')
   cX+=' Stl '+SubS(cD,nD+1,2);ELSE
   cX+=' Gabung'
ENDIF
cX+=' <'+SubS(cD,6,2)+'/'+SubS(cD,4,2)+'> '
RETURN ' ['+aD[nI][6]+'] '+cX
*--------------------------------
Static Function Light(oB,nIdx,aR)
LOCAL  aX[4],nK ;oB:Cargo:={Row(),Col(),nIdx,oB:RowPos}
aX[1]:=aX[3]:=oB:RowPos;aX[2]:=oB:LeftVisible - oB:Freeze
aX[4]:=oB:RightVisible ;oB:ColorRect(aX,{3,1})
aX[2]:=aX[4]:=oB:ColPos;oB:ColorRect(aX,{5,1});nK:=InKey(0)
oB:RefreshCurrent()    ;oB:Stabilize()
RETURN nK
*------------------------------------
Static Function TASkip(n,nS,nT,aD,aR)
LOCAL  nOld:=nS;nS:=n+nS
DO CASE
CASE nS>nT ;nS:=nT ;RETURN nT-nOld
CASE nS<01 ;nS:=01 ;RETURN 01-nOld
ENDCASE
aR:=If(aD[nS][6]='Ш',{3,1},)
RETURN n
