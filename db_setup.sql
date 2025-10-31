DROP DATABASE IF EXISTS coursework;

CREATE DATABASE coursework;

USE coursework;

-- This is the Course table
 
DROP TABLE IF EXISTS Course;

CREATE TABLE Course (
Crs_Code 	INT UNSIGNED NOT NULL,
Crs_Title 	VARCHAR(255) NOT NULL,
Crs_Enrollment INT UNSIGNED,
PRIMARY KEY (Crs_code));


INSERT INTO Course VALUES 
(100,'BSc Computer Science', 150),
(101,'BSc Computer Information Technology', 20),
(200, 'MSc Data Science', 100),
(201, 'MSc Security', 30),
(210, 'MSc Electrical Engineering', 70),
(211, 'BSc Physics', 100);


-- This is the student table definition


DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
URN INT UNSIGNED NOT NULL,
Stu_FName 	VARCHAR(255) NOT NULL,
Stu_LName 	VARCHAR(255) NOT NULL,
Stu_DOB 	DATE,
Stu_Phone 	VARCHAR(12),
Stu_Course	INT UNSIGNED NOT NULL,
Stu_Type 	ENUM('UG', 'PG'),
PRIMARY KEY (URN),
FOREIGN KEY (Stu_Course) REFERENCES Course (Crs_Code)
ON DELETE RESTRICT);


INSERT INTO Student VALUES
(612345, 'Sara', 'Khan', '2002-06-20', '01483112233', 100, 'UG'),
(612346, 'Pierre', 'Gervais', '2002-03-12', '01483223344', 100, 'UG'),
(612347, 'Patrick', 'O-Hara', '2001-05-03', '01483334455', 100, 'UG'),
(612348, 'Iyabo', 'Ogunsola', '2002-04-21', '01483445566', 100, 'UG'),
(612349, 'Omar', 'Sharif', '2001-12-29', '01483778899', 100, 'UG'),
(612350, 'Yunli', 'Guo', '2002-06-07', '01483123456', 100, 'UG'),
(612351, 'Costas', 'Spiliotis', '2002-07-02', '01483234567', 100, 'UG'),
(612352, 'Tom', 'Jones', '2001-10-24',  '01483456789', 101, 'UG'),
(612353, 'Simon', 'Larson', '2002-08-23', '01483998877', 101, 'UG'),
(612354, 'Sue', 'Smith', '2002-05-16', '01483776655', 101, 'UG');

DROP TABLE IF EXISTS Undergraduate;

CREATE TABLE Undergraduate (
UG_URN 	INT UNSIGNED NOT NULL,
UG_Credits   INT NOT NULL,
CHECK (60 <= UG_Credits <= 150),
PRIMARY KEY (UG_URN),
FOREIGN KEY (UG_URN) REFERENCES Student(URN)
ON DELETE CASCADE);

INSERT INTO Undergraduate VALUES
(612345, 120),
(612346, 90),
(612347, 150),
(612348, 120),
(612349, 120),
(612350, 60),
(612351, 60),
(612352, 90),
(612353, 120),
(612354, 90);

DROP TABLE IF EXISTS Postgraduate;

CREATE TABLE Postgraduate (
PG_URN 	INT UNSIGNED NOT NULL,
Thesis  VARCHAR(512) NOT NULL,
PRIMARY KEY (PG_URN),
FOREIGN KEY (PG_URN) REFERENCES Student(URN)
ON DELETE CASCADE);


-- Please add your table definitions below this line.......

DROP TABLE IF EXISTS Hobby;

CREATE TABLE Hobby (
Hobby_URN INT UNSIGNED NOT NULL,
Hobby_Name VARCHAR(512) NOT NULL,
Hobby_Description TEXT,
Category VARCHAR(512),
UNIQUE(Hobby_Name),
PRIMARY KEY (Hobby_URN));

INSERT INTO Hobby VALUES
(1, 'D&D', 'A Tabletop roleplaying game', 'Gaming'),
(2, '3D printing', 'Creating objects using a 3D printer', 'Construction'),
(3, 'Football', 'A team sport where you try to kick a ball into a goal', 'Fitness'),
(4, 'Chess', 'A two player game of strategy', 'Intellectual'),
(5, 'Fishing', 'Catching a fish with a fishing rod', 'Outdoor');

DROP TABLE IF EXISTS Society;

CREATE TABLE Society (
Society_URN INT UNSIGNED NOT NULL,
Society_Name VARCHAR(512) NOT NULL,
NumberOfStudents INT UNSIGNED,
UNIQUE(Society_Name),
PRIMARY KEY (Society_URN));

INSERT INTO Society VALUES
(1, 'CompSoc', 350),
(2, 'GameSoc', 100),
(3, 'Stage Crew', 30),
(4, 'Trampolining', 50),
(5, 'Crochet Society', 60);

DROP TABLE IF EXISTS Committee_Members;

CREATE TABLE Committee_Members (
Society_URN INT UNSIGNED NOT NULL,
Committee_Member VARCHAR(512) NOT NULL,
PRIMARY KEY (Society_URN, Committee_Member),
FOREIGN KEY (Society_URN) REFERENCES Society(Society_URN));

INSERT INTO Committee_Members VALUES
(1, 'Jon Smith'),
(1, 'Rachel Jones'),
(2, 'Tim Young'),
(3, 'Robert Brown'),
(4, 'Julia Evans'),
(5, 'Paul Green');

DROP TABLE IF EXISTS Student_Hobby;

CREATE TABLE Student_Hobby(
URN INT UNSIGNED NOT NULL,
Hobby_URN INT UNSIGNED NOT NULL,
PRIMARY KEY (URN, Hobby_URN),
FOREIGN KEY (URN) REFERENCES Student(URN),
FOREIGN KEY (Hobby_URN) REFERENCES Hobby(Hobby_URN));

INSERT INTO Student_Hobby VALUES
(612345, 1),
(612353, 1),
(612348, 1),
(612345, 3),
(612351, 4),
(612354, 5);

DROP TABLE IF EXISTS Attends;

CREATE TABLE Attends(
URN INT UNSIGNED NOT NULL,
Society_URN INT UNSIGNED NOT NULL,
PRIMARY KEY (URN, Society_URN),
FOREIGN KEY (URN) REFERENCES Student(URN),
FOREIGN KEY (Society_URN) REFERENCES Society(Society_URN));

INSERT INTO Attends VALUES
(612345, 1),
(612348, 1),
(612348, 3),
(612347, 2),
(612351, 1),
(612353, 1),
(612354, 1),
(612351, 4);



