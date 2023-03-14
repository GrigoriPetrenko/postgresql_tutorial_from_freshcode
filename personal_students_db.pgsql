-- Створити базу даних та таблицю за наступною схемою:
-- STUDENTS(id, first_name, last_name, birthday, email, phone_number, group, avg_mark, gender, entered_at, department)

CREATE TABLE IF NOT EXISTS STUDENTS (
 id SERIAL PRIMARY KEY,
 first_name VARCHAR(64) NOT NULL,
 last_name VARCHAR(64) NOT NULL,
 birthday DATE CHECK (birthday <= CURRENT_DATE) NOT NULL,
 email VARCHAR(64) CHECK (email <> '' ) NOT NULL UNIQUE,
 phone_number CHAR(13) NOT NULL UNIQUE,
 group_name VARCHAR(10) NOT NULL,
 avg_mark INT CHECK (avg_mark <= 12) DEFAULT 0,
 gender VARCHAR(20) NOT NULL,
 entered_at DATE NOT NULL,
 department VARCHAR(120) NOT NULL
)
-- тут     group – шифр групи
--            avg_mark – середній бал
--            entered_at – рік вступу
--            department – назва факультету

-- Продумати типи даних та обмеження для зазначених полів (стобців).
-- Заповнити таблиці тестовими даними.

INSERT INTO students (id, first_name, last_name, birthday, email, phone_number, group_name, avg_mark, gender, entered_at, department)
VALUES
    (1, 'John', 'Doe', '1998-01-01', 'johndoe@example.com', '+380991231561', 'group1', 10, 'Male', '2020-01-01', 'Sales'),
    (2, 'Jane', 'Doe', '1999-02-02', 'janedoe@example.com', '+380661234562', 'group2', 8, 'Female', '2020-01-02', 'Marketing'),
    (3, 'Bob', 'Smith', '2000-03-03', 'bobsmith@example.com', '+380631534563', 'group3', 9, 'Male', '2020-01-03', 'IT'),
    (4, 'Alice', 'Johnson', '2001-04-04', 'alicejohnson@example.com', '+380661234464', 'group4', 11, 'Female', '2020-01-04', 'HR'),
    (5, 'Tom', 'Brown', '2002-05-05', 'tombrown@example.com', '+380661234545', 'group5', 12, 'Male', '2020-01-05', 'Finance'),
    (6, 'Lisa', 'Wilson', '2003-06-06', 'lisawilson@example.com', '+380501244566', 'group6', 8, 'Female', '2020-01-06', 'Sales'),
    (7, 'David', 'Davis', '2004-07-07', 'daviddavis@example.com', '+380661234567', 'group7', 7, 'Male', '2020-01-07', 'Marketing'),
    (8, 'Sarah', 'Taylor', '2005-08-08', 'sarahtaylor@example.com', '+380664234568', 'group8', 10, 'Female', '2020-01-08', 'IT'),
    (9, 'Kevin', 'Lee', '2006-09-09', 'kevinlee@example.com', '+380661434569', 'group9', 11, 'Male', '2020-01-09', 'HR'),
    (10, 'Emily', 'Moore', '2007-10-10', 'emilymoore@example.com', '+380661434570', 'group10', 12, 'Female', '2020-01-10', 'Finance'),
    (11, 'Mark', 'Anderson', '2008-11-11', 'markanderson@example.com', '+380667234571', 'group1', 9, 'Male', '2020-01-11', 'Sales'),
    (12, 'Olivia', 'Jackson', '2009-12-12', 'oliviajackson@example.com', '+380668234572', 'group2', 8, 'Female', '2020-01-12', 'Marketing'),
    (31, 'Samantha', 'Johnson', '2000-01-31', 'samanthajohnson@example.com', '+380669234587', 'group1', 9, 'Female', '2020-02-01', 'Sales'),
    (32, 'Eric', 'Garcia', '1999-02-15', 'ericgarcia@example.com', '+380667234588', 'group2', 10, 'Male', '2020-02-02', 'Marketing'),
    (33, 'Stephanie', 'Martinez', '1998-03-20', 'stephaniemartinez@example.com', '+380663231589', 'group3', 11, 'Female', '2020-02-03', 'IT'),
    (34, 'Jacob', 'Gonzalez', '1997-04-25', 'jacobgonzalez@example.com', '+380662234590', 'group4', 12, 'Male', '2020-02-04', 'HR'),
    (35, 'Avery', 'Parker', '1996-05-30', 'averyparker@example.com', '+380665234591', 'group5', 10, 'Female', '2020-02-05', 'Finance'),
    (36, 'Caleb', 'Collins', '1995-06-04', 'calebcollins@example.com', '+380661274592', 'group6', 8, 'Male', '2020-02-06', 'Sales'),
    (37, 'Leah', 'Ramirez', '1994-07-09', 'leahramirez@example.com', '+380501284593', 'group7', 9, 'Female', '2020-02-07', 'Marketing'),
    (38, 'Isaac', 'Torres', '1993-08-14', 'isaactorres@example.com', '+380661934594', 'group8', 11, 'Male', '2020-02-08', 'IT'),
    (39, 'Madison', 'Peterson', '1992-09-19', 'madisonpeterson@example.com', '+380661274595', 'group9', 12, 'Female', '2020-02-09', 'HR'),
    (40, 'Ethan', 'Nguyen', '1991-10-24', 'ethannguyen@example.com', '+380661634596', 'group10', 10, 'Male', '2020-02-10', 'Finance'),
    (50, 'Adam', 'Smith', '1998-06-12', 'adamsmith@example.com', '+380661334580', 'group6', 9, 'Male', '2020-02-01', 'Marketing'),
    (51, 'Jessica', 'Brown', '1999-08-23', 'jessicabrown@example.com', '+380661239581', 'group7', 8, 'Female', '2020-02-02', 'Finance'),
    (52, 'George', 'Wilson', '2000-04-15', 'georgewilson@example.com', '+380661238582', 'group8', 10, 'Not decided', '2020-02-03', 'IT'),
    (53, 'Avery', 'Davis', '2001-11-27', 'averydavis@example.com', '+380661234883', 'group9', 12, 'Female', '2020-02-04', 'Sales'),
    (54, 'Mason', 'Taylor', '2002-03-09', 'masontaylor@example.com', '+380661237584', 'group10', 11, 'Male', '2020-02-05', 'HR'),
    (55, 'Eric', 'Taylor', '1995-06-05', 'erictaylor@example.com', '+380661234685', 'group5', 9, 'Male', '2020-06-05', 'Sales'),
    (56, 'Nina', 'Lee', '1997-07-15', 'ninalee@example.com', '+380661234486', 'group6', 8, 'Female', '2020-07-15', 'Marketing'),
    (57, 'Alex', 'Anderson', '1997-08-25', 'alexanderson@example.com', '+380981234387', 'group7', 10, 'Male', '2020-08-25', 'Finance'),
    (58, 'Cathy', 'Moore', '1995-09-05', 'cathymoore@example.com', '+380661334288', 'group8', 11, 'Transsexual', '2020-09-05', 'IT'),
    (59, 'Dave', 'Jackson', '1999-10-15', 'davejackson@example.com', '+380661214589', 'group9', 12, 'Male', '2020-10-15', 'Sales'),
    (60, 'Sophie', 'Miller', '1998-11-25', 'sophiemiller@example.com', '+380661234580', 'group10', 9, 'Female', '2020-11-25', 'Marketing'),
    (61, 'Frank', 'Smith', '2001-12-05', 'franksmith@example.com', '+380661234581', 'group1', 8, 'Male', '2020-12-05', 'Finance'),
    (62, 'Maggie', 'Brown', '2002-01-15', 'maggiebrown@example.com', '+380661234582', 'group2', 10, 'Female', '2021-01-15', 'IT');

-- Реалізувати запити:
-- Отримати інформацію про студентів (ім'я+прізвище, дата народження) у порядку від найстаршого до наймолодшого.
SELECT first_name, last_name, birthday
FROM students
ORDER BY birthday ASC;
-- Отримати список шифрів груп, що не повторюються.
SELECT DISTINCT group_name
FROM STUDENTS;
-- Отримати рейтинговий список студентів (ім'я (*або ініціал)+прізвище, середній бал): спочатку студентів із найвищим середнім балом, наприкінці з найменшим.
SELECT CONCAT(first_name, ' ', last_name) AS full_name, avg_mark
FROM STUDENTS
ORDER BY avg_mark DESC;
-- Отримати другу сторінку списку студентів під час перегляду по 6 студентів на сторінці.
SELECT * FROM students
ORDER BY id
OFFSET 6
LIMIT 6;
-- Отримати список 3-х найуспішніших студентів (ім'я, прізвище, середній бал, група).
-- * Отримати максимальний середній бал серед усіх студентів.
SELECT first_name || ' ' || last_name AS full_name, avg_mark, group_name 
FROM students 
WHERE avg_mark = (
  SELECT MAX(avg_mark) 
  FROM students
) 
ORDER BY avg_mark DESC 
LIMIT 3;
-- * Отримати інфо про студентів (ініціал+прізвище, номер телефону), де номер телефону буде частково прихований та представлений у форматі: +38012******* (тобто видно код оператора).
SELECT SUBSTRING(first_name, 1, 1) || '. ' || last_name AS initials, 
       '+38' || SUBSTRING(phone_number, 4, 3) || '*******' AS phone_number 
FROM students;