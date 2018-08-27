{% extends "layoutstd.php" %}


{% block content %}

<div class="row">
<br><br>
     <div class="col-md-3">
     <input class="form-control" placeholder="Search Product" name="srch-term" id="srch-term" type="text">
        <div id="jstree"></div>
    </div>
    <div class="col-md-6">
        <div id="jsGrid"></div>
    </div>

    <div class="col-md-2">
        <button>SyncronData</button>
        <p>
          melakukan syncronisasi data dengan INV.DBF di directory
          /var/www/html/DAT
</p>  
        <li><a href="script/shell.php">Run Script</a></li> 
        <p>Mengambil data dari INV.DBF Ke Postgre Database</p> 
        <li><a href="script/shell.php">Tranfer Data Ke Postgree</a></li>
</code>
    </div>

    
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



$('#jstree').jstree({
		'core' : {
			'data' : {
				"url" : "http://103.28.15.75:8069/api/catagory/list",
				"dataType" : "json" // needed only if you do not supply JSON headers
			}
		}
	});

    
</script>

<script>

$("#jsGrid").jsGrid({
  width: "100%",
  height: "auto",
  inserting: false,
        editing: true,
        sorting: true,
        paging: true,
  autoload:   true,
  paging:     true,
  pageSize:   20,
  pageButtonCount: 5,
  pageIndex:  1,

  controller: {
    loadData: function(filter) {
      return $.ajax({
        url: "http://103.28.15.75:8069/api/product/list",
        dataType: "json"
      });
    }
  },
  fields: [
    {name: "mclass", width: 5,type: "text"},
    {name: "article", width:5,type: "text"},
    {name: "colour", width: 10,type: "text"},
    {name: "size", width: 10,type: "text"}
  ]
});


</script>



{% endblock %}