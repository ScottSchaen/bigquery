-- A Pythagorean triplet is a set of three natural numbers, a < b < c, for which,
-- a^2 + b^2 = c^2
-- For example, 3^2 + 4^2 = 9 + 16 = 25 = 52.
-- There exists exactly one Pythagorean triplet for which a + b + c = 1000.
-- Find the product abc.

with nums as (SELECT num FROM unnest(generate_array(1,1000)) num)
select
a.num * b.num * c.num product
from
  nums a, nums b, nums c
where pow(a.num,2)+pow(b.num,2)=pow(c.num,2) and a.num+b.num+c.num=1000 and a.num<b.num and b.num<c.num
