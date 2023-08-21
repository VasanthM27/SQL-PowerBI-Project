CREATE DATABASE projects;
USE projects;

Select * from hr;

ALTER TABLE hr
change column ï»¿id emp_id varchar(20) null;

DESCRIBE hr;
select birthdate from hr;
#important line below
SET sql_safe_updates = 0;
update hr
SET hire_date = CASE
when hire_date LIKE '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
when hire_date LIKE '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
ELSE null
END;
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

UPDATE hr SET termdate = NULL WHERE termdate IS NULL OR termdate = '';

UPDATE hr SET termdate = STR_TO_DATE(termdate, '%Y-%m-%d %H:%M:%S')
where termdate IS NOT NULL AND termdate != '';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;
ALTER TABLE hr ADD COLUMN age int;

UPDATE hr
set age = timestampdiff(YEAR,birthdate,CURDATE());

Select * from hr;
SELECT count(gender) from HR
where age >= 18 ;

# important line below
SET sql_mode = '';
UPDATE hr SET termdate = '0000-00-00' WHERE termdate IS NULL;

#gender and race distribution in company
select gender,count(*) from hr
where age >=18 AND termdate = '0000-00-00'
group by gender;

select race,count(*) as count from hr
where age >=18 AND termdate = '0000-00-00'
group by race
order by count(*) desc;

#to show age classfication of employees
select MIN(age) as youngest, MAX(AGE) AS OLDEST from hr
where age >=18 and termdate = '0000-00-00';

select
case 
when age >= 18 AND age <=24 then '18-24'
when age >= 25 AND age <=34 then '25-34'
when age >= 35 AND age <=44 then '35-44'
when age >= 45 AND age <=54 then '45-54'
when age >= 55 AND age <=64 then '55-64'
else '65+'
end as age_group,gender,
count(*) as count
from hr
where age >=18 and termdate = '0000-00-00'
group by age_group,gender
order by age_group,gender;

#same like gender
select location, count(*) as count from hr
where age >=18 and termdate = '0000-00-00'
group by location;

#average length of employment for employees who have been terminated?
select round(AVG(datediff(termdate,hire_date))/365,0) AS avg_length_employment
from hr
where termdate <= curdate() AND termdate <> '0000-00-00' and age>=18;

#gender distribution vary across departments and job titles
select department, gender, count(*) as count from hr
where age >=18 and termdate = '0000-00-00'
group by department, gender
order by department;

#distribution of job titles across the company
select jobtitle, count(*) from hr
where age >=18 and termdate = '0000-00-00'
group by jobtitle
order by jobtitle desc;

#department has the highest turnover rate
select department,
total_count,
terminated_count,
terminated_count/total_count as termination_rate
from(
select department, count(*) as total_count,
SUM(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminated_count
from hr
where age >= 18
group by department) as subquery
order by termination_rate desc;

#distribution of employees by city and state
select location_state, count(*) as count from hr
where age >=18 and termdate = '0000-00-00'
group by location_state
order by count desc;

#hire and fire date over time by years
select year,
hires,
terminations,
hires - terminations as net_change,
round((hires - terminations)/hires* 100,2) as net_change_percent

from (
select year(hire_date) as year,
count(*) as hires,
sum(case when termdate <> '0000-00-00' and termdate <=current_date() then 1 else 0 end) as terminations
from hr
where age<=18
group by year(hire_date)
) as subquery
order by year ASC;


# what is the tenure distribution for each department, like how long employees stay in one specific department
# to get the year u have to divide by 365 days, the termdate and hure date and round it off so u may have
#the year. use avg
select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr
where termdate <= curdate() and termdate <> '0000-00-00' and age >= 18
group by department;

create database vasanth;
use vasanth;







