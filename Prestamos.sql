create table prestamos(
id_prestamo int primary key,
id_material int,
id_personal int,
fecha_salida date,
fecha_devolucion date,
cantidad int,
estatus varchar(1000)
);