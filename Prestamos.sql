create table prestamos(
id_prestamo int primary key,
id_material int,
id_personal int,
fecha_salida date,
fecha_devolucion date,
cantidad int,
estatus varchar(1000),
foreign key (id_material) references material(id_material),
foreign key (id_personal) references personal(id_personal)
) ENGINE=InnoDB;