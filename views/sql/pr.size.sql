select size 
FROM
(
select mclass,article,array_agg(rtrim(size)) as size from product where left(barcode,3)='009'
group by 1,2
) a group by size