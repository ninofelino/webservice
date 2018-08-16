{% extends "layout.php" %}


{% block content %}

<h2>Member</h2>
<table id="example" class="mdl-data-table" >
        <thead>
            <tr>
                
                <th>Name</th>
                
            </tr>
        </thead>
        <tbody>
           
             {% for row in size %}
       <tr>
       <td>{{ row.name }}</td>
     
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