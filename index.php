
        <?php
        $host = "localhost";
        $usuario = "root";
        $clave = "";
        $bd = "inventario_db";
        
        $conexion = new mysqli($host, $usuario, $clave, $bd);
        
        
        if ($conexion->connect_error) {
            die("Error de conexion: " . $conexion->connect_error);
        }
        ?>
