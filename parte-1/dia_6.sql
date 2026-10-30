USE Chinook_AutoIncrement;
GO

-- EJERCICIO 1: Clasificar canciones por precio
/* Contexto de negocio: la tienda quiere identificar cuántas canciones pertenecen a cada nivel de precio.
    Utiliza la tabla Track y su columna UnitPrice.

    Tu consulta debe:
        1. Mostrar el nombre de la canción (Name).
        2. Mostrar su precio (UnitPrice).
        3. Crear una columna llamada categoria_precio usando CASE.
        4. Aplicar las categorías:
        - Menor que 1.00: Barato.
        - Desde 1.00 hasta menor que 1.50: Medio.
        - Mayor o igual a 1.50: Caro.
        5. Ordenar los resultados por precio de menor a mayor.

    Pregunta de análisis: ¿Qué categorías crees que tendrán más canciones en Chinook? Compruébalo con tu consulta.
        R//
        Solo se muestran 2 categorías, Barato y Caro. La categoría "Barato" tiene más caciones, 3290.
    */
        

SELECT 
    Name AS cancion,
    UnitPrice AS precio_unitario,
    CASE 
        WHEN UnitPrice < 1 THEN 'Barato'
        WHEN UnitPrice >= 1 AND UnitPrice < 1.5 THEN 'Medio'
        WHEN UnitPrice >= 1.5 THEN 'Caro'
    END AS categoria_precio
FROM Track
ORDER BY UnitPrice ASC;

SELECT 
    CASE 
        WHEN UnitPrice < 1 THEN 'Barato'
        WHEN UnitPrice >= 1 AND UnitPrice < 1.5 THEN 'Medio'
        WHEN UnitPrice >= 1.5 THEN 'Caro'
    END AS categoria_precio,
    COUNT(*) as total_canciones
FROM Track
GROUP BY 
    CASE 
        WHEN UnitPrice < 1 THEN 'Barato'
        WHEN UnitPrice >= 1 AND UnitPrice < 1.5 THEN 'Medio'
        WHEN UnitPrice >= 1.5 THEN 'Caro'
    END
ORDER BY total_canciones ASC;

-- EJERCICIO 2: Resumen de canciones por categoría
/*  Crea una consulta que:
    1. Clasifique cada canción con CASE, utilizando las mismas categorías del ejercicio anterior.
    2. Cuente cuántas canciones hay en cada categoría.
    3. Muestre la categoría y el total de canciones.
    4. Ordene los resultados para identificar primero la categoría con más canciones.

    Deben aparecer las tres categorías (Barato, Medio y Caro), incluso si alguna tiene cero canciones.

    Pregunta de análisis: ¿Qué revela la distribución de canciones sobre la estructura de precios de la tienda?
        R//
        Sabiendo que el total de canciones es de 3503,
        la distribución de precios está concentrada en dos niveles: Aproximadamente el 94% de las canciones pertenece a la categoría barata y el 6% a la cara.
    */

SELECT
    Categorias.categoria_precio,
    COUNT(Track.TrackId) AS total_canciones
FROM (
    VALUES
        ('Barato'),
        ('Medio'),
        ('Caro')
) AS Categorias(categoria_precio)
LEFT JOIN Track ON Categorias.categoria_precio = 
    CASE
        WHEN Track.UnitPrice < 1 THEN 'Barato'
        WHEN Track.UnitPrice < 1.5 THEN 'Medio'
        WHEN Track.UnitPrice >= 1.5 THEN 'Caro'
    END
GROUP BY Categorias.categoria_precio
ORDER BY total_canciones DESC;

-- EJERCICIO 3: Clasificar clientes según su gasto
/*  Contexto de negocio: el equipo comercial quiere segmentar a sus clientes para identificar cuáles generan más ingresos.
    Tablas que necesitarás:
    - Customer: información de los clientes.
    - Invoice: facturas asociadas a cada cliente.
    - InvoiceLine: productos facturados, cantidades y precios.

    Construye una consulta que:
    1. Muestre el identificador del cliente, su nombre, apellido y país.
    2. Calcule su gasto total a partir de las líneas de factura.
    3. Clasifique a cada cliente según su gasto:
    - Menos de $10: Bajo.
    - Desde $10 hasta $50, inclusive: Medio.
    - Más de $50: Alto.
    4. Muestre una fila por cliente.
    5. Ordene el resultado de mayor a menor gasto total*/

SELECT 
    Customer.CustomerId,
    Customer.FirstName AS Nombre,
    Customer.LastName AS Apellido,
    Customer.Country AS Pais,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS Gasto,
    CASE
        WHEN SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) < 10 THEN 'Bajo'
        WHEN SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) <= 50 THEN 'Medio'
        WHEN SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) > 50 THEN 'Alto'
    END AS Clasificacion
FROM Customer
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
GROUP BY 
    Customer.CustomerId,
    Customer.FirstName,
    Customer.LastName,
    Customer.Country
ORDER BY Gasto DESC;




