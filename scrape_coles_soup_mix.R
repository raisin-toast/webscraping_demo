library(polite)
library(rvest)
library(tidyverse)
library(lubridate)
library(RSelenium)

# pull down the docker container and give a name
system("docker run -d --name my_container -p 4445:4444 selenium/standalone-chrome:2.53.0")

# check it is running
system("docker ps")

# get your remote driver set up and ready to go
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "chrome"
)

remDr$open()
remDr$getStatus()

website <- "https://shop.coles.com.au/a/national/everything/search/soup%20mix?pageNumber=1"

remDr$navigate(website) 

html <- remDr$getPageSource()[[1]]

html %>%
  read_html() %>%
  html_elements(".product-pricing-info") %>%
  html_text() %>% 
  parse_number()

html %>%
  read_html() %>%
  html_elements("span.price-container") %>%
  html_text() %>% 
  parse_number()

dollar <- html %>%
  read_html() %>%
  html_elements("span.dollar-value") %>%
  html_text() 

cent <- html %>%
  read_html() %>%
  html_elements(".cent-value") %>%
  html_text() 

remDr$close()

system("docker stop my_container")

system("docker rm my_container")
