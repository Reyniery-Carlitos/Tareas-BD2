-- 1. BLOQUES ANONIMOS
    -- Ejercicio 1.a: Cursor para recuperar el nombre y sueldo de los empleados
SET SERVEROUTPUT ON;
declare
    cursor employee is 
    select first_name, last_name, salary from employees;

    firstName employees.first_name%type;
    lastName employees.last_name%type;
    salaryEmp employees.salary%type;
begin
    open employee;

    loop
        if (firstName || ' ' || lastName) = 'Peter Tucker' then
            RAISE_APPLICATION_ERROR(-20001, 'No se puede ver el sueldo del jefe');
        else 
            fetch employee into firstName, lastName, salaryEmp;
            dbms_output.put_line('Nombre: ' || firstName || ' ' || lastName || ' -> Salary: ' || salaryEmp);
        end if; 
        exit when employee%NOTFOUND;
    end loop;

    close employee;
end;

    -- Ejercicio 1.b: Cursor parametrizado para imprimir el numero de empleados de ese departamento
SET SERVEROUTPUT ON;
declare
    cursor empDept(idDept employees.department_id%type) is 
    select count(department_id) from employees
    where department_id = idDept;

    numEmp Number;
begin
    open empDept(50);

    fetch empDept into numEmp;
    dbms_output.put_line(numEmp || ' Empleados');

    close empDept;
end;

    -- Ejercicio 1.c: Cursor de la tabla employees que aumenta el salario en 2% si el salario es mayor que 8000 y 3% si es menor
declare
    cursor crsEmployee is 
    select * from employees_copia
    for update;
begin
    for employee in crsEmployee loop 
        if employee.salary > 8000 then
            update employees_copia set salary = (salary * 1.02) 
            where current of crsEmployee;
        else
            update employees_copia set salary = (salary * 1.03) 
            where current of crsEmployee;
        end if;
    end loop;
end;

-- 2. FUNCIONES
    -- Ejercicio 2.a: Funcion para crear registros en la tabla de regiones
create or replace function crear_region(regionName regions.region_name%type)
return Number
as regionId regions.region_id%type;
begin
    select max(region_id) + 1 into regionId 
    from regions;

    insert into regions 
    values (regionId, regionName);

    return regionId;
exception
    when others then 
        return -1;
end;

SET SERVEROUTPUT ON;
declare 
    regionId regions.region_id%type;
begin 
    regionId := crear_region('Central America');
    dbms_output.put_line('Codigo de la region creada: ' || regionId);
end;

-- 3. PROCEDIMIENTOS
    -- EJercicio 3.a: Calculadora usando procedimientos
create or replace procedure calculator(operation varchar2, num1 number, num2 number, res out number)
is
begin
    case operation
        when 'sum' then
            res := num1 + num2;

        when 'res' then
            res := num1 - num2;

        when 'mul' then
            res := num1 * num2;

        when 'div' then
            if num2 = 0 then
                raise zero_divide;
            end if;

            res := num1 / num2;
        else
            raise_application_error(-20001, 'Operacion no valida, las operaciones permitidas son: sum, res, mul, div');
    end case;
    
    dbms_output.put_line('Resultado: ' || res);

exception
    when zero_divide then 
        dbms_output.put_line('Division por 0 es indefinida');
end;

SET SERVEROUTPUT ON;
declare
    res number;
begin 
    calculator('sum', 20, 5, res);
    
    calculator('res', 20, 5, res);

    calculator('mul', 20, 5, res);

    calculator('div', 20, 5, res);
end;

    -- Ejercicio 3.b: Procedimiento almacenado para operaciones de insercion de datos en la tabla employees copia
 CREATE TABLE EMPLOYEES_COPIA(
     EMPLOYEE_ID NUMBER(6,0) PRIMARY KEY,
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

-- En lugar de la tabla principal de employees mejor utilice la tabla de employees copia.
create or replace procedure rellenar_empCopia
is
begin
    INSERT INTO EMPLOYEES_COPIA VALUES( 100, 'Steven', 'King', 'SKING', '515.123.4567', TO_DATE('17-06-2003', 'dd-MM-yyyy'), 'AD_PRES', 24000, NULL, NULL, 90);
    INSERT INTO EMPLOYEES_COPIA VALUES( 101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', TO_DATE('21-09-2005', 'dd-MM-yyyy'), 'AD_VP', 1700, NULL, 10, 9);    
    INSERT INTO EMPLOYEES_COPIA VALUES( 102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', TO_DATE('13-01-2001', 'dd-MM-yyyy'), 'AD_VP', 1700, NULL, 10, 9);    
    INSERT INTO EMPLOYEES_COPIA VALUES( 103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', TO_DATE('03-01-2006', 'dd-MM-yyyy'), 'IT_PROG', 900, NULL, 10, 6);    
    INSERT INTO EMPLOYEES_COPIA VALUES( 104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', TO_DATE('21-05-2007', 'dd-MM-yyyy'), 'IT_PROG', 600, NULL, 10, 6);    
    INSERT INTO EMPLOYEES_COPIA VALUES( 105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', TO_DATE('25-06-2005', 'dd-MM-yyyy'), 'IT_PROG', 480, NULL, 10, 6);    
    INSERT INTO EMPLOYEES_COPIA VALUES( 106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', TO_DATE('05-02-2006', 'dd-MM-yyyy'), 'IT_PROG', 480, NULL, 10, 6);    
    INSERT INTO EMPLOYEES_COPIA VALUES( 107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', TO_DATE('07-02-2007', 'dd-MM-yyyy'), 'IT_PROG', 420, NULL, 10, 6);   
    INSERT INTO EMPLOYEES_COPIA VALUES( 108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', TO_DATE('17-08-2002', 'dd-MM-yyyy'), 'FI_MGR', 12008, NULL, 101, 100);    
    INSERT INTO EMPLOYEES_COPIA VALUES( 109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', TO_DATE('16-08-2002', 'dd-MM-yyyy'), 'FI_ACCOUNT', 9000, NULL, 108, 100);    
    INSERT INTO EMPLOYEES_COPIA VALUES( 110, 'John', 'Chen', 'JCHEN', '515.124.4269', TO_DATE('28-09-2005', 'dd-MM-yyyy'), 'FI_ACCOUNT', 8200, NULL, 108, 100);    

    dbms_output.put_line('CARGA FINALIZADA');
exception 
    when others then
        dbms_output.put_line('Code Error: ' || SQLCODE);
        dbms_output.put_line('Description Error: ' || SQLERRM);
end;

SET SERVEROUTPUT ON;
declare

begin 
    rellenar_empCopia;
end;


-- 4. TRIGGERS
    -- Ejercicio 4.a: Trigger que cambia el valor de manager id y location id si se envia con valores nulos.
create or replace trigger trigger_dept
before insert on departments 
for each row
declare
    cursor crsDepts is select department_id from departments;
begin
    for dept in crsDepts loop
        if dept.department_id = :new.department_id then
            raise_application_error(-20000, 'Departamento ya existe');
        end if;
    end loop;

    if :new.manager_id is null then
        :new.manager_id := 200;
    end if;

    if :new.location_id is null then
        :new.location_id := 1700;
    end if;
end;

    -- Ejercicio 4.b: Trigger para rellenar la tabla auditoria cuando se agrega una nueva region

 CREATE TABLE AUDITORIA (
     USUARIO VARCHAR(50),
     FECHA DATE,
     SALARIO_ANTIGUO NUMBER,
     SALARIO_NUEVO NUMBER
 );

create or replace trigger trigger_audit
before insert on regions 
begin
    insert into auditoria values(user, sysdate, 0, 0);
end;

    -- Ejercicio 4.c: Trigger para actualizar registro de la tabla employees solo si el nuevo salario es mayor que el anterior.
create or replace trigger trigger_salaryEmp
before update of salary on employees 
for each row
begin
    if :new.salary < :old.salary then
        raise_application_error(-20000, 'El salario nuevo a ingresar no puede ser menor que el anterior');
    else
        insert into auditoria values(user, sysdate, :old.salary, :new.salary);
    end if;
end;