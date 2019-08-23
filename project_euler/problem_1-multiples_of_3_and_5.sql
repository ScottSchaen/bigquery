select sum(num)
from
(select num from unnest(generate_array(1,999)) num)
where
mod(num,5)=0 or mod(num,3)=0
