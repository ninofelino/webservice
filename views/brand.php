{% extends "layoutstd.php" %}


{% block content %}
<br>
<br>
<h3>Brand</h3>
<p>
  Merk / Label Suatu product
</p>  
<div id="jsGrid"></div>



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

$("#jsGrid").jsGrid({
  width: "50%",
  height: "auto",
  inserting: true,
        editing: true,
        sorting: true,
        paging: true,
  autoload:   true,
  paging:     true,
  pageSize:   15,
  pageButtonCount: 5,
  pageIndex:  1,

  controller: {
    loadData: function(filter) {
      return $.ajax({
        url: "http://103.28.15.75:8069/api/brand/list",
        dataType: "json"
      });
    }
  },
  fields: [
    {name: "id", width: 10,type: "text"},
    {name: "name", width: 50,type: "text"}
  ]
});


</script>



{% endblock %}