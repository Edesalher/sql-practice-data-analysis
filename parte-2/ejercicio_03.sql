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

--Aportación de los primeros 10 clientes que más gastaron
WITH CustomerExpenses AS (
    SELECT
        Invoice.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        COUNT(*) AS total_invoices,
        SUM(Invoice.total) AS total_spent,
        (SUM(Invoice.total)/SUM(SUM(Invoice.total)) OVER())*100 AS contribution
    FROM Invoice
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY  
        Invoice.CustomerId,
        Customer.FirstName,
        Customer.LastName
)
SELECT TOP 10 *
FROM CustomerExpenses
ORDER BY total_spent DESC;


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

==================================================================================================================================================
*/