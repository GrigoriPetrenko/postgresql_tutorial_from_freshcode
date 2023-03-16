-- Відобразити студентів на ім'я Anton та прізвище Antonov.
SELECT * FROM STUDENTS WHERE first_name = 'Anton' AND last_name = 'Antonov';
-- Відобразити студентів, які народилися в період із 2005 по 2008 рік.
SELECT first_name, last_name, birthday FROM students WHERE birthday BETWEEN '2005-01-01' AND '2008-12-31';
-- Відобразити студентів на ім'я Mykola із середніми балами більше 4.5.
SELECT first_name, last_name, avg_mark FROM STUDENTS WHERE first_name = 'Mykola' AND avg_mark > 4.5;
-- Відобразити кількість студентів, які навчаються у кожній групі.
SELECT group_name, COUNT(*) AS num_students FROM students GROUP BY group_name;
-- Відобразити загальну кількість студентів, які вступили 2018 року.
SELECT COUNT(*) FROM STUDENTS WHERE entered_at >= '2018-01-01' AND entered_at <= '2018-12-31';
-- *Відобразити студентів, які користуються послугами оператора Київстар. (тобто містять код 098 або 096)
SELECT * FROM students WHERE phone_number LIKE '+38098%' OR phone_number LIKE '+38096%';
-- *Відобразити середній (середній) бал студентів жіночої статі кожного факультету. Список впорядкувати за зменшенням середнього балу. Стовпчик із середнім балом назвати avg_avg_mark.
SELECT department, AVG(avg_mark) AS avg_avg_mark FROM STUDENTS WHERE gender = 'Female' GROUP BY department ORDER BY avg_avg_mark DESC;
-- *Відобразити мінімальний середній бал студентів факультету інформаційних технологій, що народилися влітку, залежно від року вступу. Виводити інформацію лише про ті роки надходження, де мінімальний середній бал вищий за 3,5.
SELECT entered_at, MIN(avg_mark) AS min_avg_mark
FROM STUDENTS
WHERE department = 'IT' AND
      EXTRACT(MONTH FROM birthday) BETWEEN 6 AND 8
GROUP BY entered_at
HAVING MIN(avg_mark) > 3.5;
-- Для всіх студентів з ім'ям Bob змінити написання імені Vasia.
UPDATE STUDENTS
SET first_name = 'Vasya'
WHERE first_name = 'Bob';
-- *Додати до таблиці стовпець з інформацією про серію/номер паспорта студента.
ALTER TABLE STUDENTS ADD COLUMN passport VARCHAR(8) UNIQUE CHECK (passport ~ '^[A-Z]{2}\d{0,6}$');