CREATE TABLE "departments" (
    "dept_no" VARCHAR(5)   NOT NULL,
    "dept_name" VARCHAR(50)   NOT NULL,
    "Last_Updated" Timestamp DEFAULT Localtimestamp  NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title" VARCHAR(5)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" VARCHAR(50)   NOT NULL,
    "last_name" VARCHAR(50)   NOT NULL,
    "sex" VARCHAR(5)   NOT NULL,
    "hire_date" date   NOT NULL,
    "Last_Updated" Timestamp DEFAULT Localtimestamp  NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(5)   NOT NULL,
    "title" VARCHAR(50)   NOT NULL,
    "Last_Updated" Timestamp DEFAULT Localtimestamp  NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "salaries" (
    "id" SERIAL   NOT NULL,
    "emp_no" INTEGER   NOT NULL,
    "salary" float   NOT NULL,
    "Last_Updated" Timestamp DEFAULT Localtimestamp  NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "dept_manager" (
    "id" SERIAL   NOT NULL,
    "dept_no" VARCHAR(5)   NOT NULL,
    "emp_no" INTEGER   NOT NULL,
    "Last_Updated" Timestamp DEFAULT Localtimestamp  NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "dept_emp" (
    "id" SERIAL   NOT NULL,
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR(5)   NOT NULL,
    "Last_Updated" Timestamp DEFAULT Localtimestamp  NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");


-- 1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	e.sex,
	s.salary
FROM
	employees e
	join salaries s on e.emp_no = s.emp_no
Order by
	e.last_name ASC;


-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
-- extract to get the year - from hire dates
SELECT
	e.first_name,
	e.last_name,
	e.hire_date
FROM
employees e
WHERE
	hire_date >= '1986-01-01' AND hire_date < '1987-01-01'
ORDER BY
	e.hire_date ASC;


-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT 
	d.dept_no,
	d.dept_name,
	e.emp_no,
	e.last_name,
	e.first_name
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no
JOIN departments d ON d.dept_no = dm.dept_no;

-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT 
	de.dept_no,
	e.emp_no,
	e.last_name, 
	e.first_name,
	d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no;
	


	
-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT
	e.first_name,
	e.last_name,
	e.sex
FROM 
	employees e
WHERE
	e.first_name = 'Hercules'
	and e.last_name like 'B%'
ORDER BY 
	e. last_name;


-- 6. List each employee in the Sales department, including their employee number, last name, and first name.

SELECT
	e.emp_no,
	e.last_name,
	e.first_name
FROM 
	employees e

JOIN dept_emp de ON e.emp_no = de.emp_no

WHERE 
	de.dept_no = 'd007'
ORDER BY 
	e. last_name ASC;



-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM 
	employees e

JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE 
	d.dept_name IN ('Sales','Development')
ORDER BY 
	e. last_name ASC;

-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT
	e.last_name,
	count(e.emp_no) as num_last_name
FROM
	employees e
GROUP BY
	e.last_name
ORDER BY
	num_last_name DESC;

-- 8_Bonus
SELECT
	e.last_name,
	count(e.emp_no) as num_last_name
FROM
	employees e
GROUP BY
	e.last_name
ORDER BY
	num_last_name ASC;

SELECT
*
FROM
	employees e
WHERE
	e.last_name = 'Foolsday'