-- Purpose: Use Bigquery to find prime numbers (just for funzies)
-- Finds primes under 1k in a few seconds
-- Finds primes under 10k in 10-20 seconds
-- Finds primes under 100k in ~10 minutes
-- Free to run, 0 bytes processed !
-- Included a few ways to write it

WITH numbers AS
  (SELECT num FROM unnest(generate_array(2,1000)) num)
SELECT num 
FROM numbers AS prime
GROUP BY 1
HAVING (SELECT count(*) FROM numbers AS divisor WHERE divisor.num<prime.num and mod(prime.num,divisor.num)=0) = 0
ORDER BY num DESC;



-- Using a Cross Join
WITH numbers AS
(SELECT num FROM unnest(generate_array(2,1000)) num)
SELECT prime.num
FROM
  numbers AS prime
CROSS JOIN
  numbers AS divisor
GROUP BY num
HAVING countif(divisor.num<prime.num AND mod(prime.num,divisor.num)=0)=0
ORDER BY num DESC



-- Using an inner join. You lose "2" as a prime on the inner join because there's no divisors less than 2 on the right side.
-- Left join won't work with only inequalities in the ON
-- This one might be most performant
WITH numbers AS
(SELECT num FROM unnest(generate_array(2,10000)) num)
SELECT 2 as num
UNION ALL
SELECT prime.num
FROM
  numbers AS prime
JOIN
  numbers AS divisor ON divisor.num<prime.num
GROUP BY num
HAVING countif(mod(prime.num,divisor.num)=0)=0
ORDER BY num DESC
