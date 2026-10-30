USE Chinook_AutoIncrement;
GO

-- EJERCICIO 1:
/* La tienda quiere saber cuántos clientes tiene cada país.

    Pregunta: ¿Cuántos clientes hay en cada país? Ordena los países de mayor a menor cantidad de clientes.*/

SELECT
    Country AS pais,
    COUNT(*) AS cantidad_clientes
FROM Customer
GROUP BY Country
ORDER BY cantidad_clientes DESC;

-- EJERCICIO 2:
/* La tienda quiere analizar sus productos musicales. Calcula el precio promedio de las canciones de cada género.

    Muestra: Género, Precio promedio. Ordena del precio promedio más alto al más bajo.*/

SELECT
    Genre.Name AS genero,
    AVG(Track.UnitPrice) AS precio_promedio
FROM Track
JOIN Genre ON Genre.GenreId = Track.GenreId
GROUP BY Genre.Name
ORDER BY precio_promedio DESC;

-- EJERCICIO 3:
/* Ahora la tienda quiere identificar los géneros que tienen más de 100 canciones.

    Muestra el género y la cantidad de canciones, pero únicamente para los géneros que tengan más de 100 canciones.*/

SELECT
    Genre.Name AS genero,
    COUNT(*) AS cantidad_canciones 
FROM Track
JOIN Genre ON Genre.GenreId = Track.GenreId
GROUP BY Genre.Name
HAVING COUNT(*) > 100;

-- EJERCICIO 4:
/* La tienda quiere saber cuánto dinero ha generado cada factura. Utiliza la tabla InvoiceLine.

    Calcula:
    Total de cada factura

    Recuerda que:
    Total = Quantity × UnitPrice

    Muestra: InvoiceId, Total de la factura. Ordena de mayor a menor.*/

SELECT 
    InvoiceId,
    SUM(Quantity * UnitPrice) AS total_factura
FROM InvoiceLine
GROUP BY InvoiceId
ORDER BY total_factura DESC;

-- EJERCICIO 5: ANÁLISIS
/* La empresa quiere identificar a sus clientes de mayor valor. Utiliza Customer, Invoice e InvoiceLine.

    Calcula cuánto dinero ha gastado cada cliente en total.
    Muestra: Nombre, Apellido, Total gastado. Ordena de mayor a menor.

    Objetivo adicional
    Después de obtener el resultado, dime: ¿Quién es el cliente que más dinero ha gastado y cuánto ha gastado?*/

--forma 1
SELECT
    Customer.CustomerId,
    Customer.FirstName AS nombre,
    Customer.LastName AS apellido,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS total_gastado
FROM Invoice
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName
ORDER BY total_gastado DESC;

--forma 2
SELECT
    Customer.CustomerId,
    Customer.FirstName AS nombre,
    Customer.LastName AS apellido,
    SUM(Invoice.Total) AS total_gastado
FROM Invoice
JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName
ORDER BY total_gastado DESC;

    --El cliente que más ha gastado es Helena Holy con $49.62

