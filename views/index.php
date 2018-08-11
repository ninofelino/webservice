<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Page Title</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" media="screen" href="main.css" />
    <script src="main.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/handsontable@5.0.0/dist/handsontable.full.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/handsontable@5.0.0/dist/handsontable.full.min.css" rel="stylesheet" media="screen">
</head>

<body>
    View Controller
    <div id="example"></div>
</body>
</html>

<script>
var data = [
  ["", "Ford", "Tesla", "Toyota", "Honda"],
  ["2017", 10, 11, 12, 13],
  ["2018", 20, 11, 14, 13],
  ["2019", 30, 15, 12, 13]
];

$.ajax('product', 'GET', '', function(res) {
    var data = JSON.parse(res.response);

    hot.loadData(data.data);
    exampleConsole.innerText = 'Data loaded';
  });


var container = document.getElementById('example');
var hot = new Handsontable(container, {
  data: data,
  rowHeaders: true,
  colHeaders: true
});
</script>