USE Chinook_AutoIncrement;
GO

-- EJERCICIO 1:
/* Pregunta de negocio: ¿Cuántos clientes tiene actualmente la tienda?*/

SELECT 
    COUNT(*) AS cantidad_clientes
FROM Customer

-- EJERCICIO 2:
/* Pregunta de negocio ¿Cuántas canciones tiene disponibles la tienda?*/

SELECT
    COUNT(*) AS cantidad_canciones
FROM Track;

-- EJERCICIO 3:
/* Pregunta de negocio ¿Cuál es el precio promedio de las canciones de la tienda?*/

SELECT
    AVG(UnitPrice) AS precio_promedio
FROM Track;

-- EJERCICIO 4:
/* Pregunta de negocio ¿Cuál es el precio más alto de una canción en la tienda?*/

SELECT
    MAX(UnitPrice) AS precio_mayor
FROM Track;

-- EJERCICIO 5:
/* Pregunta de negocio ¿Cuál es el precio más bajo de una canción en la tienda?*/

SELECT 
    MIN(UnitPrice) AS precio_menor
FROM Track;

-- EJERCICIO 6:
/* Pregunta de negocio: Si sumáramos el precio de todas las canciones de la tienda, ¿cuál sería el valor total?*/

SELECT
    SUM(UnitPrice) AS precio_total
FROM Track;

-- EJERCICIO 7:
/* ¿Cuántos clientes hay en cada país?*/

SELECT
    Country AS pais,
    COUNT(*) AS cantidad_clientes
FROM Customer
GROUP BY Country;

-- EJERCICIO 8:
/* ¿Cuáles son los países que tienen más clientes?*/

SELECT
    Country AS pais,
    COUNT(*) AS cantidad_clientes
FROM Customer
GROUP BY Country
ORDER BY cantidad_clientes DESC;

-- EJERCICIO 9:
/* Pregunta de negocio ¿Cuál es el precio promedio de las canciones para cada género musical?

    Por ahora quiero que el resultado muestre el GenreId*/

SELECT
    GenreId,
    AVG(UnitPrice) AS precio_promedio
FROM Track
GROUP BY GenreId;

-- EJERCICIO 10:
/* Pregunta ¿Cuál es el precio promedio de las canciones de cada género, mostrando el nombre del género en lugar de su GenreId?*/

SELECT
    Genre.Name AS genero,
    AVG(Track.UnitPrice) AS precio_promedio
FROM Track
JOIN Genre ON Genre.GenreId = Track.GenreId
GROUP BY Genre.Name;

-- EJERCICIO 11:
/* Pregunta de negocio ¿Cuántas canciones tiene cada género?

    Mostrar el nombre del género, no el GenreId. Y quiero que además ordenes el resultado de más canciones → menos canciones*/

SELECT
    Genre.Name AS genero,
    COUNT(*) AS cantidad_canciones
FROM Track
JOIN Genre ON Genre.GenreId = Track.GenreId
GROUP BY Genre.Name
ORDER BY cantidad_canciones DESC;


