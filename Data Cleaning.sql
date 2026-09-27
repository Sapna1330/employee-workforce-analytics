CREATE TABLE employees (
    employee_id TEXT,
    first_name TEXT,
    last_name TEXT,
    age TEXT,
    department_region TEXT,
    status TEXT,
    join_date TEXT,
    salary TEXT,
    email TEXT,
    phone TEXT,
    performance_score TEXT,
    remote_work TEXT
);

SELECT* FROM employees
limit 5;

SELECT DISTINCT performance_score
FROM employees;

SELECT COUNT(*) AS total_rows
FROM employees;

SELECT
    COUNT(*) FILTER (WHERE employee_id IS NULL OR TRIM(employee_id) = '') AS employee_id_missing,
    COUNT(*) FILTER (WHERE first_name IS NULL OR TRIM(first_name) = '') AS first_name_missing,
    COUNT(*) FILTER (WHERE last_name IS NULL OR TRIM(last_name) = '') AS last_name_missing,
    COUNT(*) FILTER (WHERE age IS NULL OR TRIM(age) = '') AS age_missing,
    COUNT(*) FILTER (WHERE department_region IS NULL OR TRIM(department_region) = '') AS department_missing,
    COUNT(*) FILTER (WHERE status IS NULL OR TRIM(status) = '') AS status_missing,
    COUNT(*) FILTER (WHERE join_date IS NULL OR TRIM(join_date) = '') AS join_date_missing,
    COUNT(*) FILTER (WHERE salary IS NULL OR TRIM(salary) = '') AS salary_missing,
    COUNT(*) FILTER (WHERE email IS NULL OR TRIM(email) = '') AS email_missing,
    COUNT(*) FILTER (WHERE phone IS NULL OR TRIM(phone) = '') AS phone_missing,
    COUNT(*) FILTER (WHERE performance_score IS NULL OR TRIM(performance_score) = '') AS performance_missing,
    COUNT(*) FILTER (WHERE remote_work IS NULL OR TRIM(remote_work) = '') AS remote_work_missing
FROM employees;

SELECT
    employee_id,
    COUNT(*) AS duplicate_count
FROM employees
GROUP BY employee_id
HAVING COUNT(*) > 1;

SELECT DISTINCT TRIM(status) AS status
FROM employees
ORDER BY status;

SELECT DISTINCT TRIM(department_region) AS department_region
FROM employees
ORDER BY department_region;

SELECT DISTINCT TRIM(remote_work) AS remote_work
FROM employees
ORDER BY remote_work;

SELECT
    TRIM(performance_score) AS performance_score,
    COUNT(*) AS employee_count
FROM employees
GROUP BY TRIM(performance_score)
ORDER BY employee_count DESC;

DROP TABLE IF EXISTS employees_cleaned;

DROP TABLE IF EXISTS employees_cleaned;

CREATE TABLE employees_cleaned AS
SELECT
    NULLIF(TRIM(employee_id), '') AS employee_id,

    INITCAP(TRIM(first_name)) AS first_name,

    INITCAP(TRIM(last_name)) AS last_name,

    NULLIF(NULLIF(TRIM(age), ''), 'N/A')::INTEGER AS age,

    INITCAP(TRIM(department_region)) AS department_region,

    INITCAP(TRIM(status)) AS status,

    NULLIF(NULLIF(TRIM(join_date), ''), 'N/A')::DATE AS join_date,

    NULLIF(NULLIF(TRIM(salary), ''), 'N/A')::NUMERIC AS salary,

    LOWER(TRIM(email)) AS email,

    NULLIF(
        REGEXP_REPLACE(phone, '[^0-9]', '', 'g'),
        ''
    ) AS phone,

    INITCAP(TRIM(performance_score)) AS performance_score,

    INITCAP(TRIM(remote_work)) AS remote_work

FROM employees;


SELECT *
FROM employees_cleaned
LIMIT 10;

SELECT COUNT(*) AS total_rows
FROM employees_cleaned;

SELECT COUNT(*) AS missing_salary
FROM employees_cleaned
WHERE salary IS NULL;

SELECT *
FROM employees_cleaned
LIMIT 5;


SELECT
    COUNT(*) AS total_employees,
    ROUND(AVG(age), 2) AS average_age,
    MIN(age) AS minimum_age,
    MAX(age) AS maximum_age,
    ROUND(AVG(salary), 2) AS average_salary,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM employees_cleaned;

SELECT COUNT(*) AS total_employees
FROM employees;


SELECT
    TRIM(department_region) AS department_region,
    COUNT(*) AS employee_count
FROM employees
WHERE department_region IS NOT NULL
  AND TRIM(department_region) <> ''
GROUP BY TRIM(department_region)
ORDER BY employee_count DESC;


SELECT
    COUNT(*) AS valid_salary_records,
    ROUND(AVG(NULLIF(NULLIF(TRIM(salary), ''), 'N/A')::NUMERIC), 2) AS average_salary,
    MIN(NULLIF(NULLIF(TRIM(salary), ''), 'N/A')::NUMERIC) AS minimum_salary,
    MAX(NULLIF(NULLIF(TRIM(salary), ''), 'N/A')::NUMERIC) AS maximum_salary
FROM employees;


SELECT
    INITCAP(TRIM(performance_score)) AS performance_score,
    COUNT(*) AS employee_count
FROM employees
WHERE performance_score IS NOT NULL
  AND TRIM(performance_score) <> ''
GROUP BY INITCAP(TRIM(performance_score))
ORDER BY employee_count DESC;


SELECT
    INITCAP(TRIM(remote_work)) AS remote_work,
    COUNT(*) AS employee_count
FROM employees
WHERE remote_work IS NOT NULL
  AND TRIM(remote_work) <> ''
GROUP BY INITCAP(TRIM(remote_work))
ORDER BY employee_count DESC;


SELECT
    EXTRACT(YEAR FROM NULLIF(NULLIF(TRIM(join_date), ''), 'N/A')::DATE) AS joining_year,
    COUNT(*) AS employees_joined
FROM employees
WHERE join_date IS NOT NULL
  AND TRIM(join_date) <> ''
  AND TRIM(join_date) <> 'N/A'
GROUP BY joining_year
ORDER BY joining_year;


SELECT
    employee_id,
    first_name,
    last_name,
    age
FROM employees
WHERE
    NULLIF(NULLIF(TRIM(age), ''), 'N/A')::INTEGER < 18
    OR
    NULLIF(NULLIF(TRIM(age), ''), 'N/A')::INTEGER > 70;

	SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM employees
WHERE NULLIF(NULLIF(TRIM(salary), ''), 'N/A')::NUMERIC < 0;


SELECT
    TRIM(employee_id) AS employee_id,
    COUNT(*) AS duplicate_count
FROM employees
GROUP BY TRIM(employee_id)
HAVING COUNT(*) > 1;