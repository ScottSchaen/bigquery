WITH strings_of_words AS (
  --Put your string of words here. Make sure words are space separated
  SELECT 
    lower(regexp_replace(title,r'[^A-Za-z]+',' ')) AS word_string, 
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
 isograms AS (
  --Evaluate the letters per word
  SELECT 
    word, 
    length(word) letters_in_word,
    max((SELECT count(DISTINCT letters) FROM unnest(split(word,"")) as letters))   unique_letters_in_word
    from words, unnest(word) word
  GROUP BY 1,2
  HAVING letters_in_word=unique_letters_in_word
)
SELECT 
  isograms.letters_in_word, 
  isograms.word, 
  array_agg(struct(word_string, original) LIMIT 5) as source
FROM isograms
JOIN (SELECT word, word_string, original FROM words, unnest(word) word) words ON isograms.word=words.word
WHERE letters_in_word>10
GROUP BY 1,2
ORDER BY letters_in_word DESC
