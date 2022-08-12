. /home/informix/.bashrc
dbaccess -e testdb << EOF
delete from empleados where nombre = 'Sebastian';
EOF
