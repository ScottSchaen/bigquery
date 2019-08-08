WITH strings_of_words AS (
  -- Put your string of words here. Make sure words are space separated
  -- I lower the word and replace anything that's not a letter with a space
  SELECT 
    lower(regexp_replace(title,r'[^A-Za-z]+',' ')) AS word_string, 
    title AS original
  FROM `bigquery-samples.wikipedia_benchmark.Wiki10M` 
  WHERE language='en' AND lower(title) NOT LIKE '%file:%'
  ), 
words as (
  -- Turn strings of words into one word per row
  SELECT 
    split(word_string, ' ') word,
    word_string, 
    original
  FROM strings_of_words
),
palindromes as (
  -- Find palindromes by comparing the word to the word reversed
  SELECT 
    word palindrome, 
    length(word) number_of_letters, 
    (SELECT struct(string_agg(letters,'' ORDER BY ordr DESC) as reverse_word, count(distinct letters) as unique_letters) FROM unnest(split(word,"")) letters WITH OFFSET ordr) x
  FROM words, unnest(word) word
  GROUP BY 1
  HAVING palindrome = x.reverse_word
  --Get rid of garbage palindromes with only 1 or 2 unique letters
  AND x.unique_letters>2
  ORDER BY number_of_letters DESC
  LIMIT 1000
)
-- Associate back to original string of words
SELECT 
  palindrome, 
  number_of_letters,
  array_agg(struct(original, word_string) limit 3) as source
FROM
  palindromes
JOIN
  (SELECT word, word_string, original FROM words, unnest(word) word) words ON words.word = palindromes.palindrome
GROUP BY 1,2 
ORDER BY number_of_letters DESC
