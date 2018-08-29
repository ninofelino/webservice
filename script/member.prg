USE "/var/www/html/DAT/CUS.DBF" SHARED NEW

? "Total Rec"
? LASTREC(), RECCOUNT() 
set print to "member.sql"
set print on
do while !eof()
? "insert into members(id,name,addr) values("
?? quote(cus->code)
?? ","
?? quote(strtran(cus->name,"'"," "))
?? ","
?? quote(strtran(cus->add1+cus->add2,"'",'"'))
?? ");"

skip
enddo
set print off
? "Total Rec"
? LASTREC(), RECCOUNT() 

function quote(str)
    return "'"+alltrim(str)+"'"   
