<?php
include "conexion.php";

$sql = "SELECT * FROM inventario_general ORDER BY area, categoria";
$consulta = $conexion->query($sql);

echo "<h2>Inventario General</h2>";
echo "<table border='1' cellpadding='5'>";

echo "<tr>
        <th>Área</th>
        <th>Responsable</th>
        <th>Categoría</th>
        <th>Item</th>
        <th>Marca</th>
        <th>Modelo</th>
        <th>Cantidad</th>
        <th>Estado</th>
        <th>Fecha</th>
      </tr>";

while ($fila = $consulta->fetch_assoc()) {
    echo "<tr>
            <td>{$fila['area']}</td>
            <td>{$fila['responsable']}</td>
            <td>{$fila['categoria']}</td>
            <td>{$fila['item']}</td>
            <td>{$fila['marca']}</td>
            <td>{$fila['modelo']}</td>
            <td>{$fila['cantidad']}</td>
            <td>{$fila['estado']}</td>
            <td>{$fila['fecha']}</td>
          </tr>";
}

echo "</table>";
?>
