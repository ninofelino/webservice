USE "/srv/samba/share/SALES/C0010101.DBF" ALIAS sales SHARED NEW
do while !eof()
? dbf(),sales->FLAG,sales->CODE,sales->DESC,sales->QTY,sales->PRICE,sales->CPRICE,sales->NORCP,sales->ETYPE,sales->DDATE,sales->DEPT

skip
enddo