<!DOCTYPE html>
<html ng-app="myApp" >
<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>NuansaBaru</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="https://code.getmdl.io/1.3.0/material.indigo-pink.min.css">
<script defer src="https://code.getmdl.io/1.3.0/material.min.js"></script>
  <link rel="stylesheet" type="text/css" media="screen" href="main.css" />
  <script src="lib/angular.js"></script>
    <script src="lib/angular-touch.js"></script>
    <script src="lib/angular-resource.js"></script>
    <script src="lib/angular-animate.js"></script>
    <script src="lib/angular-route.js"></script>
   

</head>
<body>
  <div class="mdl-layout mdl-js-layout mdl-layout--fixed-header">
  <header class="mdl-layout__header">
    <div class="mdl-layout__header-row">
      <!-- Title -->
      <span class="mdl-layout-title">Nuansa Baru</span>
      <!-- Add spacer, to align navigation to the right -->
      <div class="mdl-layout-spacer"></div>
      <!-- Navigation. We hide it in small screens. -->
      <nav class="mdl-navigation mdl-layout--large-screen-only">
           <a class="mdl-navigation__link" href="">FileManager</a>
           <a class="mdl-navigation__link" href="#postgre">Adminer</a>
       
      </nav>
    </div>
  </header>
  <div class="mdl-layout__drawer">
    <span class="mdl-layout-title">DashBoard</span>
    <nav class="mdl-navigation">
       <?php
         include "tree.php";
         echo "lll";
        // menus();
       ?>
       
       {{menu | raw}}
      <a class="mdl-navigation__link" href="adminer.php">Adminer.php</a>
      <a class="mdl-navigation__link" href="">Link</a>
      <a class="mdl-navigation__link" href="">Link</a>
      <a class="mdl-navigation__link" href="">Link</a>
    </nav>
  </div>
  <main class="mdl-layout__content">
    <div class="page-content" ng-app>
      
    <!-- Your content goes here -->
     {{10+10}}
     <a ng-click="go('/employees/' + employee.id)">
       click
     </a>
     <a href="product">Product</a>
     <a href="#dept">Dep</a>
     <a href="#branch">Branch</a>
     <a href="#employees"> employeesls</a>
     <a href="adminer.php">Database</a>
     <a href="debug.html">Debug</a>
     <a href="shell.php">Bash</a>
     <a href="indeximages.php">Bash</a>
     <a href="#image">Images</a>
     <a href="image.php">Find Image</a>
     <a href="#supplier">Supplier</a>
     <a href="productbysupplier.php">Product By Supplier</a>
     
     <?php
       echo '<a href="product">Product</a>';
       echo '<a href="test">Test</a>';
       echo '<a href="upload">Upload</a>';
       echo '<a href="menu">menu</a>';
       echo '<a href="list">List Db</a>';
       echo '<a href="pr.supplier">Product By Supplier</a>';
       echo '<a href="http://flightphp.com/learn/">Reference</a>';
     ?>

     <div ng-view>
          <a href="https://developers.google.com/speed/pagespeed/insights/">Page Speed</a> 

     </div>
    
  </div>
  </main>
</div>
</body>
<script>
  'use strict';

angular.module('myApp', [
    'ngTouch',
    'ngRoute',
    'ngAnimate',
    'myApp.controllers',
    'myApp.memoryServices'
]).
config(['$routeProvider', function ($routeProvider) {
    $routeProvider.when('/product', {templateUrl: 'product', controller: 'EmployeeListCtrl'});
    $routeProvider.when('/brands', {templateUrl: 'brands.php', controller: 'EmployeeListCtrl'});
    $routeProvider.when('/branch', {templateUrl: 'branch.php', controller: 'EmployeeListCtrl'});
    $routeProvider.when('/dept', {templateUrl: 'dept.php', controller: 'EmployeeListCtrl'});
    $routeProvider.when('/size', {templateUrl: 'product.php', controller: 'EmployeeListCtrl'});
    $routeProvider.when('/image', {templateUrl: 'findimage.php', controller: 'EmployeeListCtrl'});
    $routeProvider.when('/postgre', {templateUrl: 'adminer.php', controller: 'EmployeeListCtrl'});
    $routeProvider.when('/mclass', {templateUrl: 'mclass.php', controller: 'EmployeeListCtrl'});
    $routeProvider.when('/info', {templateUrl: 'info.php', controller: 'EmployeeListCtrl'});
    $routeProvider.when('/catalog', {templateUrl: 'catalog.php', controller: 'EmployeeListCtrl'});
    $routeProvider.when('/supplier', {templateUrl: 'supplier.php', controller: 'EmployeeListCtrl'});
    
   
    $routeProvider.when('/employees', {templateUrl: 'sql.php', controller: 'EmployeeListCtrl'});
    $routeProvider.when('/employees/:employeeId', {templateUrl: 'partials/employee-detail.html', controller: 'EmployeeDetailCtrl'});
    $routeProvider.when('/employees/:employeeId/reports', {templateUrl: 'partials/report-list.html', controller: 'ReportListCtrl'});
  //  $routeProvider.otherwise({redirectTo: '/employees'});
}]);
</script>

</html>
