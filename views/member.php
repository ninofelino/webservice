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
    background:grey;
    height:800px;
}

.item-flex {
    height:100%;
    background:#c6c4c4;
}

.flexbox-container > div:first-child {
	margin-right: 20px;
    background:#c4c6c4;
    display:wrap;
}
</style>

<div class="flexbox-container">
    <div class="item-flex"><h3>Member</h3>
        <input  type="search" placeholder="Cari Member" onkeyup="carimember(this.value)"/>
        <button onclick="window.print()">Print</button> 
        <div id="member" style="height:500px"></div>
         
        </div>
    <div><h3>Member Level</h3>
         <div id="memberlevel" style="height:500px"></div> 
    </div>
    
    <div><h3>Member Type</h3>
         <div id='my'></div>
    </div>
</div>





<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="http://cdn.bossanova.uk/js/jquery.jexcel.js"></script>
<link rel="stylesheet" href="http://cdn.bossanova.uk/css/jquery.jexcel.css" type="text/css" />
<script src="//raw.github.com/botmonster/jquery-bootpag/master/lib/jquery.bootpag.min.jss"></script>
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

}



data = [


];
$('#my').jexcel({ data:data, colWidths: [ 300, 80, 100 ] });
carimemberlevel('str');

$.ajax({
	url:"menu",dataType: "json",
	success:function(data){
   	var clickAction = function(id){
			console.log("clickAction: ", id);
		}
	   
		$( "#menuUI" ).menuUI(data, clickAction);
    } //endof success
});
</script>


{% endblock %}