USE Chinook_AutoIncrement;
GO

-- EJERCICIO 1: Facturas por año
/* ¿Cuántas facturas se emitieron en cada año? */

SELECT 
    YEAR(InvoiceDate) AS año,
    COUNT(*) AS total_facturas_emitidas
FROM Invoice
GROUP BY YEAR(InvoiceDate)
ORDER BY año;

-- EJERCICIO 2: Ingresos anuales
/* Objetivo: Calcular los ingresos totales por año.
    Utiliza la tabla Invoice y su columna Total.

    Tu consulta debe mostrar:
    - año
    - ingresos_totales

    Instrucciones:
    1. Utiliza YEAR() para agrupar las facturas por año.
    2. Utiliza SUM() para sumar el importe total de las facturas de cada año.
    3. Ordena los resultados de menor a mayor año. */

SELECT
    YEAR(InvoiceDate) AS año,
    SUM(Total) AS ingresos_totales
FROM Invoice
GROUP BY YEAR(InvoiceDate)
ORDER BY año;

-- EJERCICIO 3: Ingresos mensuales
/* Ahora vamos a profundizar en el análisis temporal.

    Escribe una consulta SQL que muestre, para cada combinación de año y mes:
    1. El año.
    2. El mes.
    3. La cantidad de facturas.
    4. Los ingresos totales.

    Requisitos:
    - Utiliza YEAR(), MONTH(), COUNT() y SUM().
    - Agrupa por año y mes.
    - Ordena cronológicamente, primero por año y luego por mes. */

SELECT
    YEAR(InvoiceDate) AS año,
    MONTH(InvoiceDate) AS mes,
    COUNT(*) AS cantidad_facturas,
    SUM(Total) AS ingresos_totales
FROM Invoice
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY año, mes;


--  EJERCICIO 4: Mes con mayores ingresos
/* ¿Cuáles fueron los cinco períodos mensuales con mayores ingresos en todo el historial de Chinook?
    Escribe una consulta que muestre:
    - Año.
    - Mes.
    - Ingresos totales.

    Requisitos
    1. Agrupa las facturas por año y mes.
    2. Calcula los ingresos de cada período.
    3. Ordena los resultados de mayor a menor ingreso.
    4. Devuelve únicamente los cinco primeros resultados mediante TOP (5). */

SELECT TOP(5)
    YEAR(InvoiceDate) AS año,
    MONTH(InvoiceDate) AS mes,
    SUM(Total) AS ingresos_totales
FROM Invoice
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY ingresos_totales DESC;

-- EJERCICIO 5: Interpretación de tendencias
/* Sin escribir una nueva consulta SQL, responde estas tres preguntas utilizando los resultados de los ejercicios anteriores:

    1. Desempeño anual: ¿qué año tuvo los mayores ingresos y cuál fue la diferencia monetaria respecto al año con menores ingresos?
        R// El año 2022 tuvo la mayor cantidad de ingresos, $481.45, con una diferencia monetaria de $31.99 respecto al año 2021 que fue el año con menores ingresos.

    2. Volumen frente a ingresos: ¿qué demuestra la comparación entre 2021 y 2025 sobre la relación entre cantidad de facturas e ingresos?
        R// De acuerdo a los resultados, una mayor cantidad de facturas emitidas no te asegura una mayor cantidad de ingresos.

    3. Estacionalidad: ¿puedes afirmar que la primera mitad del año genera más ingresos que la segunda? Explica qué información adicional necesitarías para comprobarlo. 
        R// Para afirmarlo, primero se debería comparar el promedio de ingresos de la primera mitad de cada año, desde 2021 a 2025, con su segunda mitad de cada año;
            y con ello analizar si existe una tendencia que pueda afirmar si la primera mitad del año genera más ingresos.
    */

