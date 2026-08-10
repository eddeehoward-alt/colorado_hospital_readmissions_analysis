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

/*
Analysis Query 2: Classify readmission performance by measure

This query groups usable readmission ratios into three categories:

Below Expected:
The excess readmission ratio is less than 1.00.

At Expected:
The excess readmission ratio equals 1.00.

Above Expected:
The excess readmission ratio is greater than 1.00.

CAST converts the ratio from text into a number.

SUM with CASE counts how many hospital records fall into each
performance category for every measure.

The above-expected percentage shows the share of usable records
with readmissions higher than expected.
*/

SELECT
    r."Measure Name" AS measure_name,

    COUNT(*) AS hospitals_with_usable_ratio,

    SUM(
        CASE
            WHEN CAST(r."Excess Readmission Ratio" AS REAL) < 1.00
                THEN 1
            ELSE 0
        END
    ) AS below_expected_count,

    SUM(
        CASE
            WHEN CAST(r."Excess Readmission Ratio" AS REAL) = 1.00
                THEN 1
            ELSE 0
        END
    ) AS at_expected_count,

    SUM(
        CASE
            WHEN CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
                THEN 1
            ELSE 0
        END
    ) AS above_expected_count,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
                    THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS above_expected_percentage

FROM hospitals AS h
INNER JOIN readmissions AS r
    ON h."Facility ID" = r."Facility ID"

WHERE h."State" = 'CO'
  AND r."Excess Readmission Ratio" <> 'N/A'

GROUP BY r."Measure Name"

ORDER BY above_expected_percentage DESC;

/*
Analysis Query 3: Count above-expected readmission measures by hospital

This query looks at each Colorado hospital individually.

Only records with a usable excess readmission ratio are included.

SUM with CASE counts how many measures have a ratio greater
than 1.00, meaning readmissions were above expected.

COUNT(*) counts how many usable measures each hospital has.

AVG calculates the hospital's average excess readmission ratio
across its usable measures.

ORDER BY places hospitals with the greatest number of
above-expected measures first.
*/

SELECT
    h."Facility ID",
    h."Facility Name",
    h."City/Town",
    h."Hospital overall rating",

    COUNT(*) AS usable_measures,

    SUM(
        CASE
            WHEN CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
                THEN 1
            ELSE 0
        END
    ) AS above_expected_measures,

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

GROUP BY
    h."Facility ID",
    h."Facility Name",
    h."City/Town",
    h."Hospital overall rating"

ORDER BY
    above_expected_measures DESC,
    average_excess_readmission_ratio DESC;
	
/*
Analysis Query 4: Identify above-expected measures by hospital

This query keeps only Colorado readmission records with
a usable excess readmission ratio greater than 1.00.

A ratio above 1.00 indicates readmissions were higher than expected.

The results show the hospital name, measure, and ratio so we can
identify which conditions are driving above-expected performance.

ORDER BY sorts hospitals with the highest ratios first.
*/

SELECT
    h."Facility Name",
    h."City/Town",
    h."Hospital overall rating",
    r."Measure Name",
    CAST(r."Excess Readmission Ratio" AS REAL) AS excess_readmission_ratio
FROM hospitals AS h
INNER JOIN readmissions AS r
    ON h."Facility ID" = r."Facility ID"
WHERE h."State" = 'CO'
  AND r."Excess Readmission Ratio" <> 'N/A'
  AND CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
ORDER BY
    excess_readmission_ratio DESC,
    h."Facility Name";
	
/*
Analysis Query 5: Summarize above-expected readmission cases by measure

This query keeps only usable readmission ratios above 1.00.

GROUP BY creates one group for each HRRP measure.

COUNT(*) counts how many hospital records were above expected
for each measure.

AVG calculates the average ratio among only the hospitals
that were above expected.

MAX identifies the highest excess readmission ratio observed
for each measure.

ORDER BY above_expected_hospitals DESC shows which measures
had the greatest number of above-expected hospital results.
*/

SELECT
    r."Measure Name" AS measure_name,

    COUNT(*) AS above_expected_hospitals,

    ROUND(
        AVG(
            CAST(r."Excess Readmission Ratio" AS REAL)
        ),
        4
    ) AS average_ratio_above_expected,

    MAX(
        CAST(r."Excess Readmission Ratio" AS REAL)
    ) AS highest_ratio

FROM hospitals AS h

INNER JOIN readmissions AS r
    ON h."Facility ID" = r."Facility ID"

WHERE h."State" = 'CO'
  AND r."Excess Readmission Ratio" <> 'N/A'
  AND CAST(r."Excess Readmission Ratio" AS REAL) > 1.00

GROUP BY r."Measure Name"

ORDER BY
    above_expected_hospitals DESC,
    average_ratio_above_expected DESC;
	
/*
Analysis Query 6: Investigate the highest Hip/Knee readmission ratio

This query looks only at the Hip/Knee HRRP measure.

It removes N/A values and converts the excess readmission ratio
from text into a numeric value.

ORDER BY sorts the hospitals from the highest ratio to the lowest.

This query is being used to verify the 1.3313 maximum identified
in the previous summary query.
*/

SELECT
    h."Facility ID",
    h."Facility Name",
    h."City/Town",
    h."Hospital overall rating",
    r."Measure Name",
    CAST(r."Excess Readmission Ratio" AS REAL) AS excess_readmission_ratio
FROM hospitals AS h

INNER JOIN readmissions AS r
    ON h."Facility ID" = r."Facility ID"

WHERE h."State" = 'CO'
  AND r."Measure Name" = 'READM-30-HIP-KNEE-HRRP'
  AND r."Excess Readmission Ratio" <> 'N/A'

ORDER BY excess_readmission_ratio DESC;

/*
Analysis Query 7: Compare readmission performance by CMS star rating

This query groups participating Colorado hospitals by their
CMS overall hospital rating.

N/A readmission ratios are removed because they cannot be
used in numerical calculations.

Hospitals with a CMS rating of Not Available are also removed
so the rating groups can be compared numerically.

COUNT(*) counts all usable readmission records within each
star-rating group.

AVG calculates the average excess readmission ratio.

SUM with CASE counts how many records were above expected.

The percentage calculation shows the share of usable records
above expected within each CMS star-rating group.
*/

SELECT
    h."Hospital overall rating" AS hospital_rating,

    COUNT(*) AS usable_readmission_records,

    ROUND(
        AVG(
            CAST(r."Excess Readmission Ratio" AS REAL)
        ),
        4
    ) AS average_excess_readmission_ratio,

    SUM(
        CASE
            WHEN CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
                THEN 1
            ELSE 0
        END
    ) AS above_expected_records,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
                    THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS above_expected_percentage

FROM hospitals AS h

INNER JOIN readmissions AS r
    ON h."Facility ID" = r."Facility ID"

WHERE h."State" = 'CO'
  AND r."Excess Readmission Ratio" <> 'N/A'
  AND h."Hospital overall rating" <> 'Not Available'

GROUP BY h."Hospital overall rating"

ORDER BY CAST(h."Hospital overall rating" AS INTEGER);

/*
Analysis Query 8: Compare readmission performance by ownership group

CASE combines the detailed CMS ownership categories into
Nonprofit, Government, and For-profit groups.

Only usable excess readmission ratios are included.

COUNT(DISTINCT Facility ID) shows how many unique hospitals
contribute to each ownership group.

COUNT(*) counts the usable readmission records.

AVG calculates the average excess readmission ratio.

SUM with CASE counts records with ratios above 1.00.

The percentage calculation shows the share of usable
readmission records that were above expected.
*/

SELECT
    CASE
        WHEN h."Hospital Ownership" LIKE 'Voluntary non-profit%'
            THEN 'Nonprofit'

        WHEN h."Hospital Ownership" LIKE 'Government%'
            OR h."Hospital Ownership" = 'Veterans Health Administration'
            OR h."Hospital Ownership" = 'Department of Defense'
            THEN 'Government'

        WHEN h."Hospital Ownership" IN ('Proprietary', 'Physician')
            THEN 'For-profit'

        ELSE 'Other'
    END AS ownership_group,

    COUNT(DISTINCT h."Facility ID") AS hospital_count,

    COUNT(*) AS usable_readmission_records,

    ROUND(
        AVG(
            CAST(r."Excess Readmission Ratio" AS REAL)
        ),
        4
    ) AS average_excess_readmission_ratio,

    SUM(
        CASE
            WHEN CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
                THEN 1
            ELSE 0
        END
    ) AS above_expected_records,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
                    THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS above_expected_percentage

FROM hospitals AS h

INNER JOIN readmissions AS r
    ON h."Facility ID" = r."Facility ID"

WHERE h."State" = 'CO'
  AND r."Excess Readmission Ratio" <> 'N/A'

GROUP BY
    CASE
        WHEN h."Hospital Ownership" LIKE 'Voluntary non-profit%'
            THEN 'Nonprofit'

        WHEN h."Hospital Ownership" LIKE 'Government%'
            OR h."Hospital Ownership" = 'Veterans Health Administration'
            OR h."Hospital Ownership" = 'Department of Defense'
            THEN 'Government'

        WHEN h."Hospital Ownership" IN ('Proprietary', 'Physician')
            THEN 'For-profit'

        ELSE 'Other'
    END

ORDER BY average_excess_readmission_ratio;