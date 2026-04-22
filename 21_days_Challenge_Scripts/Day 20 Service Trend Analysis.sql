-- 1. Calculate running total of patients admitted by week for each service.
SELECT 
	week, service, 
	SUM(patients_admitted) OVER(PARTITION BY service ORDER BY week) AS running_total 
FROM services_weekly;

-- 2. Find the moving average of patient satisfaction over 4-week periods.
SELECT 
	week, 
	ROUND(AVG(patient_satisfaction) OVER(ROWS BETWEEN 3 PRECEDING AND CURRENT ROW),2) as mov_avg 
FROM services_weekly;

-- 3. Show cumulative patient refusals by week across all services.

SELECT
    week,
    SUM(patients_refused) AS weekly_refusals,
    SUM(SUM(patients_refused)) OVER (ORDER BY week) AS cumulative_refusals
FROM services_weekly
GROUP BY week
ORDER BY week;

-- Daily Challenge  
/* Create a trend analysis showing for each service and week: week number, patients_admitted, 
running total of patients admitted (cumulative), 3-week moving average of patient satisfaction (current week and 2 prior weeks),
and the difference between current week admissions and the service average. Filter for weeks 10-20 only. */

SELECT
    week,
    patients_admitted,
    SUM(patients_admitted) OVER(PARTITION BY service ORDER BY week) AS cumulative_patient_admissions,
    ROUND(AVG(patient_satisfaction) OVER(PARTITION BY service ORDER BY week ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS 3_week_mov_avg,
    patients_admitted - ROUND(AVG(patients_admitted) OVER(PARTITION BY service),2) AS diff_from_avg
FROM services_weekly
WHERE week BETWEEN 10 AND 20
ORDER BY service, week;
