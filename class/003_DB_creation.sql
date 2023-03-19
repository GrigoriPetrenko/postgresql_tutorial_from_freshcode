-- Предметна область (ПО) ПРОДАЖ ТЕЛЕФОНІВ:
   -- Користувачі можуть оформляти замовлення для покупки телефонів.
   -- Один користувач може оформляти декілька замовлень.
   -- В одному замовленні може бути кілька позицій телефонів у заданій кількості.

-- Замовлення 
-- id | fn  | ln  | email  | Ntel  |  tel |  screen |  cpu |  amount | date  | orderN
-- id | fn1 | ln1 | email1 | Ntel1 | tel1 | screen1 | cpu1 |    1    | date1 | order1
-- id | fn1 | ln1 | email1 | Ntel1 | tel2 | screen2 | cpu2 |    2    | date1 | order1
-- id | fn2 | ln2 | email2 | Ntel2 | tdv1 | screen1 | cpu1 |    2    | date2 | order2

-- Але тут є НЕДОЛІКИ:
--           - дублювання даних
--           - відсутність єдиного джерела істини

-- НОРМАЛІЗУЄМО відношення (розділяємо на кілька таблиць без вказаних недоліків):

-- USERS (id, fn, ln, tel, email)
-- TELS(id, brand, model, screen, cpu)
-- ORDERS(id,   N,    date,       user_id)
--    ex: 1   123456  2023-03-01    1
-- TEL_TO_ORDERS(id, order_id, tel_id, count)
--    ex:        1     1        1       1
--    ex:        2     1        10      2

-- Отже, дані зберігаємо оптимально, а збірні дані з різних таблиць вигляду
-- 1 id, N, date, id, fn, ln, tel, email  id, brand, model, screen, cpu count
-- отримуєто запитами (наприклад, з'єднаннями, підзапитами)

-- Типи зв'язків між сутностями (таблицями):
   -- 1:1 one-to-one
       -- зустрічається рідше за інших
       -- => як правило, одна з таблиць посилається на іншу
   -- 1:n one-to-many
       -- (parent) головна 1:n залежна/дочірня (child)
       -- => додаємо зовнішній ключ (REFERENCES) до залежної табл. на головну
   -- m:n many-to-many
       -- => вводимо дод. табл., яка посилатиметься (REFERENCES) на обидві з відношення m:n

-- Для ПО ПРОДАЖ ТЕЛЕФОНІВ:
-- user 1 <-> n orders (тому в orders додали user_id )
-- tels m <-> n orders (тому додали додаткову таблицю)

-- Ex: m:n
-- stud  N :  M subject => 3 таблиці
-- 1) stud
-- 2) subject
-- 3) stud_to_subjects (id, stud_id, subj_id, mark)
     
-- Ex: brand-model-tel     
-- brand  1 : m  model  1 : n  tel, тоді:
-- 1) BRANDS(id, address)
-- 2) MODELs( id, name, ..., brand_id)
-- 3) TELs( id, SN, IMEI, model_id)

---------------------------------------

users <- orders <- phones_to_orders -> phones

-- Створюємо в порядку від головних до залежних
-- Видаляємо в звоторньому

CREATE DATABASE phones_sales;

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  first_name varchar(64) NOT NULL,
  last_name varchar(64) NOT NULL,
  email varchar(64) CHECK (email<>''),
  tel char(13) NOT NULL UNIQUE CHECK(tel LIKE '+380_________')
);

INSERT INTO users(first_name, last_name, email, tel)
VALUES('Petro1', 'Petrenko1', 'test1@test.test', '+380983456789'),
    ('Petro2', 'Petrenko2', 'test2@test.test', '+380993456789'),
    ('Petro3', 'Petrenko3', 'test3@test.test', '+380933456789'),
    ('Petro4', 'Petrenko4', 'test4@test.test', '+380503456789'),
    ('Petro5', 'Petrenko5', 'test5@test.test', '+380633456789'),
    ('Petro6', 'Petrenko6', 'test6@test.test', '+380683456789'),
    ('Petro7', 'Petrenko7', 'test7@test.test', '+380443456789'),
    ('Petro8', 'Petrenko8', 'test8@test.test', '+380663456789'),
    ('Petro9', 'Petrenko9', 'test9@test.test', '+380733456789');

CREATE TABLE phones (
  id SERIAL PRIMARY KEY,
  brand VARCHAR(32) NOT NULL,
  model VARCHAR(32) NOT NULL,
  price numeric(10,2) CHECK (price > 0) NOT NULL,
  color VARCHAR(32), 
  manufactured_year SMALLINT CHECK (manufactured_year <= EXTRACT(YEAR FROM CURRENT_DATE) 
                                    AND manufactured_year >= 1970),
  UNIQUE(brand, model)
);

INSERT INTO phones(brand, model, price, color, manufactured_year)
VALUES ('Samsung', 'GALAXY1', 600.0, 'blue', 2015),
       ('Samsung', 'GALAXY2', 300.0, 'white', 2019),
       ('Samsung', 'GALAXY3', 400.0, 'blue', 2020),
       ('Samsung', 'GALAXY4', 500.0, 'white', 2021),
       ('IPhone', '7', 1800.0, 'blue', 2015),
       ('IPhone', '8', 1200.0, 'white', 2019),
       ('IPhone', '9', 1300.0, 'blue', 2020),
       ('IPhone', 'X', 2000.0, 'white', 2021),
       ('IPhone', '15', 3000.0, 'blue', 2021);    

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  created_at DATE NOT NULL CHECK(created_at<=CURRENT_DATE) DEFAULT CURRENT_DATE
);


INSERT INTO orders (user_id, created_at)
VALUES (6, '2023-02-01'),
       (2, '2023-03-03'),
       (3, '2022-08-10'),
       (3, '2022-12-28'),
       (4, '2022-07-17'),
       (1, '2022-08-30'),
       (6, '2023-01-21');
 
CREATE TABLE phones_to_orders(
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  phone_id INTEGER REFERENCES phones(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  amount SMALLINT CHECK(amount > 0)
);

INSERT INTO phones_to_orders (phone_id, order_id, amount)
VALUES (1, 6, 1),
       (1, 2, 1),
       (2, 2, 1),
       (3, 4, 1),
       (7, 4, 2),
       (9, 5, 3),
       (8, 5, 2);

---------------------------------------------------------------------------------
-- Ідея з'єднання: 
-- 1 test1
-- 2 test2       
-- JOIN
-- 1 1 2023-03-03
-- 2 1 2023-03-04
-- 3 2 2023-03-05
-- =
-- 1 1 2023-03-03 1 test1
-- 2 1 2023-03-04 1 test1
-- 3 2 2023-03-05 2 test2 

-- Ex: Вивести інформацію про користувачів і їх замовлення
SELECT *
FROM orders AS o INNER JOIN users AS u ON o.user_id=u.id;

-- Task: Вивести інфо про телефони і в якій кількості їх купували
SELECT *
FROM phones AS p INNER JOIN phones_to_orders AS ptoo ON p.id=ptoo.phone_id;

-- Ex: Вивести скільки яких телефонів купили
SELECT brand, model, sum(amount) AS total_amount
FROM phones AS p INNER JOIN phones_to_orders AS ptoo ON p.id=ptoo.phone_id
GROUP BY brand, model
ORDER BY total_amount DESC;

-- Task: Вивести кількість замовлень кожного користувача
SELECT u.id, u.first_name, u.last_name, count(*) AS count
FROM orders AS o INNER JOIN users AS u ON o.user_id=u.id
GROUP BY u.id, u.first_name, u.last_name
ORDER BY count DESC;

-- Task: Вивести інформацію про сумарну вартість проданих телефонів кожної моделі (впорядкувати)
SELECT brand, model, p.price*SUM(amount) AS total_sum
FROM phones AS p INNER JOIN phones_to_orders AS ptoo ON p.id=ptoo.phone_id
GROUP BY brand, model, p.price
ORDER BY total_sum DESC;
-- =
SELECT model, sum(price*amount) as sum
FROM public.phones_to_orders inner join phones ON phones_to_orders.phone_id = phones.id
group by model;

-- Ex: Яку сумарну кількість телефонів купили різних брендів
SELECT brand, sum(amount)
FROM phones AS p INNER JOIN phones_to_orders AS ptoo ON p.id=ptoo.phone_id
GROUP BY brand

-- Ex: Яку сумарну кількість телефонів купили різних брендів 2021 року виготовлення
SELECT brand, sum(amount)
FROM phones AS p INNER JOIN phones_to_orders AS ptoo ON p.id=ptoo.phone_id
WHERE manufactured_year = 2021
GROUP BY brand;

-- Ex: Яку сумарну кількість телефонів різних брендів купили 2022 року
SELECT brand, sum(amount)
FROM phones AS p INNER JOIN phones_to_orders AS ptoo ON p.id=ptoo.phone_id 
                 INNER JOIN orders AS o ON ptoo.order_id=o.id
WHERE EXTRACT(YEAR FROM created_at) = 2022
GROUP BY brand;                 

-- Ex: Які телефони купував юзер з id 1
SELECT *
FROM users AS u INNER JOIN orders AS o ON u.id = o.user_id
                INNER JOIN phones_to_orders AS ptoo ON o.id = ptoo.order_id
                INNER JOIN phones AS p ON p.id = ptoo.phone_id
WHERE u.id = 1;

-- Види з'єднань
-- Внутрішнє (беремо з обох таблиць тільки ті рідки, яким є відповідні в другій таблиці)
SELECT *
FROM orders AS o INNER JOIN users AS u ON o.user_id=u.id;

-- Ліве (беремо з лівої таблиці всі рідки, і дописуємо відповідно ім з правої, якщо вони існують)
SELECT *
FROM orders AS o LEFT JOIN users AS u ON o.user_id=u.id;

-- Праве (беремо з правої таблиці всі рідки, і дописуємо відповідно ім з лівої, якщо вони існують)
SELECT *
FROM orders AS o RIGHT JOIN users AS u ON o.user_id=u.id;

-- Ex: Відобразити тих користувачів, які не робили замовлень
SELECT *
FROM orders AS o RIGHT JOIN users AS u ON o.user_id=u.id
WHERE o.id IS NULL;

-- Ex: Відобразити тих користувачів, які робили замовлення
SELECT DISTINCT u.id, first_name, last_name
FROM orders AS o RIGHT JOIN users AS u ON o.user_id=u.id
WHERE o.id IS NOT NULL;
-- =
SELECT DISTINCT u.id, first_name, last_name
FROM orders AS o INNER JOIN users AS u ON o.user_id=u.id;

---------------------------------------------------------------------------------
-- Представлення VIEW (3.2)
CREATE VIEW users_to_phones AS
  SELECT u.id AS u_id, first_name, last_name, email,tel, o.id AS o_id, created_at, ptoo.id AS ptoo_id, amount, p.id AS p_id, brand,model, price,color, manufactured_year
  FROM users AS u INNER JOIN orders AS o ON u.id = o.user_id
                  INNER JOIN phones_to_orders AS ptoo ON o.id = ptoo.order_id
                  INNER JOIN phones AS p ON p.id = ptoo.phone_id;

SELECT *
FROM users_to_phones
WHERE u_id=1; 