module ReplaceScaffold
  module Generators
    # Custom scaffolding generator
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelper

            desc "appends CSS to application.scss"  

      File.open("application.scss", "a+"){|f| f << 
"
body {
    margin-top: 50px;
}

.header-image {
    display: block;
    width: 100%;
    text-align: center;
    background: url('http://placeholder.it/1900x500') no-repeat center center scroll;
    -webkit-background-size: cover;
    -moz-background-size: cover;
    background-size: cover;
    -o-background-size: cover;
}

.headline {
    padding: 120px 0;
}

.headline h1 {
    font-size: 130px;
    background: #fff;
    background: rgba(255,255,255,0.9);
}

.headline h2 {
    font-size: 77px;
    background: #fff;
    background: rgba(255,255,255,0.9);
}

.featurette-divider {
    margin: 80px 0;
}

.featurette {
    overflow: hidden;
}

.featurette-image.pull-left {
    margin-right: 40px;
}

.featurette-image.pull-right {
    margin-left: 40px;
}

.featurette-heading {
    font-size: 50px;
}

footer {
    margin: 50px 0;
}

@media(max-width:1200px) {
    .headline h1 {
        font-size: 140px;
    }

    .headline h2 {
        font-size: 63px;
    }

    .featurette-divider {
        margin: 50px 0;
    }

    .featurette-image.pull-left {
        margin-right: 20px;
    }

    .featurette-image.pull-right {
        margin-left: 20px;
    }

    .featurette-heading {
        font-size: 35px;
    }
}

@media(max-width:991px) {
    .headline h1 {
        font-size: 105px;
    }

    .headline h2 {
        font-size: 50px;
    }

    .featurette-divider {
        margin: 40px 0;
    }

    .featurette-image {
        max-width: 50%;
    }

    .featurette-image.pull-left {
        margin-right: 10px;
    }

    .featurette-image.pull-right {
        margin-left: 10px;
    }

    .featurette-heading {
        font-size: 30px;
    }
}

@media(max-width:768px) {
    .container {
        margin: 0 15px;
    }

    .featurette-divider {
        margin: 40px 0;
    }

    .featurette-heading {
        font-size: 25px;
    }
}

@media(max-width:668px) {
    .headline h1 {
        font-size: 70px;
    }

    .headline h2 {
        font-size: 32px;
    }

    .featurette-divider {
        margin: 30px 0;
    }
}

@media(max-width:640px) {
    .headline {
        padding: 75px 0 25px 0;
    }

    .headline h1 {
        font-size: 60px;
    }

    .headline h2 {
        font-size: 30px;
    }
}

@media(max-width:375px) {
    .featurette-divider {
        margin: 10px 0;
    }

    .featurette-image {
        max-width: 100%;
    }

    .featurette-image.pull-left {
        margin-right: 0;
        margin-bottom: 10px;
    }

    .featurette-image.pull-right {
        margin-bottom: 10px;
        margin-left: 0;
    }
}" }

 
  end
end