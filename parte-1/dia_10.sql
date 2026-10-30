USE Chinook_AutoIncrement;
GO

/*
    Proyecto: análisis de clientes y ventas
    Base de datos: Chinook · Nivel: intermedio inicial

    Objetivo de negocio
    La gerencia quiere identificar los clientes más valiosos, conocer el rendimiento de las ventas por país y determinar qué clientes merecen mayor atención comercial.
*/

-- PARTE 1

-- EJERCICIO 1: Gasto total por cliente
/*  La gerencia necesita conocer cuánto ha gastado cada cliente durante todo el período registrado.
    Requisitos:
    1. Mostrar el ID del cliente, nombre, apellido y país.
    2. Calcular el gasto total de cada cliente utilizando InvoiceLine.Quantity y InvoiceLine.UnitPrice.
    3. Mostrar únicamente clientes que tengan facturas.
    4. Ordenar los resultados de mayor a menor gasto total.

    R//
        La consulta muestra el gasto acumulado de cada cliente que ha realizado compras durante el período registrado en la base de datos. 
        El importe se calcula sumando el valor de todas sus líneas de factura.

        Los resultados identifican a Helena Holý, de República Checa, como la cliente con mayor gasto acumulado, con un total de **$49.62**, 
        seguida de Richard Cunningham, de Estados Unidos, con $47.62, y Luis Rojas, de Chile, con $46.62.
*/

SELECT
    Customer.CustomerId AS id,
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
ORDER BY gasto_total DESC;

-- EJERCICIO 2: Clasificación de clientes
/*  Ahora queremos identificar a los clientes de mayor valor comercial.
    Utiliza el análisis anterior como base para clasificar a los clientes en tres categorías:

    Categoría	Gasto total
    Bajo        Menor de $10
    Medio       Desde $10 hasta $40, inclusive
    Alto        Mayor de $40

    Requisitos:
    - Mostrar el nombre completo del cliente, país, gasto total y categoría.
    - Utilizar CASE para asignar la categoría.
    - Ordenar de mayor a menor gasto.

    R//
        La consulta presenta el gasto acumulado de cada cliente que ha realizado compras durante el período registrado en la base de datos y lo clasifica en función de su importe total.

        Entre los resultados obtenidos, Helena Holý, de República Checa, registra el mayor gasto acumulado, con $49.62, seguida de Richard Cunningham, de Estados Unidos, con $47.62, 
        y Luis Rojas, de Chile, con $46.62. Los tres pertenecen a la categoría «Alto», ya que sus gastos superan los $40.

        Esta clasificación permite segmentar a los clientes según su contribución económica y puede servir como punto de partida para analizar estrategias de fidelización 
        y atención comercial.

    Preguntas de negocio que deberás responder:
    1. ¿Cuántos clientes pertenecen a cada categoría?
    2. ¿Qué proporción del total de clientes representa cada categoría?

    R//
        La consulta clasifica a los 59 clientes que han realizado compras según su gasto acumulado durante el período registrado en la base de datos.

        La categoría Alta, correspondiente a gastos superiores a $40, agrupa a 14 clientes, equivalentes al 23.73% del total. 
        La categoría Media, que comprende gastos desde $10 hasta $40 inclusive, concentra a 45 clientes, equivalentes al 76.27%. 
        Por su parte, ningún cliente pertenece a la categoría Baja, definida por gastos inferiores a $10.

        Estos resultados muestran que la categoría Media concentra la mayor proporción de clientes. Esta segmentación puede servir como punto de partida 
        para investigar oportunidades de fidelización y estrategias para incrementar el gasto de los clientes, sin asumir que la categoría de gasto por sí sola 
        explica su comportamiento futuro.  

    Puedes resolver las preguntas adicionales con otra consulta si lo consideras necesario.
*/

WITH GastoClientes AS (
    SELECT
        Customer.CustomerId AS id_cliente,
        Customer.FirstName AS nombre,
        Customer.LastName AS apellido,
        Customer.Country AS pais,
        SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS total_gastado
    FROM Customer
    JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
    JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
    GROUP BY
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        Customer.Country
),
CategoriaClientes AS (
    SELECT
        id_cliente,
        nombre + ' ' + apellido AS cliente,
        pais,
        total_gastado,
        CASE
            WHEN total_gastado < 10 THEN 'Bajo'
            WHEN total_gastado <= 40 THEN 'Medio'
            WHEN total_gastado > 40 THEN 'Alto'
        END AS categoria
    FROM GastoClientes
    --ORDER BY total_gastado DESC
)

SELECT 
    Categorias.nombre AS categoria,
    COUNT(CategoriaClientes.id_cliente) AS cantidad_clientes,
    ROUND(
        CAST(COUNT(CategoriaClientes.id_cliente) AS DECIMAL(10,2))
        / (SELECT COUNT(*) FROM CategoriaClientes) * 100,
        2
    ) AS porcentaje
FROM (
VALUES
    ('Alto'),
    ('Medio'),
    ('Bajo')
) AS Categorias(nombre)
LEFT JOIN CategoriaClientes ON CategoriaClientes.categoria = Categorias.nombre
GROUP BY Categorias.nombre;

-- EJERCICIO 3: Ranking de clientes dentro de cada país
/* La gerencia quiere identificar qué clientes generan más ingresos en comparación con los demás clientes de su propio país.
    El resultado debe tener esta estructura:

    Country	    Customer	Revenue	    Rank
    USA	        Cliente A	47.62	    1
    USA	        Cliente B	43.62	    2
    Canada	    Cliente C	49.62	    1

    Requisitos:
    1. Calcular el gasto total por cliente.
    2. Utilizar una función de ventana para clasificar a los clientes dentro de cada país, ordenando por gasto descendente.
    3. Reiniciar el ranking para cada país.
    4. Mostrar país, cliente, gasto total y posición.
    5. Ordenar el resultado por país y posición.

    R//
        La consulta clasifica a los 59 clientes que han realizado compras según su gasto acumulado dentro de cada país, 
        utilizando la función de ventana `RANK()`.

        Los resultados permiten identificar al cliente con mayor gasto de cada país y detectar empates entre clientes con el mismo importe acumulado. 
        Por ejemplo, Helena Holý, de República Checa, ocupa la primera posición de su país con $49.62 y también registra el mayor gasto global entre los clientes analizados.

        Esta información puede utilizarse para orientar estrategias de fidelización y campañas comerciales adaptadas a cada mercado. 
        Sin embargo, para determinar qué países generan mayores ingresos totales sería necesario realizar un análisis adicional agrupado por país. 
*/

WITH GastoClientes AS (
    SELECT
        Customer.CustomerId AS id_cliente,
        Customer.FirstName AS nombre,
        Customer.LastName AS apellido,
        Customer.Country AS pais,
        SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS total_gastado
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
    pais,
    CONCAT(nombre, ' ', apellido) AS cliente,
    total_gastado,
    RANK() OVER(PARTITION BY pais ORDER BY total_gastado DESC) AS posicion_por_pais
FROM GastoClientes
ORDER BY pais, posicion_por_pais;

