{% extends "layout.php" %}


{% block content %}
<div id="jsGrid"></div>
<h2>Unit Of Measure</h2>


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