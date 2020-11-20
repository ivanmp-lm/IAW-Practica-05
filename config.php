<?php

define('DB_HOST', 'REPLACE_THIS_PATH');
define('DB_NAME', 'lamp_db');
define('DB_USER', 'ubuntu');
define('DB_PASSWORD', 'root');

$mysqli = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

?>
