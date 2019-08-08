#Purpose: For "cleaning" URLs and stripping them down to the actual path for grouping.
#Removes www
#Removes protcol: http(s)://
#Removes trailing slashes (i.e. github.com/ becomes github.com)
#Removes query string, parameters, and fragments (anything after ? or #)

CREATE OR REPLACE FUNCTION
  fn.clean_url(url string) AS (REGEXP_EXTRACT(url,r'^(?:http[s]?://)?(?:www[2]?[\.\-]?)?(.*?)(?:/\?|\?|/$|#|$)'))
  
#If you want to also set the URL to lower case use the below:

-- CREATE OR REPLACE FUNCTION
  -- fn.clean_url(url string) AS (LOWER(REGEXP_EXTRACT(url,r'^(?:http[s]?://)?(?:www[2]?[\.\-]?)?(.*?)(?:/\?|\?|/$|#|$)')))
