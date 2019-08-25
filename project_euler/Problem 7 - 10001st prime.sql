-- By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.
-- What is the 10 001st prime number?

WITH prime AS
  (SELECT num FROM unnest(generate_array(1,200000,2)) num),
divisor AS
  (SELECT num FROM unnest(generate_array(2,100000)) num)
SELECT num 
FROM prime
GROUP BY 1
HAVING (SELECT count(*) FROM divisor WHERE divisor.num<prime.num and mod(prime.num,divisor.num)=0) = 0
ORDER BY num asc
limit 1 offset 10000;
