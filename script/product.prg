function main()
LOCAL namasize:={"S","M","L","XL","XXL","O","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46"}
LOCAL UKURAN:=''
LOCAL WARNA:=''
LOCAL article:=''
LOCAL DESC:=''
LOCAL MULAI:=time()
LOCAL JUMLAH:=0
USE "/var/www/html/slim/DAT/INV.DBF" SHARED NEW

? "Total Record..."

?? RecCount()
SET PRINT TO inv.sql
SET PRINT ON

do while !eof()
UKURAN:=token(INV->DESC1,1)
article:=token(inv->DESC1,' ',1)
IF ASCAN(NAMASIZE,UKURAN)<1
    UKURAN:=''
ENDIF
? 'insert into product(barcode,mclass,desc1,costprc,sellprc,article,size,colour) values('
?? quote(inv->code)
?? ','
?? quote(inv->mclscode)
?? ','
DESC=strtran(inv->DESC1,"'","")
?? quote(DESC)
?? ','
?? inv->costprc
?? ','
?? inv->sellprc
?? ','

?? quote(token(inv->DESC1,' ',1))
?? ','
    
?? quote(UKURAN)
?? ','
warna:=substr(inv->desc1,at(article,inv->DESC1)+len(article))
warna:=rtrim(left(warna,at(ukuran,warna)-1))
?? quote(warna)

    ?? ') ON CONFLICT ON CONSTRAINT productid DO update set article= product.article,size=product.size,colour=product.colour;'
    skip
    jumlah:=jumlah+1
    enddo
SET PRINT OFF
cls
? "TOTAL RECORD"
?? RecCount()
? mulai-time()
? time()
? jumlah
CLOSE
return nil

function quote(str)
return "'"+alltrim(str)+"'"    