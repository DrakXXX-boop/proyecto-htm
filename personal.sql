create table personal(
id_personal int primary key,
nombre varchar(100),
puesto varchar(100),
foreign key (id_personal)
	references personal(id_personal)
    on delete cascade
    on update cascade
);