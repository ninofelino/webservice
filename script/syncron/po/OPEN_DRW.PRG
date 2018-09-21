FUNCTION OpenDrw()
 LOCAL nChoice:=4,nRest
 LOCAL _POPEN := chr(27)+chr(64)+CHR(27)+'p'+CHR(0)+CHR(15)+CHR(60)
 @10,15 SAY    '   Menu to Open Drawer     '
 @11,15 SAY    '컴컴컴컴컴컴컴컴컴컴컴컴컴�'
 @12,15 PROMPT 'Drawer connected to Printer'
 @13,15 PROMPT 'Drawer connected to COM1   '
 @14,15 PROMPT 'Drawer connected to COM2   '
 @15,15 PROMPT 'Exit to PROMPT             '
 MENU TO nChoice
 DO CASE
    CASE nChoice=1
         SET DEVI TO PRINT
         @ PRow(),00 SAY _POPEN
         SET DEVI TO SCREEN
    CASE nChoice=2
         IF Com_Open(1)
            IF !Com_Init(1,9600,'E',8,1)
               Tone(2500,4) ;RETURN(.T.)
            ENDIF
         ENDIF
         FOR i = 1 TO 160
             nRest := COM_SEND(1, CHR(0))             &&__1st attempt to transmit
         NEXT
         Com_Close(1)
    CASE nChoice=3
         IF Com_Open(2)
            IF !Com_Init(2,9600,'E',8,1)
               Tone(2500,4) ;RETURN(.T.)
            ENDIF
         ENDIF
         FOR i = 1 TO 160
             nRest := COM_SEND(2, CHR(0))             &&__1st attempt to transmit
         NEXT
         Com_Close(2)
   OTHERWISE
         CLS
         @10,15 'You already quit from this program !'
         RETURN
RETURN
