-- 2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.
-- What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?
-- Note: BigQuery can't generate more than ~1M numbers, so I used interval 2520 (per the instructions)
with nums as (select * from unnest(generate_array(2520,1000000000,2520)) as num)
select num
from (select num from nums ), (select * from unnest(generate_array(1,20)) as divisor)
group by 1
having countif(mod(num,divisor)=0)=20
order by 1 asc
limit 1
