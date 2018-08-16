{% extends "layout.php" %}


{% block content %}

<h2>SIZE</h2>
<table id="example" class="mdl-data-table" >
        <thead>
            <tr>
                
                <th>Name</th>
                
            </tr>
        </thead>
        <tbody>
           
             {% for row in size %}
       <tr>
       <td>{{ row.size }}</td>
     
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