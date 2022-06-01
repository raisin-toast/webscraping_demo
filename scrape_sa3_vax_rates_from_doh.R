library(polite)
library(rvest)
library(tidyverse)
library(lubridate)
library(readxl)

website <- "https://www.health.gov.au/resources/collections/covid-19-vaccination-geographic-vaccination-rates-sa3#may-2022"

session <-  polite::bow(website)

dates <- scrape(session) %>% 
  html_nodes(".date-display-single") %>% 
  html_text()


url <- tibble(dates) %>% 
  mutate(dates = lubridate::dmy(dates), 
         year = lubridate::year(dates), 
         month = str_pad(as.character(month(dates)), width = 2, pad = "0", side = "left"), 
         dates = str_to_lower(format(dates, "%d-%b-%Y")), 
         url = glue::glue("https://www.health.gov.au/sites/default/files/documents/{year}/{month}/covid-19-vaccination-geographic-vaccination-rates-sa3-{dates}.xlsx"), 
         dest_file = "output/vax_sa3_sheets/{dates}.xlsx") 

download_clean_sa3_data <- function(url, date) {
  download.file(url,  destfile = "output/vax_sa3_sheets/test.xlsx", mode = "wb")
  
  read_excel("output/vax_sa3_sheets/test.xlsx") %>% 
    janitor::clean_names() %>% glimpse()
}