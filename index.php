<?php
require 'vendor/autoload.php';
include 'qry.php';
include 'tree.php';

Flight::register('db', 'PDO', array('pgsql:host=103.28.15.75;dbname=felino','deploy','nuansabaru123'));


Flight::route('/', function(){
   // Flight::render('header', array('heading' => 'Hello'), 'header_content');
  
//Flight::render('body', array('body' => 'World'), 'body_content');
//Flight::render('layout', array('title' => 'Home Page'));

   
    $menu = menus();
    //echo $menu;

    $loader = new Twig_Loader_Filesystem('views');
$twig = new Twig_Environment($loader);
echo $twig->render('layout.php', array(
    'name'  => 'Frey',
    'city'  => 'Samarinda',
    'menu'    => $menu

));

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
   // Flight::render('layout', array('title' => 'Product'));
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

Flight::route('/menu', function(){
  
     menus();
  
});

function print_list($array, $parent=0) {
    print "<ul>";
    foreach ($array as $row) {
     //   if ($row->parent_id == $parent) {
            print "<li>$row->name";
            print_list($array, $row->id);  # recurse
            print "</li>";
   // }  
    }
    print "</ul>";
};

Flight::route('/list', function(){
    echo 'Upload';
    echo "<table><tbody>";
    getResult("select * from information_schema.tables where table_schema='public';");
    echo "</tbody></table>";  
});


Flight::start();