<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>NuansaBaru</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<link rel="stylesheet" href="js/jQuery.menuUI.css">
	<link rel="stylesheet" href="js/font-awesome.css">
	<link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
  <link rel="stylesheet" href="js/jsgrid.min.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid-theme.min.css"/>
 
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.1/jquery.min.js"></script>
<script src="js/jstree.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jQuery.menuUI.js"></script>
<script type="text/javascript" src="js/jsgrid.min.js"></script>
 <script type="text/javascript" src="js/felino.js"></script>    


   

</head>

<body>

<nav id="menuUI">

</nav>
<div class="container-fluid">
	<br><br>
    {% block content %}
    {% block javascripts %}{% endblock %}
    {% endblock %} 
</div>


<script>
       $.ajax({
	url:"menu",dataType: "json",
	success:function(data){
   	var clickAction = function(id){
			console.log("clickAction: ", id);
		}
	   
		$( "#menuUI" ).menuUI(data, clickAction);
    } //endof success
});

</scipt>		

	
</body>


</html>