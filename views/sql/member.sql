select concat(
'<img src="img/user.gif">'
,'<span class="badge badge-secondary">New</span>','<b>',name,id,'</b><br>','<adress>',addr,'</adrress><hr>') 
as name
from members