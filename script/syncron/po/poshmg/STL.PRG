#include "hmg.ch"
#Include 'kassa.ch'
#Include 'inkey.ch'

*-----------------------------------------------------------------------------
PROCEDURE Stl(lLan)
LOCAL cO:=SetColor()
IF Select('SATELITE')#0
   SELECT  SATELITE
   USE
ENDIF
IF !NetUse({{If(lLan,NDATA,DDATA)+'SATELITE',.f.}})
   RETURN
ENDIF
cCODE   :=SATELITE->CODE
cDESC   :=SATELITE->DESC
cADD1   :=SATELITE->ADD1
cADD2   :=SATELITE->ADD2
cTELP   :=SATELITE->TELP
cFACS   :=SATELITE->FACS
cSTO1   :=SATELITE->STO1
cSTO2   :=SATELITE->STO2
cSTO3   :=SATELITE->STO3
cSTO4   :=SATELITE->STO4
cCOM1   :=SATELITE->COM1
cCOM2   :=SATELITE->COM2
cCOM3   :=SATELITE->COM3
cCOM4   :=SATELITE->COM4
cCOM5   :=SATELITE->COM5
cFOOT   :=SATELITE->FOOT
cINF1   :=SATELITE->INF1
nT:=3
nL:=0  //__14
SetColor('n/bg,w+/n,,,n/bg')
*---------------------------
Box(nT,nL,nT+16,nL+79,'w+/bg')
@ nT   ,nL+2  SAY 'PARAMETER TERMINAL '  COLOR 'bg+/bg'
@ nT+01,nL+2  SAY ' Kode Persh. : [   ]'
@ nT+02,nL+2  SAY ' Nama Persh. : [                                        ]'
@ nT+03,nL+2  SAY ' Alamat      : [                         ]  [                         ]'
@ nT+04,nL+2  SAY ' No. Telp.   : [          ]      No. Faks. :[          ]'
@ nT+05,nL+2  SAY 'STORE MESSAGE'         COLOR 'bg+/bg'
@ nT+06,nL+2  SAY ' Store Msg. 1: [                                        ]'
@ nT+07,nL+2  SAY ' Store Msg. 2: [                                        ]'
@ nT+08,nL+2  SAY ' Store Msg. 3: [                                        ]'
@ nT+09,nL+2  SAY ' Store Msg. 4: [                                        ]'
@ nT+10,nL+2  SAY ' Commersial 1: [                                        ]'
@ nT+11,nL+2  SAY ' Commersial 2: [                                        ]'
@ nT+12,nL+2  SAY ' Foot Msg.  1: [                                        ] --> Aktif [ ]'
@ nT+13,nL+2  SAY ' Foot Msg.  2: [                                        ]'
@ nT+14,nL+2  SAY ' Foot Msg.  3: [                                        ]'
IF lINFAK
   @ nT+15,nL+2  SAY ' Infak Msg.  : [                                        ]'
ENDIF

@ nT+01,nL+18 GET cCODE     PICT '@!'
@ nT+02,nL+18 GET cDESC     PICT '@!'
@ nT+03,nL+18 GET cADD1     PICT '@!'
@ nT+03,nL+47 GET cADD2     PICT '@!'
@ nT+04,nL+18 GET cTELP     PICT '@!'
@ nT+04,nL+47 GET cFACS     PICT '@!'
@ nT+06,nL+18 GET cSTO1     PICT '@!'
@ nT+07,nL+18 GET cSTO2     PICT '@!'
@ nT+08,nL+18 GET cSTO3     PICT '@!'
@ nT+09,nL+18 GET cSTO4     PICT '@!'
@ nT+10,nL+18 GET cCOM1     PICT '@!'
@ nT+11,nL+18 GET cCOM2     PICT '@!'
@ nT+12,nL+18 GET cCOM3     PICT '@!'
@ nT+12,nL+71 GET cFOOT     PICT '!'    VALID cFoot='Y' .OR. cFoot='N'
@ nT+13,nL+18 GET cCOM4     PICT '@!'
@ nT+14,nL+18 GET cCOM5     PICT '@!'
IF lINFAK
   @ nT+15,nL+18 GET cINF1     PICT '@!'
ENDIF
READ
SetColor(cO)
IF LASTKEY()=K_ESC .OR. !RecLock()
   RETURN
ENDIF
SATELITE->CODE  :=cCODE
SATELITE->DESC  :=cDESC
SATELITE->ADD1  :=cADD1
SATELITE->ADD2  :=cADD2
SATELITE->TELP  :=cTELP
SATELITE->FACS  :=cFACS
SATELITE->STO1  :=cSTO1
SATELITE->STO2  :=cSTO2
SATELITE->STO3  :=cSTO3
SATELITE->STO4  :=cSTO4
SATELITE->COM1  :=cCOM1
SATELITE->COM2  :=cCOM2
SATELITE->COM3  :=cCOM3
SATELITE->COM4  :=cCOM4
SATELITE->COM5  :=cCOM5
SATELITE->FOOT  :=cFOOT
SATELITE->INF1  :=cINF1
CLOSE ALL
RETURN

*-----------------------------------------------------------------------------

