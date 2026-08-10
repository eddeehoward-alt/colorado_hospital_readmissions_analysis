/*
Analysis Query 1: Calculate the average excess readmission ratio
for each HRRP measure

INNER JOIN matches readmission records to Colorado hospitals
using Facility ID.

WHERE removes N/A values because they cannot be used in
numerical calculations.

CAST converts the ratio from text into a number.

AVG calculates the average excess readmission ratio for
each measure.

COUNT(*) shows how many usable hospital records contribute
to each average.

ORDER BY average_excess_readmission_ratio DESC places the
highest average ratio first.
*/

SELECT
    r."Measure Name" AS measure_name,
    COUNT(*) AS hospitals_with_usable_ratio,
    ROUND(
        AVG(
            CAST(r."Excess Readmission Ratio" AS REAL)
        ),
        4
    ) AS average_excess_readmission_ratio
FROM hospitals AS h
INNER JOIN readmissions AS r
    ON h."Facility ID" = r."Facility ID"
WHERE h."State" = 'CO'
  AND r."Excess Readmission Ratio" <> 'N/A'
GROUP BY r."Measure Name"
ORDER BY average_excess_readmission_ratio DESC;