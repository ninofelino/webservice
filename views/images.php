{% extends "layout.php" %}


{% block content %}


<div >
    <span>
    <i class="material-icons">search</i>
    <input class="mdl-textfield__input" type="text" id="search" value="" placeholder="Search Picture"/>
    </span> 
    <div  class="mdl-grid" id='results'>
      Search..
    </div>  
  
</div>
  
  


{% block javascripts %}    
<script>
$(function(){
$('#search').change(function(){
   
    $.ajax({
        url: "images/"+$('#search').val(),
        dataType:"html",
        type: "post",
        success: function(data){
           $('#results').html(data);
        }
    });
});
});
</script>
{% endblock %}


{% endblock %}