<?php
require 'vendor/autoload.php';
include 'qry.php';
include 'tree.php';

Flight::register('db', 'PDO', array('pgsql:host=103.28.15.75;dbname=felino','deploy','nuansabaru123'));


Flight::route('/', function(){
      $menu = menus();
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
   
    // $product=product(); 
    $sql = file_get_contents('views/sql/pr.supplier.sql');
     $menu = menus();
     $loader = new Twig_Loader_Filesystem('views');
     $twig = new Twig_Environment($loader);
    // $sql = "select * from menus";
     $db = Flight::db();
     $product=$db->query($sql)->fetchAll();
     
     //echo print_r($brand);
     echo $twig->render('product.php', array(
        
         'product'  => $product,
         'menu'  => $menu
     ));
  });


Flight::route('/product/list', function(){
   
    // $product=product(); 
    $sql = file_get_contents('views/sql/pr.supplier.detail.sql');
    $db = Flight::db();
     $results=$db->query($sql)->fetchAll();
     Flight::json($results);
     
  });



  Flight::route('/product/@id', function($id){
   
    // $product=product(); 
    $sql = file_get_contents('views/sql/pr.supplier.detail.sql');
     $menu = menus();
     $loader = new Twig_Loader_Filesystem('views');
     $twig = new Twig_Environment($loader);
    // $sql = "select * from menus";
     $db = Flight::db();
     $product=$db->query($sql)->fetchAll();
     
     //echo print_r($brand);
     echo $twig->render('productdetail.php', array(
          'id'=>$id,
         'product'  => $product,
         'menu'  => $menu
     ));
  });


  Flight::route('/brand', function(){
    $menu = menus();
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    $sql = "select * from menus";
    $db = Flight::db();
    $brand=$db->query('select * from brands')->fetchAll();
    
    //echo print_r($brand);
    echo $twig->render('brand.php', array(
        'name'  => 'Frey',
        'brand'  => $brand,
        'menu'  => $menu
    ));
   
    });

    Flight::route('/brand/list', function(){
        $pdo = Flight::db();
        $statement = $pdo->prepare("SELECT * FROM brands");
        $statement->execute();
        $results = $statement->fetchAll(PDO::FETCH_ASSOC);
        Flight::json($results);
     
       
        });


        Flight::route('/colour', function(){
            $menu = menus();
            $loader = new Twig_Loader_Filesystem('views');
            $twig = new Twig_Environment($loader);
            $sql = "select * from menus";
            $db = Flight::db();
            $brand=$db->query('select colour from product group by colour')->fetchAll();
            
            //echo print_r($brand);
            echo $twig->render('colour.php', array(
                'name'  => 'Frey',
                'brand'  => $brand,
                'menu'  => $menu
            ));
           
        });


        Flight::route('/uom', function(){
            $menu = menus();
            $loader = new Twig_Loader_Filesystem('views');
            $twig = new Twig_Environment($loader);
            $sql = "select * from menus";
            $db = Flight::db();
            $brand=$db->query('select colour from product group by colour')->fetchAll();
            
            //echo print_r($brand);
            echo $twig->render('uom.php', array(
                'name'  => 'Frey',
                'brand'  => $brand,
                'menu'  => $menu
            ));
           
        });    


Flight::route('/size', function(){
    $menu = menus();
    $sql = file_get_contents('views/sql/pr.size.sql');
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    $db = Flight::db();
    $brand=$db->query($sql)->fetchAll();
    
    //echo print_r($brand);
    echo $twig->render('size.php', array(
        'name'  => 'Frey',
        'size'  => $brand,
        'menu'  => $menu
    ));
   
});


Flight::route('/branch/list', function(){
    
    $pdo = new PDO("pgsql:dbname=felino;host=103.28.15.75", "deploy", "nuansabaru123");
 $statement = $pdo->prepare("SELECT * FROM branch");
$statement->execute();
$results = $statement->fetchAll(PDO::FETCH_ASSOC);
//$json = json_encode($results);

Flight::json($results);
  //return $json;
   
});

Flight::route('/branch', function(){
    $menu = menus();
    $sql = file_get_contents('views/sql/pr.size.sql');
    $sql = "select * from branch";
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    $db = Flight::db();
    $brand=$db->query($sql)->fetchAll();
    
    //echo print_r($brand);
    echo $twig->render('branch.php', array(
        'name'  => 'Frey',
        'size'  => $brand,
        'menu'  => $menu
    ));
   
});

Flight::route('/member', function(){
    $menu = menus();
    $sql = file_get_contents('views/sql/pr.size.sql');
    $sql = "select * from members";
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    $db = Flight::db();
    $brand=$db->query($sql)->fetchAll();
    echo $twig->render('member.php', array(
        'name'  => 'Frey',
        'size'  => $brand,
        'menu'  => $menu
    ));
   
});


    Flight::route('/mclass', function(){
        $loader = new Twig_Loader_Filesystem('views');
        $twig = new Twig_Environment($loader);
        $menu = menus();
        $db = Flight::db();
        $mclass=$db->query('select * from mclass')->fetchAll();
        echo $twig->render('mclass.php', array(
            'menu'  => $menu,
            'mclass'  => $mclass
            ));
        mclass(); 
        });    
    Flight::route('/mclass/list', function(){
        $pdo = new PDO("pgsql:dbname=felino;host=103.28.15.75", "deploy", "nuansabaru123");
        $sql = file_get_contents('views/sql/mclass.sql');
        $statement = $pdo->prepare($sql);
       $statement->execute();
       $results = $statement->fetchAll(PDO::FETCH_ASSOC);
       //$json = json_encode($results);
       
      Flight::json($results);
        });    


Flight::route('/supplier', function(){
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    $menu = menus();
    $db = Flight::db();
    $mclass=$db->query('select * from supplier')->fetchAll();
    echo $twig->render('supplier.php', array(
        'menu'  => $menu,
        'mclass'  => $mclass
        ));
    mclass(); 
});

Flight::route('/supplier/list', function(){
    $results=Flight::db()->query('select id,rtrim(name) as name from supplier')->fetchAll();
    Flight::json($results);
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