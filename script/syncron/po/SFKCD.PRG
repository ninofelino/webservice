#include 'kassa.ch'
*-----------------------------------------------------------------------------
PROCEDURE SFKCD(lLan)
LOCAL oTbr,oTbc,cD,nD
LOCAL nT,nI,nKey:=0,cS
aKey:=DefKey(lLan) ;nT:=Len(aKey)
IF Empty(aKey)
   RETURN
ENDIF
SAVE SCREEN TO cS
CLEAR ;GO TOP
SET SCOR  OFF
SET CONF  ON
@ 0,38 CLEAR TO 24,79
//@ 0,38,24,58 BOX 'º ººº ºº '
//@ 0,59,24,79 BOX 'º ººº ºº '
FOR nI:=1 TO 75
    GO nI
    IF nI>0 .AND. nI<26
       @ nI-01, 30 SAY Trans(nI,'99. ')+INTERN
    ELSEIF nI>25 .AND. nI<51
       @ nI-26, 47 SAY Trans(nI,'99. ')+INTERN
    ELSEIF nI>50 .AND. nI<76
       @ nI-51, 63 SAY Trans(nI,'99. ')+INTERN
    ENDIF
NEXT
Box(0,0,24,28,'w+/n')
@ 21,1 SAY '[0]-->EXIT                 '  COLOR 'W+'
@ 22,1 SAY '[2]-->FUNGSI TENDER KUPON  '  COLOR 'W+'
@ 23,1 SAY '[3]-->GANTI NAMA DI STRUK  '  COLOR 'W+'
oTbr:=TBrowseDb(1,1,20,27) ;oTbr:HeadSep:='ÂÄ' ;oTbr:ColSep:='³'
oTbc:=TBColumnNew('ASCII',{||ASCNM}) ;oTbc:FootSep:='ÁÄ' ;oTbr:AddColumn(oTbc)
oTbc:=TBColumnNew('KODE' ,{||Kode()});oTbc:FootSep:='ÁÄ' ;oTbr:AddColumn(oTbc)
oTbc:=TBColumnNew('KET'  ,{||ASGNNM});oTbc:FootSep:='ÁÄ' ;oTbr:AddColumn(oTbc)
GO TOP
DO WHILE .T.
   DO WHILE !oTbr:Stabilize()
   ENDDO
   nI:=ASSIGN
   nRec:=RecNo()
   IF nI>0 .AND. nI<76
      GO nI
      IF nI>0 .AND. nI<26
         @ nI-01, 30 SAY Trans(nI,'99. ')+INTERN  COLOR '/w*'
      ELSEIF nI>25 .AND. nI<51
         @ nI-26, 47 SAY Trans(nI,'99. ')+INTERN  COLOR '/w*'
      ELSEIF nI>50 .AND. nI<76
         @ nI-51, 63 SAY Trans(nI,'99. ')+INTERN  COLOR '/w*'
      ENDIF
   ENDIF
   nKey:=InKey(0)
   IF nI>0 .AND. nI<76
      IF nI>0 .AND. nI<26
         @ nI-01, 30 SAY Trans(nI,'99. ')+INTERN
      ELSEIF nI>25 .AND. nI<51
         @ nI-26, 47 SAY Trans(nI,'99. ')+INTERN
      ELSEIF nI>50 .AND. nI<76
         @ nI-51, 63 SAY Trans(nI,'99. ')+INTERN
      ENDIF
   ENDIF
   LOCATE FOR nKey=ASCII
   nD:=RecNo();GO nRec
   DO CASE
/*************
   CASE nKey=46  &&_______________________________________________________='.'
      IF !(ASSIGN>0 .AND. ASSIGN<76)
         FIELD->KEYL:=''
         FIELD->VLDS:=.f.
         FIELD->ASSIGN:=0
         FIELD->ASGNNM:=''
      ENDIF
      nD:=ASSIGN
      oTbr:RefreshCurrent();oTbr:Stabilize()
      oTbr:End()  ;oTbr:Stabilize()
      @ Row(),Col() GET nD PICT '99' 
      oTbr:Left() ;oTbr:Stabilize()
      @ Row(),Col() SAY Kode() 
      READ
      IF nD>0 .AND. nD<76
         GO nD;cD:=INTERN
         GO nRec
         FIELD->ASSIGN:=nD
         FIELD->ASGNNM:=cD
      ENDIF
**************************/
   CASE nKey=48  &&_______________________________________________________='0'
      EXIT
   CASE nKey=50 .AND. ASSIGN>14 .AND. ASSIGN<29  &&_______________________='2'
      FIELD->DCR:=!DCR
   CASE nKey=55 .AND. ((ASSIGN>0 .AND. ASSIGN<47) .OR. ;   &&_____________________ChgMsg
      (ASSIGN>48 .AND. ASSIGN<51))
      cD:=ASGNNM
      oTbr:End();oTbr:Stabilize()
      @ Row(),Col() GET cD PICT '@!'
      READ
      IF !Empty(cD)
	 FIELD->ASGNNM:=cD
      ENDIF
   CASE nD<=nT
      DO WHILE nKey#ASCII
	 IF RecNo()<=nD
	    oTbr:Down()
	 ELSE;oTbr:Up()
	 ENDIF
	 oTbr:Stabilize()
      ENDDO
   ENDCASE
   oTbr:home()
   oTbr:RefreshCurrent()
ENDDO
USE
REST SCREEN FROM cS
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION Kode(nD)
LOCAL cD
IF nD =NIL
   nD:=ASSIGN
ENDIF
DO CASE
CASE  nD>0  ;
.AND. nD<76 ;cD:='.'
CASE  nD=-1 ;cD:='1'
CASE  nD=-2 ;cD:='2'
CASE  nD=-3 ;cD:='3'
CASE  nD=-4 ;cD:='4'
CASE  nD=-3 ;cD:='5'
CASE  nD=-4 ;cD:='6'
OTHERWISE   ;cD:='?'
ENDCASE
RETURN '['+cD+']'+KEYL+If(VLDS,'V',' ')+If(DCR,'K',' ')

