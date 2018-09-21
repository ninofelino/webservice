#include "hmg.ch"
#include 'set.ch'
#include 'inkey.ch'
#include "Getexit.ch"

*-----------------------------------------------------------------------------
FUNCTION ReadMcr(nB,nK,cFLAG)
LOCAL nKey,nD:=0 ,cKey:=''
LOCAL aMc:={}
LOCAL GETLIST:={},aKey:=;
{{K_END,       {|o,a|o:end()         }};
,{K_HOME,      {|o,a|o:home()        }};
,{K_LEFT,      {|o,a|o:left()        }};
,{K_RIGHT,     {|o,a|o:right()       }};
,{K_CTRL_LEFT, {|o,a|o:wordLeft()    }};
,{K_CTRL_RIGHT,{|o,a|o:wordRight()   }};
,{K_DEL,       {|o,a|o:delete()      }};
,{K_CTRL_Y,    {|o,a|o:delEnd()      }};
,{K_CTRL_BS,   {|o,a|o:delWordLeft() }};
,{K_CTRL_T,    {|o,a|o:delWordRight()}};
,{K_BS,        {|o,a|If(o:TypeOut,o:delete(),o:backSpace())}};
,{K_INS,       {|o,a|SET(_SET_INSERT,!SET( _SET_INSERT ) )}}}
@ nB,nK GET nD PICT '9999999999999999' COLOR '/w,/w,,,/w'
GETLIST[1]:SetFocus()
DO WHILE .T.
   nD:=0
   cD:=''
   cKey:=''
   C_R_On()
   GETLIST[1]:Reset()
   DO WHILE nKey#13 .AND. nKey#27
      nKey:=0
      nKey:=Inkey(0) &&GetChar()
      cKey:=cKey+Chr(nKey)
      Get(GETLIST) //,nKey,aKey)
   ENDDO
   nD:=GETLIST[1]:UnTransform()
   IF SubS(cKey,3,1)='n'                    // normal case 4.16 EYA03107
      nKey:=Val(SubS(cKey,4,3))
      DO CASE
      CASE cFLAG='T01' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T02' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T03' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T04' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T05' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T06' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T07' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T08' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T09' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T10' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T11' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T12' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T13' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      CASE cFLAG='T14' ;IF(SubSt(cKey,07,1)='B',cKey:=SubS(cKey,08,16),cKey:=SubS(cKey,07,16))
      ENDCASE
      EXIT
   ELSEIF SubSt(cKey,5,1)='n'                     // BCA Cash
      cKey:=SubS(cKey,09,16)
      EXIT
   ELSEIF SubSt(cKey,1,1)='g'                     // BCA Cash
      cKey:=SubS(cKey,08,16)
      EXIT
   ELSEIF nD#0                                    // Utk Manual
      cKey:=Str(nD,16)
      EXIT
   ELSEIF nD=0                                    // Boleh Tidak Diisi->Customer
      cKey:=Str(nD,16)
      EXIT
   ELSE;Wrong('Input Card Salah...., Tekan CLEAR, Lalu Slot Kembali atau Entry Manual')
      nKey:=0
   ENDIF
ENDDO
KEYBOARD Replicate(' ',16)
DO WHILE Inkey(.1)#0
ENDDO
C_R_Off()
RETURN cKey

*-----------------------------------------------------------------------------
FUNCTION Get(aGet,n,a)
LOCAL nD,cChr,l:=.T.
LOCAL o:=aGet[1]
DO CASE
CASE (nD:=AScan(a,{|a|a[1]=n}))#0
   a[nD][2]:eval(o,aGet)
CASE (n>=32 .AND. n<=255)  ;cChr:=Chr(n)
   IF o:type=="N" .AND. (cChr=="." .OR. cChr==",")
      o:toDecPos()
   ELSE
      IF Set( _SET_INSERT )
	 o:insert( cChr )
      ELSE
         o:overstrike( cChr )
      ENDIF
      IF o:typeOut
	 IF Set( _SET_BELL )
            ??Chr(7)
	 ENDIF
      ENDIF
   ENDIF
OTHERWISE
   l:=.F.
ENDCASE
RETURN l

*-----------------------------------------------------------------------------

