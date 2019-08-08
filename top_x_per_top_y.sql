-- Purpose: A really elegant way using ARRRAY_AGG to pull Top X per Top Y, like 'Top 5 Posts per Top 10 Authors'

SELECT 
  author, 
  SUM(score) high_score, 
  ARRAY_AGG(STRUCT(title, score, TIMESTAMP_SECONDS(created_utc) as post_date) ORDER BY score DESC LIMIT 5) top_posts
FROM `fh-bigquery.reddit_posts.201*`
WHERE author!='[deleted]'
GROUP BY author
ORDER BY high_score DESC
LIMIT 10
