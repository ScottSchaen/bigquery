-- The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.
-- Find the sum of all the primes below two million.
-- Note: Unfortunately this takes nearly two hours to run :-/ Still works though

WITH prime AS
  (SELECT num FROM unnest(generate_array(1,2000000,2)) num),
divisor AS
  (SELECT num FROM unnest(generate_array(3,1000000,2)) num)
SELECT sum(num)+1
FROM prime
where not exists (select 1 FROM divisor WHERE divisor.num<prime.num and mod(prime.num,divisor.num)=0)
