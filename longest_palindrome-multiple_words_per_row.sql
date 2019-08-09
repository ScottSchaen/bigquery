WITH strings_of_words AS (
  -- Put your string of words here. Make sure words are space separated
  -- I lower the word and replace anything that's not a letter with a space
  SELECT 
    lower(regexp_replace(title,r'[^A-Za-z]+',' ')) AS word_string, 
    title AS original
  FROM `bigquery-samples.wikipedia_benchmark.Wiki10M` 
  WHERE language='en' AND lower(title) NOT LIKE '%file:%'
  GROUP BY 1,2
  ), 
words as (
  -- Turn strings of words into one word per row
  SELECT 
    split(word_string, ' ') word,
    word_string, 
    original
  FROM strings_of_words
)
SELECT 
  word palindrome, 
  length(word) number_of_letters, 
  (SELECT count(distinct letters) FROM unnest(split(word,"")) letters) unique_letters,
  array_agg(struct(original, word_string) limit 3) as source
FROM words, unnest(word) word
GROUP BY 1,2,3
--Find palindromes by comparing word to word with reversed order
HAVING word = (SELECT string_agg(letters,'' ORDER BY ordr DESC) FROM unnest(split(word,"")) letters WITH OFFSET ordr)
--Get rid of garbage palindromes with only 1 or 2 unique letters
AND unique_letters>2
ORDER BY number_of_letters DESC
LIMIT 1000
