 select concat('<a href="product/',supplier_id,'">',
 trim((select name from supplier where id=a.supplier_id)),'</a>') as name ,count from
    (
    select left(barcode,3) as supplier_id,count(*) as count from product group by 1
    ) a     
    
    