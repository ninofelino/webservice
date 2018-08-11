<?php
require_once 'dbconfig.php';

function getResult($qry){
    $host='103.28.15.75';
$db = 'felino';
$username = 'deploy';
$password = 'nuansabaru123';
    $dsn = "pgsql:host=$host;port=5432;dbname=$db;user=$username;password=$password";


    $pdo = new PDO($dsn);
    $data = $pdo->query($qry)->fetchAll();
    foreach ($data as $row) {
        echo "<tr>";
        foreach($row as $baris){
            echo '<td>'.$baris.'</td>';
        }
        echo "</tr>";
    }


}


function product(){
    getResult("select * from product");
};


function productSupplier(){
    $sql = file_get_contents('view/sql/pr.supplier.sql');
    getResult($sql);
};

function productSupplierDetail($id){
    $sql = file_get_contents('view/sql/pr.supplier.detail.sql');
    getResult($sql);
};