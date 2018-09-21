#include "hmg.ch"
#include 'kassa.ch'

*-----------------------------------------------------------------------------
PROCEDURE NIndex()
LOCAL nD,cD,cS:=BoxBgn('REINDEX....!')
*--------------------------------------
Close All
cD:='PRODUK'
NetUse({{NDATA+cD,.f.}})
IF !EMPTY(ALIAS()) ;Scrolling(cD)
   INDEX ON CODE          TO (NDATA+'PRODUK_1.NTX')
   INDEX ON Left(DESC,28) TO (NDATA+'PRODUK_2.NTX')
   INDEX ON REF           TO (NDATA+'PRODUK_3.NTX')
   INDEX ON UNIT          TO (NDATA+'PRODUK_4.NTX')
ELSE ;cD := 'NIL'
ENDIF
*--------------------------------------
cD:='CLASS'
NetUse({{NDATA+cD,.f.}})
IF !EMPTY(ALIAS()) ;Scrolling(cD)
   INDEX ON CODE          TO (NDATA+'CLASS__1.NTX')
   INDEX ON Left(DESC,10) TO (NDATA+'CLASS__2.NTX')
ELSE ;cD := 'NIL'
ENDIF
*--------------------------------------
cD:='GROUP'
NetUse({{NDATA+cD,.f.}})
IF !EMPTY(ALIAS()) ;Scrolling(cD)
   INDEX ON CODE          TO (NDATA+"GROUP__1.NTX")
ELSE ;cD := 'NIL'
ENDIF
*--------------------------------------
cD:='CUS'
NetUse({{NDATA+cD,.f.}})
IF !EMPTY(ALIAS()) ;Scrolling(cD)
   PACK
   INDEX ON CODE          TO (NDATA+"CUS____1.NTX")
   INDEX ON NAME TO (NDATA+"CUS____2.NTX")
ELSE ;cD := 'NIL'
ENDIF
cD:='CUSDET'
NetUse({{NDATA+cD,.f.}})
IF !EMPTY(ALIAS()) ;Scrolling(cD)
   INDEX ON CODE+Str(RCPTNO,6)+DToS(DATE) TO (NDATA+"CUSDET_1.NTX")
   INDEX ON DToS(DATE)+CODE+Str(RCPTNO,6) TO (NDATA+"CUSDET_2.NTX")
ELSE ;cD := 'NIL'
ENDIF
*----------------------------------------------------
*--------------------------------------
BoxEnd(cS)
CLOSE ALL
UseFile()
RETURN

*-----------------------------------------------------------------------------
PROCEDURE DIndex()
LOCAL nD,cD,cS:=BoxBgn('REINDEX....!')
*--------------------------------------
Close All
IF cStPRG='BAKERY'
   cD:='PRODUK'
   NetUse({{DDATA+cD,.f.}})
   IF !EMPTY(ALIAS()) ;Scrolling(cD)
      INDEX ON UNIT          TO (DDATA+'PRODUK_4.NTX')
      INDEX ON REF           TO (DDATA+'PRODUK_3.NTX')
      INDEX ON Left(DESC,28) TO (DDATA+'PRODUK_2.NTX')
      INDEX ON CODE          TO (DDATA+'PRODUK_1.NTX')
   ELSE ;cD := 'NIL'
   ENDIF
ENDIF
IF !NNETlogged()
   cD:='PRODUK'                                         // 150496
   NetUse({{DDATA+cD,.f.}})
   IF !EMPTY(ALIAS()) ;Scrolling(cD)
      INDEX ON CODE          TO (DDATA+'PRODUK_1.NTX')
      INDEX ON Left(DESC,28) TO (DDATA+'PRODUK_2.NTX')
      INDEX ON REF           TO (DDATA+'PRODUK_3.NTX')
   ELSE ;cD := 'NIL'
   ENDIF
ENDIF                                                  // end 150496
cD:='CLASS'
NetUse({{DDATA+cD,.f.}})
IF !EMPTY(ALIAS())  ;Scrolling(cD)
   INDEX ON CODE          TO (DDATA+'CLASS__1.NTX')
   INDEX ON Left(DESC,10) TO (DDATA+'CLASS__2.NTX')
ELSE ;cD := 'NIL'
ENDIF
*--------------------------------------
cD:='GROUP'
NetUse({{DDATA+cD,.f.}})
IF !EMPTY(ALIAS()) ;Scrolling(cD)
   INDEX ON CODE          TO (DDATA+"GROUP__1.NTX")
ELSE ;cD := 'NIL'
ENDIF
*--------------------------------------
cD:='CUS'
NetUse({{DDATA+cD,.f.}})
IF !EMPTY(ALIAS()) ;Scrolling(cD)
   INDEX ON CODE          TO (DDATA+"CUS____1.NTX")
   INDEX ON NAME          TO (DDATA+"CUS____2.NTX")
ELSE ;cD := 'NIL'
ENDIF
*--------------------------------------
BoxEnd(cS)
CLOSE ALL
UseFile()
RETURN
