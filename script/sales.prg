USE "/srv/samba/share/SALES/C0010101.DBF" SHARED NEW
do while !eof()
? recno()
skip
enddo