-- Consulta #1
SELECT name, gender, SUM(number) AS Sumatoria
FROM `bigquery-public-data.usa_names.usa_1910_2013`
GROUP BY name, gender
ORDER BY SUM(number) DESC;

-- Consulta #2
SELECT [date] AS date,state, tests_total, cases_positive_total, SUM(tests_total) OVER(PARTITION BY state) AS Total_Tests
FROM `bigquery-public-data.covid19_covidtracking.summary`;

-- Consulta #3
with totalPageViews as (
    select distinct channelGrouping, sum(totals.pageviews) over(partition by channelGrouping) as totalInd, sum(totals.pageviews) over() as totalTotal
    from `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
) select channelGrouping, totalInd as PageViews, (totalInd / totalTotal) as PorcentajeDelTotal, (totalTotal/count(*) over()) as Promedio
from totalPageViews 
order by PageViews desc;

-- Consulta 4
SELECT region, country, total_revenue, rank() over(partition by region order by region desc, total_revenue desc) as Rango FROM `pacific-ethos-361219.01.Prueba proyectoBD2` 
