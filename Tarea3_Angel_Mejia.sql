/*
Construir un bloque anonimo donde se declare un cursor y que imprima el
nombre y sueldo de los empleados (utilice la tabla employees). Si durante el
recorrido aparece el nombre Peter Tucker (el jefe) se debe genera un
RAISE_APPLICATION_ERROR indicando que no se puede ver el sueldo del
jefe.
*/

DECLARE 
    CURSOR sueldo IS SELECT * FROM EMPLOYEES;
    V1 EMPLOYEES%ROWTYPE;
BEGIN
    OPEN sueldo;
    LOOP
        FETCH sueldo INTO V1;
        EXIT WHEN sueldo%NOTFOUND;
        IF (V1.FIRST_NAME = 'Peter' AND V1.LAST_NAME = 'Tucker') THEN
            RAISE_APPLICATION_ERROR(-20001,'No se puede ver el sueldo del Jefe Peter Tucker');
        ELSE
            DBMS_OUTPUT.PUT_LINE(V1.FIRST_NAME || '' || V1.LAST_NAME || ' - SALARIO: ' || V1.SALARY);
        END IF;
    END LOOP;
    CLOSE sueldo;
END;

/*
Crear un cursor con par�metros para el parametro id de departamento e
imprima el numero de empleados de ese departamento (utilice la cla�sula
count).
*/

DECLARE
    CURSOR c1(id_depa number) IS
    SELECT 
        COUNT(EMPLOYEE_ID)as empleados
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = id_depa; 
    v1 c1%ROWTYPE;
BEGIN
    OPEN c1(100);
    FETCH c1 INTO v1;
    CLOSE c1;
    DBMS_OUTPUT.PUT_LINE('Cantidad de empleados: ' || v1.empleados); 
END;

/*
Crear un bloque que tenga un cursor de la tabla employees.
    i. Por cada fila recuperada, si el salario es mayor de 8000
       incrementamos el salario un 2%
    ii. Si es menor de 8000 incrementamos en un 3%
*/
DECLARE
    CURSOR c1 IS
    SELECT
        *
    FROM EMPLOYEES FOR UPDATE;
    empl c1%ROWTYPE;
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO empl;
        EXIT WHEN c1%NOTFOUND;
        
        IF empl.SALARY > 8000 THEN
            UPDATE employees SET SALARY =SALARY + SALARY*0.02 WHERE CURRENT OF c1;
        ElSE
            UPDATE employees SET SALARY =SALARY + SALARY*0.03 WHERE CURRENT OF c1;
        END IF;
    END LOOP;
END;

/*

*/










CREATE OR REPLACE FUNCTION CREAR_REGION (region in REGIONS.REGION_NAME%TYPE)
RETURN NUMBER
IS
    region_id REGIONS.REGION_ID%TYPE;
    VALOR_NULL EXCEPTION;
BEGIN
    SELECT
        MAX(REGION_ID)
    INTO region_id
    FROM REGIONS;
    IF region_id IS null THEN
        RAISE VALOR_NULL;
    ELSE
        INSERT INTO REGIONS (REGION_ID,REGION_NAME)
        VALUES((region_id+1),region);
        commit;
        return (region_id+1);
    END IF;
EXCEPTION
    WHEN VALOR_NULL THEN
        region_id := 0;
        INSERT INTO REGIONS (REGION_ID,REGION_NAME)
        VALUES((region_id+1),region);
        commit;
        return (region_id+1);
END;


set serveroutput on
DECLARE
  region REGIONS.REGION_NAME%TYPE;
  R NUMBER;
begin
  region:='Europa Est';
  R:=CREAR_REGION(region);
 DBMS_OUTPUT.PUT_LINE('Region_ID = '||R);
end;



/*
Construya un procedimiento almacenado que haga las operaciones de una
calculadora, por lo que debe recibir tres parametros de entrada, uno que
contenga la operaci�n a realizar (SUMA, RESTA, MULTIPLICACION,
DIVISION), num1, num2 y declare un parametro de retorno e imprima el
resultado de la operaci�n. Maneje posibles excepciones.
*/

CREATE OR REPLACE PROCEDURE CALCULATOR (operacion varchar2, num1 number, num2 number)
IS 
   result NUMBER:=0;
BEGIN
    CASE operacion
        WHEN 'SUMA' THEN result:= num1 + num2;
        WHEN 'RESTA' THEN result:= num1 - num2;
        WHEN 'MULTI' THEN result:= num1 * num2;
        WHEN 'DIVIDIR' THEN result:= num1/num2;
    END CASE;
    DBMS_OUTPUT.PUT_LINE(result);
   
EXCEPTION
    WHEN zero_divide THEN
    DBMS_OUTPUT.PUT_LINE('No se puede dividir un numero entre cero');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Asegurese de haber introducido numeros y escrito bien la operacion a realizar');
END;

SET SERVEROUTPUT ON
BEGIN
   CALCULATOR('DIVIDIR',10,2);
END;

/*
Realice una copia de la tabla employee, utilice el siguiente script:
    CREATE TABLE EMPLOYEES_COPIA
            (EMPLOYEE_ID NUMBER (6,0) PRIMARY KEY,
            FIRST_NAME VARCHAR2(20 BYTE),
            LAST_NAME VARCHAR2(25 BYTE),
            EMAIL VARCHAR2(25 BYTE),
            PHONE_NUMBER VARCHAR2(20 BYTE),
            HIRE_DATE DATE,
            JOB_ID VARCHAR2(10 BYTE),
            SALARY NUMBER(8,2),
            COMMISSION_PCT NUMBER(2,2),
            MANAGER_ID NUMBER(6,0),
            DEPARTMENT_ID NUMBER(4,0)
    );
Rellene la tabla employees_copia utilizando un procedimiento almacenado,
el cual no recibir� parametros unicamente ejecutara los inserts en la nueva
tabla, imprima el codigo de error en caso de que ocurra y muestre un
mensaje por pantalla que diga �Carga Finalizada�.

*/

CREATE TABLE EMPLOYEES_COPIA
            (EMPLOYEE_ID NUMBER (6,0) PRIMARY KEY,
            FIRST_NAME VARCHAR2(20 BYTE),
            LAST_NAME VARCHAR2(25 BYTE),
            EMAIL VARCHAR2(25 BYTE),
            PHONE_NUMBER VARCHAR2(20 BYTE),
            HIRE_DATE DATE,
            JOB_ID VARCHAR2(10 BYTE),
            SALARY NUMBER(8,2),
            COMMISSION_PCT NUMBER(2,2),
            MANAGER_ID NUMBER(6,0),
            DEPARTMENT_ID NUMBER(4,0)
);


CREATE OR REPLACE PROCEDURE InsertEmployees
IS
BEGIN
    BEGIN    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 100    
        , 'Steven'    
        , 'King'    
        , 'SKING'    
        , '515.123.4567'    
        , TO_DATE('17-06-2003', 'dd-MM-yyyy')    
        , 'AD_PRES'    
        , 24000    
        , NULL    
        , NULL    
        , 90    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 101    
        , 'Neena'    
        , 'Kochhar'    
        , 'NKOCHHAR'    
        , '515.123.4568'    
        , TO_DATE('21-09-2005', 'dd-MM-yyyy')    
        , 'AD_VP'    
        , 17000    
        , NULL    
        , 100    
        , 90    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 102    
        , 'Lex'    
        , 'De Haan'    
        , 'LDEHAAN'    
        , '515.123.4569'    
        , TO_DATE('13-01-2001', 'dd-MM-yyyy')    
        , 'AD_VP'    
        , 17000    
        , NULL    
        , 100    
        , 90    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 103    
        , 'Alexander'    
        , 'Hunold'    
        , 'AHUNOLD'    
        , '590.423.4567'    
        , TO_DATE('03-01-2006', 'dd-MM-yyyy')    
        , 'IT_PROG'    
        , 9000    
        , NULL    
        , 102    
        , 60    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 104    
        , 'Bruce'    
        , 'Ernst'    
        , 'BERNST'    
        , '590.423.4568'    
        , TO_DATE('21-05-2007', 'dd-MM-yyyy')    
        , 'IT_PROG'    
        , 6000    
        , NULL    
        , 103    
        , 60    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 105    
        , 'David'    
        , 'Austin'    
        , 'DAUSTIN'    
        , '590.423.4569'    
        , TO_DATE('25-06-2005', 'dd-MM-yyyy')    
        , 'IT_PROG'    
        , 4800    
        , NULL    
        , 103    
        , 60    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 106    
        , 'Valli'    
        , 'Pataballa'    
        , 'VPATABAL'    
        , '590.423.4560'    
        , TO_DATE('05-02-2006', 'dd-MM-yyyy')    
        , 'IT_PROG'    
        , 4800    
        , NULL    
        , 103    
        , 60    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 107    
        , 'Diana'    
        , 'Lorentz'    
        , 'DLORENTZ'    
        , '590.423.5567'    
        , TO_DATE('07-02-2007', 'dd-MM-yyyy')    
        , 'IT_PROG'    
        , 4200    
        , NULL    
        , 103    
        , 60    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 108    
        , 'Nancy'    
        , 'Greenberg'    
        , 'NGREENBE'    
        , '515.124.4569'    
        , TO_DATE('17-08-2002', 'dd-MM-yyyy')    
        , 'FI_MGR'    
        , 12008    
        , NULL    
        , 101    
        , 100    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 109    
        , 'Daniel'    
        , 'Faviet'    
        , 'DFAVIET'    
        , '515.124.4169'    
        , TO_DATE('16-08-2002', 'dd-MM-yyyy')    
        , 'FI_ACCOUNT'    
        , 9000    
        , NULL    
        , 108    
        , 100    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 110    
        , 'John'    
        , 'Chen'    
        , 'JCHEN'    
        , '515.124.4269'    
        , TO_DATE('28-09-2005', 'dd-MM-yyyy')    
        , 'FI_ACCOUNT'    
        , 8200    
        , NULL    
        , 108    
        , 100    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 111    
        , 'Ismael'    
        , 'Sciarra'    
        , 'ISCIARRA'    
        , '515.124.4369'    
        , TO_DATE('30-09-2005', 'dd-MM-yyyy')    
        , 'FI_ACCOUNT'    
        , 7700    
        , NULL    
        , 108    
        , 100    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 112    
        , 'Jose Manuel'    
        , 'Urman'    
        , 'JMURMAN'    
        , '515.124.4469'    
        , TO_DATE('07-03-2006', 'dd-MM-yyyy')    
        , 'FI_ACCOUNT'    
        , 7800    
        , NULL    
        , 108    
        , 100    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 113    
        , 'Luis'    
        , 'Popp'    
        , 'LPOPP'    
        , '515.124.4567'    
        , TO_DATE('07-12-2007', 'dd-MM-yyyy')    
        , 'FI_ACCOUNT'    
        , 6900    
        , NULL    
        , 108    
        , 100    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 114    
        , 'Den'    
        , 'Raphaely'    
        , 'DRAPHEAL'    
        , '515.127.4561'    
        , TO_DATE('07-12-2002', 'dd-MM-yyyy')    
        , 'PU_MAN'    
        , 11000    
        , NULL    
        , 100    
        , 30    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 115    
        , 'Alexander'    
        , 'Khoo'    
        , 'AKHOO'    
        , '515.127.4562'    
        , TO_DATE('18-05-2003', 'dd-MM-yyyy')    
        , 'PU_CLERK'    
        , 3100    
        , NULL    
        , 114    
        , 30    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 116    
        , 'Shelli'    
        , 'Baida'    
        , 'SBAIDA'    
        , '515.127.4563'    
        , TO_DATE('24-12-2005', 'dd-MM-yyyy')    
        , 'PU_CLERK'    
        , 2900    
        , NULL    
        , 114    
        , 30    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 117    
        , 'Sigal'    
        , 'Tobias'    
        , 'STOBIAS'    
        , '515.127.4564'    
        , TO_DATE('24-07-2005', 'dd-MM-yyyy')    
        , 'PU_CLERK'    
        , 2800    
        , NULL    
        , 114    
        , 30    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 118    
        , 'Guy'    
        , 'Himuro'    
        , 'GHIMURO'    
        , '515.127.4565'    
        , TO_DATE('15-11-2006', 'dd-MM-yyyy')    
        , 'PU_CLERK'    
        , 2600    
        , NULL    
        , 114    
        , 30    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 119    
        , 'Karen'    
        , 'Colmenares'    
        , 'KCOLMENA'    
        , '515.127.4566'    
        , TO_DATE('10-08-2007', 'dd-MM-yyyy')    
        , 'PU_CLERK'    
        , 2500    
        , NULL    
        , 114    
        , 30    
        );    
END; 

begin 
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 120    
        , 'Matthew'    
        , 'Weiss'    
        , 'MWEISS'    
        , '650.123.1234'    
        , TO_DATE('18-07-2004', 'dd-MM-yyyy')    
        , 'ST_MAN'    
        , 8000    
        , NULL    
        , 100    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 121    
        , 'Adam'    
        , 'Fripp'    
        , 'AFRIPP'    
        , '650.123.2234'    
        , TO_DATE('10-04-2005', 'dd-MM-yyyy')    
        , 'ST_MAN'    
        , 8200    
        , NULL    
        , 100    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 122    
        , 'Payam'    
        , 'Kaufling'    
        , 'PKAUFLIN'    
        , '650.123.3234'    
        , TO_DATE('01-05-2003', 'dd-MM-yyyy')    
        , 'ST_MAN'    
        , 7900    
        , NULL    
        , 100    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 123    
        , 'Shanta'    
        , 'Vollman'    
        , 'SVOLLMAN'    
        , '650.123.4234'    
        , TO_DATE('10-10-2005', 'dd-MM-yyyy')    
        , 'ST_MAN'    
        , 6500    
        , NULL    
        , 100    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 124    
        , 'Kevin'    
        , 'Mourgos'    
        , 'KMOURGOS'    
        , '650.123.5234'    
        , TO_DATE('16-11-2007', 'dd-MM-yyyy')    
        , 'ST_MAN'    
        , 5800    
        , NULL    
        , 100    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 125    
        , 'Julia'    
        , 'Nayer'    
        , 'JNAYER'    
        , '650.124.1214'    
        , TO_DATE('16-07-2005', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 3200    
        , NULL    
        , 120    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 126    
        , 'Irene'    
        , 'Mikkilineni'    
        , 'IMIKKILI'    
        , '650.124.1224'    
        , TO_DATE('28-09-2006', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2700    
        , NULL    
        , 120    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 127    
        , 'James'    
        , 'Landry'    
        , 'JLANDRY'    
        , '650.124.1334'    
        , TO_DATE('14-01-2007', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2400    
        , NULL    
        , 120    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 128    
        , 'Steven'    
        , 'Markle'    
        , 'SMARKLE'    
        , '650.124.1434'    
        , TO_DATE('08-03-2008', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2200    
        , NULL    
        , 120    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 129    
        , 'Laura'    
        , 'Bissot'    
        , 'LBISSOT'    
        , '650.124.5234'    
        , TO_DATE('20-08-2005', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 3300    
        , NULL    
        , 121    
        , 50    
        );    
END; 

begin  
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 130    
        , 'Mozhe'    
        , 'Atkinson'    
        , 'MATKINSO'    
        , '650.124.6234'    
        , TO_DATE('30-10-2005', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2800    
        , NULL    
        , 121    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 131    
        , 'James'    
        , 'Marlow'    
        , 'JAMRLOW'    
        , '650.124.7234'    
        , TO_DATE('16-02-2005', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2500    
        , NULL    
        , 121    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 132    
        , 'TJ'    
        , 'Olson'    
        , 'TJOLSON'    
        , '650.124.8234'    
        , TO_DATE('10-04-2007', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2100    
        , NULL    
        , 121    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 133    
        , 'Jason'    
        , 'Mallin'    
        , 'JMALLIN'    
        , '650.127.1934'    
        , TO_DATE('14-06-2004', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 3300    
        , NULL    
        , 122    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 134    
        , 'Michael'    
        , 'Rogers'    
        , 'MROGERS'    
        , '650.127.1834'    
        , TO_DATE('26-08-2006', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2900    
        , NULL    
        , 122    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 135    
        , 'Ki'    
        , 'Gee'    
        , 'KGEE'    
        , '650.127.1734'    
        , TO_DATE('12-12-2007', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2400    
        , NULL    
        , 122    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 136    
        , 'Hazel'    
        , 'Philtanker'    
        , 'HPHILTAN'    
        , '650.127.1634'    
        , TO_DATE('06-02-2008', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2200    
        , NULL    
        , 122    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 137    
        , 'Renske'    
        , 'Ladwig'    
        , 'RLADWIG'    
        , '650.121.1234'    
        , TO_DATE('14-07-2003', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 3600    
        , NULL    
        , 123    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 138    
        , 'Stephen'    
        , 'Stiles'    
        , 'SSTILES'    
        , '650.121.2034'    
        , TO_DATE('26-10-2005', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 3200    
        , NULL    
        , 123    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 139    
        , 'John'    
        , 'Seo'    
        , 'JSEO'    
        , '650.121.2019'    
        , TO_DATE('12-02-2006', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2700    
        , NULL    
        , 123    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 140    
        , 'Joshua'    
        , 'Patel'    
        , 'JPATEL'    
        , '650.121.1834'    
        , TO_DATE('06-04-2006', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2500    
        , NULL    
        , 123    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 141    
        , 'Trenna'    
        , 'Rajs'    
        , 'TRAJS'    
        , '650.121.8009'    
        , TO_DATE('17-10-2003', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 3500    
        , NULL    
        , 124    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 142    
        , 'Curtis'    
        , 'Davies'    
        , 'CDAVIES'    
        , '650.121.2994'    
        , TO_DATE('29-01-2005', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 3100    
        , NULL    
        , 124    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 143    
        , 'Randall'    
        , 'Matos'    
        , 'RMATOS'    
        , '650.121.2874'    
        , TO_DATE('15-03-2006', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2600    
        , NULL    
        , 124    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 144    
        , 'Peter'    
        , 'Vargas'    
        , 'PVARGAS'    
        , '650.121.2004'    
        , TO_DATE('09-07-2006', 'dd-MM-yyyy')    
        , 'ST_CLERK'    
        , 2500    
        , NULL    
        , 124    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 145    
        , 'John'    
        , 'Russell'    
        , 'JRUSSEL'    
        , '011.44.1344.429268'    
        , TO_DATE('01-10-2004', 'dd-MM-yyyy')    
        , 'SA_MAN'    
        , 14000    
        , .4    
        , 100    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 146    
        , 'Karen'    
        , 'Partners'    
        , 'KPARTNER'    
        , '011.44.1344.467268'    
        , TO_DATE('05-01-2005', 'dd-MM-yyyy')    
        , 'SA_MAN'    
        , 13500    
        , .3    
        , 100    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 147    
        , 'Alberto'    
        , 'Errazuriz'    
        , 'AERRAZUR'    
        , '011.44.1344.429278'    
        , TO_DATE('10-03-2005', 'dd-MM-yyyy')    
        , 'SA_MAN'    
        , 12000    
        , .3    
        , 100    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 148    
        , 'Gerald'    
        , 'Cambrault'    
        , 'GCAMBRAU'    
        , '011.44.1344.619268'    
        , TO_DATE('15-10-2007', 'dd-MM-yyyy')    
        , 'SA_MAN'    
        , 11000    
        , .3    
        , 100    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 149    
        , 'Eleni'    
        , 'Zlotkey'    
        , 'EZLOTKEY'    
        , '011.44.1344.429018'    
        , TO_DATE('29-01-2008', 'dd-MM-yyyy')    
        , 'SA_MAN'    
        , 10500    
        , .2    
        , 100    
        , 80    
        );    
end;

begin 
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 150    
        , 'Peter'    
        , 'Tucker'    
        , 'PTUCKER'    
        , '011.44.1344.129268'    
        , TO_DATE('30-01-2005', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 10000    
        , .3    
        , 145    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 151    
        , 'David'    
        , 'Bernstein'    
        , 'DBERNSTE'    
        , '011.44.1344.345268'    
        , TO_DATE('24-03-2005', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 9500    
        , .25    
        , 145    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 152    
        , 'Peter'    
        , 'Hall'    
        , 'PHALL'    
        , '011.44.1344.478968'    
        , TO_DATE('20-08-2005', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 9000    
        , .25    
        , 145    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 153    
        , 'Christopher'    
        , 'Olsen'    
        , 'COLSEN'    
        , '011.44.1344.498718'    
        , TO_DATE('30-03-2006', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 8000    
        , .2    
        , 145    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 154    
        , 'Nanette'    
        , 'Cambrault'    
        , 'NCAMBRAU'    
        , '011.44.1344.987668'    
        , TO_DATE('09-12-2006', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 7500    
        , .2    
        , 145    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 155    
        , 'Oliver'    
        , 'Tuvault'    
        , 'OTUVAULT'    
        , '011.44.1344.486508'    
        , TO_DATE('23-11-2007', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 7000    
        , .15    
        , 145    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 156    
        , 'Janette'    
        , 'King'    
        , 'JKING'    
        , '011.44.1345.429268'    
        , TO_DATE('30-01-2004', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 10000    
        , .35    
        , 146    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 157    
        , 'Patrick'    
        , 'Sully'    
        , 'PSULLY'    
        , '011.44.1345.929268'    
        , TO_DATE('04-03-2004', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 9500    
        , .35    
        , 146    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 158    
        , 'Allan'    
        , 'McEwen'    
        , 'AMCEWEN'    
        , '011.44.1345.829268'    
        , TO_DATE('01-08-2004', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 9000    
        , .35    
        , 146    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 159    
        , 'Lindsey'    
        , 'Smith'    
        , 'LSMITH'    
        , '011.44.1345.729268'    
        , TO_DATE('10-03-2005', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 8000    
        , .3    
        , 146    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 160    
        , 'Louise'    
        , 'Doran'    
        , 'LDORAN'    
        , '011.44.1345.629268'    
        , TO_DATE('15-12-2005', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 7500    
        , .3    
        , 146    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 161    
        , 'Sarath'    
        , 'Sewall'    
        , 'SSEWALL'    
        , '011.44.1345.529268'    
        , TO_DATE('03-11-2006', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 7000    
        , .25    
        , 146    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 162    
        , 'Clara'    
        , 'Vishney'    
        , 'CVISHNEY'    
        , '011.44.1346.129268'    
        , TO_DATE('11-11-2005', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 10500    
        , .25    
        , 147    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 163    
        , 'Danielle'    
        , 'Greene'    
        , 'DGREENE'    
        , '011.44.1346.229268'    
        , TO_DATE('19-03-2007', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 9500    
        , .15    
        , 147    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 164    
        , 'Mattea'    
        , 'Marvins'    
        , 'MMARVINS'    
        , '011.44.1346.329268'    
        , TO_DATE('24-01-2008', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 7200    
        , .10    
        , 147    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 165    
        , 'David'    
        , 'Lee'    
        , 'DLEE'    
        , '011.44.1346.529268'    
        , TO_DATE('23-02-2008', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 6800    
        , .1    
        , 147    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 166    
        , 'Sundar'    
        , 'Ande'    
        , 'SANDE'    
        , '011.44.1346.629268'    
        , TO_DATE('24-03-2008', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 6400    
        , .10    
        , 147    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 167    
        , 'Amit'    
        , 'Banda'    
        , 'ABANDA'    
        , '011.44.1346.729268'    
        , TO_DATE('21-04-2008', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 6200    
        , .10    
        , 147    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 168    
        , 'Lisa'    
        , 'Ozer'    
        , 'LOZER'    
        , '011.44.1343.929268'    
        , TO_DATE('11-03-2005', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 11500    
        , .25    
        , 148    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 169      
        , 'Harrison'    
        , 'Bloom'    
        , 'HBLOOM'    
        , '011.44.1343.829268'    
        , TO_DATE('23-03-2006', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 10000    
        , .20    
        , 148    
        , 80    
        );    
end;

begin  
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 170    
        , 'Tayler'    
        , 'Fox'    
        , 'TFOX'    
        , '011.44.1343.729268'    
        , TO_DATE('24-01-2006', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 9600    
        , .20    
        , 148    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 171    
        , 'William'    
        , 'Smith'    
        , 'WSMITH'    
        , '011.44.1343.629268'    
        , TO_DATE('23-02-2007', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 7400    
        , .15    
        , 148    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 172    
        , 'Elizabeth'    
        , 'Bates'    
        , 'EBATES'    
        , '011.44.1343.529268'    
        , TO_DATE('24-03-2007', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 7300    
        , .15    
        , 148    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 173    
        , 'Sundita'    
        , 'Kumar'    
        , 'SKUMAR'    
        , '011.44.1343.329268'    
        , TO_DATE('21-04-2008', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 6100    
        , .10    
        , 148    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 174    
        , 'Ellen'    
        , 'Abel'    
        , 'EABEL'    
        , '011.44.1644.429267'    
        , TO_DATE('11-05-2004', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 11000    
        , .30    
        , 149    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 175    
        , 'Alyssa'    
        , 'Hutton'    
        , 'AHUTTON'    
        , '011.44.1644.429266'    
        , TO_DATE('19-03-2005', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 8800    
        , .25    
        , 149    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 176    
        , 'Jonathon'    
        , 'Taylor'    
        , 'JTAYLOR'    
        , '011.44.1644.429265'    
        , TO_DATE('24-03-2006', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 8600    
        , .20    
        , 149    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 177    
        , 'Jack'    
        , 'Livingston'    
        , 'JLIVINGS'    
        , '011.44.1644.429264'    
        , TO_DATE('23-04-2006', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 8400    
        , .20    
        , 149    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 178    
        , 'Kimberely'    
        , 'Grant'    
        , 'KGRANT'    
        , '011.44.1644.429263'    
        , TO_DATE('24-05-2007', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 7000    
        , .15    
        , 149    
        , NULL    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 179    
        , 'Charles'    
        , 'Johnson'    
        , 'CJOHNSON'    
        , '011.44.1644.429262'    
        , TO_DATE('04-01-2008', 'dd-MM-yyyy')    
        , 'SA_REP'    
        , 6200    
        , .10    
        , 149    
        , 80    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 180    
        , 'Winston'    
        , 'Taylor'    
        , 'WTAYLOR'    
        , '650.507.9876'    
        , TO_DATE('24-01-2006', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 3200    
        , NULL    
        , 120    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 181    
        , 'Jean'    
        , 'Fleaur'    
        , 'JFLEAUR'    
        , '650.507.9877'    
        , TO_DATE('23-02-2006', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 3100    
        , NULL    
        , 120    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 182    
        , 'Martha'    
        , 'Sullivan'    
        , 'MSULLIVA'    
        , '650.507.9878'    
        , TO_DATE('21-06-2007', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 2500    
        , NULL    
        , 120    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 183    
        , 'Girard'    
        , 'Geoni'    
        , 'GGEONI'    
        , '650.507.9879'    
        , TO_DATE('03-02-2008', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 2800    
        , NULL    
        , 120    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 184    
        , 'Nandita'    
        , 'Sarchand'    
        , 'NSARCHAN'    
        , '650.509.1876'    
        , TO_DATE('27-01-2004', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 4200    
        , NULL    
        , 121    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 185    
        , 'Alexis'    
        , 'Bull'    
        , 'ABULL'    
        , '650.509.2876'    
        , TO_DATE('20-02-2005', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 4100    
        , NULL    
        , 121    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 186    
        , 'Julia'    
        , 'Dellinger'    
        , 'JDELLING'    
        , '650.509.3876'    
        , TO_DATE('24-06-2006', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 3400    
        , NULL    
        , 121    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 187    
        , 'Anthony'    
        , 'Cabrio'    
        , 'ACABRIO'    
        , '650.509.4876'    
        , TO_DATE('07-02-2007', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 3000    
        , NULL    
        , 121    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 188    
        , 'Kelly'    
        , 'Chung'    
        , 'KCHUNG'    
        , '650.505.1876'    
        , TO_DATE('14-06-2005', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 3800    
        , NULL    
        , 122    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 189    
        , 'Jennifer'    
        , 'Dilly'    
        , 'JDILLY'    
        , '650.505.2876'    
        , TO_DATE('13-08-2005', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 3600    
        , NULL    
        , 122    
        , 50    
        );    
end;

begin  
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 190    
        , 'Timothy'    
        , 'Gates'    
        , 'TGATES'    
        , '650.505.3876'    
        , TO_DATE('11-07-2006', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 2900    
        , NULL    
        , 122    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 191    
        , 'Randall'    
        , 'Perkins'    
        , 'RPERKINS'    
        , '650.505.4876'    
        , TO_DATE('19-12-2007', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 2500    
        , NULL    
        , 122    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 192    
        , 'Sarah'    
        , 'Bell'    
        , 'SBELL'    
        , '650.501.1876'    
        , TO_DATE('04-02-2004', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 4000    
        , NULL    
        , 123    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 193    
        , 'Britney'    
        , 'Everett'    
        , 'BEVERETT'    
        , '650.501.2876'    
        , TO_DATE('03-03-2005', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 3900    
        , NULL    
        , 123    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 194    
        , 'Samuel'    
        , 'McCain'    
        , 'SMCCAIN'    
        , '650.501.3876'    
        , TO_DATE('01-07-2006', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 3200    
        , NULL    
        , 123    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 195    
        , 'Vance'    
        , 'Jones'    
        , 'VJONES'    
        , '650.501.4876'    
        , TO_DATE('17-03-2007', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 2800    
        , NULL    
        , 123    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 196    
        , 'Alana'    
        , 'Walsh'    
        , 'AWALSH'    
        , '650.507.9811'    
        , TO_DATE('24-04-2006', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 3100    
        , NULL    
        , 124    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 197    
        , 'Kevin'    
        , 'Feeney'    
        , 'KFEENEY'    
        , '650.507.9822'    
        , TO_DATE('23-05-2006', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 3000    
        , NULL    
        , 124    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 198    
        , 'Donald'    
        , 'OConnell'    
        , 'DOCONNEL'    
        , '650.507.9833'    
        , TO_DATE('21-06-2007', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 2600    
        , NULL    
        , 124    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 199    
        , 'Douglas'    
        , 'Grant'    
        , 'DGRANT'    
        , '650.507.9844'    
        , TO_DATE('13-01-2008', 'dd-MM-yyyy')    
        , 'SH_CLERK'    
        , 2600    
        , NULL    
        , 124    
        , 50    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 200    
        , 'Jennifer'    
        , 'Whalen'    
        , 'JWHALEN'    
        , '515.123.4444'    
        , TO_DATE('17-09-2003', 'dd-MM-yyyy')    
        , 'AD_ASST'    
        , 4400    
        , NULL    
        , 101    
        , 10    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 201    
        , 'Michael'    
        , 'Hartstein'    
        , 'MHARTSTE'    
        , '515.123.5555'    
        , TO_DATE('17-02-2004', 'dd-MM-yyyy')    
        , 'MK_MAN'    
        , 13000    
        , NULL    
        , 100    
        , 20    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 202    
        , 'Pat'    
        , 'Fay'    
        , 'PFAY'    
        , '603.123.6666'    
        , TO_DATE('17-08-2005', 'dd-MM-yyyy')    
        , 'MK_REP'    
        , 6000    
        , NULL    
        , 201    
        , 20    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 203    
        , 'Susan'    
        , 'Mavris'    
        , 'SMAVRIS'    
        , '515.123.7777'    
        , TO_DATE('07-06-2002', 'dd-MM-yyyy')    
        , 'HR_REP'    
        , 6500    
        , NULL    
        , 101    
        , 40    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 204    
        , 'Hermann'    
        , 'Baer'    
        , 'HBAER'    
        , '515.123.8888'    
        , TO_DATE('07-06-2002', 'dd-MM-yyyy')    
        , 'PR_REP'    
        , 10000    
        , NULL    
        , 101    
        , 70    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 205    
        , 'Shelley'    
        , 'Higgins'    
        , 'SHIGGINS'    
        , '515.123.8080'    
        , TO_DATE('07-06-2002', 'dd-MM-yyyy')    
        , 'AC_MGR'    
        , 12008    
        , NULL    
        , 101    
        , 110    
        );    
    
INSERT INTO EMPLOYEES_COPIA VALUES     
        ( 206    
        , 'William'    
        , 'Gietz'    
        , 'WGIETZ'    
        , '515.123.8181'    
        , TO_DATE('07-06-2002', 'dd-MM-yyyy')    
        , 'AC_ACCOUNT'    
        , 8300    
        , NULL    
        , 205    
        , 110    
        );    
END;
COMMIT;

DBMS_OUTPUT.PUT_LINE('Carga Finalizada');

EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLCODE || SQLERRM);
END;

SET SERVEROUTPUT ON
BEGIN
   InsertEmployees;
END;




/*
Crear un TRIGGER BEFORE INSERT en la tabla DEPARTMENTS que al insertar
un departamento compruebe que el c�digo no est� repetido y luego que si
el LOCATION_ID es NULL actualic� el campo con el valor 1700 y si el
MANAGER_ID es NULL lo actualic� el campo con el valor 200.
*/
CREATE OR REPLACE TRIGGER TR_DEPARTMENT  
BEFORE INSERT ON DEPARTMENTS 
FOR EACH ROW
DECLARE
    CURSOR c1 is
    select * from DEPARTMENTS;
BEGIN
    IF INSERTING THEN
        for i in c1
            loop
                if i.DEPARTMENT_ID = :NEW.DEPARTMENT_ID THEN
                    RAISE_APPLICATION_ERROR(-20001,'EL codigo ya pertenece a un departamento');
                end if;
            end loop;
        if :NEW.LOCATION_ID IS NULL THEN
            :NEW.LOCATION_ID := 1700;
        end if;
        if :NEW.MANAGER_ID IS NULL THEN
            :NEW.MANAGER_ID := 200;
        end if;
    END IF;
END;

INSERT INTO departments VALUES (280,'Admin2',null,null);

/*
Crear una tabla denominada AUDITORIA con las siguientes columnas: 
CREATE TABLE AUDITORIA (
     USUARIO VARCHAR(50),
     FECHA DATE,
     SALARIO_ANTIGUO NUMBER,
    SALARIO_NUEVO NUMBER
)

Crear un TRIGGER BEFORE INSERT de tipo STATEMENT,de forma que cada vez que
se haga un INSERT en la tabla REGIONS guarde una fila en la tabla AUDITORIA con
el usuario y la fecha en la que se ha hecho el INSERT (los campos
SALARIO_ANTIGUO, SALARIO_NUEVO tendran un valor de 0 )
*/
CREATE OR REPLACE TRIGGER tr_LogAuditoria
BEFORE INSERT
ON REGIONS
BEGIN
    IF INSERTING THEN
        INSERT INTO AUDITORIA VALUES(USER,SYSDATE,0,0);
    END IF;
END;

INSERT INTO REGIONS VALUES (8,'EU_SUR');


/*
Crear un trigger BEFORE UPDATE de la columna SALARY de la tabla
EMPLOYEES de tipo EACH ROW.
� Si el valor de modificaci�n es menor que el valor actual el TRIGGER
debe disparar un RAISE_APPLICATION_FAILURE �no se puede modificar
el salario con un valor menor�.
� Si el salario es mayor debemos insertar un registro en la tabla
AUDITORIA. (Guardando user, fecha, salario_anterior, salario_nuevo)
*/
CREATE OR REPLACE TRIGGER tg_salary
BEFORE UPDATE OF SALARY ON EMPLOYEES
FOR EACH ROW
BEGIN
    IF :NEW.SALARY < :OLD.SALARY THEN
        RAISE_APPLICATION_ERROR(-20001,'NO SE PUEDE MODIFICAR UN SALARIO A UNO MENOR'); 
    END IF;
    IF :NEW.SALARY > :OLD.SALARY THEN
        INSERT INTO AUDITORIA VALUES (USER,SYSDATE,:OLD.SALARY,:NEW.SALARY);
    END IF;
END;

UPDATE EMPLOYEES SET SALARY = 24000 WHERE EMPLOYEE_ID = 100;



