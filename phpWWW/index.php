<?php
phpinfo();
    /**
     * Mysql Connect
     */
    $servernameMySQL = 'localhost';
    $usernameMySQL = 'root';
    $passwordMySQL = 'root';

    try {
        $connMySQL = new PDO("mysql:host=$servernameMySQL;dbname=mysql", $usernameMySQL, $passwordMySQL);
        if (!$connMySQL) {
            echo "MySQL: Connection failed!!! \n";
        }
        // set the PDO error mode to exception
        $connMySQL->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        echo "MySQL: Connected successfully \n"; 
    } catch(PDOException $e) {
        echo "MySQL: Connection failed: " . $e->getMessage() . "\n";
    }

    echo "<br />";

    /**
     * PostgreSQL Connect
     */
    $servernamePostgres = 'localhost';
    $usernamePostgres = 'postgres';
    $passwordPostgres = 'root';

    try {
        $connPostgres = pg_connect("host=$servernamePostgres port=5432 dbname=postgres user=$usernamePostgres password=$passwordPostgres");
        if ($connPostgres) {
            echo "PostgreSQL: Connected successfully \n"; 
        } else {
            echo "PostgreSQL: Connection failed!!! \n";
        }
    } catch(PDOException $e) {
        echo "PostgreSQL: Connection failed: " . $e->getMessage() . "\n";
    }

    echo "<br />";

    /**
     * MongoDB Connect
     */
    $servernameMongo = 'mongodb://localhost:27017';

    try {
        $connMongo = new MongoDB\Driver\Manager($servernameMongo);
        if ($connMongo) {
            echo "MongoDB: Connected successfully \n"; 
        } else {
            echo "MongoDB: Connection failed!!! \n";
        }
    } catch(Exception $e) {
        echo "MongoDB: Connection failed: " . $e->getMessage() . "\n";
    }
?>
