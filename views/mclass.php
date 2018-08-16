{% extends "layout.php" %}


{% block content %}
<style>
.mdl-card__media > img {
  max-width: 25%;
}
</style>

<div class="mdl-grid">
  <div class="mdl-card mdl-cell mdl-cell--6-col mdl-cell--4-col-tablet mdl-shadow--2dp">
 
	<div class="mdl-card__title">
      <h1 class="mdl-card__title-text">MCLASS</h1>
    </div>
    <div class="mdl-card__supporting-text">
	
	<div id="jstree">

</div>
        </div>
  </div>
</div>

  

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