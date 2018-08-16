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


function menu(){
    //$sql = file_get_contents('view/sql/menu.sql');
    $sql = "select * from menus";

    $pdo = new PDO($dsn);
    $data = $pdo->query($qry)->fetchAll();
    return get_menu($data);
};

function productSupplierDetail($id){
    $sql = file_get_contents('view/sql/pr.supplier.detail.sql');
    getResult($sql);
};

function get_menu($data, $parent = 0) {
    static $i = 1;
    $tab = str_repeat(" ", $i);
    if ($data[$parent]) {
    $html = "$tab<ul id='menu-tree' class='filetree'>";
    $i++;
    foreach ($data[$parent] as $v) {
    $child = get_menu($data, $v->id);
    $html .= "$tab<li>";
    $html .= '<a href="'.$v->url.'">'.$v->name.'</a>';
    if ($child) {
    $i--;
    $html .= $child;
    $html .= "$tab";
    }
    $html .= '</li>';
    }
    $html .= "$tab</ul>";
    return $html;
    }
    else {
    return false;
    }
    };

    function has_children($rows,$id) {
        foreach ($rows as $row) {
          if ($row['parent_id'] == $id)
            return true;
        }
        return false;
      }
      function build_menu($rows,$parent=0)
      {  
        $result = "<ul>";
        foreach ($rows as $row)
        {
          if ($row['parent_id'] == $parent){
            $result.= "<li>{$row['title']}";
            if (has_children($rows,$row['id']))
              $result.= build_menu($rows,$row['id']);
            $result.= "</li>";
          }
        }
        $result.= "</ul>";
      
        return $result;
      }
   //   echo build_menu($menu);

      function login() {
        $username = $_POST['username'];
        $password = $_POST['password'];
    
        echo json_encode(array(
            "code"=>0,
            "message"=>"Succeed",
            "data"=>array(
                "username"=>$username,
                "realname"=>"Amri Shodiq"
            )
        ));
    };

    function mclass(){
        echo "Mclass";
     };
     
     function brand(){
        echo "Brands";
        return "LLLLL";
     };

?>     