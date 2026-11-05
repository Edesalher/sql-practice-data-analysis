USE Chinook_AutoIncrement;
GO

--DÍA 1: Radiografía del negocio
--Objetivo del día: pasar de una pregunta general de negocio a un conjunto pequeño de métricas bien definidas, y explicar qué significan y qué no significan.


-- EJERCICIO 1:
/*
    Contexto: Chinook es una tienda digital de música. Acaba de llegar un nuevo director comercial que no conoce el negocio. 
    Antes de su primera reunión te pide un resumen general, sin tecnicismos, de qué tan grande es la empresa y a cuántos clientes vende.

    Qué debes investigar:

    ¿Cuánto ha vendido la empresa en total?
    ¿Cuántas compras (facturas) se han realizado?
    ¿Cuántos clientes distintos han comprado?
    ¿Cuánto gasta, en promedio, un cliente por compra?
    ¿Qué período cubren los datos?

    Requisitos:

    -Tú decides qué tablas y columnas necesitas. Parte de la pregunta de negocio, no de la sintaxis.
    -Entrega tus cifras en una forma que el director pueda leer de un vistazo.
    -Comprueba por tu cuenta que tus cifras son coherentes entre sí. Si puedes obtener la misma cifra por dos caminos distintos y coinciden, mejor.

    Criterios de éxito:

    -Las cinco preguntas están respondidas con cifras correctas.
    -Las métricas están definidas con claridad. Por ejemplo, debes poder explicar qué cuenta exactamente “cliente” y qué significa “promedio” en tu resultado.
    -Tu interpretación incluye al menos una conclusión respaldada por los datos y al menos una cosa que no puedes concluir con ellos.
*/

--por Invoice
WITH Ventas AS (
    SELECT 
        CAST(MIN(InvoiceDate) AS DATE) AS fecha_desde,
        CAST(MAX(InvoiceDate) AS DATE) AS fecha_hasta,
        SUM(Total) AS total_ventas,
        COUNT(*) AS numero_facturas,
        COUNT(DISTINCT CustomerId) AS numero_clientes
    FROM Invoice
)
SELECT
    fecha_desde,
    fecha_hasta,
    total_ventas,
    numero_facturas,
    total_ventas/numero_facturas AS promedio_gasto_compra,
    numero_clientes
FROM Ventas;

--por InvoiceLine
WITH LineasVentas AS (
    SELECT 
        CAST(MIN(InvoiceDate) AS DATE) AS fecha_desde,
        CAST(MAX(InvoiceDate) AS DATE) AS fecha_hasta,
        SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS total_ventas,
        COUNT(DISTINCT InvoiceLine.InvoiceId) AS numero_facturas,
        COUNT(DISTINCT Invoice.CustomerId) AS numero_clientes
    FROM InvoiceLine
    JOIN Invoice ON Invoice.InvoiceId = InvoiceLine.InvoiceId
)
SELECT
    fecha_desde,
    fecha_hasta,
    total_ventas,
    numero_facturas,
    total_ventas/numero_facturas AS promedio_gasto_compra,
    numero_clientes
FROM LineasVentas;

--validación de numero de clientes según facturas con los clientes registrados
SELECT 
    COUNT(*) numero_clientes_registrados
FROM Customer;


-- EJERCICIO 2:
/*
    Contexto: el director comercial leyó tu resumen y hace una pregunta: “Si cada cliente compra en promedio unas 7 veces, ¿puedo suponer que todos mis clientes se comportan más o menos igual?”

    Qué debes investigar:

    ¿Qué tan parecido o distinto es el comportamiento de compra entre los 59 clientes? Considera tanto cuántas veces compran como cuánto gastan en total.
    ¿Representa el promedio de 6.98 facturas por cliente a un cliente típico?
    ¿Está la actividad de ventas repartida de forma pareja entre los clientes, o se concentra en pocos?

    Requisitos:

    -Tú eliges las métricas y la forma de mostrar cómo se distribuyen los clientes. Define cada una con su unidad.
    -Valida tus resultados contra las cifras del Ejercicio 1 (ventas totales, facturas, clientes).
    -Redacta una respuesta para el director en 4 o 5 frases: hallazgo principal primero, evidencia, una limitación, y una hipótesis claramente marcada como tal.

    Criterios de éxito:

    -Responde directamente la pregunta del director (sí, no o “depende”) apoyándote en cifras.
    -Tu resultado se puede conciliar con lo que ya sabes del negocio.
    -Distingues lo que los datos muestran de lo que supones sobre por qué los clientes se comportan así.
*/

--Por Invoice: Totales, promedios, desviaciones y rango
WITH facturasClientes AS (
    SELECT
        Invoice.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        COUNT(*) AS total_invoices,
        SUM(Invoice.total) AS total_spent
    FROM Invoice
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY    
        Invoice.CustomerId,
        Customer.FirstName,
        Customer.LastName
    ORDER BY total_spent DESC, CustomerId
)
SELECT DISTINCT
    SUM(total_invoices) AS sum_invoices,
    CAST(AVG(CAST(total_invoices AS DECIMAL)) AS DECIMAL(10, 2)) AS avg_invoices,
    CAST(STDEVP(total_invoices) AS DECIMAL(10, 2)) AS dev_invoices,
    CAST(STDEVP(total_invoices)/AVG(CAST(total_invoices AS DECIMAL))*100 AS DECIMAL(10, 2)) AS cv_invoices,
    MIN(total_invoices) AS min_invoices,
    MAX(total_invoices) AS max_invoices,
    SUM(total_spent) AS sum_spent,
    CAST(AVG(total_spent) AS DECIMAL(10, 2)) AS avg_spent,
    CAST(STDEVP(total_spent) AS DECIMAL(10,2)) AS dev_spent,
    CAST(STDEVP(total_spent)/AVG(total_spent)*100 AS DECIMAL(10,2)) AS cv_spent,
    MIN(total_spent) AS min_spent,
    MAX(total_spent) AS max_spent
FROM facturasClientes;


--Por InvoiceLine: Totales, promedios, desviaciones y rango
WITH facturasClientes2 AS (
    SELECT
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        COUNT(DISTINCT InvoiceLine.InvoiceId) AS total_invoices,
        SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS total_spent
    FROM InvoiceLine
    JOIN Invoice ON Invoice.InvoiceId = InvoiceLine.InvoiceId
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY 
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName
    --ORDER BY total_spent DESC, Customer.CustomerId
)
SELECT DISTINCT
    SUM(total_invoices) AS sum_invoices,
    CAST(AVG(CAST(total_invoices AS DECIMAL)) AS DECIMAL(10, 2)) AS avg_invoices,
    CAST(STDEVP(total_invoices) AS DECIMAL(10, 2)) AS dev_invoices,
    CAST(STDEVP(total_invoices)/AVG(CAST(total_invoices AS DECIMAL))*100 AS DECIMAL(10, 2)) AS cv_invoices,
    MIN(total_invoices) AS min_invoices,
    MAX(total_invoices) AS max_invoices,
    SUM(total_spent) AS sum_spent,
    CAST(AVG(total_spent) AS DECIMAL(10, 2)) AS avg_spent,
    CAST(STDEVP(total_spent) AS DECIMAL(10,2)) AS dev_spent,
    CAST(STDEVP(total_spent)/AVG(total_spent)*100 AS DECIMAL(10,2)) AS cv_spent,
    MIN(total_spent) AS min_spent,
    MAX(total_spent) AS max_spent
FROM facturasClientes2;

--Por Invoice: Mediana
WITH facturasClientes AS (
    SELECT
        Invoice.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        COUNT(*) AS total_invoices,
        SUM(Invoice.total) AS total_spent
    FROM Invoice
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY    
        Invoice.CustomerId,
        Customer.FirstName,
        Customer.LastName
)
SELECT DISTINCT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_invoices) OVER () AS median_invoices,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_spent) OVER () AS median_spent
FROM facturasClientes;


--Por InvoiceLine: Mediana
WITH facturasClientes2 AS (
    SELECT
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        COUNT(DISTINCT InvoiceLine.InvoiceId) AS total_invoices,
        SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS total_spent
    FROM InvoiceLine
    JOIN Invoice ON Invoice.InvoiceId = InvoiceLine.InvoiceId
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY 
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName
)
SELECT DISTINCT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_invoices) OVER () AS median_invoices,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_spent) OVER () AS median_spent
FROM facturasClientes2;

