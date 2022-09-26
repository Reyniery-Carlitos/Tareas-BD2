-- Ejercicio #1: Sacar el primer caracter en mayusculas separados por punto.
SET SERVEROUTPUT ON;
declare
    nombre varchar2(25) := 'carlos';
    apellido1 varchar2(25) := 'rubio';
    apellido2 varchar2(25) := 'dominguez';
begin
    dbms_output.put_line(upper(substr(nombre, 1, 1)) || '.' || upper(substr(apellido1, 1, 1)) || '.' || upper(substr(apellido2, 1, 1)));
end;

-- Ejercicio #2: Determinar si es par o impar.
SET SERVEROUTPUT ON;
declare
    isEven number;
begin
    isEven := 6;
    if mod(isEven, 2) = 0 then
        dbms_output.put_line('PAR');
    else 
        dbms_output.put_line('IMPAR');
    end if;
end;

-- Ejercicio #3: Devolver el salario máximo del departamento 100 y lo deje en una variable denominada salario_maximo
SET SERVEROUTPUT ON;
declare
    salario_maximo employees.salary%type;
begin
    select max(salary) into salario_maximo 
    from employees 
    where department_id = 100;
    
    dbms_output.put_line('Salario maximo departamento: ' || salario_maximo); 
end;

-- Ejercicio #4: Visualizar el nombre del departamento y el numero de empleados.
SET SERVEROUTPUT ON;
declare
    idDepartment number := 60;
    departmentName departments.department_name%type;
    totalEmployees number;
begin
    select dep.department_name, count(emp.department_id) into departmentName, totalEmployees
    from employees emp
    inner join departments dep
    on dep.department_id = emp.department_id 
    where dep.department_id = idDepartment
    group by dep.department_name, emp.department_id;

    dbms_output.put_line('Id Departamento: ' || idDepartment);
    dbms_output.put_line('Nombre Departamento: ' || departmentName);
    dbms_output.put_line('Total empleados: ' || totalEmployees);
end;

-- Ejercicio #5: Utilizando dos consultas sacar el salario maximo, minimo y diferencia de una empresa.
SET SERVEROUTPUT ON;
declare
    maxSalary employees.salary%type;
    minSalary employees.salary%type;
begin
    -- Consulta 1
    select max(salary) into maxSalary
    from employees;

    -- Consulta 2
    select min(salary) into minSalary
    from employees;

    dbms_output.put_line('Salario maximo empresa: ' || maxSalary);
    dbms_output.put_line('Salario minimo empresa: ' || minSalary);
    dbms_output.put_line('Diferencia: ' || (maxSalary - minSalary));
end;
