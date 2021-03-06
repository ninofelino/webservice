<?php
require 'vendor/autoload.php';
include 'qry.php';
include 'tree.php';

Flight::register('db', 'PDO', array('pgsql:host=103.28.15.75;dbname=felino','deploy','nuansabaru123'));

Flight::route('/test', function(){
    $menu = menus();
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
   // echo $twig->render('test.html', array('name'  => 'Home'));
    linuxuser();
   
});

Flight::route('/route', function(){
    $menu = menus();
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    echo $twig->render('route.html', array('name'  => 'Home'));
   
   
});
Flight::route('/', function(){
    $menu = menus();
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    echo $twig->render('welcome.html', array(
    'name'  => 'Home',
  'city'  => 'Samarinda',
  'menu'    => $menu

));

});




Flight::route('/calendar', function(){
    $menu = menus();
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    echo $twig->render('calendar.html', array(
    'name'  => 'Home',
  'city'  => 'Samarinda',
  'menu'    => $menu

));

});


Flight::route('/login', function(){
    $menu = menus();
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    echo $twig->render('login.html', array(
    'name'  => 'Home',
  'city'  => 'Samarinda',
  'menu'    => $menu

));

});


Flight::route('/info', function(){
    $menu = menus();
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    echo $twig->render('info.html', array(
    'name'  => 'Home',
  'city'  => 'Samarinda',
  'menu'    => $menu

));

});

Flight::route('POST /login', 'login');


Flight::route('/barcode/@id', function($id){
    $sql = file_get_contents('views/sql/barcode.sql');
    $sql = $sql." where article like '".$id."%'";
    $db = Flight::db();
     $results=$db->query($sql)->fetchAll();
     Flight::json($results);
});


Flight::route('/infodb', function(){
    $sql = file_get_contents('views/sql/infodb.sql');
     $db = Flight::db();
     $results=$db->query($sql)->fetchAll();
     Flight::json($results);
});

Flight::route('/supplier/topten', function(){
    $sql = file_get_contents('views/sql/topsupplier.sql');
     $db = Flight::db();
     $results=$db->query($sql)->fetchAll();
     Flight::json($results);
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
         'name' => 'Product',
         'product'  => $product,
         'menu'  => $menu
     ));
  });


  Flight::route('/catagory/list', function(){
   
    // $product=product(); 
    $sql = file_get_contents('views/sql/catagory.sql');
    $db = Flight::db();
     $results=$db->query($sql)->fetchAll();
     Flight::json($results);
     
  });

  Flight::route('/images', function(){
    $menu = menus();
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    $sql = "select * from menus";
    $db = Flight::db();
    $brand=$db->query('select * from brands')->fetchAll();
    echo $twig->render('images.php', array(
        'name'  => 'Images',
        'brand'  => $brand,
        'menu'  => $menu
    ));
   
    });


    Flight::route('/menu', function(){
        $sql = file_get_contents('views/sql/menu.sql');
        $db = Flight::db();
         $results=$db->query($sql)->fetchAll();
         //Flight::json($results);
         header('Content-Type: application/json');
         echo '{"menu":'.json_encode($results).'}' ;
        });

        Flight::route('/nav', function(){
            $menu = nav();
           
            echo $menu; 
            
           
            });      


  Flight::route('/images/@id', function($id){
    
    $gb=find("../img/_sfpg_data/thumb/",$id."*.jpg");
   // print_r($gb);
    foreach($gb as $gambar){
        echo '<div class="mdl-cell mdl-cell--3-col">';
        echo basename($gambar).'<br>';
        echo '<img src="http://103.28.15.75:8069/'.$gambar.'">';
        echo '</div>';
    }
    
});

Flight::route('/script', function(){
    echo "images";
    print_r(glob("/var/www/html/*.JPG"));
});


Flight::route('/syncron', function(){
    echo "Syncron";
   // $output = passthru('sh /var/www/html/api/script/pr.sh');
   $output = passthru('top');
    echo $output;
});

Flight::route('/product/list', function(){
   
    // $product=product(); 
    $sql = file_get_contents('views/sql/pr.supplier.detail.sql');
    $db = Flight::db();
     $results=$db->query($sql)->fetchAll();
     Flight::json($results);
     
  });

  Flight::route('/product/supplier/@id', function($id){
   
    // $product=product(); 
    $sql = file_get_contents('views/sql/pr.supplier.detail.sql');
    $sql .=" where supplier='".$id."'";
    echo $sql;
    $db = Flight::db();
     $results=$db->query($sql)->fetchAll();
    Flight::json($results);
     
  });

  Flight::route('/directory/@dir', function($dir){
   
   
    imagelist("/var/www/html/images","*.jpg");
     
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

  Flight::route('/pos', function(){
    $menu = menus();
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    $sql = "select * from menus";
    $db = Flight::db();
    $brand=$db->query('select * from brands')->fetchAll();
    
    //echo print_r($brand);
    echo $twig->render('pos.html', array(
        'name'  => 'Point Of Sale',
        'brand'  => $brand,
        'menu'  => $menu
    ));
   
    });

    Flight::route('/terminal', function(){
        $loader = new Twig_Loader_Filesystem('views');
        $twig = new Twig_Environment($loader);
       echo $twig->render('terminal.html');
       
        });


  Flight::route('/brand', function(){
    $menu = menus();
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    $sql = "select * from menus";
    $db = Flight::db();
    $brand=$db->query('select * from brands')->fetchAll();
    echo $twig->render('brand.php', array(
        'name'  => 'Brand',
        'brand'  => $brand,
        'menu'  => $menu
    ));
   
    });


    Flight::route('/upload/home', function(){
        $menu = menus();
        $loader = new Twig_Loader_Filesystem('views');
        $twig = new Twig_Environment($loader);
        $sql = "select * from menus";
        $db = Flight::db();
        $brand=$db->query('select * from brands')->fetchAll();
        echo $twig->render('upload.php', array(
            'name'  => 'Brand',
            'brand'  => $brand,
            'menu'  => $menu
        ));
       
        });

        Flight::route('/upload/post', function(){
            $target_dir = "uploads/";
            $target_file = $target_dir . basename($_FILES["fileToUpload"]["name"]);
            $uploadOk = 1;
            $imageFileType = strtolower(pathinfo($target_file,PATHINFO_EXTENSION));
            // Check if image file is a actual image or fake image
            if(isset($_POST["submit"])) {
                $check = getimagesize($_FILES["fileToUpload"]["tmp_name"]);
                if($check !== false) {
                    echo "File is an image - " . $check["mime"] . ".";
                    $uploadOk = 1;
                } else {
                    echo "File is not an image.";
                    $uploadOk = 0;
                }
            } 
           
           echo "Success";
            });

    Flight::route('/brand/list', function(){
        $sql = file_get_contents('views/sql/brand.sql');
        $db = Flight::db();
         $results=$db->query($sql)->fetchAll();
         Flight::json($results);
     });
     

     Flight::route('/dbf', function(){
        $loader = new Twig_Loader_Filesystem('views');
        $twig = new Twig_Environment($loader);
        $sql = "select * from menus";
        $db = Flight::db();
        $brand=$db->query('select * from brands')->fetchAll();
        echo $twig->render('dbf.html', array(
            'name'  => 'Brand',
            'brand'  => $brand
        ));
     });


     Flight::route('/samba', function(){
       echo file_get_contents('/etc/samba/smb.conf');
     });

     Flight::route('/dbf/list', function(){
        Flight::json(getFileList('/var/www/html/DAT'));
     });

     Flight::route('/dir/@id', function($id){


      
        $a=array("sales"=>"/srv/samba/share/SALES",
                 "dbf"=>"/var/www/html/DAT");
        echo $id;
        echo array_search($id,$a);
        Flight::json(getFileList(array_search("sales",$a)));
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
                'name'  => 'Colour',
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
        
        Flight::route('/po', function(){
            $menu = menus();
            $loader = new Twig_Loader_Filesystem('views');
            $twig = new Twig_Environment($loader);
            $sql = "select * from menus";
            $db = Flight::db();
            $brand=$db->query('select colour from product group by colour')->fetchAll();
            
            //echo print_r($brand);
            echo $twig->render('po.html', array(
                'name'  => 'Frey',
                'brand'  => $brand,
                'menu'  => $menu
            ));
           
        }); 

        Flight::route('/install', function(){
            $menu = menus();
            $loader = new Twig_Loader_Filesystem('views');
            $twig = new Twig_Environment($loader);
            $sql = "select * from menus";
            $db = Flight::db();
            $brand=$db->query('select colour from product group by colour')->fetchAll();
            
            //echo print_r($brand);
            echo $twig->render('install.html', array(
                'name'  => 'Frey',
                'brand'  => $brand,
                'menu'  => $menu
            ));
           
        }); 


        Flight::route('/server', function(){
            $menu = menus();
            $loader = new Twig_Loader_Filesystem('views');
            $twig = new Twig_Environment($loader);
            $sql = "select * from menus";
            $db = Flight::db();
            $brand=$db->query('select colour from product group by colour')->fetchAll();
            
            //echo print_r($brand);
            echo $twig->render('server.php', array(
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
Flight::route('/branchlistFolderFiles/list', function(){
    
    $pdo = new PDO("pgsql:dbname=felino;host=103.28.15.75", "deploy", "nuansabaru123");
 $statement = $pdo->prepare("SELECT * FROM branch");
$statement->execute();
$results = $statement->fetchAll(PDO::FETCH_ASSOC);
//$json = json_encode($results);

Flight::json($results);
  //return $json;
   
});

Flight::route('/branch/list', function(){
    
    $sql = file_get_contents('views/sql/branch.sql');
    $db = Flight::db();
    $results=$db->query($sql)->fetchAll();
    
    Flight::json($results);
  
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
        'name'  => 'Branch',
        'size'  => $brand,
        'menu'  => $menu
    ));
   
});

Flight::route('/member', function(){
    $menu = menus();
   // $sql = file_get_contents('views/sql/pr.size.sql');
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

Flight::route('/member/list', function(){
    
    $sql = file_get_contents('views/sql/member.sql');
    $db = Flight::db();
    $results=$db->query($sql)->fetchAll();
    
    Flight::json($results);
  
});

Flight::route('/memberlevel/list', function(){
    
    $sql = file_get_contents('views/sql/memberlevel.sql');
    $db = Flight::db();
    $results=$db->query($sql)->fetchAll();
    
    Flight::json($results);
  
});

Flight::route('/member/@id', function($id){
    
    $sql = file_get_contents('views/sql/member.sql');
    $sql = $sql." where name like '".$id."%' LIMIT 20";
    $db = Flight::db();
    $results=$db->query($sql)->fetchAll();
    Flight::json($results);
  
});


Flight::route('/mclass', function(){
    $loader = new Twig_Loader_Filesystem('views');
    $twig = new Twig_Environment($loader);
    $menu = menus();
    $db = Flight::db();
    $mclass=$db->query('select * from mclass')->fetchAll();
    echo $twig->render('mclass.php', array(
            'name' =>'Mclass',
            'menu'  => $menu,
            'mclass'  => $mclass
            ));
    }); 

    Flight::route('/terminal', function(){
        $loader = new Twig_Loader_Filesystem('views');
        $twig = new Twig_Environment($loader);
        $menu = menus();
        $db = Flight::db();
        $mclass=$db->query('select * from mclass')->fetchAll();
        echo $twig->render('terminal.php', array(
                'name' =>'Mclass',
                'menu'  => $menu,
                'mclass'  => $mclass
                ));
        }); 

    Flight::route('/mclass/list', function(){
        $pdo = new PDO("pgsql:dbname=felino;host=103.28.15.75", "deploy", "nuansabaru123");
        $sql = file_get_contents('views/sql/mclass.sql');
        $statement = $pdo->prepare($sql);
       $statement->execute();
       $results = $statement->fetchAll(PDO::FETCH_ASSOC);
      
       
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
   // mclass(); 
});

Flight::route('/supplier/list', function(){
    $results=Flight::db()->query('select id,rtrim(name) as name from supplier')->fetchAll();
    Flight::json($results);
});

Flight::route('/pr.supplier', function(){
    productSupplier(); 
 });


 Flight::route('/purchaseOrder', function(){
       echo "Purchase Order";
 });


 Flight::route('/syncron', function(){
    $output=shell_exec('script/sh pr.sh');
   print_r($output);
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

function print_lilistFolderFilesst($array, $parent=0) {
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


