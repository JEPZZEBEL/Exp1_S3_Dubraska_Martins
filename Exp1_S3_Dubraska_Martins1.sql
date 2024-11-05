 ---creacion de tablas
CREATE TABLE Ventas (
    venta_id NUMBER PRIMARY KEY,
    producto_id NUMBER,
    cliente_id NUMBER,
    fecha DATE,
    cantidad NUMBER,
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

CREATE SEQUENCE venta_seq START WITH 1;



CREATE TABLE Productos (
    producto_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255),
    precio NUMBER(10, 2),
    categoria VARCHAR2(100)
);


CREATE SEQUENCE producto_seq START WITH 1;

CREATE TABLE Clientes (
    cliente_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255),
    fecha_registro DATE,
    ciudad VARCHAR2(100)
);

CREATE SEQUENCE cliente_seq START WITH 1;

---Poblamiento

BEGIN
    INSERT INTO Productos (producto_id, nombre, precio, categoria) VALUES (producto_seq.NEXTVAL, 'Televisor 40"', 400, 'Electr�nica');
    INSERT INTO Productos (producto_id, nombre, precio, categoria) VALUES (producto_seq.NEXTVAL, 'Laptop Pro 15', 1200, 'Electr�nica');
    INSERT INTO Productos (producto_id, nombre, precio, categoria) VALUES (producto_seq.NEXTVAL, 'Cafetera', 80, 'Electrodom�sticos');
    INSERT INTO Productos (producto_id, nombre, precio, categoria) VALUES (producto_seq.NEXTVAL, 'Licuadora', 45, 'Electrodom�sticos');
END;

-- Poblamiento de Clientes
BEGIN
    INSERT INTO Clientes (cliente_id, nombre, fecha_registro, ciudad) VALUES (cliente_seq.NEXTVAL, 'Juan P�rez', TO_DATE('2020-01-10', 'YYYY-MM-DD'), 'Madrid');
    INSERT INTO Clientes (cliente_id, nombre, fecha_registro, ciudad) VALUES (cliente_seq.NEXTVAL, 'Ana G�mez', TO_DATE('2020-03-15', 'YYYY-MM-DD'), 'Barcelona');
    INSERT INTO Clientes (cliente_id, nombre, fecha_registro, ciudad) VALUES (cliente_seq.NEXTVAL, 'Luis Rodr�guez', TO_DATE('2022-06-25', 'YYYY-MM-DD'), 'Valencia');
END;

-- Poblamiento de Ventas
BEGIN
    INSERT INTO Ventas (venta_id, producto_id, cliente_id, fecha, cantidad) VALUES (venta_seq.NEXTVAL, 1, 1, TO_DATE('2022-10-05', 'YYYY-MM-DD'), 2);
    INSERT INTO Ventas (venta_id, producto_id, cliente_id, fecha, cantidad) VALUES (venta_seq.NEXTVAL, 2, 2, TO_DATE('2022-10-06', 'YYYY-MM-DD'), 1);
    INSERT INTO Ventas (venta_id, producto_id, cliente_id, fecha, cantidad) VALUES (venta_seq.NEXTVAL, 3, 1, TO_DATE('2022-11-15', 'YYYY-MM-DD'), 3);
    INSERT INTO Ventas (venta_id, producto_id, cliente_id, fecha, cantidad) VALUES (venta_seq.NEXTVAL, 1, 3, TO_DATE('2022-11-25', 'YYYY-MM-DD'), 1);
END;


--Caso 1

-- Lista el nombre de cada producto agrupado por categor�a. Ordena los resultados por precio de mayor a menor.

SELECT categoria,
       UPPER(nombre) AS nombre,
       precio
FROM Productos
ORDER BY precio DESC;

--Calcula el promedio de ventas mensuales (en cantidad de productos) y muestra el mes y a�o con mayores ventas.

SELECT TO_CHAR(fecha, 'YYYY') AS a�o,
       TO_CHAR(fecha, 'MM') AS mes,
       AVG(cantidad) AS promedio_mensual,
       SUM(cantidad) AS total_vendido
FROM Ventas
GROUP BY TO_CHAR(fecha, 'YYYY'), TO_CHAR(fecha, 'MM')
ORDER BY total_vendido DESC
FETCH FIRST 1 ROWS ONLY;


-- Encuentra el ID del cliente que ha gastado m�s dinero en compras durante el �ltimo a�o. 
-- Aseg�rate de considerar clientes que se registraron hace menos de un a�o.

SELECT c.cliente_id,
       UPPER(c.nombre) || ' - ID: ' || CAST(c.cliente_id AS VARCHAR2(10)) AS cliente_nombre,
       SUM(p.precio * v.cantidad) AS total_gastado
FROM Ventas v
JOIN Productos p ON v.producto_id = p.producto_id
JOIN Clientes c ON v.cliente_id = c.cliente_id
GROUP BY c.cliente_id, c.nombre
ORDER BY total_gastado DESC
FETCH FIRST 1 ROWS ONLY;

-- Caso 2
--cracion de tabla
CREATE TABLE Empleados (
    empleado_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255),
    departamento VARCHAR2(100),
    fecha_contratacion DATE,
    salario NUMBER(10, 2)
);

CREATE SEQUENCE empleado_seq START WITH 1;

--Poblacion de tabla

BEGIN
    INSERT INTO Empleados (empleado_id, nombre, departamento, fecha_contratacion, salario) VALUES (empleado_seq.NEXTVAL, 'Carlos Mart�nez', 'Finanzas', TO_DATE('2010-04-01', 'YYYY-MM-DD'), 3000);
    INSERT INTO Empleados (empleado_id, nombre, departamento, fecha_contratacion, salario) VALUES (empleado_seq.NEXTVAL, 'Mar�a L�pez', 'Recursos Humanos', TO_DATE('2012-07-15', 'YYYY-MM-DD'), 2500);
END;


--	Determina el salario promedio, el salario m�ximo y el salario m�nimo por departamento.

SELECT departamento,
       AVG(salario) AS salario_promedio,
       MAX(salario) AS salario_maximo,
       MIN(salario) AS salario_minimo
FROM Empleados
GROUP BY departamento;

-- Utilizando funciones de grupo, encuentra el salario m�s alto en cada departamento.

SELECT departamento,
       MAX(salario) AS salario_mas_alto
FROM Empleados
GROUP BY departamento;


-- Calcula la antig�edad en a�os de cada empleado y muestra aquellos con m�s de 10 a�os en la empresa

SELECT empleado_id,
       nombre,
       departamento,
       TRUNC((SYSDATE - fecha_contratacion) / 365.25) AS antiguedad_anos
FROM Empleados
WHERE (SYSDATE - fecha_contratacion) / 365.25 > 10;





