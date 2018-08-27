select concat('<li><a href="',url,'">',t.name,'  <span class="badge badge-danger">',t.jml,'</span></a></li>') as name FROM
(
select 'product' as name,'product' as url,count(*) as JML from product
union
select 'supplier' as name,'supplier' as url,count(*) as JML from supplier
union 
select 'mclass' as name,'mclass' as url,count(*) as JML from mclass
union
select 'Member' as name,'member' as url,count(*) as JML from members
union
select 'Brand' as name,'brand' as url,count(*) as JML from brands
) t