FUNCTION RTNFunc(c,n,a)
LOCAL cD:=''
   lGRTN:=!lGRTN
   cD:=Left(SATELITE->CPNO,4)
   SAVE TO ('DAT\'+cD+'TEMP.MEM') ALL LIKE ?G*
   IF lGRTN ;@ 07,02 SAY 'RTN' COLOR '*/w'
      ELSE  ;@ 07,02 SAY '   ' COLOR ' /w'
   ENDIF
RETURN .T.
