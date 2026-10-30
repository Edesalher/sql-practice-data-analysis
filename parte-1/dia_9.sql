USE Chinook_AutoIncrement;
GO

-- EJERCICIO 1: Ranking global de clientes
/*  Objetivo: identificar a los clientes que más dinero han gastado.
    1. Calcula el gasto total de cada cliente utilizando las tablas necesarias.
    2. Crea una columna que asigne una posición a cada cliente según su gasto, de mayor a menor, utilizando ROW_NUMBER().
    3. Muestra el nombre, apellido, país, gasto total y posición.
    4. Ordena el resultado para que los clientes con mayor gasto aparezcan primero.

    Pregunta de análisis: ¿quién es el cliente que más ha gastado y cuánto representa su gasto?

    R//
        Se ha obtenido el gasto total de cada cliente a partir de la suma del importe de todas sus líneas de compra y 
        se ha realizado un ranking de mayor a menor, del cual Helena Holy ocupa el puesto No. 1 con $49.62, 
        seguido de Richard Cunningham en el puesto No. 2 con $47.62 y Luis Rojas en el puesto No. 3 con $46.62.
*/

SELECT
    Customer.FirstName AS nombre,
    Customer.LastName AS apellido,
    Customer.Country AS pais,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS gasto_total,
    ROW_NUMBER() OVER(ORDER BY SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) DESC) AS posicion
FROM Customer
JOIN Invoice ON invoice.CustomerId = Customer.CustomerId
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
GROUP BY
    Customer.CustomerId,
    Customer.FirstName,
    Customer.LastName,
    Customer.Country;

-- EJERCICIO 2: Ranking por país
/*  Objetivo: comparar clientes que pertenecen al mismo país.
    1. Calcula el gasto total de cada cliente.
    2. Asigna un ranking por país usando RANK().
    3. El cliente que más gasta dentro de cada país debe ocupar la primera posición.
    4. Muestra país, cliente, gasto total y ranking dentro de su país.

    Pregunta de análisis: ¿qué clientes son los que más gastan en sus respectivos países?
    
    R//
        En el resultado final se observa qué clientes gastan más en sus respectivos países ocupando el puesto No.1 de su ranking.
        La consulta devuelve a los clientes con mayor gasto de cada país, incluyendo todos los empates en el primer puesto.
*/

WITH RankingClientes AS (
    SELECT
        Customer.Country AS pais,
        Customer.FirstName AS nombre,
        Customer.LastName AS apellido,
        SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS gasto_total,
        RANK() OVER(PARTITION BY Customer.Country ORDER BY SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) DESC) AS ranking
    FROM Customer
    JOIN Invoice ON invoice.CustomerId = Customer.CustomerId
    JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
    GROUP BY
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        Customer.Country
)
SELECT *
FROM RankingClientes
WHERE ranking = 1;

-- EJERCICIO 3: Gasto del cliente frente al total
/*  Objetivo: conocer la contribución de cada cliente a los ingresos.
    1. Calcula el gasto total de cada cliente.
    2. Añade una columna que muestre el gasto total de todos los clientes en cada fila, usando SUM() OVER().
    3. Calcula el porcentaje que representa el gasto de cada cliente respecto al total.
    4. Ordena los clientes por gasto descendente.

    Pregunta de análisis: ¿qué porcentaje de los ingresos totales representa el cliente que más gasta?

    R//
        El cliente que más gasta, Helena Holy, representa un %2.13 de los ingresos totales.

        Se calcula la contribución porcentual de cada cliente a los ingresos totales. 
        Los resultados muestran un gasto global de los clientes de $2328.60 y el porcentaje que representa el gasto de cada cliente respecto al gasto global. 
        La mayor contribución es de Helena Holy con %2.13, seguida de Richard Cunningham con %2.05 y Luis Rojas con %2.00.

        Ningún cliente representa por sí solo una gran proporción del gasto total. Incluso el cliente con mayor gasto aporta apenas un 2.13 %. 
        Esto sugiere que el gasto está distribuido entre muchos clientes, aunque para evaluar la concentración real convendría analizar también los porcentajes 
        acumulados de los principales clientes.
*/

WITH GastoClientes AS (
    SELECT
        Customer.CustomerId,
        Customer.FirstName AS nombre,
        Customer.LastName AS apellido,
        SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS gasto_total_individual
    FROM Customer
    JOIN Invoice ON invoice.CustomerId = Customer.CustomerId
    JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
    GROUP BY
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName
)
SELECT 
    nombre,
    apellido,
    gasto_total_individual,
    SUM(gasto_total_individual) OVER() AS gasto_total_clientes,
    (gasto_total_individual/SUM(gasto_total_individual) OVER()) * 100 AS [% respecto al total]
FROM GastoClientes
ORDER BY gasto_total_individual DESC;

-- EJERCICIO 4: Desafío de analista
/*  Objetivo: construir una tabla que permita comparar el rendimiento de clientes dentro de sus países.
    Crea un resultado con estas columnas:
    - Country
    - Customer — nombre completo del cliente.
    - Revenue — gasto total.
    - CountryRank — posición del cliente dentro de su país.
    - GlobalRank — posición del cliente a nivel global.

    Requisitos:
    - Usa RANK() para ambos rankings.
    - Calcula los rankings a partir del gasto, de mayor a menor.
    - Mantén una fila por cliente.
    - Ordena el resultado por país y después por ranking dentro del país.

    Pregunta de análisis: ¿el cliente que más gasta globalmente también es el que más gasta en su país?

    R//
        Se calculó el ranking global y por país de los clientes según su gasto total. Helena Holý, de República Checa, ocupa el primer lugar 
        tanto en su país como a nivel global, con un gasto de $49.62. Richard Cunningham ocupa la segunda posición global y la primera en Estados Unidos, 
        mientras que Luis Rojas ocupa la tercera posición global y la primera en Chile. Los empates en el gasto generan posiciones compartidas en el ranking global.
*/

WITH GastoClientes AS (
    SELECT
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        Customer.Country,
        SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS gasto
    FROM Customer
    JOIN Invoice ON invoice.CustomerId = Customer.CustomerId
    JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
    GROUP BY
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        Customer.Country
)
SELECT 
    Country,
    FirstName + ' ' + LastName AS nombre,
    gasto AS Revenue,
    RANK() OVER(PARTITION BY Country ORDER BY gasto DESC) AS CountryRank,
    RANK() OVER(ORDER BY gasto DESC) AS GlobalRank
FROM GastoClientes
ORDER BY Country, CountryRank;