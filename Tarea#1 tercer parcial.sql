--Ejercicio#1
select
name,
gender,
SUM(number) as Sum_number
from bigquery-public-data.usa_names.usa_1910_2013
group by name, gender
order by Sum_number desc


--Ejercicio#2
select
date,
state,
tests_total,
cases_positive_total,
SUM(tests_total) over(partition by state) as suma_total
from bigquery-public-data.covid19_covidtracking.summary
order by state desc

--Ejercicio #3
select
  ara.channelGrouping,
  ara.pageviews,
  ara.pageviews/(SUM(ara.pageviews) OVER()) as porcentaje,
  AVG(ara.pageviews) OVER() as promedio
from (select
        channelGrouping,
        SUM(totals.pageviews) as  pageviews,
      from bigquery-public-data.google_analytics_sample.ga_sessions_20170801
      group by channelGrouping, date) as ara
order by porcentaje desc

--Ejercicio#4
SELECT 
Region,
Country,
Total_Revenue,
ROW_NUMBER() OVER(PARTITION BY Region ORDER BY Total_Revenue DESC)
FROM `apiclientes-346203.basededatos2.Sales`
order by Region