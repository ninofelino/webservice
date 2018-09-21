#include "hmg.ch"
#INCLUDE 'KASSA.CH'
*--------------------------------------------------------------------------------
FUNCTION JRFFUNC(c,n,a)
SET DEVICE TO PRINT
@ PRow(),0 SAY _PJOUR+_PLFEED
@ PRow(),0 SAY _PALL
SET DEVICE TO SCREEN
RETURN .T.

*--------------------------------------------------------------------------------
FUNCTION RCPFUNC(c,n,a)
SET DEVICE TO PRINT
@ PRow()+1 ,0 SAY _PRCPT+_PLFEED
@ PRow(),0 SAY _PALL
SET DEVICE TO SCREEN
RETURN .T.
