-- A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.
-- Find the largest palindrome made from the product of two 3-digit numbers.

with nums as (select * from unnest(generate_array(100,999)) as num)
select 
  num1.num*num2.num prod
from nums num1, nums num2
where cast(num1.num*num2.num as string) = (SELECT string_agg(digits,'' ORDER BY ordr DESC) FROM unnest(split(cast(num1.num*num2.num AS STRING),"")) digits WITH OFFSET ordr)
order by prod desc
limit 1
