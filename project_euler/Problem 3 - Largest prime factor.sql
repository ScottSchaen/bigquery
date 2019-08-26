-- The prime factors of 13195 are 5, 7, 13 and 29.
-- What is the largest prime factor of the number 600851475143 ?
-- Note: BigQuery can't generate an array larger than 1million, so I had to get weird with this.
with nums as (select * from unnest(generate_array(1,1000000)) as num)
select greatest(max(case when a_divisors=0 then divisor_a end), max(case when a_divisors=0 then divisor_a end)) from
(
select divisor_a, countif(mod(divisor_a,num)=0 and divisor_a>num) a_divisors, divisor_b, countif(mod(divisor_b,num)=0 and divisor_b>num) b_divisors
from
  (select num as divisor_a, cast(600851475143/num as numeric) divisor_b
  from
    (select num from nums
    union all
    select num+1000000 as num from nums)
  where mod(600851475143,num)=0 and num>1), nums
  where num>1
  group by divisor_a, divisor_b
)
