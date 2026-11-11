#HR Analytics Dashboard

#1. Total Employees: What is the total number of employees currently registered in the organization?
select count(*)
from employees;

#2. Active Employees: How many employees currently have an "Active" employment status?
select count(*) as Active_enployee
from employees
where employment_status="Active";

#3. Employee Attrition Rate: What percentage of employees have left the company (resigned or terminated)?
select 
	sum(case when employment_status in ("Terminated","Resigned") then 1 else 0 end) * 100/count(*) as attrition_rate
from employees;

#4. Average Employee Salary: What is the average salary across all employees?
select round(avg(salary),2) as avg_sal
from employees;

#5. Salary by Department: What is the average salary in each department, and which department pays the most?
select  department_name,
		round(avg(salary),2) as avg_sal 
from employees
join departments
using(department_id)
group by department_name
order by avg_sal desc;

#6. Salary by Designation: What is the average salary across different job designations/roles?
select  designation,
		round(avg(salary),2) as avg_sal 
from employees
group by designation
order by avg_sal desc;

#7. Average Performance Rating: What is the average performance rating across all employees?
select round(avg(performance_rating),2) as avg_performance_rate
from performance;

#8. Top Performers: Who are the employees with the highest performance ratings (top performers)?
select employee_id,employee_name,performance_rating
from employees
join performance
using (employee_id)
order by performance_rating desc limit 10;

#9. Bonus Distribution: How is bonus amount distributed across employees?
select 
	 case
     when bonus < 10000 then '0-10000'
     when bonus < 20000 then '20000-30000'
     when bonus < 30000 then '30000-40000'
     else '40000-50000'
	 end as Bonus_Range,
     count(*) as Employee_Count
from performance
group by bonus_range
order by bonus_range;

#10. Department-wise Headcount: How many employees work in each department?
select 
	 department_name,
     count(employee_id) as head_count
from employees
join departments
using (department_id)
group by department_name
order by head_count desc;

#11. Gender Diversity Ratio: What is the ratio of male to female employees in the company?
select  gender,count(*),
		count(*)*100/(select count(*) from employees) as gender_diversity
from employees
group by gender;

#12. Age Distribution: Which age group has the highest concentration of employees?
select 
	case
    when age between 20 and 29 then '20-29'
    when age between 30 and 39 then '30-39'
    when age between 40 and 49 then '40-49'
    else '50+'
    end as age_group,
    count(*) as emp_count
from employees
group by age_group
order by age_group;
 
#13. Average Employee Tenure: On average, how long have employees been working at the company (based on hire date)?
select round(avg(datediff(curdate(),hire_date)/365),1) as avg_tenure
from employees;

#14. New Hires by Month: How many new employees were hired each month (hiring trend)?
select  date_format(hire_date,'%Y-%m') as hire_month,
		count(*) as count_emp
from employees
group by hire_month
order by hire_month;

#15. Employee Attendance Rate:What is the overall attendance rate of employees (Present days / Total days)?
select  
		sum(case when status = 'Present' then 1 else 0 end)*100 / count(*) as attendance_rate
from attendance;

#16. Leave Utilization: How much leave have employees taken/utilized?
select count(status) as leaves_taken
from attendance
where status = "Leave";

#17. Absenteeism Rate: What is the absenteeism rate relative to total working days?
select 
	sum(case when status = "Absent" then 1 else 0 end)*100/count(*) as absenteeism_rate
from attendance;

#18. Highest Paying Department: Which department offers the highest average salary?
select 
	department_name,
	round(avg(salary),2) as department_sal
from employees
join departments
using (department_id)
group by department_name
order by department_sal desc limit 1;

#19. Highest Paying Job Role: Which designation/job role earns the highest average salary?
select 
	designation,
	round(avg(salary),2) as designation_sal
from employees
group by designation
order by designation_sal desc limit 1;

#20. Promotion Eligibility List: Which employees are eligible for promotion based on high performance ratings?
select e.employee_id,e.employee_name,p.performance_rating
from employees e
join performance p
on p.employee_id = e.employee_id
where p.performance_rating > 4.0
order by p.performance_rating desc;

#21. Performance Rating Distribution: How are performance ratings distributed across the company 
#(how many employees fall in each rating range)?
select 
	case
    when performance_rating < 2 then '1.00-1.99'
    when performance_rating < 3 then '2.00-2.99'
    when performance_rating < 4 then '3.00-3.99'
    else '4.00-5.00'
	end as rating_range,
    count(*) as emp_count
from performance
group by rating_range
order by rating_range;
    
#22. Employee Growth Trend: How has the employee headcount grown over time (year/month-wise)?
select  year(hire_date) as hire_year,
		count(*) as employee_hired
from employees
group by hire_year
order by hire_year;

#23. Employees by City: How many employees are based in each city?
select  city,
		count(*) as emp_count
from employees
group by city
order by emp_count desc;

#24. Department-wise Attrition: Which department has the highest attrition rate?
select  department_name,
		count(*) as emp_left_count,
		sum(case when employment_status in ('Terminated','Resigned') then 1 else 0 end)* 100/count(*) as attrition_rate
from employees
join departments
using (department_id)
group by department_name
order by attrition_rate desc;

#25. Workforce Dashboard Metrics: What does the overall workforce summary look like 
#(total headcount, active employees, attrition rate,average salary, average rating — all in one dashboard view)?
select 
	(select count(*) from employees) as total_headcount, 
    (select count(*) from employees where employment_status = "active") as active_employees,
    (select sum(case when employment_status in ('Terminated','Resigned') then 1 else 0 end)* 100/count(*)from employees) as attrition_rate,
    (select round(avg(salary),2) from employees) as average_salary,
    (select round(avg(performance_rating),2) from performance) as average_rating