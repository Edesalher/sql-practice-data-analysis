USE Chinook_AutoIncrement;
GO

-- EJERCICIO 1: 
-- Obtén todos los registros de la tabla Customer.

SELECT *
FROM Customer

-- EJERCICIO 2: 
/* El gerente quiere obtener una lista de clientes para una campaña de marketing.

    Necesita únicamente:
    -nombre
    -apellido
    -país

    Tu tarea
    Escribe una consulta que devuelva solamente esas tres columnas de Customer.*/

SELECT
    FirstName AS Nombre,
    LastName AS Apellido,
    Country AS País
FROM Customer

-- EJERCICIO 3:
/* El gerente te dice: "Quiero ver únicamente los clientes que viven en Estados Unidos."

    Tu tarea
    Devuelve: FirstName, LastName, Country únicamente para los clientes cuyo país sea USA.*/

SELECT
    FirstName AS Nombre,
    LastName AS Apellido,
    Country AS Pais
FROM Customer
WHERE Country = 'USA'

-- EJERCICIO 4:
/* El gerente quiere contactar clientes que viven en Brazil, Canada o Germany.

    Necesitamos nuevamente:
    -FirstName
    -LastName
    -Country

    Tu reto
    Obtén únicamente los clientes cuyo Country sea: Brazil, Canada, Germany*/

SELECT 
    FirstName AS Nombre,
    LastName AS Apellido,
    Country AS Pais
FROM Customer
WHERE Country IN ('Brazil', 'Canada', 'Germany')

-- EJERCICIO 5:
/* El gerente quiere: Todas las canciones cuyo precio sea mayor que 1.

    Tu tarea
    Muestra Name, UnitPrice de los tracks cuyo precio sea mayor que 1.*/

SELECT
    Name,
    UnitPrice
FROM Track
WHERE UnitPrice > 1

-- EJERCICIO 6:
/* ¿Cuáles son los 10 tracks más caros?

    Tu misión
    Obtén Name, UnitPrice de los 10 tracks más caros.*/

SELECT TOP(10)
    Name,
    UnitPrice
FROM Track
ORDER BY UnitPrice DESC

-- EJERCICIO 7: ANALISIS
/* Imagínate que eres Data Analyst de Chinook y el gerente te dice: "Quiero saber cuáles son nuestros productos más caros." */

SELECT TOP(3)
    Name,
    Composer,
    UnitPrice
FROM Track
ORDER BY UnitPrice DESC

-- EJERCICIO 8:
/* El gerente quiere encontrar canciones que cumplan dos condiciones simultáneamente: El precio debe ser mayor que $1 y el género debe ser Rock.

    Tu tarea 1
    Primero explora la tabla Genre. Quiero que obtengas: GenreId, Name de Genre.

    Tu tarea 2
    Obtén: Name, UnitPrice, GenreId de los tracks que cumplan ambas condiciones:

    UnitPrice > 1
    GenreId = 1

    Esta vez NO necesitas JOIN.*/

SELECT * FROM Genre; --id de Rock es 1

SELECT
    Name,
    UnitPrice,
    GenreId
FROM Track
WHERE 
    UnitPrice > 1 
    AND GenreId = 1; --1 corresponde a Rock

-- EJERCICIO 9:
/* El gerente dice: "Quiero analizar los tracks que sean Rock o Jazz."

    Tu misión
    Primero consulta Genre y determina el GenreId de Jazz.

    Después escribe una consulta sobre Track que muestre: Name, UnitPrice, GenreId para los tracks que sean Rock o Jazz*/

SELECT * FROM Genre; --id de Jazz es 2

SELECT 
    Name,
    UnitPrice,
    GenreId
FROM Track
WHERE GenreId = 1 OR GenreId = 2;

-- EJERCICIO 10:
/* El gerente quiere analizar los tracks cuyo precio esté entre $0.99 y $1.49, inclusive.

    Tu tarea
    Obtén Name, UnitPrice de todos los tracks cuyo precio esté dentro de ese rango.*/

SELECT
    Name,
    UnitPrice
From Track
WHERE UnitPrice BETWEEN 0.99 AND 1.49

-- EJERCICIO 11:
/* El gerente dice: "Quiero encontrar todas las canciones cuyo nombre contenga la palabra Love."

    Tu tarea
    Obtén Name, UnitPrice de todos los tracks cuyo nombre contenga Love.*/

SELECT 
    Name,
    Composer,
    UnitPrice
FROM Track
WHERE Name LIKE '%Love%'

-- EJERCICIO 12:
/* El gerente dice: "Quiero las canciones cuyo nombre empiece con Love."

    Tu tarea
    Obtén Name, Composer, UnitPrice de los tracks cuyo nombre empiece con Love.*/

SELECT 
    Name,
    Composer,
    UnitPrice
From Track
WHERE Name LIKE 'Love%'

-- EJERCICIO 13:
/* ¿En qué países tenemos clientes? 

    Tu tarea
    "Dame todos los países diferentes en los que tenemos clientes."*/

SELECT 
    DISTINCT Country
FROM Customer;

-- EJERCICIO 14:
/* Encuentra todos los tracks que no tienen compositor registrado.

    Muestra: Name, Composer
*/

SELECT 
    Name,
    Composer
FROM Track
WHERE Composer IS NULL

-- EJERCICIO 15: MINI-RETO DE INTEGRACIÓN
/* El gerente te dice: "Quiero identificar los 10 tracks más caros que contengan la palabra Love en su nombre."

    Necesitamos:
    -Solo los tracks cuyo nombre contenga Love.
    -Los 10 más caros.

    Mostrar: Name, Composer, UnitPrice ordenados del más caro al más barato.*/

SELECT
    Name,
    Composer,
    UnitPrice
FROM Track
WHERE Name LIKE '%Love%'
ORDER BY UnitPrice DESC
