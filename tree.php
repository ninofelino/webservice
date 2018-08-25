
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

function nav()
{
    $result='';
    $sql=runsql("select id,parent_id,rtrim(name) as name,url,img from menus order by 1");
    $sql->execute();
    $arrayCategories = array();
    
    
    while($row = $sql->fetch())
    {
    // print $row[1].$row[0].'</br>';
     $arrayCategories[$row['id']] = array("parent_id" => $row['parent_id'], "name" =>                       
     $row['name'],"url"=>$row['url'],"img"=>$row['img'],"id"=>$row['id']);   
    }
    $result=createTree($arrayCategories, 0);
    return $result;
};
   

function createTree($array, $currentParent, $currLevel = 0, $prevLevel = -1) {
    $hasil='';
    foreach ($array as $categoryId => $category) {
    
    if ($currentParent == $category['parent_id']) {                       
       if ($currLevel > $prevLevel) $hasil.= ''; 
     //  $hasil.= '<li class="nav-item active">';
     if ($currLevel == $prevLevel) $hasil.= " ";
    // if ($currLevel == 0) $hasil.= '<li class="nav-item dropdown">';
    if ($currLevel == 0) $hasil.= '<a class="nav-link dropdown-toggle waves-effect waves-light" id="navbar'.$category['id'].'" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">'.$currLevel.$category['name'].'</a></li>';
    if ($currLevel == 1) $hasil.= '<a class="dropdown-item">'.$category['name'].'</a>';
       
        if ($currLevel > $prevLevel) { $prevLevel = $currLevel; }
    
        $currLevel++; 
          $hasil.='<div class="dropdown-menu dropdown-primary" aria-labelledby="navbarDropdownMenuLink">';
          $hasil.=createTree ($array, $categoryId, $currLevel, $prevLevel);
       $hasil.='</div>';
     //  if ($currLevel == 0) $hasil.= "</li> ";
        $currLevel--;               
        }   
    
    }
    
    if ($currLevel == $prevLevel) //$hasil.= " </li> ";
    //$hasil.= "</ul> ";
    return $hasil;
    }

function createTreeView($array, $currentParent, $currLevel = 0, $prevLevel = -1) {
    $hasil='';
    foreach ($array as $categoryId => $category) {
    
    if ($currentParent == $category['parent_id']) {                       
      //  if ($currLevel > $prevLevel) $hasil.= " <ul class='tree'> "; 
    
        if ($currLevel == $prevLevel) $hasil.= " ";
    
        $hasil.= '<a class="mdl-navigation__link" href="'.$category['url'].'"><i class="material-icons">'.$category['img'].'</i>'.$category['name'].'</a></span>';
    
        if ($currLevel > $prevLevel) { $prevLevel = $currLevel; }
    
        $currLevel++; 
    
        $hasil.=createTreeView ($array, $categoryId, $currLevel, $prevLevel);
    
        $currLevel--;               
        }   
    
    }
    
    if ($currLevel == $prevLevel) $hasil.= " </li> ";
    // </ul> ";
    return $hasil;
    }