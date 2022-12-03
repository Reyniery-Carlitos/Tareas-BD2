-- Consulta #1
SELECT name, gender, SUM(number) AS Sumatoria
FROM `bigquery-public-data.usa_names.usa_1910_2013`
GROUP BY name, gender
ORDER BY SUM(number) DESC;

-- Consulta #2
SELECT [date] AS date,state, tests_total, cases_positive_total, SUM(tests_total) OVER(PARTITION BY state) AS Total_Tests
FROM `bigquery-public-data.covid19_covidtracking.summary`;

-- Consulta #3
WITH totalPageViews AS (
    SELECT DISTINCT channelGrouping, SUM(totals.pageviews) OVER(PARTITION BY channelGrouping) AS totalInd, SUM(totals.pageviews) OVER() AS totalTotal
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
) SELECT channelGrouping, totalInd AS PageViews, (totalInd / totalTotal) AS PorcentajeDelTotal, (totalTotal/COUNT(*) OVER()) AS Promedio
FROM totalPageViews 
ORDER BY PageViews DESC;

-- Consulta 4
SELECT region, country, total_revenue, RANK() OVER(PARTITION BY region ORDER BY total_revenue DESC) AS Rango 
FROM `pacific-ethos-361219.01.Prueba proyectoBD2` 
ORDER BY region, Rango;
