{% extends "layoutstd.php" %}


{% block content %}
<style>
.item-flex{
  background:red;
  padding: 10px;
}  
</style>  

<div class="flexbox-container">
      <br><br>
     <div class="item-flex" 
     style="background:#c4c4c4;
      overflow: scroll;
     " >
     <br>
     <input class="form-control" placeholder="Search Product" name="srch-term" id="srch-term" type="text">
     
     <div id="jstree"></div>
    </div>
<div class="item-flex"
style="background:#c4c4c4;
      overflow: scroll;
     "
>
    <button class="btn btn-primary">Download</button>
    <button class="btn btn-primary">Print</button>
    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">
  Edit
</button>

     
        <table class=" table-stripped">
             <thead>
             <th>Style Name</th>
             <th></th>
               
             </thead>
             <tbody id="hasil"> 
             
             <tbody>
        </table>
    
        
    </div>
    <div class="gambar">
        
        <input class="form-control form-control-lg form-control-borderless" type="search" placeholder="Cari Gambar di Clouds" onkeyup="carigambar(this.value)">
            <div id="gambar"></div>   

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
        <div id="event_result"></div>
        
        <div id="jsGrid2"></div>

    </div>

    
</div>


<div id="myModal" class="modal fade centered-modal" role="dialog">
   <div class="modal-dialog">
	<!-- konten modal-->
	<div class="modal-content">
		<!-- heading modal -->
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
			<h4 class="modal-title">Edit Article</h4>
		</div>
		<!-- body modal -->
		<div class="modal-body">
      <p>bagian body modal.</p>
      Lorem ipsum dolor sit amet consectetur, adipisicing elit. Alias, consectetur enim dolore repellendus laborum blanditiis nihil minima eaque rem fugiat exercitationem consequuntur consequatur nesciunt nemo nulla harum? Sequi, ex placeat.
		</div>
		<!-- footer modal -->
		<div class="modal-footer">
			<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		</div>
	</div>
   </div>
</div>

<!-- Modal -->


{% block javascripts %}
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



$('#jstree').jstree({'core' : {
			'data' : {"url" : "catagory/list","dataType" : "json"}}
	});

 
 



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
        url: "product/list",
        dataType: "json"
      });
    }
  },
  fields: [
    {name: "supplier", width: 5,type: "text"},
    {name: "mclass", width: 5,type: "text"},
    {name: "article", width:5,type: "text"},
    {name: "colour", width: 10,type: "text"},
    {name: "size", width: 20,type: "text"}
  ]
});

$('#jstree').on('changed.jstree', function (e, data) {
    var i, j, r = [];
    var hasil;
    var isibaris;
    for(i = 0, j = data.selected.length; i < j; i++) {
      r.push(data.instance.get_node(data.selected[i]).id);
    }
    hasil="product/supplier/"+r.join(', ');
    
    $('#event_result').html(hasil);
    isibaris='';
    $('#hasil').html("grid here");
      $.ajax({ 
        url: hasil,success:
        function(data){
          $('#hasil').LoadingOverlay("show");
              $.each( data, function( key, val ) {
                isibaris='<tr><td><b>'+val['article']+'</b><td><td><small>'+val['colour']+'</small><td>'+val['mclass']+'</td>'+'<td>'+val['size']+'</td></tr>';
                $('#hasil').append(isibaris);
             // alert(key);
             $('#hasil').LoadingOverlay("hide", true);
          }
        
        );
          
        }


      });
            

    

  })
  // create the instance
  .jstree();
</script>

{% endblock %}
{% endblock %}

