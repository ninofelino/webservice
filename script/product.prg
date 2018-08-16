LOCAL namasize:={"S","M","L","XL","XXL","28","29","30","31","41","42","43","44","45","46"}
LOCAL UKURAN:=''
USE "/var/www/html/slim/DAT/INV.DBF" SHARED NEW
? "Total Record..."

?? RecCount()
SET PRINT TO inv.dmp
SET PRINT ON

do while !eof()
? 'insert into product(barcode,mclass,desc1,costprc,sellprc,article,size) values('
?? quote(inv->code)
?? ','
?? quote(inv->mclscode)
?? ','
?? quote(inv->DESC1)
?? ','
?? inv->costprc
?? ','
?? inv->sellprc
?? ','

?? quote(token(inv->DESC1,' ',1))
?? ','
UKURAN:=token(INV->DESC1,1)
IF ASCAN(NAMASIZE,UKURAN)<1
    UKURAN:='ALL SIZE'
ENDIF    
?? UKURAN

?? ') ON CONFLICT ON CONSTRAINT productid DO update set article= product.article,size=product.size;'
skip
enddo
SET PRINT OFF
CLOSE

function quote(str)
return "'"+alltrim(str)+"'"    