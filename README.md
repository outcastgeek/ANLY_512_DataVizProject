# ANLY_512_DataVizProject

## Goals:
The final project asks you to synthesize your R skills and your research interests. Specifically, you must define an analytic topic, identify data related to that topic, perform several analytic and graphic visualization tasks on the topic, and then prepare a report in Rmarkdown as a final submission. You should upload to Rpubs a refined report on your project, with clear language and refined graphs that adhere to the lessons we've had throughout the semester.

## Specifics:

Introduction. Your job in this section is to describe in detail what your topic is. Include research-based information that supports your selection of the project. So, if you are investigating pollution, you would include references perhaps from the EPA and news articles on pollution issues, as well as academic references on this topic.  Be sure to cite your references appropriately.  Also, you should state some __general exploratory analysis questions__ that you are going to answer in your project.
Data & Methods. You should describe in detail the data sources you used, why you selected them, and also the analytic methods utilized.  While the emphasis is on graphs, I want you to include __baseline statistics__  on each dataset. This means the number of cases in each dataset, and standard means and frequency counts for each measure you include in the analysis. 
Refer to our readings on visualization design. Include citations and references that provide explanations about your choices for different visualizations your create. You might want to make this a subsection of your methods.
Have Enough Data. You must choose a dataset that has a sufficient number of "outcome" measures for your analysis, as well as enough factors or contextual measures. Additionally, you must have enough cases (rows) of data in your dataset (roughly 60 or more) so that your visualizations are sufficiently apparent.  
Consider Various Data Sources. Some repositories for data are the [UCI machine learning database](http://archive.ics.uci.edu/ml/datasets.html). Additionally, there are [science datasets](https://www.nature.com/sdata/policies/repositories) and social science datasets at [ICPSR](https://www.icpsr.umich.edu/icpsrweb/). You can find financial datasets [here](http://www.r-bloggers.com/financial-data-accessible-from-r-part-iii).  The US Census Bureau [American Fact Finder](https://factfinder.census.gov/faces/nav/jsf/pages/searchresults.xhtml?refresh=t) is also excellent, as is the [USDA Economic Research Service](https://www.ers.usda.gov/data-products/) and the [Bureau of Labor Statistics](http://www.bls.gov/). [Transportation](https://www.rita.dot.gov/bts/data_and_statistics/index.html) and [science](https://www2.clarku.edu/research/sciencelibrary/databases/physics.cfm) data are also available. In short, use Google to identify institutions that supply data. Be cautious of data sources that are not from reputable/established institutions or which do not describe the source of data clearly.You can also __create your OWN__ dataset! Also remember you can use more than one dataset to complete the project, and you might even merge datasets (if appropriate).
Length. Your report on your project should be about +-1000 words.
Example of report:  See the attached report for information about what is expected. __NOTE: This example report does not include a table of baseline stats, which is a requirement!__ 
Use [APA headings](https://owl.english.purdue.edu/owl/resource/560/16/).   Minimally, headings should include the following sections: Introduction, Data & Methods, Analysis, Discussion. You may create additional subsections of these four main sections.
If you are on a team, INCLUDE ALL TEAM MEMBER NAMES AT THE TOP OF YOUR PAPER.

# Setup (Windows)

* [Using Version Control with RStudio](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN)
* [Git for Windown](https://git-scm.com/)
* [Github Desktop](https://desktop.github.com/)

// TODO

# Links

* [Twitter Threads](https://www.kaggle.com/danielgrijalvas/twitter-threads)
* [24 thousand tweets later](https://www.kaggle.com/derrickmwiti/24-thousand-tweets-later#tweets.csv)
* [Google Dataset Search](https://toolbox.google.com/datasetsearch) is very interesting, and a related discussion can be found [here on HN](https://news.ycombinator.com/item?id=17919297)
* [Awesome Public Datasets](https://github.com/awesomedata/awesome-public-datasets/blob/master/README.rst) is a list of topic-centric public data sources in high quality which have been collected and tidied from blogs, answers, and user responses.
* [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page) contains the free knowledge base with 49,887,230 data items that anyone can edit.
* [SPARQL](https://en.wikipedia.org/wiki/SPARQL) (pronounced "sparkle", a recursive acronym[2] for SPARQL Protocol and RDF Query Language) is an [RDF query language](https://en.wikipedia.org/wiki/RDF_query_language).
* [WikidataQueryServiceR](https://cran.r-project.org/web/packages/WikidataQueryServiceR/index.html) is the API Client Library for 'Wikidata Query Service'

  Example:
  ```r
  # Install the Library to Query Wikidata
  install.packages("WikidataQueryServiceR")
  
  # Load the Library
  library(WikidataQueryServiceR)
  
  # Run Sample Query
  query_wikidata('SELECT DISTINCT
      ?genre ?genreLabel
    WHERE {
      ?film wdt:P31 wd:Q11424.
      ?film rdfs:label "The Cabin in the Woods"@en.
      ?film wdt:P136 ?genre.
      SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
    }')
  ```
* [Using R to Analyse Linked Data](https://medium.swirrl.com/using-r-to-analyse-linked-data-7225eefe2eb8)

Example:
```r
# Install SPARQL, the library to Issue RDF Queries into Semantic Datasets
install.packages("SPARQL")

# Load the library
library(SPARQL)

# Run a query
endpoint <- 'http://statistics.gov.scot/sparql'
query <- 'PREFIX qb: <http://purl.org/linked-data/cube#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sdmx: <http://purl.org/linked-data/sdmx/2009/concept#>
PREFIX data: <http://statistics.gov.scot/data/>
PREFIX sdmxd: <http://purl.org/linked-data/sdmx/2009/dimension#>
PREFIX mp: <http://statistics.gov.scot/def/measure-properties/>
PREFIX stat: <http://statistics.data.gov.uk/def/statistical-entity#>
SELECT ?areaname ?nratio ?yearname ?areatypename WHERE {
?indicator qb:dataSet data:alcohol-related-discharge ;
             sdmxd:refArea ?area ;
             sdmxd:refPeriod ?year ;
             mp:ratio ?nratio .
?year rdfs:label ?yearname .
  
?area stat:code ?areatype ;
      rdfs:label ?areaname .
?areatype rdfs:label ?areatypename .
}'
qd <- SPARQL(endpoint,query)

# Inspect the query results
head(qd)
df <- qd$results
head(df)

```

