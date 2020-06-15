# Swap "MCMLXXXIV" for a roman numeral of your choice.
# Works with all properly formed roman numerals, and then some!
# How it works: 
#     Translates each numeral to a number and decides whether to add it 
#     or subtract it from the running total depending on whether the following 
#     number is higher. Example: IX --> I, 1 is less than 10, X, so subtract 1 and add 10.

select 
  sum(number*sign) number,
  string_agg(numeral,'') numeral
from
(
  select numeral, 
         n, 
         number, 
         ifnull(case when number < lead(number) over (order by n) then -1 else 1 end,1) as sign
  from unnest(split("MCMLXXXIV",'')) numeral with offset n
  join (select 'I' numeral, 1 number union all
        select 'V' numeral, 5 number union all
        select 'X' numeral, 10 number union all
        select 'L' numeral, 50 number union all
        select 'C' numeral, 100 number union all
        select 'D' numeral, 500 number union all
        select 'M' numeral, 1000 number ) using (numeral)
 )
