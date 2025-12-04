create table material(
id_material int primary key,
nombre varchar(100),
descripcion varchar(1000),
id_taller int,
cantidad int,
estado varchar(100),
foreign key (id_taller)
    references taller(id_taller)
    on delete cascade
    on update cascade
);