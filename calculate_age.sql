# How do you calculate someone's age in BigQuery?!
# Inspired by: https://medium.com/@jamescerwinly/how-to-accurately-calculate-age-in-bigquery-999a8417e973
# It seems like a straight-forward problem until you factor in leap years. 
# You're a year older when you make it to your birth date, not when it's been 365 days since your last birthday.

SELECT 
floor(cast(format_date('%Y.%m%d',current_date) AS float64) - cast(format_date('%Y.%m%d',bday) AS float64)) age
FROM
(
SELECT date('2000-02-29') AS bday
)
