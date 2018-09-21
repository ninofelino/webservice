#include "hmg.ch"
*-----------------------------------------------------------------------------
FUNCTION BSPFunc(c,n)
LOCAL nD:=Len(c)
IF nD>0 ;c:=Left(c,nD-1)
ENDIF
RETURN .t.
