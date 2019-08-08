WITH words as (
  -- One "word" per row. I remove any non-alphabetical characters.
  SELECT 
    lower(regexp_replace(title,r'[^A-Za-z]+','')) AS word, 
    title AS original
  FROM `bigquery-samples.wikipedia_benchmark.Wiki10M` 
  WHERE language='en' AND lower(title) NOT LIKE '%file:%'
),
palindromes as (
  -- Find palindromes by comparing the word to the word reversed
  SELECT 
    word palindrome, 
    length(word) number_of_letters, 
    (SELECT struct(string_agg(letters,'' ORDER BY ordr DESC) as reverse_word, count(DISTINCT letters) AS unique_letters) FROM unnest(split(word,"")) letters WITH OFFSET ordr) x,
    any_value(original) original
  FROM words
  GROUP BY 1
  HAVING palindrome = x.reverse_word
  --Get rid of garbage palindromes with only 1 or 2 unique letters
  AND x.unique_letters>2
  ORDER BY number_of_letters DESC
  LIMIT 1000
)
SELECT 
* EXCEPT (x), x.unique_letters
FROM palindromes
ORDER BY number_of_letters DESC
