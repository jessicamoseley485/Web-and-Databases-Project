USE coursework;


-- Query 1 - Shows the number of students on each course
SELECT Stu_Course, COUNT(Stu_Course) as 'Number of students'
FROM Student
GROUP BY Stu_Course;


-- Query 2 - Shows the full name and URN of every student on the course 'BSc Computer Science' who is part of the society 'CompSoc'
SELECT CONCAT(Stu_FName, ' ', Stu_LName) as 'Student Name', Student.URN
FROM Student INNER JOIN Course
ON Student.Stu_Course = Course.Crs_Code
INNER JOIN Attends
ON Student.URN = Attends.URN AND Attends.Society_URN = 1 AND Course.Crs_Code = 100;

-- Query 3 - Shows the URN of every student who is part of the society 'CompSoc'
SELECT URN
FROM Attends
WHERE Society_URN =
	(SELECT Society_URN
	FROM Society
	WHERE Society_Name = 'CompSoc');


-- If you want to do some more queries as the extra challenge task you can include them here
	
-- Query 4 - Creates an index on Society_URN in the table 'Society'
CREATE INDEX SocietyURN_Index
ON Society(Society_URN);
	
-- Query 5 - Creates a composite index on Stu_FName and Stu_LName in the table 'Student'
CREATE INDEX studentName
ON Student(Stu_FName, Stu_LName);

-- Query 6 - Creates a prefix index based on the first character of Stu_LName in the table 'Student'
CREATE INDEX Surname_Initial
ON Student(Stu_LName(1));

-- Query 7 - Shows the Full name and URN of all the students in the society 'CompSoc' who have the hobby 'D&D'
SELECT CONCAT(Stu_FName, ' ', Stu_LName) as 'Student Name', Student.URN
FROM Student INNER JOIN Student_Hobby
ON Student.URN = Student_Hobby.URN
INNER JOIN Attends
ON Student.URN = Attends.URN AND Attends.Society_URN = 
 	(SELECT Society_URN
	FROM Society
	WHERE Society_Name = 'CompSoc')
AND Student_Hobby.Hobby_URN =
	(SELECT Hobby_URN
	FROM Hobby
	WHERE Hobby_Name = 'D&D');

-- Query 8 - Shows a list of the societies that the student 'Iyabo Ogunsola' is part of
SELECT Society.Society_URN, Society_Name
FROM Society INNER JOIN Attends
ON Society.Society_URN = Attends.Society_URN
WHERE Attends.URN = 
	(SELECT URN
	FROM Student
	WHERE Stu_FName = 'Iyabo' AND Stu_LName = 'Ogunsola');



										


