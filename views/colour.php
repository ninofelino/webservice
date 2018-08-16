{% extends "layout.php" %}


{% block content %}

<h2>Colour</h2>
<table id="example" class="mdl-data-table" style="width:40%">
        <thead>
            <tr>
                <th>ID </th>
                <th>Name</th>
                
            </tr>
        </thead>
        <tbody>
           
             {% for row in brand %}
       <tr>
       <td>{{ row.colour }}</td>
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