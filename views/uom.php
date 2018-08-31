{% extends "layoutstd.php" %}


{% block content %}
<div id="jsGrid"></div>

<li>
<a href="https://select2.org/dropdown">Select2</a>
</li>
<div style="width:520px;margin:0px auto;margin-top:30px;height:500px;">
  <h2>Select Box with Search Option Jquery Select2.js</h2>
  <select class="itemName form-control" style="width:500px" name="itemName"></select>
</div>

<h2>Unit Of Measure</h2>
<select id="locality-dropdown" name="locality">
</select>

<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css" rel="stylesheet" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>
<script type="text/javascript">
      $('.itemName').select2({
        placeholder: 'Select an item',
        ajax: {
          url: 'brand/list',
          dataType: 'json',
          delay: 250,
          processResults: function (data) {
            return {
              results: data
            };
          },
          cache: true
        }
      });
</script>
<script>
let dropdown = $('#locality-dropdown');

dropdown.empty();

dropdown.append('<option selected="true" disabled>Choose State/Province</option>');
dropdown.prop('selectedIndex', 0);

const url = 'https://api.myjson.com/bins/7xq2x';

// Populate dropdown with list of provinces
$.getJSON(url, function (data) {
  $.each(data, function (key, entry) {
    dropdown.append($('<option></option>').attr('value', entry.abbreviation).text(entry.name));
  })
});

</script>



{% endblock %}