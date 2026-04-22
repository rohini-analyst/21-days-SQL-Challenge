-- 1. Count the number of patients by each service.
SELECT 
	service, COUNT(patient_id) AS Patient_Count 
FROM patients 
GROUP BY service;

-- 2. Calculate the average age of patients grouped by service.
SELECT 
	service, ROUND(AVG(age),2) AS Average_Age 
FROM patients 
GROUP BY service;

-- 3. Find the total number of staff members per role.
SELECT 
	role, COUNT(staff_id) AS Staff_Count 
FROM staff 
GROUP BY role;

-- Daily Challenge  
/* For each hospital service, 
calculate the total number of patients admitted, total patients refused, and the admission rate (percentage of requests that were admitted). 
Order by admission rate descending. */

SELECT 
    service,
    SUM(patients_admitted) AS patients_admitted_count,
    SUM(patients_refused) AS patients_refused_count,
    ROUND(SUM(patients_admitted) / SUM(patients_request) * 100,2) AS admission_rate
FROM services_weekly
GROUP BY service;
