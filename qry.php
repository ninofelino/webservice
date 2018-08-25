<?php
require_once 'dbconfig.php';


function listFolderFiles($dir){
    $ffs = scandir($dir);

    unset($ffs[array_search('.', $ffs, true)]);
    unset($ffs[array_search('..', $ffs, true)]);

    // prevent empty ordered elements
    if (count($ffs) < 1)
        return;

    echo '<ol>';
    foreach($ffs as $ff){
        echo '<li>'.$ff;
        if(is_dir($dir.'/'.$ff)) listFolderFiles($dir.'/'.$ff);
        echo '</li>';
    }
    echo '</ol>';
}

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


function Xproduct(){
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

function getFileList($dir)
  {
    // array to hold return value
    $retval = [];

    // add trailing slash if missing
    if(substr($dir, -1) != "/") {
      $dir .= "/";
    }

    // open pointer to directory and read list of files
    $d = @dir($dir) or die("getFileList: Failed opening directory {$dir} for reading");
    while(FALSE !== ($entry = $d->read())) {
      // skip hidden files
      if($entry{0} == ".") continue;
      if(is_dir("{$dir}{$entry}")) {
        $retval[] = [
          'name' => "{$dir}{$entry}/",
          'type' => filetype("{$dir}{$entry}"),
          'size' => 0,
          'lastmod' => filemtime("{$dir}{$entry}")
        ];
      } elseif(is_readable("{$dir}{$entry}")) {
        $retval[] = [
          //'name' => "{$dir}{$entry}",
          'name' => "{$entry}",
         // 'type' => mime_content_type("{$dir}{$entry}"),
          'size' => filesize("{$dir}{$entry}"),
          'lastmod' => filemtime("{$dir}{$entry}")
        ];
      }
    }
    $d->close();

    return $retval;
  }

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

    


     function find($dir, $pattern){
        // escape any character in a string that might be used to trick
        // a shell command into executing arbitrary commands
        $dir = escapeshellcmd($dir);
        // get a list of all matching files in the current directory
        $files = glob("$dir/$pattern");
        // find a list of all directories in the current directory
        // directories beginning with a dot are also included
        foreach (glob("$dir/{.[^.]*,*}", GLOB_BRACE|GLOB_ONLYDIR) as $sub_dir){
            $arr   = find($sub_dir, $pattern);  // resursive call
            $files = array_merge($files, $arr); // merge array with files from subdirectory
        }
        // return all found files 
        return $files;
    }

?>     