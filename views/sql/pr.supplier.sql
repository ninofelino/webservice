 select concat('<a href="',supplier_id,'">',trim((select name from supplier where id=a.supplier_id)),'</a>'),count from
    (
    select left(barcode,3) as supplier_id,count(*) as count from product group by 1
    ) a     
    
    