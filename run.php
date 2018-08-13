<?php
function runsql($statement){
    $host='103.28.15.75';
    $db = 'felino';
    $username = 'deploy';
    $password = 'nuansabaru123';
    $dsn = "pgsql:host=$host;port=5432;dbname=$db;user=$username;password=$password";
    $conn = new PDO($dsn);
    $sql = $conn->prepare($statement);
    $sql->execute();
    return $sql;
 }  
 ?>