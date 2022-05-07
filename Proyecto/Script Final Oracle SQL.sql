ALTER SESSION SET "_ORACLE_SCRIPT" = true;
SET SERVEROUTPUT ON -- Para que nos de salida por consola 
---------------------------------------------------------------
------------- 1) GESTION DE USUARIOS Y TABLAS -----------------
---------------------------------------------------------------

-------------------------
-- 1. Usuario "GESTOR" --
-------------------------
CREATE USER GESTOR IDENTIFIED BY 1234; -- Creamos usuario
GRANT CREATE SESSION TO GESTOR; -- Permisos de conexion

GRANT ALTER ON alumnos_pac TO GESTOR; -- Permisos para alterar la tabla alumnos_pac 
GRANT ALTER ON asignaturas_pac TO GESTOR; -- Permisos para alterar la tabla asignaturas_pac 

------------------------------------------------------------------------
--- Nos conectamos al usuario GESTOR y realizamos todos estos cambios---
------------------------------------------------------------------------
ALTER TABLE ilerna_pac.alumnos_pac ADD ciudad VARCHAR(30); -- Anadimos la columna ciudad a la tabla alumnos
ALTER TABLE ilerna_pac.asignaturas_pac MODIFY nombre_profesor VARCHAR(50); -- Modificamos a VARCHAR(50) la columna nombre_profesor de la tabla asignaturas
ALTER TABLE ilerna_pac.asignaturas_pac DROP COLUMN creditos; -- Eliminamos la columna creditos de la tabla asignaturas
ALTER TABLE ilerna_pac.asignaturas_pac ADD ciclo VARCHAR(3); -- Anadimos la columna ciclo a la tabla asignatura
    
--------------------------    
-- 2. Usuario "DIRECTOR"--
--------------------------
CREATE ROLE rol_director; -- Creamos el rol 
CREATE USER director IDENTIFIED BY 1234; -- Creamos el usuario

GRANT CREATE SESSION TO director;
GRANT SELECT, INSERT, UPDATE ON alumnos_pac TO rol_director;
GRANT SELECT, INSERT, UPDATE ON asignaturas_pac TO rol_director;

GRANT rol_director TO director; -- Damos el rol a director --

INSERT INTO ILERNA_PAC.alumnos_pac(id_alumno) --Anadimos valores a la tabla alumnos_pac --
 VALUES ('LIARSA');

INSERT INTO ILERNA_PAC.asignaturas_pac(id_asignatura, nombre_asignatura, nombre_profesor, ciclo) --Anadimos valores a la tabla asignatura
VALUES ('DAX_M02B', 'MP2.Bases de datos B', 'Guillem Mauri', 'DAX');

UPDATE ILERNA_PAC.asignaturas_pac SET ciclo = 'DAM' WHERE id_asignatura = 'DAX_M02B'; -- Realizamos una modificacion a el campo ciclo con un id especifico

---------------------------------------------------------------
-- 2)	BLOQUES ANONIMOS -------------------------------------- 
---------------------------------------------------------------
--  PUNTOS ACTUALES

/*
Creamos un bloque anonimo que muestre:
- Puntos actuales
- Ranking
- Puntos actuales + 300

Creamos 3 variables que en las que guardas valores 
- Contador
- Input en el que meter un numero de jugador
- Variable que guarda la acumulacion de puntos

Seleccionamos los puntos de el jugador que hayamos introducido a traves del input
Hacemos un While LOOP que se repita 4 veces como indica el enunciado 

Hacemos if con el que filtar el rango en el que se encuentra y lo anadimos con un update set

Fuera del if le anadimos +300 a la variable puntos que hemos almacenado dentro del bloque.

Todo este proceso se realizara 4 veces (1 de inicio y 3 vueltas)
Mostrando un resultado difrente 4 veces 
*/


-- DECLARAMOS 2 VARIABLES 
/
DECLARE
puntos_actuales NUMBER(10, 2):=0; --Variable con los puntos 
v_counter NUMBER(2) :=1; -- Contador para el loop
jugador_seleccionado NUMBER(2);

BEGIN
    jugador_seleccionado := &jug_selec;
    SELECT puntos INTO puntos_actuales FROM jugadores_pac WHERE id_jugador=jugador_seleccionado;
    WHILE v_counter <= 4 LOOP -- Realizar el codigo mientras el contador sea menor o igual a 4
    
    -- Anadimos condicionales para los diferentes casos que pueden existir
    -- En todos los casos posibles se ejecutara una salida por consola que muestre los puntos actuales y el ranking actual
    
    -- Caso entre 0 y 1000 - ranking bronce
        IF puntos_actuales BETWEEN 0 AND 1000 THEN
            dbms_output.put_line('Puntos actuales: '||puntos_actuales); 
            UPDATE jugadores_pac SET ranking='Bronze' WHERE id_jugador=jugador_seleccionado;
            dbms_output.put_line('Ranking: Bronze');
            
      -- Caso entre 1001 y 1400 - ranking plata
        ELSIF puntos_actuales BETWEEN 1001 AND 1400 THEN 
            dbms_output.put_line('Puntos actuales: '||puntos_actuales);
            UPDATE jugadores_pac SET ranking='Plata' WHERE id_jugador=jugador_seleccionado;
            dbms_output.put_line('Ranking: Plata');
    
      -- Caso entre 1401 y 1800 - ranking oro
        ELSIF puntos_actuales BETWEEN 1401 AND 1800 THEN 
            dbms_output.put_line('Puntos actuales: '||puntos_actuales);
            UPDATE jugadores_pac SET ranking='Oro' WHERE id_jugador=jugador_seleccionado;
            dbms_output.put_line('Ranking: Oro');
    
      -- Caso entre 1801 y 2200 - ranking platino
        ELSIF puntos_actuales BETWEEN 1801 AND 2200 THEN 
            dbms_output.put_line('Puntos actuales: '||puntos_actuales);
            UPDATE jugadores_pac SET ranking='Platino' WHERE id_jugador=jugador_seleccionado;
            dbms_output.put_line('Ranking: Platino');
    
      -- Caso entre 2201 y 99999 - ranking diamante
        ELSIF puntos_actuales BETWEEN 2001 AND 99999 THEN 
            dbms_output.put_line('Puntos actuales: '||puntos_actuales);
            UPDATE jugadores_pac SET ranking='Diamante' WHERE id_jugador=jugador_seleccionado;
            dbms_output.put_line('Ranking: Diamante');
        ELSE
             dbms_output.put_line('Tus puntos no entran dentro de los valores establecidos por el ranking -> '||puntos_actuales);
        END IF;
        
        -- Fuera del IF agregamos siempre +1 al contador
        -- Tambien anadimos el incremento a los puntos actuales y los mostramos por pantalla
        
        puntos_actuales := puntos_actuales+300;
        UPDATE jugadores_pac SET puntos = puntos_actuales WHERE id_jugador=jugador_seleccionado;
        
        v_counter := v_counter + 1;
        dbms_output.put_line('Incremento de 300: '||puntos_actuales);
        dbms_output.put_line(''); --Linea para separar las salidas de consola cada vez que ejecuta el bucle
        
    END LOOP;
    END;

---------------------------------------------------------------
-- 3)	PROCEDIMIENTOS Y FUNCIONES SIMPLES -------------------- 
---------------------------------------------------------------

--  NUMERO MAYOR
/*

Funcion con 3 parametros (3 numeros) y nos dice cual es el mas grande 

Realizamos 1 IF para saber que no hay ningun numero igual, en caso de que lo haya devolvemos que no se puede.
Realizamos otros 2 IF para comparar si el num1 es mas grande que los demas o el num2 es mas grande que los demas.
Realizamos un ELSE dando a opcion el que si ninguno de estos es el mas grande entoces es el numero 3

como es una funcion devolvemos el numero mas grande con un return
*/

/
CREATE FUNCTION numero_mayor (num1 NUMBER, num2 NUMBER, num3 NUMBER)
RETURN VARCHAR
AS
    num_mayor VARCHAR(100);
BEGIN

    IF num1 != num2 OR num1 != num3 OR num3 != num2 THEN -- IF para saber si NO se repiten numeros 
        -- 2 IF y un ELSE para comparar los numeros y el mas grande es el que se devolvera
        IF num1 > num2 AND num1 > num3 THEN
            num_mayor:=num1;
        ELSIF num2 > num1 AND num2 > num3 THEN
            num_mayor:=num2;
        ELSE 
            num_mayor:=num3;
        END IF;
    ELSE  -- ELSE por si algun numero se repite 
        num_mayor := 'No se pueden repetir n�meros en la secuencia';
    END IF;
    RETURN(num_mayor);
END;

---------------------------------------------------------------
-- 4)	PROCEDIMIENTOS Y FUNCIONES COMPLEJAS ------------------ 
---------------------------------------------------------------

--  NUMERO DE JUGADORES POR RANKING
-- Funcion de para mostrar la cantidad de jugadores por ranking que hay 

/
CREATE FUNCTION jugadores_por_ranking (ranking_act VARCHAR) -- Pasamos por parametro un valor que haga referencia a la columna ranking de la tabla jugadores_pac
RETURN NUMBER -- Devolvemos un numero
AS
    num_jugadores NUMBER(3); -- Variable en la que almacenar el num de jugadores por ranking
BEGIN
    SELECT COUNT(*) INTO num_jugadores FROM ilerna_pac.jugadores_pac WHERE ranking = ranking_act; -- Select con el ranking seleccionado que nos haga la cuenta de las filas con ese ranking
    RETURN num_jugadores; -- Devolvemos el contador con el num de personas en ese ranking
END;

---------------------------------------------------------------
-- 5)	GESTIÓN DE TRIGGERS ----------------------------------- 
---------------------------------------------------------------

-- Crear un trigger automatico que realiza un update al ranking automaticamente despues de realizar un update a los puntos 
/
CREATE OR REPLACE TRIGGER cambio_ranking_jugador BEFORE
    UPDATE OF puntos ON jugadores_pac -- tabla en la que se realizara
    FOR EACH ROW -- Por cada linea que hagamos update
DECLARE
    v_puntos NUMBER(10,2); 
    v_nombre VARCHAR2(20);
    v_hora VARCHAR2(20);
    v_fecha DATE;
BEGIN   
    v_nombre:= :new.nombre; -- Guardamos el nombre del usuario de la linea que hemos hecho update 
    v_puntos:= :new.puntos; -- Guardamos los puntos del usuario de la linea que hemos hecho update 
    
    SELECT to_char(sysdate, 'HH24:MI:ss') INTO v_hora FROM dual; -- Guardamos la hora de la modificacion en una variable 
        
    SELECT sysdate INTO v_fecha FROM dual; -- Guardamos la fecha en una variable
    
    -- cadena de if y elsif para filtrar los puntos actuales de la linea a la que se le ha hecho update y cambiar el ranking acorde a los puntos introducidos
        IF v_puntos BETWEEN 0 AND 1000 THEN
            :new.ranking := 'Bronze';
            
      -- Caso entre 1001 y 1400 - ranking plata
        ELSIF v_puntos BETWEEN 1001 AND 1400 THEN 
            :new.ranking := 'Plata';
            
      -- Caso entre 1401 y 1800 - ranking oro
        ELSIF v_puntos BETWEEN 1401 AND 1800 THEN 
            :new.ranking := 'Oro';
            
      -- Caso entre 1801 y 2200 - ranking platino
        ELSIF v_puntos BETWEEN 1801 AND 2200 THEN 
            :new.ranking := 'Platino';
            
      -- Caso entre 2201 y 99999 - ranking diamante
        ELSIF v_puntos BETWEEN 2001 AND 99999 THEN 
            :new.ranking := 'Diamante';
        END IF; -- Terminamos el IF
    -- Sacamos por pantalla un mensaje con las 4 variables recogidas mas el antiguo ranking
    DBMS_OUTPUT.PUT_LINE('El ranking del jugador '|| v_nombre || ' se ha modificado el dia '||v_fecha||' '||v_hora||', antes era '||:old.ranking||' y ahora es '||:new.ranking);
END;

---------------------------------------------------------------
-- 6)   BLOQUES ANÓNIMOS PARA PRUEBAS DE CÓDIGO --------------- 
---------------------------------------------------------------

-- 1.	COMPROBACIÓN REGISTROS DE TABLAS
/
EXECUTE dbms_output.put_line('-- 1.	COMPROBACIÓN REGISTROS DE TABLAS');
SELECT ALL* FROM alumnos_pac;-- Mostramos la tabla
SELECT ALL* FROM asignaturas_pac;-- Mostramos la tabla




-- 2.	COMPROBACIÓN DE LA FUNCION “NUMERO_MAYOR�?
/
EXECUTE dbms_output.put_line('-- 2.	COMPROBACIÓN DE LA FUNCION “NUMERO_MAYOR�?'); 
-- Bloque anonimo con 3 variables numericas y 1 varchar donde se recogera el resultado
DECLARE
resultado VARCHAR(100);

numero1 number(8);
numero2 number(8);
numero3 number(8);

BEGIN
numero1:= 23;
numero2:= 37;
numero3:= 32;

resultado:=numero_mayor(numero1,numero2,numero3); -- Hacemos referencia a la funcion ya creada para que se guarde el resultado 
dbms_output.put_line('El mayor entre ('||numero1||', '||numero2||', '||numero3||') es: '||resultado); -- MOstramos el resultado
END;





-- 3.	COMPROBACIÓN DE LA FUNCION “JUGADORES_POR_RANKING�?
/
EXECUTE dbms_output.put_line('-- 3.	COMPROBACIÓN DE LA FUNCION “JUGADORES_POR_RANKING�?');
-- Bloque anonimos que inicializa la funcion de jugadores_por_ranking
DECLARE
nombre_ranking VARCHAR(14);
contador_personas NUMBER(3);
BEGIN
    nombre_ranking :='Plata'; --Ponemos el nombre del ranking 
    contador_personas:=jugadores_por_ranking(nombre_ranking); -- Inicializamos la funcion con la variable con el nombre del ranking
    dbms_output.put_line('En el ranking '||nombre_ranking|| ', tenemos a '||contador_personas||' jugadores.');
END;






-- 4.	COMPROBACIÓN DE LOS TRIGGERS
/
EXECUTE dbms_output.put_line('-- 4. COMPROBACI�N DE LOS TRIGGERS');
-- Bloque anonimo en el que a�adiremos los valores que deseamos para el update y salte el trigger
DECLARE
    v_puntos jugadores_pac.puntos%TYPE;
    v_idjug jugadores_pac.id_jugador%TYPE;
BEGIN
    v_idjug := &idjug;
    v_puntos:= &puntos;
    
    UPDATE jugadores_pac SET puntos=v_puntos WHERE id_jugador=v_idjug; -- Sentencia update de la tabla jugadores_pac para que salte el triger
END;
