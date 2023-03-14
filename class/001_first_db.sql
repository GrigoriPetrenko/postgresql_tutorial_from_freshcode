-- Клієнти для сервера PostgreSQL:
-- - консольний клієнт psql (PostgreSQL)
-- - десктопний (веб) застосунок PGAdmin
-- - розширення VSCode
-- - серверна частина full-stack застосунку

-- SQL
-- Назви розділів вказані до https://postgrespro.ru/docs/postgresql/15/index

-- Прийнято іменувати в snake_case
-- Великі літери, спец.символи - в подвійних лапках

-- Створення БД (1.3, 23.2)
CREATE DATABASE test;
CREATE DATABASE "Test1";
CREATE DATABASE test-db;

-- Видалення БД (1.3, 23.5)
DROP DATABASE test1;
DROP DATABASE "Test1";
DROP DATABASE "test-db";

CREATE TABLE IF NOT EXISTS users (
 id SERIAL,
 first_name VARCHAR(64),
 last_name VARCHAR(64),
 is_male BOOLEAN
)

-- Видалення таблиці (5.1)
DROP TABLE IF EXISTS users;

/* Створення таблиці (2.3, 5.1)
  * з типами даних (8)
  * з обмеженнями (5.4):
    - обмеження-перевірка CHECK (умова) - рівня стовпця чи таблиці
    - обмеження NOT NULL                - рівня стовпця
    - обмеження унікальності UNIQUE     - рівня стовпця чи таблиці
    - первинний ключ PRIMARY KEY        - рівня стовпця чи таблиці
      (первинний ключ - стовпець або набір стовпців, які однозначно ідентифікують запис(рядок))
      (може бути один на таблицю)
      (PRIMARY KEY = UNIQUE + NOT NULL)
  * та зі значеннями за замовчуванням DEFAULT (5.2)
*/

CREATE TABLE IF NOT EXISTS users (
 id SERIAL PRIMARY KEY,
 first_name VARCHAR(64) NOT NULL,
 last_name VARCHAR(64),
 email VARCHAR(64) CHECK (email <> '' ) NOT NULL UNIQUE,
 tel_number CHAR(13) NOT NULL UNIQUE,
 birthday DATE CHECK (birthday <= CURRENT_DATE) NOT NULL,
 is_male BOOLEAN,
 orders_count SMALLINT CHECK (orders_count >= 0) DEFAULT 0
)

-- Додавання даних до таблиці (2.4)
-- Кількість і послідовність полів мають співпадати
INSERT INTO users(first_name, last_name, email, tel_number, birthday, is_male)
VALUES ('Test1', 'Testovich', 'test4@test.com', '+380999999995', '2000-09-01', TRUE);

INSERT INTO users(first_name, last_name, email, tel_number, birthday, is_male)
VALUES ('Test', 'Testovich', 'testtf@test.com', '+380999299992', '1999-01-31', TRUE),
       ('Test', 'Testovich', 'testgfh@test.com', '+380929999991', '1999-01-10', TRUE);

-- Task: Описати структуру таблиці для сутності ТЕЛЕФОН (бренд, модель, ціна, колір, дата виробництва)
CREATE TABLE IF NOT EXISTS phones (
  id SERIAL PRIMARY KEY,
  brand VARCHAR(64) NOT NULL,
  model VARCHAR(64) NOT NULL,
  color VARCHAR(64),
  production_date DATE CHECK (production_date <= CURRENT_DATE) NOT NULL,
  price NUMERIC(7,2) CHECK (price > 0) ,
  UNIQUE(brand, model)
)

-- Task: Додати дані до телефонів (2-3 рядка)
INSERT INTO phones(brand, model, color, production_date, price)
VALUES ('Test', '12', 'black', '2020-10-01', 2000.55),
       ('Test', 'TS8i', 'orange', '2022-09-01', 35000.55);

-- Запити на вибірку
-- SELECT ЩО
-- FROM ЗВІДКИ;

-- Вивести літеральне значення
SELECT CURRENT_DATE;
SELECT CURRENT_TIME;
SELECT CURRENT_TIMESTAMP;

-- * - вивести всі стовпці
SELECT *
FROM users;

-- Проєкція - вибрати конкретні стовпці
SELECT first_name, last_name
FROM users;

-- Призначення псевдонімів (ім'я_стовпця/значення AS нове_ім'я)
SELECT first_name AS name, last_name AS surname
FROM users;

-- Обчислення значень за допомогою функцій (глава 9)
SELECT first_name || ' ' || last_name AS "Fullname", email
FROM users;

-- Ex: Вивести для кожного користувача день і місяць народження
SELECT first_name || ' ' || last_name AS "Fullname", 
       EXTRACT(DAY FROM birthday) AS day, 
       EXTRACT(MONTH FROM birthday) AS month
FROM users;

-- Ex: Вивести для користувачів їх вік
SELECT first_name || ' ' || last_name AS "Fullname",
     EXTRACT(YEAR FROM age(birthday))
FROM users;       

-- Task: Отримати для кожної пари бренд/модель кількість місяців з дати їх виробництва
SELECT brand || '/' || model AS "Phone",
       EXTRACT(MONTH FROM AGE(production_date)) AS month_count
FROM phones;

-- Відображення різних значень DISTINCT (тобто прибрати рядки, що дублюються) (2.5)
SELECT DISTINCT first_name
FROM users;

-- Сортування (2.5, 7.5)
-- ORDER BY ASC (за зростанням: за замовчуванням), DESC (за спаданням: вказувати явно)
SELECT first_name || ' ' || last_name AS "Fullname",
       email, tel_number
FROM users
ORDER BY email DESC;       

SELECT first_name || ' ' || last_name AS "Fullname",
       email, tel_number
FROM users
ORDER BY first_name, email DESC;   

-- Task: Впорядкувати телефони за датою виробництва. Найновіші зверху
SELECT brand, model, production_date
FROM phones
ORDER BY production_date DESC;

-- Ex: Отримати список користувачів, впорядкованих за днем/місяцем народження впродовж року
SELECT first_name, 
       EXTRACT(DAY FROM birthday) AS day, 
       EXTRACT(MONTH FROM birthday) AS month,
       birthday
FROM users
ORDER BY EXTRACT(MONTH FROM birthday), EXTRACT(DAY FROM birthday);

-- Пагінація (7.6)
-- LIMIT (скільки відобразити) OFFSET (скільки пропустити)

SELECT *
FROM users
ORDER BY id
LIMIT 5 OFFSET 5;

-- Ex: Отримати найдорожчий телефон
SELECT *
FROM phones
ORDER BY price DESC
LIMIT 1;
-- (OFFSET 0)