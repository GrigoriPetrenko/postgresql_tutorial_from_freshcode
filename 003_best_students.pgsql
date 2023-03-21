CREATE DATABASE BestStudents;

CREATE TABLE Students (
    id_of_student SERIAL PRIMARY KEY,
    name varchar(64) NOT NULL,
    surname varchar(64) NOT NULL
);

CREATE TABLE Courses (
    id_course SERIAL PRIMARY KEY,
    title VARCHAR(120) NOT NULL,
    description varchar(300),
    hours INTEGER
);
CREATE TABLE Exams (
    id_of_student INTEGER REFERENCES Students(id_of_student),
    id_course INTEGER REFERENCES Courses(id_course),
    mark numeric(2,1) CHECK (mark <= 12) DEFAULT NULL,
    PRIMARY KEY (id_of_student, id_course)
);

INSERT INTO Students (name, surname) VALUES
('John', 'Doe'),
('Jane', 'Doe'),
('Bob', 'Smith'),
('Alice', 'Johnson'),
('Tom', 'Wilson');

INSERT INTO Students (name, surname) VALUES
('New', 'Student');

INSERT INTO Courses (title, description, hours) VALUES
('Introduction to Computer Science', 'Basic concepts in computer science', 40),
('Database Systems', 'Introduction to database design and implementation', 60),
('Data Structures and Algorithms', 'Design and analysis of algorithms and data structures', 80),
('Web Development', 'Building dynamic web applications using HTML, CSS, and JavaScript', 50),
('Artificial Intelligence', 'Introduction to artificial intelligence and machine learning', 70);

INSERT INTO Courses (title, description, hours) VALUES
('Not Importent Science', 'No description', 40);

-- ERROR: numeric field overflow - чому?
ALTER TABLE Exams ALTER COLUMN mark TYPE NUMERIC(3,1);

INSERT INTO Exams (id_of_student, id_course, mark) VALUES
(1, 1, 10.0),
(1, 2, 4.0),
(1, 3, 8.0),
(2, 1, 11.0),
(2, 5, 9.0),
(3, 2, 7.0),
(3, 3, 9.0),
(4, 4, 10.0),
(4, 5, 11.0),
(5, 1, 6.0),
(5, 4, 9.0),
(5, 5, 11.0);
INSERT INTO Exams (id_of_student, id_course, mark) VALUES
(1, 6, NULL);

SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM exams;

-- Відобразити імена та прізвища студентів та назви курсів, що ними вивчаються.
SELECT Students.name, Students.surname, Courses.title
FROM Students
INNER JOIN Exams ON Students.id_of_student = Exams.id_of_student
INNER JOIN Courses ON Exams.id_course = Courses.id_course;
-- Створити представлення по запиту 1.
CREATE VIEW StudentsCourses AS
SELECT Students.name, Students.surname, Courses.title
FROM Students
INNER JOIN Exams ON Students.id_of_student = Exams.id_of_student
INNER JOIN Courses ON Exams.id_course = Courses.id_course;
-- Відобразити бали студента 	John Doe з дисципліни «Database Systems».
SELECT Exams.mark
FROM Exams
INNER JOIN Students ON Exams.id_of_student = Students.id_of_student
INNER JOIN Courses ON Exams.id_course = Courses.id_course
WHERE Students.name = 'John' AND Students.surname = 'Doe' AND Courses.title = 'Database Systems';
-- Відобразити студентів, які мають бали нижче 6.
SELECT Students.name, Students.surname, Courses.title, Exams.mark
FROM Exams
INNER JOIN Students ON Exams.id_of_student = Students.id_of_student
INNER JOIN Courses ON Exams.id_course = Courses.id_course
WHERE Exams.mark <= 6;
-- Відобразити студентів, які прослухали дисципліну «Introduction to Computer Science» та мають за нею оцінку.
SELECT Students.name, Students.surname, Exams.mark
FROM Exams
INNER JOIN Students ON Exams.id_of_student = Students.id_of_student
INNER JOIN Courses ON Exams.id_course = Courses.id_course
WHERE Courses.title = 'Introduction to Computer Science' AND Exams.mark IS NOT NULL;
-- Відобразити середній бал та кількість курсів, які відвідав кожен студент.
SELECT s.id_of_student, s.name, s.surname, COUNT(e.id_course) AS courses_count, ROUND(AVG(e.mark), 1) AS average_mark
FROM Students s
INNER JOIN Exams e ON s.id_of_student = e.id_of_student
GROUP BY s.id_of_student, s.name, s.surname;
-- Відобразити студентів, які мають середній бал вище 9.0.
SELECT s.name, s.surname, ROUND(AVG(e.mark),1) AS avg_mark
FROM Students s
INNER JOIN Exams e ON s.id_of_student = e.id_of_student
GROUP BY s.id_of_student
HAVING AVG(e.mark) > 9.0;
-- *Відобразити дисципліни, які ще не прослухав жоден студент.
SELECT *
FROM Courses
LEFT JOIN Exams ON Courses.id_course = Exams.id_course
WHERE Exams.mark IS NULL;
-- (Підзапити:)
-- Отримати список студентів, у яких день народження збігається із днем народження 'John', 'Doe'.
ALTER TABLE Students ADD COLUMN date_of_birth DATE;

UPDATE Students SET date_of_birth = '1993-05-10' WHERE name = 'John' AND surname = 'Doe';
UPDATE Students SET date_of_birth = '1995-03-15' WHERE name = 'Jane' AND surname = 'Doe';
UPDATE Students SET date_of_birth = '1992-07-02' WHERE name = 'Bob' AND surname = 'Smith';
UPDATE Students SET date_of_birth = '1994-11-20' WHERE name = 'Alice' AND surname = 'Johnson';
UPDATE Students SET date_of_birth = '1993-05-10' WHERE name = 'Tom' AND surname = 'Wilson';

SELECT name, surname
FROM Students
WHERE DATE_TRUNC('day', date_of_birth) = (
    SELECT DATE_TRUNC('day', date_of_birth)
    FROM Students
    WHERE name = 'John' AND surname = 'Doe'
);

-- Відобразити студентів, які мають середній бал вище, ніж 'John', 'Doe'.
SELECT name, surname
FROM Students
WHERE id_of_student IN (
    SELECT id_of_student
    FROM Exams
    WHERE mark IS NOT NULL
    GROUP BY id_of_student
    HAVING AVG(mark) > (
        SELECT AVG(mark)
        FROM Exams
        WHERE id_of_student = (
            SELECT id_of_student
            FROM Students
            WHERE name = 'John' AND surname = 'Doe'
        ) AND mark IS NOT NULL
    )
);
-- Отримати список предметів, у яких кількість годин більше, ніж у 'Database Systems'.
SELECT title 
FROM Courses 
WHERE hours > (
    SELECT hours FROM Courses WHERE title = 'Database Systems'
) AND title <> 'Database Systems';
-- Отримати список
-- студент | предмет | оцінка
-- де оцінка має бути більшою за НАЙНИЖЧУ оцінку 'John' 'Doe'.
-- (Умовні вирази:)
-- Вивести
-- студент | предмет | оцінка
-- щоб оцінка виводилася у літерному вигляді "відмінно", "добре" або "задовільно".
