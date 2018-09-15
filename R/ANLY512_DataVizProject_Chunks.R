## @knitr installLibraries

install.packages("knitr")
install.packages("kableExtra")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("pastecs")
install.packages("haven")
install.packages("ggridges")
install.packages("WikidataQueryServiceR")
install.packages("SPARQL")

## @knitr loadLibraries

library(ggplot2)
library(dplyr)
library(pastecs)
library(haven)
library(ggridges)
library(WikidataQueryServiceR)
library(SPARQL)

## @knitr helperFunctions

# Obtains the full File Path
fullFilePath <- function(fileName)
{
  fileFolder <- "./"
  fileNamePath <- paste(fileFolder, fileName, sep = "")
  fileNamePath
}

# Converts column of Timestamps to Date
ttColToDate <- function(dFrame, colName) {
  dFrame[colName] <- as.POSIXct(dFrame[colName], origin="1970-01-01")
  dFrame
}

# Converts column to utf-8
toUtf8 <- function(column) {
  columnUtf8 <- iconv(enc2utf8(column), sub = "byte")
  columnUtf8
}

# Formats Data
fmt <- function(dt, caption = "") {
  fmt_dt <- dt %>%
    kable("latex", longtable = T, booktabs = T)
  fmt_dt
}

# Style Data
style <- function(dt, full_width = F, angle = 0) {
  style_dt <- dt %>%
    kable_styling(latex_options = "striped", full_width = full_width) %>%
    row_spec(0, angle = angle)
  style_dt
}

## @knitr loadUberTaxiData

taxiWeatherFile <- 'new-york-city-taxi-trip-hourly-weather.csv'
taxiWeatherData <- taxiWeatherFile %>%
  fullFilePath %>%
  read.csv(encoding = "UTF-8", header=TRUE, stringsAsFactors=FALSE)

#taxiWeatherData %>% summarize %>% fmt(caption = "New York City Taxi Data Summary") #%>% style(full_width = T, angle = 45)
taxiWeatherData %>% stat.desc %>% fmt(caption = "New York City Taxi Data Description") %>% style(full_width = T, angle = 45)

uberNycFile <- 'uber_nyc_enriched.csv'
uberNycData <- uberNycFile %>%
  fullFilePath %>%
  read.csv(encoding = "UTF-8", header=TRUE, stringsAsFactors=FALSE)

#uberNycData %>% summarize %>% fmt(caption = "Uber New York City Data Summary") %>% style(full_width = T, angle = 45)
uberNycData %>% stat.desc %>% fmt(caption = "Uber New York City Data Description") %>% style(full_width = T, angle = 45)


## @knitr loadData

# Run Sample Wikidata Query
wkdata <- query_wikidata('SELECT DISTINCT
               ?genre ?genreLabel
               WHERE {
               ?film wdt:P31 wd:Q11424.
               ?film rdfs:label "The Cabin in the Woods"@en.
               ?film wdt:P136 ?genre.
               SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
               }')

# Inspect the data
wkdata %>% head %>% fmt(caption = "SPARQL Results Head") %>% style(full_width = T)
wkdata %>% colnames %>% fmt(caption = "SPARQL Results Column Names") %>% style(full_width = T)

# Run a SPARQL query
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
df <- qd$results
df %>% head %>% fmt(caption = "SPARQL Results Head") %>% style(full_width = T)
df %>% colnames %>% fmt(caption = "SPARQL Results Column Names") %>% style(full_width = T)
