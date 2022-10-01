/*Visualizar iniciales de un nombre
• Crea un bloque PL/SQL con tres variables VARCHAR2:
o Nombre
o apellido1
o apellido2
• Debes visualizar las iniciales separadas por puntos.
• Además siempre en mayúscula
• Por ejemplo alberto pérez García debería aparecer--> A.P.G 

*/
DECLARE
    Nombre VARCHAR2(50);
    apellido1 VARCHAR2(50);
    apellido2 VARCHAR2(50);

BEGIN
    Nombre := 'alberto';
    apellido1 := 'perez';
    apellido2 := 'garcia';
    
    DBMS_OUTPUT.put_line(SUBSTR(UPPER(Nombre),1,1)||'.' ||SUBSTR(UPPER(apellido1),1,1) ||'.'|| SUBSTR(UPPER(apellido2),1,1)); 
END;

/*
Debemos hacer un bloque PL/SQL anónimo, donde declaramos una variable
NUMBER la variable puede tomar cualquier valor. Se debe evaluar el valor y
determinar si es PAR o IMPAR
• Como pista, recuerda que hay una función en SQL denominada MOD, que
permite averiguar el resto de una división. Por ejemplo MOD(10,4) nos
devuelve el resto de dividir 10 por 4.
*/

DECLARE
 numero NUMBER;
 verificador number;
BEGIN
    numero := 21;
    verificador := MOD(numero,2);
    
    if verificador = 0 then
        DBMS_OUTPUT.PUT_LINE('El numero'||' '||numero||' es par');
    else
        DBMS_OUTPUT.PUT_LINE('El numero'||' '||numero||' es impar');
    end if;
END;


/*
Crear un bloque PL/SQL que devuelva al salario máximo del departamento 100 y lo
deje en una variable denominada salario_maximo y la visualice
*/
DECLARE
    salario_maximo EMPLOYEES.SALARY%TYPE;
BEGIN
    select MAX(SALARY) into salario_maximo FROM EMPLOYEES where department_id = 100;
    DBMS_OUTPUT.PUT_LINE(salario_maximo);
END;

/*
Crear una variable de tipo DEPARTMENT_ID y ponerla algún valor, por ejemplo 10.
Visualizar el nombre de ese departamento y el número de empleados que tiene.
Crear dos variables para albergar los valores. 
*/

DECLARE
    depa_id EMPLOYEES.DEPARTMENT_ID%TYPE;
    depa_name DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    num_empl number;
BEGIN
    depa_id := 100;
    
    SELECT DEPARTMENT_NAME into depa_name FROM departments where department_id = depa_id;
    
    SELECT COUNT(EMPLOYEE_ID) INTO num_empl FROM EMPLOYEES where department_id = depa_id;
    DBMS_OUTPUT.PUT_LINE('Empleados del deparmatamento de '||depa_name||':'||' '||num_empl);
END;

/*
Mediante dos consultas recuperar el salario máximo y el salario mínimo de la
empresa e indicar su diferencia 
*/
DECLARE
    salario_maximo EMPLOYEES.SALARY%TYPE;
    salario_minimo EMPLOYEES.SALARY%TYPE;
    diferencia number;
BEGIN
    select MAX(SALARY) into salario_maximo FROM EMPLOYEES;
    select MIN(SALARY) into salario_minimo FROM EMPLOYEES;
    DBMS_OUTPUT.PUT_LINE(salario_maximo);
    DBMS_OUTPUT.PUT_LINE(salario_minimo);
    
    diferencia := salario_maximo - salario_minimo;
    DBMS_OUTPUT.PUT_LINE(diferencia);
END;



