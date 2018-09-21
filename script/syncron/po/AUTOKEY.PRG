#include "kassa.ch"
*-----------------------------------------------------------------------------
FUNCTION AutoKey(c,n,a)
LOCAL cD:=''
TOMBOL->(__DBLocate({||ASCII==LastKey()},,,,.f.))
IF TOMBOL->(Found())
   cD:=TOMBOL->(AllTrim(ASGNNM))
   DO CASE
   CASE TOMBOL->(ASSIGN)=_B_KEY ;c:=Left(c+cD,13)
   CASE TOMBOL->(ASSIGN)=_A_KEY ;c:=cD   ;PLUFunc(@c,@n,@a)
   CASE TOMBOL->(ASSIGN)=_C_KEY ;c:=AllTrim(TOMBOL->ASGNNM) ;DP1Func(@c,@n,@a)
   CASE TOMBOL->(ASSIGN)=_D_KEY ;c:=AllTrim(TOMBOL->ASGNNM) ;DP2Func(@c,@n,@a)
   CASE TOMBOL->(ASSIGN)=_E_KEY ;c:=AllTrim(TOMBOL->ASGNNM) ;DP3Func(@c,@n,@a)
   ENDCASE
ENDIF
RETURN .t.

