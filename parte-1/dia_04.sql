USE Chinook_AutoIncrement;
GO

-- EJERCICIO 1: Ventas por país del cliente
/* Contexto empresarial: la tienda Chinook quiere identificar los países que generan más ingresos por ventas.

    Tu tarea es calcular el importe total facturado por país del cliente.*/

SELECT
    Customer.Country AS pais,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS total_facturado
FROM Invoice
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.Country
ORDER BY total_facturado DESC;


-- EJERCICIO 2: Rendimiento de los empleados
/* La gerencia quiere saber cuánto dinero en ventas se atribuye a cada empleado según los clientes que tiene asignados.

    Utiliza las tablas Employee, Customer, Invoice e InvoiceLine.

    Tu consulta debe mostrar:
    -Nombre y apellido del empleado.
    -Total de ventas atribuidas a sus clientes.
    -Resultados ordenados de mayor a menor venta.*/

SELECT DISTINCT EmployeeId, FirstName, LastName
FROM Employee;

SELECT DISTINCT SupportRepId
FROM Customer;

SELECT
    Employee.EmployeeId,
    Employee.FirstName AS nombre,
    Employee.LastName AS apellido,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS total_ventas
FROM Employee
JOIN Customer ON Customer.SupportRepId = Employee.EmployeeId
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
GROUP BY Employee.EmployeeId, Employee.FirstName, Employee.LastName
ORDER BY total_ventas DESC;

-- EJERCICIO 3: Géneros musicales e ingresos
/* Contexto: la gerencia quiere saber qué géneros musicales generan más ingresos, para decidir en qué categorías conviene enfocar sus esfuerzos comerciales.

    Tu tarea es calcular los ingresos totales por género musical.

    Requisitos:
    -Utiliza Genre, Track, InvoiceLine y las tablas necesarias para relacionarlas.
    -Muestra el nombre del género y los ingresos totales.
    -Ordena los resultados de mayor a menor ingreso.*/

SELECT
    Genre.Name AS genero,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS ingresos_totales
FROM Genre
JOIN Track ON Track.GenreId = Genre.GenreId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Genre.GenreId, Genre.Name
ORDER BY ingresos_totales DESC;

-- EJERCICIO 4: Los 10 clientes que más gastan
/* Contexto empresarial: Chinook quiere identificar a sus clientes más valiosos para diseñar una campaña de fidelización.

    Escribe una consulta que devuelva los 10 clientes que más dinero han gastado.

    Requisitos:
    -Utiliza Customer, Invoice e InvoiceLine.
    -Muestra CustomerId, nombre, apellido y país.
    -Calcula el gasto total de cada cliente.
    -Ordena de mayor a menor gasto.

    Preguntas de análisis:
    ¿Cuánto ha gastado el cliente que ocupa el primer lugar?
    ¿Qué países aparecen entre los 10 clientes principales?
    ¿Qué estrategia de fidelización propondrías para estos clientes?
        R//
        Personalización: Identificar los géneros musicales preferidos de cada cliente para ofrecer promociones relevantes.
        Reconocimiento: Ofrecer recompensas por compras acumuladas o por alcanzar determinados niveles de gasto.
*/

SELECT TOP(10)
    Customer.CustomerId,
    Customer.FirstName AS Nombre,
    Customer.LastName AS Apellido,
    Customer.Country AS Pais,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS GastoTotal
FROM Customer
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
GROUP BY 
    Customer.CustomerId,
    Customer.FirstName,
    Customer.LastName,
    Customer.Country
ORDER BY GastoTotal DESC, Customer.CustomerId ASC;

