/*
Query 1: Preview the hospital dataset

This query displays the first 10 hospital records.

SELECT * means show every column.
FROM hospitals means retrieve the data from the hospitals table.
LIMIT 10 keeps the result small and easy to review.

This is an initial data-exploration query used to confirm that
the dataset imported correctly.
*/

SELECT *
FROM hospitals
LIMIT 10;

/*
This query counts every row in the hospitals table.

It confirms that the CSV was imported and that the table
is available for analysis.
*/

SELECT COUNT(*) AS total_hospitals
FROM hospitals;

/*
Query 3: Count hospital records in Colorado

WHERE "State" = 'CO' keeps only hospital records where
the State column contains the Colorado abbreviation.

COUNT(*) counts the remaining rows.

AS colorado_hospitals gives the result a clear column name.
*/

SELECT COUNT(*) AS colorado_hospitals
FROM hospitals
WHERE "State" = 'CO';

/*
Query 4: count colorado hospitals that offer emergency services.
where "state" = 'CO' keeps only colorado hospital records.

And "Emergency Services" = 'yes' keeps only the hospitals that indicate emergency services are available
 Count(*) counts the remaining hospitals
 
 AS colorado_hospitals_with_emergency_services gives the result a clear and readable name.
 */
 
 SELECT COUNT(*) AS colorado_hospitals_with_emergency_services
 FROM hospitals
 WHERE "State" = 'CO'
	AND "Emergency Services" = 'Yes';

/*
Query 5: Calculate the percentage of Colorado hospitals
that offer emergency services

COUNT(*) counts all Colorado hospitals.

SUM(CASE WHEN ... THEN 1 ELSE 0 END) counts only the hospitals
where Emergency Services equals Yes.

Multiplying by 100.0 converts the result into a percentage.

ROUND(..., 1) rounds the percentage to one decimal place.
*/

SELECT
    COUNT(*) AS total_colorado_hospitals,
    SUM(
        CASE
            WHEN "Emergency Services" = 'Yes' THEN 1
            ELSE 0
        END
    ) AS hospitals_with_emergency_services,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN "Emergency Services" = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS emergency_services_percentage
FROM hospitals
WHERE "State" = 'CO';
/*
Query 6: count colorado hospitals by emergency service status

Where "State" = 'CO' keeps only colorado hospitals
Group by "emergency services" creates a separate group for each response, such as Yes and No.

Count(*) counts how many hospitals are in each GROUP
Order by hospital_count DESC places the largest group first.
*/

SELECT
	"Emergency Services",
	COUNT(*) AS hospital_count
FROM hospitals
WHERE "State" = 'CO'
GROUP BY "Emergency Services"
ORDER BY hospital_count DESC;

/*
Query 7: Count Colorado hospitals by hospital type

WHERE "State" = 'CO' keeps only Colorado hospitals.

GROUP BY "Hospital Type" creates a separate group for each
type of hospital in the dataset.

COUNT(*) counts how many hospitals belong to each type.

ORDER BY hospital_count DESC sorts the results from the
largest group to the smallest group.
*/

SELECT
    "Hospital Type",
    COUNT(*) AS hospital_count
FROM hospitals
WHERE "State" = 'CO'
GROUP BY "Hospital Type"
ORDER BY hospital_count DESC;

/*
Query 8: Calculate the percentage of Colorado hospitals
in each hospital type

WHERE "State" = 'CO' keeps only Colorado hospitals.

GROUP BY "Hospital Type" creates one group for each hospital type.

COUNT(*) counts the hospitals in each group.

The subquery:
    SELECT COUNT(*) FROM hospitals WHERE "State" = 'CO'
returns the total number of Colorado hospitals.

Each hospital-type count is divided by the Colorado total
and multiplied by 100.0 to produce a percentage.

ROUND(..., 1) formats the percentage to one decimal place.
*/

SELECT
    "Hospital Type",
    COUNT(*) AS hospital_count,
    ROUND(
        100.0 * COUNT(*) /
        (
            SELECT COUNT(*)
            FROM hospitals
            WHERE "State" = 'CO'
        ),
        1
    ) AS percentage_of_colorado_hospitals
FROM hospitals
WHERE "State" = 'CO'
GROUP BY "Hospital Type"
ORDER BY hospital_count DESC;

/*
Query 9: Count Colorado hospitals by ownership type

WHERE "State" = 'CO' keeps only Colorado hospitals.

GROUP BY "Hospital Ownership" creates one group for each
ownership category, such as nonprofit, government, or proprietary.

COUNT(*) counts how many hospitals belong to each ownership group.

ORDER BY hospital_count DESC sorts the categories from the
largest number of hospitals to the smallest.
*/

SELECT
    "Hospital Ownership",
    COUNT(*) AS hospital_count
FROM hospitals
WHERE "State" = 'CO'
GROUP BY "Hospital Ownership"
ORDER BY hospital_count DESC;

/*
Query 10: Group Colorado hospitals into broader ownership categories

CASE reviews each hospital's detailed ownership description
and assigns it to a broader category.

Ownership values containing the words Voluntary non-profit
are grouped as Nonprofit.

Ownership values containing the word Government, along with
Veterans Health Administration and Department of Defense,
are grouped as Government.

Ownership values equal to Proprietary or Physician are grouped
as For-profit.

ELSE captures any unexpected ownership value as Other.

COUNT(*) counts the hospitals in each broader category.

GROUP BY repeats the CASE logic so SQLite can create one result
row for each category.

ORDER BY hospital_count DESC places the largest group first.
*/

SELECT
    CASE
        WHEN "Hospital Ownership" LIKE 'Voluntary non-profit%'
            THEN 'Nonprofit'
        WHEN "Hospital Ownership" LIKE 'Government%'
            OR "Hospital Ownership" = 'Veterans Health Administration'
            OR "Hospital Ownership" = 'Department of Defense'
            THEN 'Government'
        WHEN "Hospital Ownership" IN ('Proprietary', 'Physician')
            THEN 'For-profit'
        ELSE 'Other'
    END AS ownership_group,
    COUNT(*) AS hospital_count
FROM hospitals
WHERE "State" = 'CO'
GROUP BY
    CASE
        WHEN "Hospital Ownership" LIKE 'Voluntary non-profit%'
            THEN 'Nonprofit'
        WHEN "Hospital Ownership" LIKE 'Government%'
            OR "Hospital Ownership" = 'Veterans Health Administration'
            OR "Hospital Ownership" = 'Department of Defense'
            THEN 'Government'
        WHEN "Hospital Ownership" IN ('Proprietary', 'Physician')
            THEN 'For-profit'
        ELSE 'Other'
    END
ORDER BY hospital_count DESC;

/*
Query 11: Calculate the percentage of Colorado hospitals
in each broad ownership group

CASE combines the detailed CMS ownership categories into
Nonprofit, Government, and For-profit.

COUNT(*) counts the number of hospitals in each ownership group.

The subquery counts all Colorado hospitals.

Each ownership-group count is divided by the Colorado total
and multiplied by 100.0 to calculate its percentage.

ROUND(..., 1) formats the result to one decimal place.
*/

SELECT
    CASE
        WHEN "Hospital Ownership" LIKE 'Voluntary non-profit%'
            THEN 'Nonprofit'
        WHEN "Hospital Ownership" LIKE 'Government%'
            OR "Hospital Ownership" = 'Veterans Health Administration'
            OR "Hospital Ownership" = 'Department of Defense'
            THEN 'Government'
        WHEN "Hospital Ownership" IN ('Proprietary', 'Physician')
            THEN 'For-profit'
        ELSE 'Other'
    END AS ownership_group,
    COUNT(*) AS hospital_count,
    ROUND(
        100.0 * COUNT(*) /
        (
            SELECT COUNT(*)
            FROM hospitals
            WHERE "State" = 'CO'
        ),
        1
    ) AS percentage_of_colorado_hospitals
FROM hospitals
WHERE "State" = 'CO'
GROUP BY
    CASE
        WHEN "Hospital Ownership" LIKE 'Voluntary non-profit%'
            THEN 'Nonprofit'
        WHEN "Hospital Ownership" LIKE 'Government%'
            OR "Hospital Ownership" = 'Veterans Health Administration'
            OR "Hospital Ownership" = 'Department of Defense'
            THEN 'Government'
        WHEN "Hospital Ownership" IN ('Proprietary', 'Physician')
            THEN 'For-profit'
        ELSE 'Other'
    END
ORDER BY hospital_count DESC;

/*
Query 12: Count Colorado hospitals by overall rating

WHERE "State" = 'CO' keeps only Colorado hospitals.

GROUP BY "Hospital Overall Rating" creates one group for
each rating value.

COUNT(*) counts how many hospitals received each rating.

ORDER BY sorts the ratings in numerical order.

Because the CMS column may contain text such as
Not Available, this query keeps the original values visible
so we can inspect the data before calculating averages.
*/

SELECT
    "Hospital Overall Rating",
    COUNT(*) AS hospital_count
FROM hospitals
WHERE "State" = 'CO'
GROUP BY "Hospital Overall Rating"
ORDER BY "Hospital Overall Rating";

/*
Query 13: Measure overall-rating availability for Colorado hospitals

COUNT(*) counts all Colorado hospitals.

SUM with CASE counts hospitals whose overall rating is
not listed as Not Available.

The percentage calculation divides the number of hospitals
with ratings by the total number of Colorado hospitals.

ROUND(..., 1) formats the percentage to one decimal place.
*/

SELECT
    COUNT(*) AS total_colorado_hospitals,
    SUM(
        CASE
            WHEN "Hospital Overall Rating" <> 'Not Available' THEN 1
            ELSE 0
        END
    ) AS hospitals_with_rating,
    SUM(
        CASE
            WHEN "Hospital Overall Rating" = 'Not Available' THEN 1
            ELSE 0
        END
    ) AS hospitals_without_rating,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN "Hospital Overall Rating" <> 'Not Available' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS rating_availability_percentage
FROM hospitals
WHERE "State" = 'CO';

/*
Query 14: Calculate the average overall rating for Colorado hospitals

WHERE "State" = 'CO' keeps only Colorado hospitals.

AND "Hospital Overall Rating" <> 'Not Available'
removes hospitals without a valid rating.

CAST converts the rating from text into a number so SQLite
can calculate an average.

AVG calculates the mean rating.

ROUND(..., 2) formats the result to two decimal places.
*/

SELECT
    ROUND(
        AVG(
            CAST("Hospital Overall Rating" AS REAL)
        ),
        2
    ) AS average_colorado_hospital_rating
FROM hospitals
WHERE "State" = 'CO'
  AND "Hospital Overall Rating" <> 'Not Available';
  
 /*
Query 15: List Colorado hospitals with a 5-star overall rating

WHERE "State" = 'CO' keeps only Colorado hospitals.

AND "Hospital Overall Rating" = '5' keeps only hospitals
with the highest available CMS overall rating.

SELECT returns the hospital name, city, ownership type,
hospital type, and emergency-services status.

ORDER BY sorts the hospitals alphabetically by facility name.
*/

SELECT
    "Facility Name",
    "City/Town",
    "Hospital Type",
    "Hospital Ownership",
    "Emergency Services",
    "Hospital Overall Rating"
FROM hospitals
WHERE "State" = 'CO'
  AND "Hospital Overall Rating" = '5'
ORDER BY "Facility Name";

/*
Query 16: Compare average hospital ratings by broad ownership group

WHERE "State" = 'CO' keeps only Colorado hospitals.

AND "Hospital Overall Rating" <> 'Not Available'
removes hospitals without a valid rating.

CASE combines detailed CMS ownership categories into
Nonprofit, Government, and For-profit groups.

CAST converts the rating from text into a number.

AVG calculates the average rating for each ownership group.

COUNT(*) shows how many rated hospitals are included in each group.

ROUND(..., 2) formats the average rating to two decimal places.
*/

SELECT
    CASE
        WHEN "Hospital Ownership" LIKE 'Voluntary non-profit%'
            THEN 'Nonprofit'
        WHEN "Hospital Ownership" LIKE 'Government%'
            OR "Hospital Ownership" = 'Veterans Health Administration'
            OR "Hospital Ownership" = 'Department of Defense'
            THEN 'Government'
        WHEN "Hospital Ownership" IN ('Proprietary', 'Physician')
            THEN 'For-profit'
        ELSE 'Other'
    END AS ownership_group,
    COUNT(*) AS rated_hospital_count,
    ROUND(
        AVG(
            CAST("Hospital Overall Rating" AS REAL)
        ),
        2
    ) AS average_rating
FROM hospitals
WHERE "State" = 'CO'
  AND "Hospital Overall Rating" <> 'Not Available'
GROUP BY
    CASE
        WHEN "Hospital Ownership" LIKE 'Voluntary non-profit%'
            THEN 'Nonprofit'
        WHEN "Hospital Ownership" LIKE 'Government%'
            OR "Hospital Ownership" = 'Veterans Health Administration'
            OR "Hospital Ownership" = 'Department of Defense'
            THEN 'Government'
        WHEN "Hospital Ownership" IN ('Proprietary', 'Physician')
            THEN 'For-profit'
        ELSE 'Other'
    END
ORDER BY average_rating DESC;

/*
Query 17: Compare rating availability by ownership group

CASE combines detailed CMS ownership values into broader
Nonprofit, Government, and For-profit groups.

COUNT(*) counts all hospitals in each ownership group.

SUM with CASE counts how many hospitals have an available rating.

The percentage calculation divides rated hospitals by all hospitals
in the ownership group.

ROUND(..., 1) formats the percentage to one decimal place.
*/

SELECT
    CASE
        WHEN "Hospital Ownership" LIKE 'Voluntary non-profit%'
            THEN 'Nonprofit'
        WHEN "Hospital Ownership" LIKE 'Government%'
            OR "Hospital Ownership" = 'Veterans Health Administration'
            OR "Hospital Ownership" = 'Department of Defense'
            THEN 'Government'
        WHEN "Hospital Ownership" IN ('Proprietary', 'Physician')
            THEN 'For-profit'
        ELSE 'Other'
    END AS ownership_group,

    COUNT(*) AS total_hospitals,

    SUM(
        CASE
            WHEN "Hospital Overall Rating" <> 'Not Available' THEN 1
            ELSE 0
        END
    ) AS hospitals_with_rating,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN "Hospital Overall Rating" <> 'Not Available' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS rating_availability_percentage

FROM hospitals
WHERE "State" = 'CO'

GROUP BY
    CASE
        WHEN "Hospital Ownership" LIKE 'Voluntary non-profit%'
            THEN 'Nonprofit'
        WHEN "Hospital Ownership" LIKE 'Government%'
            OR "Hospital Ownership" = 'Veterans Health Administration'
            OR "Hospital Ownership" = 'Department of Defense'
            THEN 'Government'
        WHEN "Hospital Ownership" IN ('Proprietary', 'Physician')
            THEN 'For-profit'
        ELSE 'Other'
    END

ORDER BY rating_availability_percentage DESC;

/*
Query 18: Compare average ratings by hospital type

WHERE "State" = 'CO' keeps only Colorado hospitals.

AND "Hospital Overall Rating" <> 'Not Available'
removes hospitals without a valid rating.

COUNT(*) shows how many rated hospitals are included
for each hospital type.

CAST converts the rating from text into a number.

AVG calculates the average rating for each hospital type.

ROUND(..., 2) formats the average to two decimal places.

ORDER BY average_rating DESC places the highest-rated
hospital type first.
*/

SELECT
    "Hospital Type",
    COUNT(*) AS rated_hospital_count,
    ROUND(
        AVG(
            CAST("Hospital Overall Rating" AS REAL)
        ),
        2
    ) AS average_rating
FROM hospitals
WHERE "State" = 'CO'
  AND "Hospital Overall Rating" <> 'Not Available'
GROUP BY "Hospital Type"
ORDER BY average_rating DESC;

/*
Query 19: Compare rating availability by hospital type

WHERE "State" = 'CO' keeps only Colorado hospitals.

COUNT(*) counts all hospitals in each hospital type.

SUM with CASE counts how many hospitals have an available
overall rating.

The percentage calculation divides hospitals with ratings
by the total hospitals in each type.

ROUND(..., 1) formats the percentage to one decimal place.

ORDER BY rating_availability_percentage DESC places the
hospital types with the most complete rating data first.
*/

SELECT
    "Hospital Type",
    COUNT(*) AS total_hospitals,
    SUM(
        CASE
            WHEN "Hospital Overall Rating" <> 'Not Available' THEN 1
            ELSE 0
        END
    ) AS hospitals_with_rating,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN "Hospital Overall Rating" <> 'Not Available' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS rating_availability_percentage
FROM hospitals
WHERE "State" = 'CO'
GROUP BY "Hospital Type"
ORDER BY rating_availability_percentage DESC;

/*
Query 20: Count Colorado hospitals by city

WHERE "State" = 'CO' keeps only Colorado hospitals.

GROUP BY "City/Town" creates one group for each city.

COUNT(*) counts how many hospitals are located in each city.

ORDER BY hospital_count DESC sorts the cities from the
largest number of hospitals to the smallest.

LIMIT 10 returns only the top 10 cities.
*/

SELECT
    "City/Town",
    COUNT(*) AS hospital_count
FROM hospitals
WHERE "State" = 'CO'
GROUP BY "City/Town"
ORDER BY hospital_count DESC, "City/Town"
LIMIT 10;

/*
Query 21: Find Colorado cities with only one hospital

WHERE "State" = 'CO' keeps only Colorado hospitals.

GROUP BY "City/Town" creates one group for each city.

COUNT(*) counts the number of hospitals in each city.

HAVING COUNT(*) = 1 keeps only cities where the hospital
count equals one.

ORDER BY sorts the cities alphabetically.
*/

SELECT
    "City/Town",
    COUNT(*) AS hospital_count
FROM hospitals
WHERE "State" = 'CO'
GROUP BY "City/Town"
HAVING COUNT(*) = 1
ORDER BY "City/Town";

/*
Query 22: Count Colorado cities with exactly one hospital

The inner query groups Colorado hospitals by city and keeps
only cities with one hospital.

The outer query counts how many cities remain after that filter.

This uses a subquery, which means one query is placed inside
another query.
*/

SELECT COUNT(*) AS cities_with_one_hospital
FROM (
    SELECT
        "City/Town"
    FROM hospitals
    WHERE "State" = 'CO'
    GROUP BY "City/Town"
    HAVING COUNT(*) = 1
) AS one_hospital_cities;

/*
Query 24: Calculate the percentage of Colorado cities
with exactly one hospital

The first subquery counts the total number of distinct Colorado cities.

The second subquery counts cities with exactly one hospital.

The final calculation divides one-hospital cities by all cities
and multiplies by 100.0 to create a percentage.

ROUND(..., 1) formats the percentage to one decimal place.
*/

SELECT
    (
        SELECT COUNT(DISTINCT UPPER(TRIM("City/Town")))
        FROM hospitals
        WHERE "State" = 'CO'
    ) AS total_colorado_cities,

    (
        SELECT COUNT(*)
        FROM (
            SELECT UPPER(TRIM("City/Town")) AS standardized_city
            FROM hospitals
            WHERE "State" = 'CO'
            GROUP BY UPPER(TRIM("City/Town"))
            HAVING COUNT(*) = 1
        )
    ) AS cities_with_one_hospital,

    ROUND(
        100.0 *
        (
            SELECT COUNT(*)
            FROM (
                SELECT UPPER(TRIM("City/Town")) AS standardized_city
                FROM hospitals
                WHERE "State" = 'CO'
                GROUP BY UPPER(TRIM("City/Town"))
                HAVING COUNT(*) = 1
            )
        )
        /
        (
            SELECT COUNT(DISTINCT UPPER(TRIM("City/Town")))
            FROM hospitals
            WHERE "State" = 'CO'
        ),
        1
    ) AS percentage_with_one_hospital;
	
/*
Query 16: Count Colorado readmission records by measure

INNER JOIN matches the readmission records to Colorado hospitals
using Facility ID.

GROUP BY creates one group for each readmission measure.

COUNT(*) counts all records reported for each measure.

SUM with CASE counts how many records contain a usable excess
readmission ratio rather than N/A.

The percentage calculation shows the availability of usable
ratios within each measure.

ORDER BY measure_name sorts the measures alphabetically.
*/

SELECT
    r."Measure Name" AS measure_name,
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN r."Excess Readmission Ratio" <> 'N/A' THEN 1
            ELSE 0
        END
    ) AS records_with_ratio,

    SUM(
        CASE
            WHEN r."Excess Readmission Ratio" = 'N/A' THEN 1
            ELSE 0
        END
    ) AS records_without_ratio,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN r."Excess Readmission Ratio" <> 'N/A' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS ratio_availability_percentage

FROM hospitals AS h
INNER JOIN readmissions AS r
    ON h."Facility ID" = r."Facility ID"

WHERE h."State" = 'CO'

GROUP BY r."Measure Name"

ORDER BY measure_name;

/*
Query 17: Check for unexpected values in the excess readmission ratio column

This query looks for values that are neither N/A nor valid numbers.

GLOB checks whether a value contains characters outside the
expected numeric pattern.

If this query returns no rows, the column contains only numeric
ratios and N/A values.
*/

SELECT DISTINCT
    r."Excess Readmission Ratio" AS unexpected_ratio_value
FROM readmissions AS r
WHERE r."State" = 'CO'
  AND r."Excess Readmission Ratio" <> 'N/A'
  AND r."Excess Readmission Ratio" NOT GLOB '[0-9]*.[0-9]*'
ORDER BY unexpected_ratio_value;

/*
Q18: Identify CO hospitals without readmission records

LEFT JOIN keeps every CO hospital from the hospitals table, even when no matching readmission record exists.

WHERE r."Facility ID" IS NULL keeps only hospitals that did not match to the readmissions table.

this helps document which hospitals are outside the available readmission dataset.
*/

SELECT
	h."Facility ID",
	h."Facility Name",
	h."City/Town",
	h."Hospital Type",
	h."Hospital Ownership"
FROM hospitals AS h
LEFT JOIN readmissions AS r
	ON h."Facility ID" = r."Facility ID"
WHERE h."State" = 'CO'
	AND r."Facility ID" IS NULL
ORDER BY h."Facility Name";

