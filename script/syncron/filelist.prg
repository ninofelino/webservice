local i,aname
local nLen,pilih
local home:="/home/headoffice/posserver/ics/DAT"
set defa to "/home/headoffice/posserver/ics/DAT"
nLen:= ADir( "/home/headoffice/posserver/ics/DAT/*.DBF",aName ) 
aName := Array( nLen ) 
ADir( "/home/headoffice/posserver/ics/DAT/*.DBF",aName ) 
cls
@ 0,0 SAY "INVENTORY DBF Manager Nuansa Baru Indonesia"
do while .t.
DISPBOX(1, 0, maxrow(),21,1)
pilih:=achoice(2,1,maxrow()-1,20,asort(aname))
if pilih>1
DBUSEAREA(.T., "DBFNTX", aname[pilih])
@ 0,maxcol()-30 say aname[pilih]
@ maxrow(),30 SAY "F3 Search"
else
    quit
endif    
DISPBOX(1,22, maxrow()-1,maxcol(),1)
dbedit(2,23,maxrow()-2,maxcol()-1,,"KeyExcept")
enddo


FUNCTION KeyExcept
    PARAMETER action_key
    *
    DO CASE
    CASE action_key = 27
       * Esc...exit DBEDIT().
       ALERT("ESCAPE")
       QUIT
       RETURN 0

    CASE action_key = 13
       * Return...field edit (see discussion below).
      // RETURN FieldEdit()

    CASE action_key = 7 .AND. (.NOT. EOF()) .AND.;
    LASTREC()<> 0
       * Del...toggle delete status.
      

    CASE action_key = -9
       * F10...enter menu system.
       //RETURN MenuSys()

    OTHERWISE
       * Any other key...slightly distasteful tone.
       TONE(100, 1)
       RETURN 1
    ENDCASE
