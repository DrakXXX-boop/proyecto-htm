<?php
$servidor = "localhost"; 
$usuario = "root";
$password = ""; 
$base_de_datos = "inventario_db";

$conexion = new mysqli($servidor, $usuario, $password, $base_de_datos);

if ($conexion->connect_error) {
 die("La conexión falló: " . $conexion->connect_error);
}

$conexion->set_charset("utf8");
?>