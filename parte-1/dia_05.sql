USE Chinook_AutoIncrement;
GO

-- EJERCICIO 1: Canciones compradas por cliente
/* Obtén el nombre y apellido del cliente y la cantidad total de canciones que ha comprado.

    Requisitos:
    - Utiliza Customer, Invoice e InvoiceLine.
    - Cuenta las unidades vendidas, no solamente el número de facturas.
    - Agrupa por cliente.
    - Muestra primero los clientes con mayor cantidad de canciones.*/

SELECT 
    Customer.FirstName AS nombre,
    Customer.LastName AS apellido,
    SUM(InvoiceLine.Quantity) AS total_canciones_compradas
FROM Customer
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
GROUP BY 
    Customer.CustomerId, 
    Customer.FirstName, 
    Customer.LastName
ORDER BY total_canciones_compradas DESC;

SELECT
    SUM(InvoiceLine.Quantity) AS total_unidades,
    COUNT(DISTINCT Invoice.InvoiceId) AS total_facturas,
    COUNT(DISTINCT Customer.CustomerId) AS total_clientes
FROM Customer
JOIN Invoice
    ON Invoice.CustomerId = Customer.CustomerId
JOIN InvoiceLine
    ON InvoiceLine.InvoiceId = Invoice.InvoiceId;

-- EJERCICIO 2: Ingresos por género musical
/* Necesitarás relacionar las ventas con los géneros y calcular dos métricas diferentes:
    - Cantidad de unidades vendidas.
    - Ingresos totales facturados, usando InvoiceLine.Quantity * InvoiceLine.UnitPrice.*/

SELECT
    Genre.Name AS genero,
    SUM(InvoiceLine.Quantity) AS total_unidades_vendidas,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS total_ingresos
FROM Genre
JOIN Track ON Track.GenreId = Genre.GenreId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Genre.GenreId, Genre.Name
ORDER BY total_ingresos DESC;

-- EJERCICIO 3: Ingresos por artista
/* Identificar qué artistas generan más ingresos.

    El resultado debe contener:
    -artista: Nombre del artista
    -total_ingresos: Suma de los importes de sus ventas*/

SELECT
    Artist.Name as artista,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS total_ingresos
FROM Artist
JOIN Album ON Album.ArtistId = Artist.ArtistId
JOIN Track ON Track.AlbumId = Album.AlbumId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Artist.ArtistId, Artist.Name
ORDER BY total_ingresos DESC;

-- EJERCICIO 4: Top 10 artistas
/* Tu tarea: Mostrar únicamente los diez artistas que generan más ingresos. */

SELECT TOP(10)
    Artist.Name as artista,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS total_ingresos
FROM Artist
JOIN Album ON Album.ArtistId = Artist.ArtistId
JOIN Track ON Track.AlbumId = Album.AlbumId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Artist.ArtistId, Artist.Name
ORDER BY total_ingresos DESC;

-- EJERCICIO 5: Top 10 de géneros por ingresos.

SELECT TOP(10)
    Genre.Name AS genero,
    SUM(InvoiceLine.Quantity) AS total_unidades_vendidas,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS total_ingresos
FROM Genre
JOIN Track ON Track.GenreId = Genre.GenreId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Genre.GenreId, Genre.Name
ORDER BY total_ingresos DESC;
