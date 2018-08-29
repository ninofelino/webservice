{% extends "layoutstd.php" %}
 


{% block content %}
<style>
  .flexbox-container {
	display: -ms-flex;
	display: -webkit-flex;
	display: flex;
}

.flexbox-container > div {
	width: 30%;
	padding: 10px;
}



.flexbox-container > div:first-child {
	margin-right: 20px;
}
</style>
<div class="flexbox-container">
    <div><h3>Members</h3>
         <input placeholder="Members">
         <div id='my'></div>
     </div>
    <div><h3>Column 2</h3></div>
    <div><h3>Column 2</h3></div>
</div>





<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="http://cdn.bossanova.uk/js/jquery.jexcel.js"></script>
<link rel="stylesheet" href="http://cdn.bossanova.uk/css/jquery.jexcel.css" type="text/css" />
<script>
data = [


];
$('#my').jexcel({ data:data, colWidths: [ 300, 80, 100 ] });

</script>


{% endblock %}