
<?php
include "run.php";

function menus()
{
    $result='';
    $sql=runsql("select * from menus order by 1");
    $sql->execute();
    $arrayCategories = array();
    
    
    while($row = $sql->fetch())
    {
    // print $row[1].$row[0].'</br>';
     $arrayCategories[$row['id']] = array("parent_id" => $row['parent_id'], "name" =>                       
     $row['name'],"url"=>$row['url'],"img"=>$row['img']);   
    }
    $result=createTreeView($arrayCategories, 0);
    return $result;
};

   

function createTreeView($array, $currentParent, $currLevel = 0, $prevLevel = -1) {
    $hasil='';
    foreach ($array as $categoryId => $category) {
    
    if ($currentParent == $category['parent_id']) {                       
        if ($currLevel > $prevLevel) $hasil.= " <ul class='tree'> "; 
    
        if ($currLevel == $prevLevel) $hasil.= " ";
    
        $hasil.= '<a class="mdl-navigation__link" href="'.$category['url'].'"><i class="material-icons">'.$category['img'].'</i>'.$category['name'].'</a></span>';
    
        if ($currLevel > $prevLevel) { $prevLevel = $currLevel; }
    
        $currLevel++; 
    
        $hasil.=createTreeView ($array, $categoryId, $currLevel, $prevLevel);
    
        $currLevel--;               
        }   
    
    }
    
    if ($currLevel == $prevLevel) $hasil.= " </li>  </ul> ";
    return $hasil;
    }