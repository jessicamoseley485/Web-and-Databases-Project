const express = require('express');
const ejs = require('ejs');
const util = require('util');
const mysql = require('mysql2');
const bodyParser = require('body-parser');


/**
 * The following constants with your MySQL connection properties
 * You should only need to change the password
 */

const PORT = 8000;
const DB_HOST = 'localhost';
const DB_USER = 'root';
const DB_PASSWORD = 'gaYfXRxO5E';
const DB_NAME = 'coursework';
const DB_PORT = 3306;

/**
 * DO NOT CHANGE ANYTHING BELOW THIS LINE UP TO THE NEXT COMMENT
 */
var connection = mysql.createConnection({
	host: DB_HOST,
	user: DB_USER,
	password: DB_PASSWORD,
	database: DB_NAME,
	port: DB_PORT
});

connection.query = util.promisify(connection.query).bind(connection);

connection.connect(function (err) {
	if (err) {
		console.error('error connecting: ' + err.stack);
		console.log('Please make sure you have updated the password in the index.js file. Also, ensure you have run db_setup.sql to create the database and tables.');
		return;
	}
	console.log('Connected to the Database');
});


const app = express();

app.set('view engine', 'ejs');
app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: false }));

/**
 * YOU CAN CHANGE THE CODE BELOW THIS LINE
 */

// Add your code here

app.get('/', async (req, res) => {
	const totalCourses = await connection.query(
		'SELECT COUNT(*) as count FROM Course'
	)
	const totalEnrolments = await connection.query(
		'SELECT SUM (Crs_Enrollment) as sum FROM Course'
	)
	const averageEnrolment = await connection.query(
		'SELECT AVG(Crs_Enrollment) as avg FROM Course'
	)
	const highestEnrolment = await connection.query(
		'SELECT Crs_Title FROM Course WHERE Crs_Enrollment = (SELECT MAX(Crs_Enrollment) as max FROM Course)'
	)
	
	const lowestEnrolment = await connection.query(
		'SELECT Crs_Title FROM Course WHERE Crs_Enrollment = (SELECT MIN(Crs_Enrollment) as min FROM Course)'
	)

	res.render('index', {
		totalCourses: totalCourses[0].count,
		totalEnrolments: totalEnrolments[0].sum,
		averageEnrolment: averageEnrolment[0].avg,
		highestEnrolment: highestEnrolment[0].Crs_Title,
		lowestEnrolment: lowestEnrolment[0].Crs_Title
	}); 
});

app.get('/courses', async (req, res) => {
	const courses = await connection.query('SELECT * FROM Course')
	res.render('courses', {courses: courses});
});

app.get('/edit-course/:id', async (req, res) => {
	const course = await connection.query('SELECT Crs_Title, Crs_Enrollment FROM Course WHERE Crs_Code = ?', [req.params.id]);

	res.render('edit', {course: course[0], message: ''});
});

app.get('/create-course', async (req, res) => {
	res.render('create', {message: ''});
});

app.post('/create-course', async (req, res) => {
	const newCourse  = req.body;
	const courses = await connection.query('SELECT * FROM Course');
	unique = true;

	if (newCourse.Crs_Title.length < 10 || newCourse.Crs_Title.length > 250) {
		res.render('create', {message: 'Course not created, invalid course title'});
		return;
	} else if (isNaN(newCourse.Crs_Code)) {
		res.render('create', {message: 'Course not created, invalid course code'});
		return;
	} else if (code = 'ER_DUP_ENTRY') {
		res.render('create', {message: 'Course not created, course code is not unique'});
		return;
	} else if (isNaN(newCourse.Crs_Enrollment) || newCourse.Crs_Enrollment < 0 || newCourse.Crs_Enrollment > 10000) {
		res.render('create', {message: 'Course not created, enrollment not within a suitable range'});
		res.send("Course not created, enrollment not within suitable range");
		return;
	}

	await connection.query('INSERT INTO Course VALUES ((?), (?), (?))', [newCourse.Crs_Code, newCourse.Crs_Title, newCourse.Crs_Enrollment]);
	res.render('create', {message: 'Course Created'});
	
});

app.post('/edit-course/:id', async (req, res) => {
	const updatedCourse  = req.body;

	if (updatedCourse.Crs_Title.length < 10 || updatedCourse.Crs_Title.length > 250) {
		const course = await connection.query('SELECT Crs_Title, Crs_Enrollment FROM Course WHERE Crs_Code = ?', [req.params.id]);

		res.render('edit', {course: course[0], message: 'Course not updated, course title not the correct length'});
		return;
	} else if (isNaN(updatedCourse.Crs_Enrollment) || updatedCourse.Crs_Enrollment < 0 || updatedCourse.Crs_Enrollment > 10000) {
		const course = await connection.query('SELECT Crs_Title, Crs_Enrollment FROM Course WHERE Crs_Code = ?', [req.params.id]);

		res.render('edit', {course: course[0], message: 'Course not updated, enrollment not within a valid range'});
		return;
	}

	await connection.query('UPDATE Course SET ? WHERE Crs_Code = ?', [updatedCourse, req.params.id])
	const course = await connection.query('SELECT Crs_Title, Crs_Enrollment FROM Course WHERE Crs_Code = ?', [req.params.id]);

	res.render('edit', {course: course[0], message: 'Course updated'});

});










/**
 * DON'T CHANGE ANYTHING BELOW THIS LINE
 */

app.listen(PORT, () => {

	console.log(`Server is running on port http://localhost:${PORT}`);

});



exports.app = app;