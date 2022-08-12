. /home/informix/.bashrc
dbaccess -e testdb << EOF
UPDATE empleados set nombre = 'Sebastian', update_ts = (select CURRENT) where nombre = 'Julian';
EOF
