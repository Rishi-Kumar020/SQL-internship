use hr_data;
# employee_survey_data   general_data   manager_survey_data

# 1. Retrieve the total number of employees in the dataset.
SELECT COUNT(DISTINCT (EmployeeID)) AS Total_Employees FROM general_data;

# 2. List all unique job roles in the dataset.
SELECT DISTINCT(JobRole) as Unique_Job_Roles FROM general_data;

# 3. Find the average age of employees.
SELECT ROUND(AVG(Age), 2) AS Employee_Avg_Age
FROM general_data;
    
# 4. Retrieve the names and ages of employees who have worked at the company for more than 5 years.
select * from general_data;
SELECT Emp_Name, Age, YearsAtCompany FROM general_data WHERE YearsAtCompany > 5 ORDER BY YearsAtCompany;

# 5. Get a count of employees grouped by their department.
SELECT Department, COUNT(EmployeeID) FROM general_data GROUP BY Department;

# 6. List employees who have 'High' Job Satisfaction.
SELECT g.EmployeeID, g.Emp_Name, e.JobSatisfaction FROM employee_survey_data e
INNER JOIN general_data g ON g.EmployeeID = e.EmployeeID WHERE e.JobSatisfaction = 4; 

# 7. Find the highest Monthly Income in the dataset.
SELECT Emp_Name, MonthlyIncome FROM general_data
WHERE MonthlyIncome = (SELECT MAX(MonthlyIncome) FROM general_data);

# 8. List employees who have 'Travel_Rarely' as their BusinessTravel type.
SELECT Emp_Name, BusinessTravel
FROM general_data
WHERE BusinessTravel = 'Travel_Rarely';

# 9. Retrieve the distinct MaritalStatus categories in the dataset.
SELECT DISTINCT MaritalStatus AS MaritalStatus_Categories
FROM general_data;

# 10. Get a list of employees with more than 2 years of work experience but less than 4 years in their current role.
SELECT Emp_Name, TotalWorkingYears, YearsWithCurrManager
FROM general_data
WHERE TotalWorkingYears > 2 AND YearsWithCurrManager < 4;

# 11. List employees who have changed their job roles within the company (JobLevel and JobRole differ from their previous job).
SELECT 
    Curr.Emp_Name,
    Curr.EmployeeID,
    Curr.JobLevel AS CurrentJobLevel,
    Curr.JobRole AS CurrentJobRole,
    Previous.JobLevel AS PreviousJobLevel,
    Previous.JobRole AS PreviousJobRole
FROM general_data AS Curr
JOIN general_data AS Previous ON Curr.EmployeeID = Previous.EmployeeID
WHERE Curr.JobRole <> Previous.JobRole;

# 12. Find the average distance from home for employees in each department.
SELECT Department, AVG(DistanceFromHome) AS Avg_Dist_from_Home
FROM general_data GROUP BY Department;

# 13. Retrieve the top 5 employees with the highest MonthlyIncome.
SELECT Emp_Name, MonthlyIncome FROM general_data
ORDER BY MonthlyIncome DESC LIMIT 5;

# 14. Calculate the percentage of employees who have had a promotion in the last year.
SELECT 
    COUNT(CASE WHEN YearsSinceLastPromotion <= 1 THEN EmployeeID END) AS PromotedLastYearCount,
    COUNT(EmployeeID) AS TotalEmployees,
    (COUNT(CASE WHEN YearsSinceLastPromotion <= 1 THEN EmployeeID END) / COUNT(EmployeeID)) * 100 AS PromotionPercentage
FROM general_data;

# 15. List the employees with the highest and lowest EnvironmentSatisfaction.
select Emp_Name, EnvironmentSatisfaction as Highest_satisfaction from employee_survey_data e join general_data g on e.EmployeeID = g.EmployeeID
where EnvironmentSatisfaction = (select max(EnvironmentSatisfaction) from employee_survey_data);

select Emp_Name, EnvironmentSatisfaction as Lowest_satisfaction from employee_survey_data e join general_data g on e.EmployeeID = g.EmployeeID  
where EnvironmentSatisfaction = (select min(EnvironmentSatisfaction) from employee_survey_data);

# 16. Find the employees who have the same JobRole and MaritalStatus.
SELECT JobRole, MaritalStatus, EmployeeCount
FROM (SELECT JobRole, MaritalStatus, COUNT(*) OVER (PARTITION BY JobRole, MaritalStatus) AS EmployeeCount,
ROW_NUMBER() OVER (PARTITION BY JobRole, MaritalStatus) AS RowNum FROM general_data) AS Counts
WHERE EmployeeCount > 1 AND RowNum = 1;

# 17. List the employees with the highest TotalWorkingYears who also have a PerformanceRating of 4.
SELECT g.EmployeeID, g.Emp_Name, g.TotalWorkingYears, m.PerformanceRating
FROM general_data g
JOIN manager_survey_data m ON g.EmployeeID = m.EmployeeID
WHERE m.PerformanceRating = 4
ORDER BY g.TotalWorkingYears DESC;

# 18. Calculate the average Age and JobSatisfaction for each BusinessTravel type.
SELECT BusinessTravel, ROUND(AVG(Age), 2) AS AvgAge, ROUND(AVG(JobSatisfaction), 2) AS AvgJobSatisfaction
FROM general_data JOIN employee_survey_data ON general_data.EmployeeID = employee_survey_data.EmployeeID
GROUP BY BusinessTravel;

# 19. Retrieve the most common EducationField among employees.
SELECT EducationField, COUNT(*) AS FieldCount
FROM general_data
GROUP BY EducationField
ORDER BY FieldCount DESC;

# 20. List the employees who have worked for the company the longest but haven't had a promotion.
SELECT EmployeeID, Emp_Name, YearsAtCompany, YearsSinceLastPromotion
FROM general_data
WHERE YearsAtCompany = (SELECT MAX(YearsAtCompany) FROM general_data WHERE YearsSinceLastPromotion = 0);

