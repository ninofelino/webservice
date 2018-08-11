<?php
 
function login() {<br>        // validasi
    $missingParameters = array();
    if (!isset($_POST['username'])) {
        array_push($missingParameters, 'username');
    }
    if (!isset($_POST['password'])) {
        array_push($missingParameters, 'password');
    }
    reportMissingParameters($missingParameters);
<br>        // logic
    $username = $_POST['username'];
    $password = $_POST['password'];
    <br>        // response
    Flight::json(array(
        "code"=>0,
        "message"=>"Succeed",
        "data"=>array(
            "username"=>$username,
            "realname"=>"Amri Shodiq"
        )
    ));
}
 
function reportMissingParameters($missingParameters) {
    $parameters = implode(", ", $missingParameters);
    Flight::json(array(
        "code"=>1,
        "message"=>"Missing parameter: ".$parameters.".",
        "data"=>null
    ));
    exit();
}
 
?>