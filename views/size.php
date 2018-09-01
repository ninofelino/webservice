{% extends "layoutstd.php" %}


{% block content %}
<div class="row">
<h2>SIZE</h2>
<table id="example" class="mdl-data-table" >
        <thead>
            <tr>
                
            <th>Name</th>
            <th>Name</th>
                
            </tr>
        </thead>
        <tbody>
           
             {% for row in size %}
       <tr>
       <td>{{ row.size }}</td>
       <td>{{ row.jml }}</td>
     
       </tr>
    {% endfor %}
      
        </tbody>
       
    </table>
</div>
<script>


$(document).ready(function() {
    $('#example').DataTable();
    
} );
</script>
{% endblock %}