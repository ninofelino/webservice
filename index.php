<?php
require 'vendor/autoload.php';
include 'qry.php';

Flight::register('db', 'PDO', array('pgsql:host=103.28.15.75;dbname=felino','deploy','nuansabaru123'));


Flight::route('/', function(){
   // Flight::render('header', array('heading' => 'Hello'), 'header_content');
  
//Flight::render('body', array('body' => 'World'), 'body_content');
//Flight::render('layout', array('title' => 'Home Page'));
echo '<a href="product">Product</a>';
    echo '<a href="test">Test</a>';
    echo '<a href="upload">Upload</a>';
    echo '<a href="menu">menu</a>';
    echo '<a href="list">List Db</a>';
    echo '<a href="pr.supplier">Product By Supplier</a>';
    echo '<a href="http://flightphp.com/learn/">Reference</a>';
   
    

});

Flight::route('POST /login', 'login');


Flight::route('/test', function(){
    $db = Flight::db();
    $stmt=$db->query('select * from product');
    while ($row = $stmt->fetch())
{
    echo $row[1] . "\n";
}

    echo 'Test!';
});

Flight::route('/product', function(){
    product(); 
 });

 Flight::route('/pr.supplier', function(){
    productSupplier(); 
 });

 Flight::route('/pr.supplier/@id', function($id){
    echo $id; 
    echo "<table><tbody>";
    productSupplierDetail($id);
    echo "</tbody></table>";  
   // productSupplier(); 
 });

Flight::route('/upload', function(){
    echo 'Upload';
    echo "<table><tbody>";
    getResult('select * from brands');
    echo "</tbody></table>";  
});

Flight::route('/list', function(){
    echo 'Upload';
    echo "<table><tbody>";
    getResult("select * from information_schema.tables where table_schema='public';");
    echo "</tbody></table>";  
});


Flight::start();