
Hi, WELCOME friend

How to run?
      - copy all R script files into WD(work directory)
      - execute loadAllArticles.R only

loadAllArticles.R:
         - Main program
         - step1: extract article list page url from the journal's main page
         - step2: extract total page information (count and url of each page)
         - step3: extract article url list from each page, adn store in a data.frame
                  call function: loadArticleList()
         - step4: save all article page (DOI.html) to /HTMLs folder, extract 10 required fields from the article full text page and store in a data.frame
                  call function: analysisArticle()
         - step5: save final result(data.frame) into /output/BMC Medical Genetics.txt




util.R
FUNCTION 1:
      - FUNCTION NAME: loadArticleList
      - FUNCTION:extract DOI and url of article lists in the specified page
      - INPUT:[page_url:the url of article list page]
      - OUTPUT:[data.frame(DOI,URL:url of article full text)]

FUNCTION 2:
       - FUNCTION NAME: analysisArticle
       - FUNCTION:extract all required field from the specified article full text page
       - INPUT:[DOI,URL:url of article full text]
       - OUTPUT:[data.frame(DOI, title, author, authorAffiliation, correspondingAuthor,correspondingAuthorEmail, publicationDate, abstract, keywords, fullText)], single row

FUNCTION 3:
      - FUNCTION NAME: extract
      - FUNCTION:extract xmlValue from specified XML tag/node
      - INPUT:[parsedHtml, pattern]
      - OUTPUT:[string of xmlValue embedded in the tag/node]

FUNCTION 4:
      - FUNCTION NAME: extracAttribute
      - FUNCTION:extract XML attribute value from specified XML tag/node and attribute name
      - INPUT:[parsedHtml, pattern, attribute]
      - OUTPUT:[string of attribute value]

FUNCTION 5:
      - FUNCTION NAME: extractAuthors
      - FUNCTION:extract author, corresponding author, corresponding author's email
      - INPUT:[parsedHtml]
      - OUTPUT:[vector(author, corresponding.author, email)]

FUNCTION 6:
        - FUNCTION NAME: extractAffliation
        - FUNCTION:extract affliationID and affliationText
        - INPUT:[parsedHtml]
        - OUTPUT:[data.frame(affliationID, affliationText)]
        - WARNING: it is not being used in this project, but if you need to comply the author and their affliations, this dunction will be helpful




readTheResult.R is not part of the program, it is for reading the result data


If you any question mail me to sg952@njit.edu or shubham26g1994@gmail.com

Have a good one!!!