. /home/informix/.bashrc
dbaccess -e testdb << EOF
insert into empleados (nombre, apellido, fechanacimiento) values ('Julian', 'Blasco', (select CURRENT));

insert into empleados (nombre, apellido, fechanacimiento) values ('Micaela', 'Gonzalez', (select CURRENT));

EOF
