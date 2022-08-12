. /home/informix/.bashrc
dbaccess -e - << EOF
DROP DATABASE testdb;
CREATE DATABASE testdb with log;

--CREATE SEQUENCE empleados_id_seq;
CREATE TABLE empleados  (
        id              SERIAL NOT NULL,
        nombre      VARCHAR(50) NOT NULL,
        apellido    VARCHAR(50),
        fechaNacimiento DATETIME YEAR TO SECOND,
        update_ts   DATETIME YEAR TO SECOND DEFAULT current year to second NOT NULL,
        PRIMARY KEY(id)
        ENABLED
)
LOCK MODE ROW;

CREATE TABLE nvd_empleados  (
        id_nvd_empleados        SERIAL NOT NULL,
        nvd_cod             VARCHAR(10) NOT NULL,
        nvd_tipo            VARCHAR(6) NOT NULL,
        id                      INTEGER NOT NULL,
        last_modified       DATETIME YEAR to SECOND DEFAULT CURRENT YEAR to SECOND,
        estado_ws           SMALLINT DEFAULT 0
        )
LOCK MODE ROW;

CREATE INDEX nvd_empleados_index
        ON nvd_empleados(id);

CREATE INDEX nvd_empleados_index_1
        ON nvd_empleados(id_nvd_empleados);

-------------------------------------------------------------
--------------------- sp_lgs_novedades ----------------------
-------------------------------------------------------------
--DROP PROCEDURE sp_lgs_novedades;
CREATE PROCEDURE sp_lgs_novedades(
    p_id INTEGER,
    p_accion char(1),
    p_table char(10)
)
define p_id_exists INTEGER;
--let pre_exp_id_exists = 0;

-- Insertamos las novedades en las tablas correspondientes
IF p_table = "emp" THEN

          IF p_accion = "I" THEN

              INSERT INTO nvd_empleados (nvd_cod, nvd_tipo, id, estado_ws)
              values (p_table ,p_accion, p_id, 0);

          ELIF p_accion = "U" THEN
              SELECT COUNT(id) INTO p_id_exists FROM nvd_empleados WHERE id = p_id AND nvd_tipo = 'I';

              IF p_id_exists > 0 THEN
                    INSERT INTO nvd_empleados (nvd_cod, nvd_tipo, id, estado_ws)
                    values (p_table ,p_accion, p_id, 0);
              END IF

          ELIF p_accion = "D" THEN
                INSERT INTO nvd_empleados (nvd_cod, nvd_tipo, id, estado_ws)
                values (p_table ,p_accion, p_id, 0);

          END IF

ELIF p_table = "otra_tabla" THEN
            -- Otra acciones
END IF

END PROCEDURE;


-------------------------------------------------------------
-------------------- Trigger - nvd_empleados ----------------
-------------------------------------------------------------
CREATE TRIGGER tr_lgs_ins_emp insert on empleados referencing new as new_emp
for each row
        (
                execute procedure sp_lgs_novedades(new_emp.id, 'I' ,'emp' )
        );

CREATE TRIGGER tr_lgs_upd_emp update on empleados referencing new as new_emp
for each row
        (
                execute procedure sp_lgs_novedades(new_emp.id, 'U' ,'emp' )
        );

CREATE TRIGGER tr_lgs_del_emp delete on empleados referencing old as old_emp
for each row
        (
                execute procedure sp_lgs_novedades(old_emp.id, 'D' ,'emp' )
        );

SELECT * FROM empleados;

SELECT * FROM nvd_empleados;
EOF
