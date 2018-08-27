select concat('<li>',name,'<span class="badge badge-danger">',jml,'</span></li>') as name FROM
(
select (select rtrim(name)  from supplier where id=ks) as name,jml from
(
select left(barcode,3) as ks,count(*) as jml from product group by 1
order by 2 desc limit 10
) t
) X