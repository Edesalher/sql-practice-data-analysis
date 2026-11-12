/*
==================================================================================================================================================
EJERCICIO 03
DIA: 01

Contexto: el director comercial vio tus hallazgos y propone un programa VIP para los 10 clientes que más gastaron: un 15% de descuento en 
sus próximas compras. Su razonamiento es: “son los clientes que más ingresos me aportan, así que debo premiarlos para no perderlos.”

Qué debes investigar: si tus propios resultados de los ejercicios 1 y 2 respaldan esa propuesta. No necesitas nuevas consultas, aunque 
puedes hacer una si crees que la necesitas para sustentar tu respuesta.

Requisitos:

-Evalúa la premisa del director usando cifras que ya tienes.
-Indica qué información adicional te haría falta para decidir.
-Explica cómo comprobarías, después de implementarlo, si el programa funcionó.

==================================================================================================================================================
*/

-- Consultas SQL

USE Chinook_AutoIncrement;
GO

--Aportación de los segundos 10 clientes (11 - 20) que más gastaron
WITH CustomerExpenses AS (
    SELECT
        Invoice.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        SUM(Invoice.total) AS total_spent,
        (SUM(Invoice.total)/SUM(SUM(Invoice.total)) OVER())*100 AS contribution
    FROM Invoice
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY Invoice.CustomerId, Customer.FirstName, Customer.LastName
),
TopClients AS (
    SELECT *
    FROM CustomerExpenses
    ORDER BY total_spent DESC
    OFFSET 10 ROWS
    FETCH NEXT 10 ROWS ONLY
)
SELECT SUM(contribution) AS second_top_10_customer_contribution
FROM TopClients;

--Aportación de 10 clientes sin ordenar por gasto
WITH CustomerExpenses AS (
    SELECT
        Invoice.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        SUM(Invoice.total) AS total_spent,
        (SUM(Invoice.total)/SUM(SUM(Invoice.total)) OVER())*100 AS contribution
    FROM Invoice
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY Invoice.CustomerId, Customer.FirstName, Customer.LastName
),
TopClients AS (
    SELECT TOP 10 *
    FROM CustomerExpenses
)
SELECT SUM(contribution) AS contribution_10_customers
FROM TopClients;

--Total de compras de los primeros 10 clientes que más gastaron
WITH CustomerInvoices AS (
    SELECT
        Invoice.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        COUNT(*) AS total_invoices,
        SUM(Invoice.total) AS total_spent
    FROM Invoice
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY Invoice.CustomerId, Customer.FirstName, Customer.LastName
)
SELECT TOP 10
    CustomerId, FirstName, LastName, total_invoices
FROM CustomerInvoices
ORDER BY total_spent DESC;

--Fecha de última compra (factura)
SELECT TOP 1 
    InvoiceDate AS last_invoice_date, YEAR(InvoiceDate) AS last_invoice_year
FROM Invoice
ORDER BY InvoiceDate DESC;

--Fecha de última compra de los 10 primeros clientes que más gastaron
WITH CustomerInvoices AS (
    SELECT
        Invoice.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        MAX(Invoice.InvoiceDate) AS last_invoice_date,
        COUNT(*) AS total_invoices,
        SUM(Invoice.total) AS total_spent
    FROM Invoice
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY Invoice.CustomerId, Customer.FirstName, Customer.LastName
),
TopCustomers AS (
    SELECT TOP 10
        CustomerId, FirstName, LastName, last_invoice_date
    FROM CustomerInvoices
    ORDER BY total_spent DESC
)
SELECT *, YEAR(last_invoice_date) AS last_invoice_year
FROM TopCustomers
ORDER BY last_invoice_date DESC;


/*
==================================================================================================================================================
ANÁLISIS

Del ejercicio 1 y 2 se sabe

| Ventas totales | Facturas | Clientes | Ticket |
|----------------|----------|----------|--------|
| 2328.60        | 412      | 59       | 5.65   |

Compras por cliente:
| Total   | Media | Mediana | S    | CV    | S +/- CV       | Rango         | Min   | Max   |
|---------|-------|---------|------|-------|----------------|---------------|-------|-------|
| 412     | 6.98  | 7       | 0.13 | 1.85% | 6.98 +/- 0.13  | 6.85 - 7.11   | 6     | 7     |

Gastos por cliente:
| Total   | Media | Mediana | S    | CV    | S +/- CV       | Rango         | Min   | Max   |
|---------|-------|---------|------|-------|----------------|---------------|-------|-------|
| 2328.60 | 39.47 | 37.62   | 2.89 | 7.13% | 39.47 +/- 2.89 | 36.58 - 42.36 | 36.64 | 49.62 |

Contribuciones al gasto

| Clientes ordenados de mayor a menor gasto | % de clientes | % de ventas |
|-------------------------------------------|--------------:|------------:|
| Primeros 10 de 59                         |       16.95 % |     19.37 % |
| Segundos 10 de 59                         |       16.95 % |     17.23 % |
| Cualquiera 10 de 59                       |       16.95 % |     17.27 % |

- Si todos los clientes hubieran gastado lo mismo, la aportación de los primeros 10 clientes sería: 16.95%
- Comparando 19.37% con 17.23% y 17.27%, el top 10 tiene aproximadamente 2 puntos porcentuales de ventaja.
- Redondeando el período analizado a 5 años:
    facturas por año: 7/5 = 1.4 facturas por año
    1.4 * 10 clientes = 14 facturas por año * 5 años = 70 facturas aportadas por los 10 clientes = 70/412 = 16.99% ~ 17%
    Casi todos los clientes compraron 7 veces, por ello 10 clientes de los 59 (16.95%) hicieron 16.99% facturas.
- Comparando los porcentajes de aportación de los primeros 10 clientes que más gastaron, 16.99% en facturas y 19.37% en ventas:
    Puntos porcentuales de diferencia: 2.38
    En la desviación estańdar y CV tambié se refleja que la aportación de los clientes a las ventas no es homogénea.
- Sabiendo que la fecha de la última factura, de las 412, es 2025-12-22 (diciembre 2025):
    Del top 10 de clientes que más gastaron 9 compraron por última vez en 2025. El restante compró la última vez en octubre 2024.
    De los 9 que compraron por última vez en 2025, solo 1 compró por última vez en diciembre 2025.
    Los datos no aseguran que el top 10 de clientes seguirá comprando en próximos años.

==================================================================================================================================================
*/