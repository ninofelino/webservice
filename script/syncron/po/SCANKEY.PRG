#include "kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION ScanKey(c,n,a)
LOCAL nCntr:=0,nKey:=0,cD:='',c1:='',c2:='',cD1,cD2,cD3
LOCAL nR:=Seconds()%100, lCom1:=.F. ,lCom2:=.F.,nColor:=0
LOCAL cPE:=' Printer Error.Printer Error.Printer Error.Printer '
LOCAL aCol:={'B+','G+','BG+','R+','BR+','GR+','W+'}
LOCAL nRX:=VAL(Substr(SATELITE->CPNO,3,2))

PROMOSI->(DBGoto(nRx))
cd1     :=PROMOSI->LINE1
cd2     :=PROMOSI->LINE2
cd3     :=PROMOSI->LINE1+' '+PROMOSI->LINE2
cSPE    :=SaveScreen(11,01,13,78)
lBarCode:=.F.

//IF nPortDrw#3 .AND. nPortDsp#1 .AND. nPortPrn#2
//   Com_Open(1)  ;Com_Init(1,nBaud,"N",8,1) ;Com_Dtr(1,.T.) ;lCom1:=.T.
//ENDIF
//IF nPortDrw#4 .AND. nPortDsp#2 .AND. nPortPrn#3
//   Com_Open(2)  ;Com_Init(2,nBaud,"N",8,1) ;Com_Dtr(2,.T.) ;lCom2:=.T.
//ENDIF
//IF nTipeDsp#8
//   Com_Open(nPortDsp)  ;Com_Init(nPortDsp,09600,'O',8,1) ;Com_Dtr(nPortDsp,.T.)
//ENDIF

DO WHILE .T.
   KSetNum(.T.)
   KSetCaps(.F.)
   IF lGLan
      DO CASE
      CASE !NNetLogged()       
         IF Select('DLL')#0    ;SELECT DLL     ;USE ;ENDIF
         IF Select('PRODUK')#0 ;SELECT PRODUK  ;USE ;ENDIF
	 lGLan:=.F.;LOOP
*     CASE DLL->WAKTU#Left(Time(),2) .AND. DLL->(RecLock())        ;TimeSend()
      CASE DLL->CMD='RQS' .AND. DLL->(RecLock())   ;nCntr:=DLL->NO ;cD:=DLL->FTYPE 
         DO CASE
         CASE cD='CAPTURE'  .OR. (cD='ALL' .AND. nCntr=5) ;cD:=(SATELITE->CPNO) //;SELECT CP
         CASE cD='TERMINAL' .OR. (cD='ALL' .AND. nCntr=4) ;cD:='TERMINAL'       //;SELECT SATELITE
         CASE cD='PROMOSI'  .OR. (cD='ALL' .AND. nCntr=3) ;cD:='PROMOSI'        //;SELECT PROMOSI
         CASE cD='CASHIER'  .OR. (cD='ALL' .AND. nCntr=2) ;cD:='CASHIER'        //;SELECT CASHIER
         CASE cD='TOMBOL'   .OR. (cD='ALL' .AND. nCntr=2) ;cD:='TOMBOL'         //;SELECT TOMBOL
         CASE cD='CLASS'    .OR. (cD='ALL' .AND. nCntr=1) ;cD:='CLASS'          //;SELECT CLASS
         CASE cD='ALL' .AND. nCntr=0
       	    DLL->CMD:='   '
            DLL->(DBUnlock())
            DLL->(DBCommit())
            LOOP
         OTHERWISE ;DLL->NO:=0
            DLL->CMD:='   '
            DLL->(DBUnlock())
            DLL->(DBCommit())
            LOOP
         ENDCASE
         DBCommitAll()
         USE (DDATA+cD) NEW ALIAS COPY
	 //---------------------------
	 IF cD='CP'
	    RCP->(DBCloseArea())
	 ENDIF
         COPY TO (NDLL+cD)
	 IF cD='CP'
            USE (NDLL+cD) NEW SHARED ALIAS RCP
	 ENDIF
	 //-----------------------------------
         SELECT COPY;USE
         SELECT TEMP
         DO CASE
         CASE DLL->FTYPE #'ALL';DLL->CMD:='   '
         OTHERWISE             ;DLL->NO -=1
         ENDCASE   
         DLL->(DBUnlock())
         DLL->(DBCommit())
      CASE DLL->CMD='SND' .AND. DLL->(RecLock())
         nCntr:=DLL->NO
         cD:=DLL->FTYPE 
         DBCommitAll()
         IF cD='TERMINAL' .OR. (cD='ALL' .AND. nCntr=4) ;cD:='TERMINAL'
            USE (NDATA+cD+'.DBF') NEW SHARED ALIAS ST
            SATELITE->CODE :=ST->CODE
            SATELITE->DESC :=ST->DESC
            SATELITE->ADD1 :=ST->ADD1
            SATELITE->ADD2 :=ST->ADD2
            SATELITE->TELP :=ST->TELP
            SATELITE->FACS :=ST->FACS
            SATELITE->COM1 :=ST->COM1
            SATELITE->COM2 :=ST->COM2
            SATELITE->COM3 :=ST->COM3
            SATELITE->COM4 :=ST->COM4
            SATELITE->COM5 :=ST->COM5
            SATELITE->FOOT :=ST->FOOT
            SATELITE->STO1 :=ST->STO1
            SATELITE->STO2 :=ST->STO2
            SATELITE->STO3 :=ST->STO3
            SATELITE->STO4 :=ST->STO4
            SATELITE->KEYM0:=ST->KEYM0
            SATELITE->KEYM1:=ST->KEYM1
            SATELITE->KEYM2:=ST->KEYM2
            SATELITE->KEYM3:=ST->KEYM3
            SATELITE->KEYM4:=ST->KEYM4
            SATELITE->KEYM5:=ST->KEYM5
            SATELITE->KEYM6:=ST->KEYM6
            SATELITE->KEYM7:=ST->KEYM7
            SATELITE->KEYM8:=ST->KEYM8
                                         //___U/ OPTION KUPON BARU
            SATELITE->CTK   :=ST->CTK
            SATELITE->KUPON :=ST->KUPON
            SATELITE->TGLKPN:=ST->TGLKPN
            SATELITE->TLR   :=ST->TLR
            ST->(DBCLOSEAREA())
         ELSE;DO CASE
            CASE cD='PROMOSI'  .OR. (cD='ALL' .AND. nCntr=3) ;cD:='PROMOSI'
               SELECT (cD) ;USE
               COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
               USE (DDATA+cD)  ALIAS (cD)
            CASE cD='CASHIER'  .OR. (cD='ALL' .AND. nCntr=3) ;cD:='CASHIER'
               SELECT (cD) ;USE
               COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
               USE (DDATA+cD)  ALIAS (cD)
               CASHIER->(__DBLocate({||CODE==cGLCd},,,,.f.))
            CASE cD='TOMBOL'   .OR. (cD='ALL' .AND. nCntr=2) ;cD:='TOMBOL'
               SELECT (cD) ;USE
               COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
               USE (DDATA+cD)  ALIAS (cD)  ;ResetKey(@a)
            CASE cD='CLASS'    .OR. (cD='ALL' .AND. nCntr=1) ;cD:='CLASS'
               SELECT (cD) ;USE
               COPY FILE (NDATA+cD+'.DBF') TO (DDATA+cD+'.DBF')
               USE (DDATA+cD)  ALIAS (cD)
               INDEX ON CODE TO (DDATA+'CLASS__1')
               INDEX ON Left(CODE,10) TO (DDATA+'CLASS__2')
               SET INDEX TO  (DDATA+'CLASS__1'),(DDATA+'CLASS__2')
            CASE cD='ALL' .AND. nCntr=0
               DLL->CMD:='   '
               DLL->(DBUnlock())
               DLL->(DBCommit())
               LOOP
            OTHERWISE ;DLL->NO:=0
               DLL->CMD:='   '
               DLL->(DBUnlock())
               DLL->(DBCommit())
               LOOP
            ENDCASE
         ENDIF
         DO CASE
         CASE DLL->FTYPE #'ALL';DLL->CMD:='   '
         OTHERWISE             ;DLL->NO -=1
         ENDCASE
         DLL->(DBUnlock())
         DLL->(DBCommit())
      ENDCASE
   ENDIF
   IF nCntr>350
      cD1:=SubS(cD1,2)+Left(cD1,1) 
      cD2:=Right(cD2,1)+Left(cD2,Len(cD2)-1)
      cD3:=SubS(cD3,2)+Left(cD3,1)
      c1:=Left(cD1,20) ;c2:=Left(cD2,20)
      IF nTipeDsp<3 ;CustDisp(c1,c2,.T.)
      ENDIF
      nColor:=IF(nColor=7,1,nColor+1)
      @ 26,01 SAY REPLI(' ',52)
      @ 26,02 SAY ' '+c1+'        '+c2 COLOR aCol[nColor]
   ELSE;nCntr++
   ENDIF
   IF cStPrg#'/NP' .AND. !PrintReady()
      Box(11,12,13,68,'r')
      @ 12,15 SAY cPE  COLOR 'w+*/r'
      Inkey(3)
      RestScreen(11,01,13,78,cSPE)
      nCntr:=101;InKey();LOOP
   ELSEIF (nKey:=InKey(.1))#0;EXIT
   ELSEIF lCom1 .OR. lCom2
      cD:=AllTrim(StrTran(cD,Chr(0),''))
      c=FilterNum(Left(cD,13))
      lBarCode:=.T.
      EXIT
   ENDIF
ENDDO
//IF nTipeDsp<3
//   Com_Send(nPortDsp,Chr(27)+'[2J')  &&_____Clear Customer Display
//   Com_Close(nPortDsp)
//ENDIF
//IF lCom1
//   Com_Close(1)
//ENDIF
//IF lCom2
//   Com_Close(2)
//ENDIF
RETURN nKey

*-----------------------------------------------------------------------------
Function FilterNum(cS)
LOCAL  nI,nT:=Len(cS),cD,cT:=''
FOR nI:=1 TO nT
    cD:=SubS(cS,nI,1)
    IF IsDigit(cD)
       cT+=cD
    ENDIF
NEXT
RETURN cT
*-----------------------------------------------------------------------------
Static Procedure TimeSend()
LOCAL cD:=SATELITE->CPNO
DBCommitAll()
USE (DDATA+cD) NEW ALIAS COPY
Copy To (NDLL+cD);SELECT COPY;USE
DLL->WAKTU:=Time()
DLL->(DBUNLOCK())
DLL->(DBCOMMIT())
SELECT TEMP
RETURN
*-----------------------------------------------------------------------------

