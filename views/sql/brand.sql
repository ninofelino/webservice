select a.id,a.name,b.name as suppliername 
from brands a
left outer join supplier b on a.supplier=b.id