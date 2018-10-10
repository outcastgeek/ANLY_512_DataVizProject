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
