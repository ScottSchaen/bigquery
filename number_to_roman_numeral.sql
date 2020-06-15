# Using the standard rules for Roman Numerals at https://en.wikipedia.org/wiki/Roman_numerals
# Inner query cross joins every numeral to the number_to_convert (here "789")
# My solution looks at how many times the number goes into the mod of the previous numeral (ordered descending)
# Example: 75. C goes into 75 0 times with a remainder of 75. L goes into 75 once with a remainder of 25. 10 goes into 25 twice with a remainder of 5...
# My inner query produces inproper numerals (i.e. VIIII instead of IX) so there's a 7-layer-replace to make it proper :) 


with translation as
         (select 'I' numeral, 1 number union all
          select 'V' numeral, 5 number union all
          select 'X' numeral, 10 number union all
          select 'L' numeral, 50 number union all
          select 'C' numeral, 100 number union all
          select 'D' numeral, 500 number union all
          select 'M' numeral, 1000 number )
select replace(replace(replace(replace(replace(replace(replace(
        string_agg(letters, '' order by number desc),
        'CCCC','CD'),'DCCC','CM'),'LXXXX','XC'),'XXXX','XL'),'VIIII','IX'),'IIII','IV'),'XXXX','XL') numeral,
       any_value(number_to_convert) number
from (
  select *, 
    cast(floor(number_to_convert/number) as int64) divisors, 
    cast(floor(number_to_convert/number) as int64) * number fulfilled,
    mod(number_to_convert,number) remainder,
    repeat(numeral, cast(floor(ifnull(mod(number_to_convert,lag(number) over (order by number desc)),number_to_convert)/number) as int64)) letters, 
    ifnull(mod(number_to_convert,lag(number) over (order by number desc)),number_to_convert)
  from
  (select 789 as number_to_convert), translation
  order by number desc
  )
