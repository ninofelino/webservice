{% extends "layout.php" %}
{% block content %}
<h4>Supplier</h4>



<div id="jsGrid"></div>



<script>

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
        url: "http://103.28.15.75:8069/api/supplier/list",
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