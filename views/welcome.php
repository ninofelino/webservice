<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="A front-end template that helps you build fast, modern mobile web apps.">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Material Design Lite Starter Project</title>
    <link rel="shortcut icon" href="favicon.png" />

    <!-- Fonts -->
    <link href='https://fonts.googleapis.com/css?family=Roboto:regular,bold,italic,thin,light,bolditalic,black,medium&amp;lang=en' rel='stylesheet' type='text/css'>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <!--font-awesome-->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">

    <link rel="stylesheet" href="vendor/material-design-lite/material.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.js"></script>
 
    <link rel="stylesheet" href="css/app.css">
    <link rel="stylesheet" href="css/components/icons--modifiers.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="https://code.getmdl.io/1.3.0/material.indigo-pink.min.css">
<script defer src="https://code.getmdl.io/1.3.0/material.min.js"></script>
</head>
<body>

<!-- Always shows a header, even in smaller screens. -->
<div class="mdl-layout mdl-js-layout mdl-layout--fixed-header">
    <header class="mdl-layout__header">
        <div class="mdl-layout__header-row">
            <!-- Title -->
            <span class="mdl-layout-title">Job Attractor</span>
            <!-- Add spacer, to align navigation to the right -->
            <div class="mdl-layout-spacer"></div>
            <!-- Navigation. We hide it in small screens. -->
            <nav class="mdl-navigation mdl-layout--large-screen-only">
                <a class="mdl-navigation__link" href="#">ABOUT</a>
                <a class="mdl-navigation__link" href="#">FAQ</a>
                <a class="mdl-navigation__link" href="#">BLOG</a>
                <a class="mdl-navigation__link" href="#">LOGIN</a>
            </nav>
            <!--Right aligned menu below button -->
            <div class="mdl-menu--headerWrapper">
                <button id="menu-speed" class="mdl-button mdl-js-button mdl-button--icon">
                    <i class="material-icons">more_vert</i>
                </button>
                <ul class="mdl-menu mdl-menu--bottom-right mdl-js-menu mdl-js-ripple-effect" for="menu-speed">
                    <li class="mdl-menu__item">Fast</li>
                    <li class="mdl-menu__item">Medium</li>
                    <li class="mdl-menu__item">Slow</li>
                </ul>
            </div>
        </div>
    </header>
    <div class="mdl-layout__drawer mdl-layout--small-screen-only">
        <span class="mdl-layout-title">Title</span>
        <nav class="mdl-navigation">
            <div id="badan"></div>
            <a class="mdl-navigation__link" href="#">ABOUT</a>
            <a class="mdl-navigation__link" href="#">FAQ</a>
            <a class="mdl-navigation__link" href="#">BLOG</a>
            <a class="mdl-navigation__link" href="#">LOGIN</a>
        </nav>
    </div>
    <main class="mdl-layout__content">
        <div class="page-content"><!-- Your content goes here -->
        <div class="content-grid mdl-grid">
  <div class="content-column mdl-cell mdl-cell--4-col mdl-cell--4-col-tablet mdl-cell--4-col-phone mdl-cell--top">
    <!-- add content here -->
    Lorem ipsum, dolor sit amet consectetur adipisicing elit. Reprehenderit, quia. Quaerat, vel neque adipisci autem nemo voluptates unde fuga asperiores aut veniam laudantium molestiae amet deleniti, nostrum dolores. Adipisci, dolorum?
  </div>
  <div class="content-column mdl-cell mdl-cell--4-col mdl-cell--4-col-phone mdl-cell--hide-tablet">
    <!-- also here -->
    

  </div>
  <div class="content-column mdl-cell mdl-cell--4-col mdl-cell--4-col-tablet mdl-cell--4-col-phone mdl-cell--bottom mdl-cell--hide-phone">
    <!-- and probably also here -->
  </div>
</div>
        
        
        </div>
    </main>
</div>

<script>
    $('#badan').load('menu');
</script> 

</body>
   

</html>