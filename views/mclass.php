{% extends "layout.php" %}


{% block content %}



    <div id="jstree"></div>
     

  

<script>
$('#jstree').jstree({
		'core' : {
			'data' : {
				"url" : "http://103.28.15.75:8069/api/mclass/list",
				"dataType" : "json" // needed only if you do not supply JSON headers
			}
		}
	});

    
</script>




{% endblock %}