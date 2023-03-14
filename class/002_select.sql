-- Фільтрація (7.2.2)
-- WHERE

-- SELECT ЩО
-- FROM ЗВІДКИ
-- WHERE УМОВА;

------------------------------------------------------------------------------------
-- Оператори порівняння (9.2)
-- >, <, >=, <=, =, <> (!=) 

-- Ex: Відібрати користувачів з іменем Test1
SELECT *
FROM users
WHERE first_name = 'Test1';

-- Ex: Відібрати користувачів, що народилися до 2000 року
SELECT * 
FROM users
WHERE birthday < '2000-01-01';

-- Ex: Відібрати користувачів з іменйлом, що не дорівнює 'test6@test.com'
SELECT email
FROM users
WHERE email <> 'test6@test.com';

--------------------------------------------------------------------------------------------
-- Логічні оператори  (9.1)
-- AND OR NOT

-- Ex: Знайти користувачів на ім'я Test Testovich
SELECT *
FROM users
WHERE first_name = 'Test' AND last_name = 'Testovich';

-- Task: Знайти користувачів, які народилися 1998, 1999, 2000 рр.
SELECT *
FROM users
WHERE EXTRACT(YEAR FROM birthday) >= 1998 
      AND EXTRACT(YEAR FROM birthday) <= 2000 ;
-- =
SELECT *
FROM users
WHERE birthday >= '1998-01-01' AND birthday <= '2000-12-31';      

-- Task: Знайти користвачів до 18 років і більше= 65
INSERT INTO users(first_name, last_name, email, tel_number, birthday, is_male)
VALUES ('test2', NULL, 'tes1dsf4ttf@test.com', '+380959292990', '1950-01-31', FALSE),
       ('Test3', NULL, 'ted1sf4stgfh@test.com', '+380952999995', '2010-01-10', FALSE);

-- Ex: Знайти користувачів до 18 або більше= 65
SELECT *
FROM users
WHERE EXTRACT(YEAR FROM AGE(birthday)) < 18 OR EXTRACT(YEAR FROM AGE(birthday)) >= 65;

----------------------------------------------------------------------------------------------
-- Пошук за шаблоном  (9.7.1)
-- LIKE, ILIKE (регістронезалежний)

-- % - будь-яка кількість будь-яких символів (включаючи нічого)
-- _ - один будь-який символ

-- Ex: Відібрати користувачів з іменем Test
SELECT *
FROM users
WHERE first_name LIKE 'Test';

-- Ex: Відібрати користувачів з іменем Test + один символ
SELECT *
FROM users
WHERE first_name LIKE 'Test_';

-- Ex: Відібрати користувачів з іменем, що починається на test
SELECT *
FROM users
WHERE email NOT LIKE 'test%';
-- '%test%' test, 1sdvdsftest, testdsfjsdjfksd, fhjsdfjsdtest5465456
-- '_%test%_' 

-- Ex: Відібрати користувачів з номерами телефонів оператора 099, 050, 066
SELECT *
FROM users
WHERE tel_number LIKE '+38099_______' 
      OR tel_number LIKE '+38050_______' 
      OR tel_number LIKE '+38066_______';
-- '+38099%', '___099_______' , '%099_______'

-- Ex: Відібрати користувачів на ім'я test2 незалежно від регістра
SELECT *
FROM users 
WHERE first_name ILIKE 'tEsT2';

----------------------------------------------------------------------------------
-- Перевірка на приналежність інтервалу (діапазону) (9.2)
-- BETWEEN..AND

-- Ex: Знайти користувачів, які народилися 1998, 1999, 2000 рр.
SELECT *
FROM users
WHERE birthday >= '1998-01-01' AND birthday <= '2000-12-31';  
-- =
SELECT *
FROM users
WHERE birthday BETWEEN '1998-01-01' AND '2000-12-31';

-- поза межами діапазону: NOT BETWEEN..AND
-- Ex: Знайти користувачів до 18 і більше 65 років
SELECT *
FROM users
WHERE EXTRACT(YEAR FROM AGE(birthday)) < 18 OR EXTRACT(YEAR FROM AGE(birthday)) >= 65;
-- =
SELECT *
FROM users
WHERE EXTRACT(YEAR FROM AGE(birthday)) NOT BETWEEN 18 AND 65;

---------------------------------------------------------------------------------
-- Перевірка на приналежність списку значень (7.2.2, 9.24.1, 9.24.2)
-- IN 

-- Ex: Відобразити користувачів з іменами Test1, Test2
SELECT *
FROM users
WHERE first_name = 'Test1' OR first_name = 'Test2';
-- =
SELECT *
FROM users
WHERE first_name IN ('Test1','Test2');

------------------------------------------------------------------
-- Порівняння з NULL (9.2)
-- IS NULL / ISNULL
-- IS NOT NULL / NOTNULL

-- Ex: Перевирити у кого не вказано прізвище
-- = NULL
SELECT *
FROM users
WHERE last_name IS NULL;

-- Ex: Перевирити у кого вказано прізвище
-- <> NULL
SELECT *
FROM users
WHERE last_name IS NOT NULL;

-----------------------------------------------------------------------------------
-- Порядок виконання інструкцій
-- 5 SELECT
-- 1 FROM
-- 2 WHERE
-- 3 ORDER BY
-- 4 LIMIT OFFSET

-- Ex: Знайти прізвища і дату народження користувачів 
-- з явно вказаним прізвищем, які народилися в січні 
-- і прорядкувати за прізвищем 
-- і відобразити 3 і 4 результати

SELECT last_name, birthday
FROM users
WHERE last_name IS NOT NULL AND EXTRACT(MONTH FROM birthday) = 1
ORDER BY last_name
LIMIT 2 OFFSET 2;
---------------------------------------------------------------------------------------------
-- 0 Создать табл. employees (id, fn, ln, email, birthday, gender, salary)

CREATE TYPE gender_type AS ENUM ('male', 'female', 'other');

CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  first_name varchar(30) NOT NULL,
  last_name varchar(30) NOT NULL,
  email varchar(50) CHECK (email <> ''),
  birthday date NOT NULL CHECK (birthday < current_date),
  gender gender_type NOT NULL,
  salary numeric(10,2) NOT NULL DEFAULT 6000.00
);

DROP TABLE employees;

INSERT INTO employees (last_name, first_name, email, birthday, gender, salary)
VALUES ('Ivanov', 'Timur', 'ivanov@gmail.com', '1993-01-01', 'male', 10000.00),
       ('Avramenko', 'Timur', NULL, '2002-01-22', 'male', 12000.00),
       ('Smirnova', 'Svetlana', 'sveta@gmail.com', '1994-10-14', 'female', 9000.00),
       ('Kulik', 'Petr', NULL, '2001-01-05', 'male', 14000.00),
       ('Goncharova', 'Maria', 'mashka@gmail.com', '1989-03-14', 'female', 12000.00),
       ('Naumenko', 'Roman', NULL, '1960-02-08', 'other', 8000.00),
       ('Naumenko', 'Maksim', 'roma@gmail.com', '1980-03-31', 'male', 25000.00);

-- Task 1 Відобразити всіх співробітників, прізвище яких починається на A і закінчується на kо / Avramenko, Adelko, Ako
SELECT *
FROM employees
WHERE last_name LIKE 'A%ko';

-- Task 2 Відобразити всіх співробітників, які народилися раніше 2000 року та впорядкувати їх за прізвищем.
-- Якщо прізвище однакове, то за ім'ям
SELECT *
FROM employees
WHERE birthday < '2000-01-01'
ORDER BY last_name, first_name;

-- Task 3 Відобразити ім'я, прізвище та вік співробітників, ім'я яких починається з Т, а прізвище містить o, /Okhrimenko, Tolok
-- упорядковані за віком від молодшого до старшого
SELECT first_name, last_name, EXTRACT(YEAR FROM AGE(birthday)) AS age
FROM employees
WHERE first_name LIKE 'T%' AND last_name ILIKE '%o%'
ORDER BY age;

-- Task 4 Відобразити всіх співробітників, які народилися 1960 року
SELECT * 
FROM employees 
WHERE EXTRACT(YEAR FROM birthday) = 1960;

-- Task 5 Відобразити 2 найстарших співробітника віком від 25 до 28 років
SELECT *
FROM employees
WHERE EXTRACT(YEAR FROM AGE(birthday)) BETWEEN 25 AND 28
ORDER BY birthday
LIMIT 2;

-- Task 6 Відобразити співробітників без email, які народилися в січні 
SELECT *
FROM employees
WHERE email ISNULL AND EXTRACT(MONTH FROM birthday) = 1;

------------------------------------------------------------------------------------------------------------

-- Агрегатні функції (9.21)
-- COUNT, MIN, MAX, AVG, SUM

-- Ex: Обчислити загальну кількість користувачів
SELECT count(id) AS "Users count"
FROM users;

-- Ex: Обчислити середній вік користувачів
SELECT AVG(EXTRACT( YEAR FROM AGE(birthday))) AS "Avg age"
FROM users;

-- Ex: Обчислити максимальну зп користувачів
SELECT MAX(salary)
FROM employees;

-- Ex: Обчислити максимальну зп жінок
SELECT MAX(salary)
FROM employees
WHERE gender = 'female';

-- Task: Визначити кількість співробітників, у яких ДН в січні
SELECT count(id)
FROM employees
WHERE EXTRACT(MONTH FROM birthday) = 1;

---------------------------------------------------------------------------------------------
-- Групування (7.2.3)
-- GROUP BY

-- Ex: Обчислити середню зп для кожного гендера
SELECT gender, AVG(salary)
FROM employees
GROUP BY gender;

-- Ex: Обчислити кількість користувачів з кожним ім'ям
SELECT first_name, COUNT(id)
FROM users
GROUP BY first_name;

-- Ex: Обчислити середню зп працівників допенсійного віку
SELECT gender, AVG(salary)
FROM employees
WHERE EXTRACT(YEAR FROM AGE(birthday)) < 65
GROUP BY gender;

-- Task: Вивести кількість співробітників, народжених кожного місяця, з явно вказаними email
SELECT EXTRACT(MONTH FROM(birthday)) AS month_number, count(*)
FROM employees
WHERE email IS NOT NULL
GROUP BY month_number
ORDER BY month_number;

-----------------------------------------------------------------------
-- Умова на групу (фільтрація груп) (7.2.3)
-- HAVING

-- Ex: Відобразити середню зп тих гендерів, для яких вона більше за 14000
SELECT gender, AVG(salary)
FROM employees
GROUP BY gender
HAVING AVG(salary)>14000;

-- Ex: вивести гендери та мінімальні зарплати тільки для тих гендерів,
-- чисельність яких > 1 особи
SELECT gender, MIN(salary)
FROM employees
GROUP BY gender
HAVING COUNT(*)>1;

-- Ex: Відобразити середню зп чоловіків
SELECT gender, MIN(salary)
FROM employees
WHERE gender = 'male' -- (якщо можна умову помістити в WHERE, то поміщати сюди, а не в HAVING)
GROUP BY gender;
-- ~
SELECT gender, MIN(salary)
FROM employees
GROUP BY gender
HAVING gender = 'male'; -- В HAVING поміщати умови тільки на групи, які не можна в WHERE

-- Порядок виконання інструкцій в запитах на вибірку
-- 9 SELECT 4 calc_aggregate_func
-- 1 FROM
-- 2 WHERE
-- 3 GROUP BY
-- 5 HAVING 
-- 6 ORDER BY
-- 8 LIMIT 7 OFFSET

--------------------------------------------------------------------------
-- Зміна структури таблиці (5.6)
-- ALTER

-- Ex: Додати для працівникыв поле для номеру телефона
ALTER TABLE employees
ADD COLUMN tel_number CHAR(13) CHECK (tel_number LIKE '+380_________');

INSERT INTO employees (last_name, first_name, email, birthday, gender, salary, tel_number)
VALUES ('Ivanov', 'Timur', 'ivanov@gmail.com', '1993-01-01', 'male', 10000.00, '+380999999999')
RETURNING *;

---------------------------------------------------------------------------------------------
-- Оновлення даних в таблиці (6.2)
-- UPDATE

-- Ex: Підвищити працівникам зп на 20%
UPDATE employees
SET salary = salary * 1.2
RETURNING first_name;

-- Ex: Змінити пошту працівнику з id 1
UPDATE employees
SET email = 'test1@gmail.com'
WHERE id = 1;

-- Task: збільшити жінкам зп на 10% 
UPDATE employees
SET salary = salary * 1.1
WHERE gender = 'female';

---------------------------------------------------------------------------
-- Видалення даних з таблиці (6.3)
-- DELETE

-- Видалити інфо про співробітника з id 2
DELETE FROM employees
WHERE id = 2
RETURNING *;

----------------------------------------------------------------------------

-- Повернення даних при виконанні INSERT, UPDATE, DELETE (6.4)
-- RETURNING

------------------------------------------------------------------------------
-- SQL - Structured Query Language (мова структурованих запитів):
-- - DDL - Data Definition Language (мова опису даних):
       -- CREATE
       -- DROP
       -- ALTER
-- - DML - Data Manipulation Language (мова управління (маніпулювання) даними):
       -- INSERT
       -- SELECT (іноді окремо виділяють у DQL)
       -- UPDATE
       -- DELETE
       -- = (CRUD)
-- - DCL - Data Control Language: керування правами доступу до даних
-- - TCL - Transaction Control Language: керування транзакціями