{% extends "layout.php" %}


{% block content %}

<div class="mdl-grid">
<div class="mdl-cell mdl-cell--4-col" id="jstree"></div>
    
<div class="mdl-cell mdl-cell--4-col" id="jsGrid"></div> 
</div>
   
      

		
      
    


            
            
<script>
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
  width: "60%",
  height: "auto",
  inserting: false,
        editing: true,
        sorting: true,
        paging: true,
  autoload:   true,
  paging:     true,
  pageSize:   10,
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