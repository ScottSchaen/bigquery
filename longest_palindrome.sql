WITH strings_of_words AS (
  --Put your string of words here. Make sure words are space separated
  SELECT 
    regexp_replace(title,r'[^A-Za-z]+',' ') AS word_string, 
    title AS original
  FROM `bigquery-samples.wikipedia_benchmark.Wiki10M` 
  WHERE language='en' AND lower(title) NOT LIKE '%file:%'
  ), 
words as (
  --Turn strings of words into one word per row
  SELECT 
    split(word_string, ' ') word,
    word_string, 
    original
  FROM strings_of_words
),
letters AS (
  --For each word, break the letters into separate rows
  SELECT split(word,'') letter, word FROM (
    SELECT lower(trim(word)) word, count(*)
    FROM 
    words,unnest(word) word
    GROUP BY 1)
  )
 select word, count(*) number_of_letters, string_agg(letter, '' order by ordr desc) word_backward from letters, unnest(letter) as letter with offset ordr
 group by 1
 having word = word_backward
 order by number_of_letters desc
 limit 1000
