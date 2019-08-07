with sentences as (
  SELECT 
    regexp_replace(title,r'[^A-Za-z]+',' ') as sentence, 
    title as original_sentence
    FROM `bigquery-samples.wikipedia_benchmark.Wiki10M` 
    where language='en'
  )
, words as (
  select split(sentence, ' ') word, sentence, original_sentence
  from sentences
)
, letters as (
  select split(word,'') letter, word from 
    (
    select lower(trim(word)) word, count(*)
    from 
    words,unnest(word) word
    group by 1
    order by 2 desc
   )
   )
, isograms as (
  select word, count(*) letters, count(distinct letter) u_letters from
  (select letter, word
  from 
  letters, unnest(letter) letter
  )
  group by 1
  having letters=u_letters
)
select letters, words.word, array_agg(struct(sentence, original_sentence) limit 5)
from isograms
join (select word, sentence, original_sentence from words, unnest(word) word) words on isograms.word=words.word
where letters>10
group by 1,2
order by letters desc
