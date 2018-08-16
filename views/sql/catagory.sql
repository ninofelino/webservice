select * from

(
select '1' as id,'Supplier' as text,'#' as parent
union
select '2' as id,'Mclass' as text,'#' as parent
union
select id,"text",parent from catagory
) t order by 1