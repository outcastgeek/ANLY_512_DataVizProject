## @knitr installLibraries

install.packages("knitr")
install.packages("kableExtra")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("pastecs")
install.packages("haven")
install.packages("ggridges")
install.packages("lubridate")
install.packages("WikidataQueryServiceR")
install.packages("SPARQL")

## @knitr loadLibraries

library(ggplot2)
library(dplyr)
library(pastecs)
library(haven)
library(ggridges)
library(lubridate)
library(WikidataQueryServiceR)
library(SPARQL)
require(scales)

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
  read.csv(encoding = "UTF-8", header=TRUE, stringsAsFactors=FALSE) %>%
  mutate(DATE = pickup_datetime %>% as.Date()) %>%
  #filter("2015" == DATE %>% year()) %>%
  group_by(DATE) %>%
  mutate(taxi_rides = n())

#taxiWeatherData %>% summarize %>% fmt(caption = "New York City Taxi Data Summary") #%>% style(full_width = T, angle = 45)
taxiWeatherData %>% stat.desc %>% fmt(caption = "New York City Taxi Data Description") %>% style(full_width = T, angle = 45)

uberNycFile <- 'uber_nyc_enriched.csv'
uberNycData <- uberNycFile %>%
  fullFilePath %>%
  read.csv(encoding = "UTF-8", header=TRUE, stringsAsFactors=FALSE) %>%
  mutate(DATE = pickup_dt %>% as.Date()) %>%
  group_by(DATE) %>%
  mutate(uber_rides = n())

#uberNycData %>% summarize %>% fmt(caption = "Uber New York City Data Summary") %>% style(full_width = T, angle = 45)
uberNycData %>% stat.desc %>% fmt(caption = "Uber New York City Data Description") %>% style(full_width = T, angle = 45)

#taxiUberRidesData <- taxiWeatherData %>%
#  full_join(., uberNycData) %>%
#  group_by(DATE) %>%
#  filter(row_number()==1) %>%
#  select(DATE, taxi_rides, uber_rides)

taxiRidesData <- taxiWeatherData %>%
  mutate(
    YEAR = DATE %>% year(),
    MONTH = DATE %>% month(label = TRUE),
    SEASON = ifelse(DATE %>% month() %in% c(9, 10, 11), "FALL",
                    ifelse(DATE %>% month() %in% c(12, 1, 2), "WINTER",
                           ifelse(DATE %>% month() %in% c(3, 4, 5), "SPRING", "SUMMER")))
  ) %>%
  group_by(MONTH) %>%
  mutate(MONTH_YEAR = paste(MONTH, " ", YEAR), taxi_monthly_rides = sum(taxi_rides)) %>%
  filter(row_number()==1) %>%
  select(MONTH_YEAR, taxi_monthly_rides, SEASON)

uberRidesData <- uberNycData %>%
  mutate(
    YEAR = DATE %>% year(),
    MONTH = DATE %>% month(label = TRUE),
    SEASON = ifelse(DATE %>% month() %in% c(9, 10, 11), "FALL",
                    ifelse(DATE %>% month() %in% c(12, 1, 2), "WINTER",
                           ifelse(DATE %>% month() %in% c(3, 4, 5), "SPRING", "SUMMER")))
    ) %>%
  group_by(MONTH) %>%
  mutate(MONTH_YEAR = paste(MONTH, " ", YEAR), uber_monthly_rides = sum(uber_rides)) %>%
  filter(row_number()==1) %>%
  select(MONTH_YEAR, uber_monthly_rides, SEASON)

## @knitr pickupsTaxiUber

ggplot(taxiRidesData, aes(x = MONTH_YEAR, y = taxi_monthly_rides, fill=SEASON)) +
  geom_bar(stat="identity") +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  ggtitle("Taxi Rides 2015 - 2017")

ggplot(uberRidesData, aes(x = MONTH_YEAR, y = uber_monthly_rides, fill=SEASON)) +
  geom_bar(stat="identity") +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  ggtitle("Uber Rides 2015")


