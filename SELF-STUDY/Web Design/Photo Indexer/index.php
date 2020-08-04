<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css?family=Rochester|Vollkorn+SC&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/baguettebox.js/1.8.1/baguetteBox.min.css">
    <link rel="stylesheet" href="../../gallery-grid.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
    <title>Chanelle & David's Wedding Album</title>
</head>

<body>
    <div class="container gallery-container">
        <div class="tz-gallery">
            <div class="row">
                <!-- php script to scan directory for images and output them in a lightbox -->
                <?php
                $files = glob("*.*");
                for ($i = 0; $i < count($files); $i++) {
                    $image = $files[$i];
                    $supported_file = array(
                        'gif',
                        'jpg',
                        'jpeg',
                        'png'
                    );

                    $ext = strtolower(pathinfo($image, PATHINFO_EXTENSION));
                    if (in_array($ext, $supported_file)) {
                        echo '<div class="col-sm-6 col-md-4">';
                        echo '<a class="lightbox" href="' . $image . '">';
                        echo '<img src="' . $image . '" loading="lazy" alt="' . basename($image, ".jpg") . '" />' . "\n";
                        echo '</a>' . "\n";
                        echo '</div>' . "\n\n";
                    } else {
                        continue;
                    }
                }
                ?>
            </div>

        </div>

    </div>
    <!-- Script to handle the lightbox -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/baguettebox.js/1.8.1/baguetteBox.min.js"></script>
    <script>
        baguetteBox.run('.tz-gallery');
    </script>
</body>

</html>