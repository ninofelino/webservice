select * FROM
(select left(barcode,3) as supplier,mclass,article,colour,array_agg(rtrim(size)) as size from product 
 group by 1,2,3,4
 order by mclass,article
) t 