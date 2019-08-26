-- If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
-- Find the sum of all the multiples of 3 or 5 below 1000.

select sum(num)
from
(select num from unnest(generate_array(1,999)) num)
where
mod(num,5)=0 or mod(num,3)=0
