<?php
// Incluye el archivo de conexión
include 'conexion.php';
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Recuperar los datos del formulario (usando los 'name' del HTML)
    $nombre_objeto = $conexion->real_escape_string($_POST['nombre']);
    $uso_funcion = $conexion->real_escape_string($_POST['funcion']);
    $cantidad = (int)$_POST['cantidad'];
    
    // Consulta SQL para INSERTAR datos
    $sql = "INSERT INTO inventario (Nombre, Uso, Cantidad) 
            VALUES ('$nombre_objeto', '$uso_funcion', $cantidad)";

    if ($conexion->query($sql) === TRUE) {
        echo "<h1>✅ ¡Registro guardado con éxito!</h1>";
        echo "<p>El objeto '<strong>$nombre_objeto</strong>' ha sido añadido al inventario.</p>";
        echo "<br><a href='index.html'>Volver al formulario</a>";
    } else {
        echo "<h1>❌ Error al guardar los datos</h1>";
        // El mensaje de error de MySQL (clave para la depuración)
        echo "<p>Detalles del error: " . $conexion->error . "</p>";
        echo "<br><a href='index.html'>Volver al formulario</a>";
    }

    $conexion->close();
} else {
    echo "Acceso no permitido.";
}
?>