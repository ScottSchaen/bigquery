WITH strings_of_words AS (
  --Put your string of words here. Make sure words are space separated
  SELECT 
    regexp_replace(title,r'[^A-Za-z]+',' ') AS word_string, 
    title AS original
  FROM `bigquery-samples.wikipedia_benchmark.Wiki10M` 
  WHERE language='en'
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
  ),
 isograms AS (
  --Evaluate the letters per word
  SELECT word, count(*) letters_in_word, count(distinct letter) unique_letters_in_word FROM (
    SELECT letter, word
    FROM 
    letters, unnest(letter) letter)
  GROUP BY 1
  having letters_in_word=unique_letters_in_word
)

SELECT 
  isograms.letters_in_word, 
  isograms.word, 
  array_agg(struct(word_string, original) LIMIT 5)
FROM isograms
JOIN (SELECT word, word_string, original FROM words, unnest(word) word) words ON isograms.word=words.word
WHERE letters_in_word>10
GROUP BY 1,2
ORDER BY letters_in_word DESC
