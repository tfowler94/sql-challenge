--Data Engineering: rows 2-61
--Drop tables if exist
DROP TABLE Department_Employees;
DROP TABLE Department_Managers;
DROP TABLE Salaries;
DROP TABLE Departments;
DROP TABLE Employees;
DROP TABLE Titles;

--Create tables based on CSV files
CREATE TABLE Departments (
	dept_no VARCHAR(20) PRIMARY KEY,
	dept_name VARCHAR(20) NOT NULL
);

CREATE TABLE Department_Employees (
	emp_no VARCHAR(20),
	dept_no VARCHAR(20),
	CONSTRAINT fk_emp_no FOREIGN KEY (emp_no) REFERENCES Employees(emp_no),
	CONSTRAINT fk_dept_no FOREIGN KEY (dept_no) REFERENCES Departments(dept_no),	
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE Department_Managers (
	dept_no VARCHAR(20),
	emp_no VARCHAR(20),
	CONSTRAINT fk_emp_no FOREIGN KEY (emp_no) REFERENCES Employees(emp_no),
	CONSTRAINT fk_dept_no FOREIGN KEY (dept_no) REFERENCES Departments(dept_no),
	PRIMARY KEY (dept_no,emp_no)
);

CREATE TABLE Employees (
	emp_no VARCHAR(20) PRIMARY KEY,
	emp_title_id VARCHAR(20), 
	birth_date DATE NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	sex VARCHAR(1) NOT NULL,
	hire_date DATE NOT NULL,
	CONSTRAINT fk_emp_title FOREIGN KEY (emp_title_id) REFERENCES Titles(title_id)
);

CREATE TABLE Salaries (
	emp_no VARCHAR(20),
	salary int NOT NULL,
	PRIMARY KEY (emp_no, salary),
	CONSTRAINT fk_emp_no FOREIGN KEY (emp_no) REFERENCES Employees(emp_no)
);

CREATE TABLE Titles (
	title_id VARCHAR(20) PRIMARY KEY,
	title VARCHAR(20) NOT NULL
);

-- Confirm tables exist with data
SELECT * FROM Titles;
SELECT * FROM Employees;
SELECT * FROM Departments;
SELECT * FROM Salaries;
SELECT * FROM Department_Managers;
SELECT * FROM Department_Employees;

-- Data Analysis rows 64-140
-- List the employee number, last name, first name, sex, and salary of each employee
SELECT emp.emp_no,
	emp.last_name,
	emp.first_name,
	emp.sex,
	sal.salary
FROM Employees as emp
INNER JOIN Salaries as sal ON
	emp.emp_no = sal.emp_no;

-- List the first name, last name, and hire date for the employees who were hired in 1986
SELECT	emp.first_name,
	emp.last_name,
	emp.hire_date
FROM Employees as emp
WHERE emp.hire_date >= '19860101' AND emp.hire_date <= '19861231';

-- List the manager of each department along with their department number, department name, employee number, last name, and first name
SELECT dept.dept_no,
	dept.dept_name,
	emp.emp_no,
	emp.last_name,
	emp.first_name	
FROM Employees as emp
INNER JOIN Department_Managers as dm ON
	emp.emp_no = dm.emp_no
INNER JOIN Departments as dept ON
	dept.dept_no = dm.dept_no;
	
-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name
SELECT dept.dept_no,
	emp.emp_no,
	emp.last_name,
	emp.first_name,
	dept.dept_name
FROM Employees as emp
INNER JOIN Department_Employees as de ON
	emp.emp_no = de.emp_no
INNER JOIN Departments as dept ON
	dept.dept_no = de.dept_no;

-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B
SELECT emp.first_name,
	emp.last_name,
	emp.sex
FROM Employees as emp
WHERE emp.first_name = 'Hercules' AND emp.last_name LIKE 'B%';

-- List each employee in the Sales department, including their employee number, last name, and first name
SELECT dept.dept_name,
	emp.emp_no,
	emp.last_name,
	emp.first_name	
FROM Employees as emp
INNER JOIN Department_Employees as de ON
	emp.emp_no = de.emp_no
INNER JOIN Departments as dept ON
	dept.dept_no = de.dept_no
WHERE dept.dept_no = 'd007';

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name
SELECT emp.emp_no,
	emp.last_name,
	emp.first_name,
	dept.dept_name
FROM Employees as emp
INNER JOIN Department_Employees as de ON
	emp.emp_no = de.emp_no
INNER JOIN Departments as dept ON
	dept.dept_no = de.dept_no
WHERE dept.dept_no = 'd007' OR dept.dept_no = 'd005';

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT emp.last_name, COUNT(*) as last_names
FROM Employees as emp
GROUP BY emp.last_name
ORDER BY emp.last_name DESC;