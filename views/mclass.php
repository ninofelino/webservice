{% extends "layoutstd.php" %}


{% block content %}

<div class="flexbox-container">  
    <br>
	<div>
		<input> 
		<div id="jstree"></div>
    </div>
</div>	
     

  

<script>
menunav();	

function menunav(){
	$.ajax({
	url:"menu",dataType: "json",
	success:function(data){
   	var clickAction = function(id){
			console.log("clickAction: ", id);
		}
	   
		$( "#menuUI" ).menuUI(data, clickAction);
    } //endof success
});

};



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