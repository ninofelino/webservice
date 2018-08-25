select * from

(
select '1' as id,'<b>Supplier</b>' as text,'#' as parent
union
select '2' as id,'Mclass' as text,'#' as parent
union
select id,concat(rtrim("text")) as text,parent from catagory
) t 
where text<>''
order by 1