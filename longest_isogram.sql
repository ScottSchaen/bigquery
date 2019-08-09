-- Purpose: Find the longest isogram (words with only one of every letter).

WITH words AS (
  --Put your string of words here. Make sure words are space separated
  SELECT 
    split(lower(regexp_replace(title,r'[^A-Za-z]+',' '))) AS word_string, 
    title AS original
  FROM `bigquery-samples.wikipedia_benchmark.Wiki10M` 
  WHERE language='en' AND lower(title) NOT LIKE '%file:%'
  GROUP BY 1,2
  ), 
words as (
  --Turn strings of words into one word per row
  SELECT 
    split(word_string, ' ') word,
    word_string, 
    original
  FROM strings_of_words
)
SELECT 
  word AS isogram, 
  any_value((SELECT count(DISTINCT letters) FROM unnest(split(word,"")) as letters)) AS unique_letters_in_word,
  array_agg(struct(original, word_string) LIMIT 5) AS source
FROM words, unnest(word) word
GROUP BY 1
HAVING length(word)=unique_letters_in_word
ORDER BY unique_letters_in_word DESC
