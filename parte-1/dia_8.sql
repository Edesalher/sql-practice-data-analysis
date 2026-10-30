USE Chinook_AutoIncrement;
GO

-- EJERCICIO 1: Clientes que gastan por encima del promedio
/*  Contexto de negocio: la tienda quiere identificar a los clientes cuyo gasto total supera el gasto promedio por cliente.
    Requisitos:
        1. Calcula el gasto total de cada cliente utilizando las tablas Customer, Invoice e InvoiceLine.
        2. Calcula el gasto promedio entre los clientes.
        3. Devuelve únicamente los clientes cuyo gasto total sea superior a ese promedio.
        4. Muestra el ID del cliente, nombre, apellido, país y gasto total.
        5. Ordena los resultados de mayor a menor gasto.
    Restricción: resuelve el ejercicio utilizando al menos una subconsulta. No uses una CTE todavía. 
    
    R//
        El gasto promedio por cliente es de $39.47. Un total de 22 clientes supera esta cifra, 
        lo que representa a los clientes con un gasto superior al promedio de la población analizada. 
        Helena Holý ocupa el primer lugar, con un gasto acumulado de $49.62.
*/

SELECT
    Customer.CustomerId AS id_cliente,
    Customer.FirstName AS nombre,
    Customer.LastName AS apellido,
    Customer.Country AS pais,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS gasto_total_cliente
FROM Customer
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
GROUP BY
    Customer.CustomerId,
    Customer.FirstName,
    Customer.LastName,
    Customer.Country
HAVING SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) > (
    SELECT 
        AVG(gastos_totales_clientes.gasto_total) AS gasto_promedio_cliente
    FROM (
        SELECT
            SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS gasto_total
        FROM Customer
        JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
        JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
    GROUP BY
        Customer.CustomerId
    ) AS gastos_totales_clientes
)
ORDER BY gasto_total_cliente DESC;

-- EJERCICIO 2: Canciones con precio superior al promedio
/*  Contexto de negocio: el equipo comercial quiere identificar las canciones cuyo precio está por encima del precio promedio del catálogo.
    Utiliza la tabla Track.
    Tu consulta debe:
        - Mostrar el ID de la canción, nombre, género y precio unitario.
        - Incluir únicamente canciones con un precio superior al promedio de todas las canciones.
        - Ordenar de mayor a menor precio.
    Utiliza una subconsulta para calcular el promedio de UnitPrice.

    Pregunta de análisis: ¿Por qué sería más útil comparar el precio de cada canción con el promedio del catálogo que limitarse a mostrar las canciones más caras?

    R//
        Comparar el precio de cada canción con el promedio del catálogo permite identificar productos cuyo precio está por encima del nivel general.

        El precio promedio del catálogo es de aproximadamente $1.05. Se identificaron 213 canciones con un precio unitario superior a este promedio, todas con un precio de $1.99. 
        Los resultados muestran que las canciones seleccionadas pertenecen a géneros como TV Shows, Drama, Science Fiction, Comedy y Sci Fi & Fantasy. 
*/

SELECT
    Track.TrackId AS id_cancion,
    Track.Name AS nombre,
    Genre.Name AS genero,
    Track.UnitPrice AS precio_unitario
FROM Track
JOIN Genre ON Genre.GenreId = Track.GenreId
WHERE Track.UnitPrice > (
    SELECT
        AVG(UnitPrice) AS precio_promedio_cancion
    FROM Track
)
ORDER BY precio_unitario DESC, Track.TrackId ASC;

-- EJERCICIO 3: Gasto por cliente utilizando una CTE
/*  Ahora resolveremos un problema similar al del primer ejercicio, pero organizando la consulta con una CTE.
    Crea una CTE llamada GastoClientes que contenga:
        - CustomerId
        - Nombre y apellido del cliente
        - País
        - Gasto total acumulado
    Después, consulta esa CTE para mostrar los diez clientes que más han gastado.
    La consulta debe utilizar WITH y SUM().

    Objetivo: separar el cálculo del gasto de la consulta que analiza los resultados.

    R//
        Se identificaron los diez clientes con mayor gasto acumulado. Helena Holý ocupa el primer lugar con $49.62, 
        seguida de Richard Cunningham con $47.62 y Luis Rojas con $46.62. 
        Esta información permite identificar a los clientes de mayor valor según su gasto histórico registrado en la tienda.
*/

WITH GastoClientes AS (
    SELECT
        Customer.CustomerId,
        Customer.FirstName AS nombre,
        Customer.LastName AS apellido,
        Customer.Country AS pais,
        SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS gasto_total
    FROM Customer
    JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
    JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
    GROUP BY 
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        Customer.Country
)
SELECT TOP(10)
    *
FROM GastoClientes
ORDER BY gasto_total DESC, CustomerId ASC;

-- EJERCICIO 4: Clientes con gasto superior a $40
/*  Utiliza la CTE GastoClientes del ejercicio anterior para identificar a los clientes cuyo gasto total sea superior a $40.
    Requisitos:
    - Mostrar nombre, apellido, país y gasto total.
    - Ordenar de mayor a menor gasto.
    - No repetir el cálculo de las sumas en la consulta principal.

    Pregunta de análisis: ¿qué ventaja tiene utilizar una CTE en este caso?

    R//
        Utilizar una CTE permite mayor legibilidad y reutilización de consultas.

        Se identificaron 14 clientes cuyo gasto acumulado supera los $40. Helena Holý ocupa el primer lugar con $49.62, seguida de Richard Cunningham con $47.62 y Luis Rojas con $46.62. 
        Esta consulta permite identificar a los clientes que superan un umbral de gasto específico, reutilizando la CTE para evitar repetir los cálculos de agregación.
*/

WITH GastoClientes AS (
    SELECT
        Customer.CustomerId,
        Customer.FirstName AS nombre,
        Customer.LastName AS apellido,
        Customer.Country AS pais,
        SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS gasto_total
    FROM Customer
    JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
    JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
    GROUP BY 
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        Customer.Country
)
SELECT
    nombre,
    apellido,
    pais,
    gasto_total
FROM GastoClientes
WHERE gasto_total > 40
ORDER BY gasto_total DESC, CustomerId ASC;

-- EJERCICIO 5: Reflexión técnica
/*
    1. ¿Qué es una subconsulta y cuándo la utilizarías?
        R// Es una consulta anidada dentro de otra consulta padre. La utilizaría cuando necesito agregar o relacionar a mi consulta principal datos específicos o puntuales.

    2. ¿Qué es una CTE y qué problema ayuda a resolver?
        R// Es una consulta que permite organizar otra consulta mas compleja en partes más fáciles de leer y mantener.
            Permite poder hacer diferentes consultas sin necesidad de volver a escribir la consulta desde cero.

    3. ¿Una CTE necesariamente mejora el rendimiento de una consulta frente a una subconsulta? Explica tu razonamiento.
        R// Si SQL Server realiza la ejecución de la CTE, cuando es llamada por el FROM, de la misma manera que una subconsulta, no mejoraría el rendimiento, 
            pero si SQL Server ejecuta primero la CTE para prepararla y luego ejecuta la consulta principal donde se utiliza, considero que podría mejorar el rendimiento ya que 
            la consulta principal sería mas corta a diferencia de si lo hacemos todo sobre una sola consulta usando subconsultas

    4. Si tuvieras que mantener una consulta extensa con varios cálculos intermedios, ¿cuál de las dos herramientas preferirías y por qué?
        R// Usaría CTEs por legibilidad ya que cuando una consulta es extensa y además necesita varios calculas intermedios, hacerlo todo sobre la misma consulta usando subconsultas
            hace que el query sea complicado de leer y mantener. Las CTEs permitirína orden y facilitarían el mantenimiento y/o posibles futuros ajustes.
*/

