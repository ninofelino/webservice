{% extends "layout.php" %}
{% block content %}

<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid-theme.min.css"/>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid.min.js"></script>

<h3>Branch</h3>
<div id="jsGrid"></div>


<script>
  $("#jsGrid").jsGrid({
  width: "50%",
  height: "auto",

  autoload:   true,
  paging:     true,
  pageSize:   5,
  pageButtonCount: 5,
  pageIndex:  1,

  controller: {
    loadData: function(filter) {
      return $.ajax({
        url: "http://103.28.15.75:8069/api/branch/list",
        dataType: "json"
      });
    }
  },
  fields: [
    {name: "id", width: 10},
    {name: "name", width: 50}
  ]
});
</script>
{% endblock %}