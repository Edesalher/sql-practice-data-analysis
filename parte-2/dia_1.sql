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

