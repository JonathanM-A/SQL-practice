-- How many total employees in this company
SELECT 
    COUNT(*)
FROM
    STAFF;
    
-- What about gender distribution?
SELECT 
    gender, COUNT(gender)
FROM
    staff
GROUP BY 1;

-- How many employees in each department
SELECT 
    department, COUNT(department)
FROM
    staff
GROUP BY department;

-- How many distinct departments ?
SELECT 
    COUNT(DISTINCT department)
FROM
    staff;

-- What is the highest and lowest salary of employees?
SELECT 
    MIN(salary) AS lowest_salary, MAX(salary) AS highest_salary
FROM
    staff;

-- what about salary distribution by gender group?
SELECT 
    gender,
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary,
    AVG(salary) AS average_salary
FROM
    staff
GROUP BY gender;

-- How much total salary company is spending each year?
SELECT 
    SUM(salary)
FROM
    staff;
    
-- want to know distribution of min, max average salary by department
SELECT 
    department,
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary,
    AVG(salary) AS average_salary
FROM
    staff
GROUP BY 1;

-- how spread out those salary around the average salary in each department?
SELECT 
    department,
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary,
    ROUND(AVG(salary), 2) AS average_salary,
    ROUND(VAR_POP(salary), 2) AS variance_salary,
    ROUND(STDDEV_POP(salary), 2) AS stddev_salary
FROM
    staff
GROUP BY 1;

-- which department has the highest salary spread out?
SELECT 
    department,
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary,
    ROUND(AVG(salary), 2) AS average_salary,
    ROUND(VAR_POP(salary), 2) AS variance_salary,
    ROUND(STDDEV_POP(salary), 2) AS stddev_salary
FROM
    staff
GROUP BY 1
ORDER BY 6 DESC
LIMIT 1;

-- Let's see Health department salary
SELECT 
    department,
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary,
    ROUND(AVG(salary), 2) AS average_salary,
    ROUND(VAR_POP(salary), 2) AS variance_salary,
    ROUND(STDDEV_POP(salary), 2) AS stddev_salary
FROM
    staff
GROUP BY 1
HAVING department = 'Health';

-- we will make 3 buckets to see the salary earning status for Health Department
-- 100000 = high earner, 100000-50000 = middle earner, ,50000 low earner
SELECT 
    id,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'high earner'
        WHEN salary < 50000 THEN 'low earner'
        ELSE 'middle earner'
    END AS incone_level
FROM
    staff
WHERE
    department LIKE 'Health'
ORDER BY 2 DESC;

-- how many staff are at each salary level
SELECT 
    COUNT(*),
    CASE
        WHEN salary >= 100000 THEN 'high earner'
        WHEN salary < 50000 THEN 'low earner'
        ELSE 'middle earner'
    END AS income_level
FROM
    staff
WHERE
    department LIKE 'Health'
GROUP BY income_level;

-- Let's find out about Outdoors department salary
SELECT 
    department,
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary,
    ROUND(AVG(salary), 2) AS average_salary,
    ROUND(VAR_POP(salary), 2) AS variance_salary,
    ROUND(STDDEV_POP(salary), 2) AS stddev_salary
FROM
    staff
GROUP BY 1
HAVING department = 'Outdoors';

SELECT 
    id,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'high earner'
        WHEN salary < 50000 THEN 'low earner'
        ELSE 'middle earner'
    END AS incone_level
FROM
    staff
WHERE
    department LIKE 'Outdoors'
ORDER BY 2 DESC;

-- Salary levels of Outdoor department
SELECT 
    COUNT(*),
    CASE
        WHEN salary >= 100000 THEN 'high earner'
        WHEN salary < 50000 THEN 'low earner'
        ELSE 'middle earner'
    END AS income_level
FROM
    staff
WHERE
    department LIKE 'Outdoors'
GROUP BY income_level;

-- What are the deparment start with B
SELECT DISTINCT
    department
FROM
    staff
WHERE
    department LIKE 'B%';

-- How many employees are in Assistant roles
SELECT 
    COUNT(*)
FROM
    staff
WHERE
    job_title LIKE '%Assistant%';

-- What are those Assistant roles?
SELECT DISTINCT
job_title
FROM
    staff
WHERE
    job_title LIKE '%Assistant%';

-- let's check which roles are assistant role or not
SELECT DISTINCT
    job_title, job_title LIKE '%Assistant%' is_Assistant_role
FROM
    staff
ORDER BY 2 DESC;

-- We want to extract job category from the assistant position which starts with word Assisant
SELECT 
    job_title,
    SUBSTR(job_title,
        LENGTH('Assistant') + 1) AS job_category
FROM
    staff
WHERE
    job_title LIKE 'Assistant%';

-- As there are several duplicated ones, we want to know only unique ones
SELECT 
    DISTINCT job_title,
    SUBSTR(job_title,
        LENGTH('Assistant') + 1) AS job_category
FROM
    staff
WHERE
    job_title LIKE 'Assistant%';
    
-- we want to replace word Assistant with Asst.
SELECT DISTINCT
    job_title,
    REPLACE(job_title, 'Assistant', 'Asst.') AS short_title
FROM
    staff
WHERE
    job_title LIKE 'Assistant%';

-- We want to know job title with Assistant with Level 3 and 4
SELECT DISTINCT
    job_title
FROM
    staff
WHERE
    job_title LIKE '%Assistant III%'
        OR job_title LIKE '%Assistant IV%';

-- now we want to know job title with Assistant, started with roman numerial I, follwed by 1 character
SELECT DISTINCT
    job_title
FROM
    staff
WHERE
    job_title LIKE '%Assistant I_';

-- job title starts with either E, P or S character , followed by any characters
SELECT DISTINCT
    job_title
FROM
    staff
WHERE
    SUBSTR(job_title, 1, 1) IN ('E' , 'P', 'S');
    
-- we want to know person's salary comparing to his/her department average salary
SELECT last_name, department, salary,
	AVG(salary) OVER(
		PARTITION BY department) as average_department_salary
FROM staff;

-- how many people are earning above/below the average salary of his/her department ?
SELECT status AS 'salary status', COUNT(*) AS number_of_employees
    FROM(SELECT 
        last_name,
        department,
        salary,
        CASE
            WHEN salary > AVG(salary) OVER(PARTITION BY department) THEN 'above average'
            ELSE 'below average'
        END AS status,
        AVG(salary) OVER(PARTITION BY department) as average_department_salary
    FROM
        staff
    GROUP BY 1 , 2 , 3) AS table_A
GROUP BY TABLE_A.status;

-- Assume that people who earn at least 100,000 salary is Executive.
-- We want to know the average salary for executives for each department.
SELECT DISTINCT
    department,
    ROUND(AVG(salary), 2) AS average_executive_salary
FROM
    staff
WHERE
    salary >= 100000
GROUP BY department
ORDER BY 2 DESC;

-- who earns the most in the company?
SELECT 
    last_name, department, salary
FROM
    staff
WHERE
    salary = (SELECT 
            MAX(salary)
        FROM
            staff);

-- who earn the most in his/her own department
SELECT 
    last_name, department, salary
FROM
    staff
WHERE
    salary IN (SELECT DISTINCT
            MAX(salary)
        FROM
            staff
        GROUP BY department)
        AND department IN (SELECT DISTINCT
            department
        FROM
            staff
        GROUP BY 1);
        
        -- OR
SELECT 
    last_name, department, salary
FROM
    staff
WHERE
    (department , salary) IN (SELECT DISTINCT
            department, MAX(SALARY)
        FROM
            staff
        GROUP BY 1)
GROUP BY 1 , 2 , 3;

-- full details info of employees with company division
SELECT 
    last_name, staff.department, company_division, salary
FROM
    staff
        JOIN
    company_divisions ON staff.department = company_divisions.department;
SELECT 
    last_name, staff.department, company_division, salary
FROM
    staff
        LEFT JOIN
    company_divisions ON staff.department = company_divisions.department;

-- now all 1000 staffs are returned, but some 47 people have missing company - division.
-- who are those people with missing company division?
SELECT 
    last_name, staff.department
FROM
    staff
        LEFT JOIN
    company_divisions ON staff.department = company_divisions.department
WHERE
    company_division IS NULL;

-- employees per regions and country
SELECT 
    country,
    company_regions,
    COUNT(staff.id) AS num_of_employees
FROM
    staff
        JOIN
    company_regions ON staff.region_id = company_regions.region_id
GROUP BY 1 , 2;

-- employee salary vs average salary of his/her department
SELECT
	id, last_name, department, salary,
    ROUND(AVG(salary) OVER(PARTITION BY department),2) AS avg_department_salary
FROM
	staff
ORDER BY 3;

-- employee salary vs max salary of his/her department
SELECT
	id, last_name, department, salary,
    MAX(salary) OVER(PARTITION BY department) AS max_department_salary
FROM 
	staff
ORDER BY 3;
    
-- employee salary vs min salary of his/her Company Region
SELECT
	id, last_name, company_regions, salary,
    MIN(SALARY) OVER(PARTITION BY company_regions) AS min_regional_salary
FROM
	staff
		JOIN
	company_regions ON staff.region_id = company_regions.region_id
ORDER BY 3;
