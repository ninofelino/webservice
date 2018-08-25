{% extends "layout.php" %}


{% block content %}

<main class = "mdl-layout__content">    
      <div class = "mdl-grid">
              
            <div class = "mdl-cell mdl-cell--2-col graybox">
                     <input id="barcode" value="3"/>
                     <div id="results"></div>
            </div>      
            <div class = "mdl-cell mdl-cell--4-col graybox">
                <div class="spin" data-spin /></div> 
                <button id="addrow">Add</button>       
                <table id="items">
                      <thead>
                      <th>Barcode</th>
                      <th>Article</th>
                      <th>Qty</th>
                      <th>Discount</th>
                      <th>Total</th>
                <thead>  
                <tbody>
                      <tr class="item-row">
                      <td>12345678</td>
                      <td>VIVINICI</td>
                      <td>1</td>
                      <td>10000</td>
                      <td>1000000</td>  
                      </tr>  
                </tbody>    


                <table>    
                </div>

 <div class = "mdl-cell mdl-cell--1-col red">
   Lorem, ipsum dolor sit amet consectetur adipisicing elit. Alias dignissimos sapiente porro sed officia. Consectetur numquam nulla sapiente voluptate reiciendis expedita unde cum culpa veniam vel. Expedita delectus facilis optio.
</div>  
                 
                
</div>
              
</main>                

 <style>
 .spin
{
  background: #444; /* outline */
  > *
  {
    background: #EEE; /* hand */
  }
}
</style>  


<script>


var cari='6';
var peopleHTML='';
$('#add').click(function(){
  alert('Click');
});


$("#addrow").click(function(){
    $(".item-row:last").after('<tr class="item-row"><td class="item-name"><div class="delete-wpr">Item Name<a class="delete" href="javascript:;" title="Remove row">X</a></div></td><td class="description"><textarea>Description</textarea></td><td><textarea class="cost">$0</textarea></td><td><textarea class="qty">0</textarea></td><td><span class="price">$0</span></td></tr>');
    if ($(".delete").length > 0) $(".delete").show();
    bind();
  });

$('#barcode').change(function(){
  
  $('.spin').spin('show');
  $("#results").html("");
  $.ajax({url:'barcode/'+$('#barcode').val(),
   // data:{action:action, query:query},
    success:function(data)
    
    {
      peopleHTML='';
      for (var key in data) {
       
        peopleHTML += "<tr>";  
        peopleHTML += "<td>" + data[key]["label"] + "</td>";
        peopleHTML += "</tr>";    
         
      }

      // Replace table’s tbody html with peopleHTML
      $("#results").html(peopleHTML);
    }
 
  })
});
 



</script>




{% endblock %}