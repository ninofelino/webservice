{% extends "layout.php" %}


{% block content %}
<h3>Product Detail{{id}}</h3>
<div id="jsGrid"></div>
<table id="example" class="display" style="width:100%">
<thead>
 <tr>
 <th>Mclass</th><th>Article</th>
 <th>Size</th>
</tr>
<thead>

<tbody>
    {% for row in product %}
       <tr>
       <td>{{ row.mclass | raw}}</td>
       <td>{{ row.article}}</td>
       <td>{{ row.size}}</td>
     
       
       </tr>
    {% endfor %}

</tbody>


</table>


<script>
$(document).ready(function() {
    $('#example').DataTable();
} );
</script>



{% endblock %}