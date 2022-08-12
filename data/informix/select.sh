. /home/informix/.bashrc
dbaccess -e testdb << EOF
select * from empleados;
EOF
