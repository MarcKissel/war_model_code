https://www.datacamp.com/community/tutorials/scraping-javascript-generated-data-with-r



library(rvest)
library(stringr)
library(plyr)
library(dplyr)
library(ggvis)
library(knitr)
options(digits = 4)
#loaded file 
system("./phantomjs scrape_techstars.js")
batches <- html("techstars.html") %>%
  html_nodes(".batch")

class(batches)


#and this video https://www.youtube.com/watch?v=GayFRUUtHj4
#or https://gist.github.com/hrbrmstr/dc62bb2b35617e9badc5

#bewlos form video
#remember need phantomJS

url <- ("http://sdwebx.worldbank.org/climateportal/index.cfm?page=downscaled_data_download&menu=historical")
connection <- "TAS_data.js"

writeLines(sprintf("var page = require('webpage').create();
page.open('%s', function () {
    console.log(page.content); //page source
    phantom.exit();
});", url), con=connection)

 
system_input<- "C:/Users/kisselm/Documents/phantomjs TAS_data.js  > TAS_data.html"
system(system_input)

system("phantomjs TAS_data.js >TAS_data.html",  intern=TRUE)

#above not working since not wriitng 

#below is fomr the github gist linked above in a comment


write(readLines(pipe("phantomjs TAS_data.js", "r")), "TAS_data.html")

#above works!!!

html <- "TAS_data.html"
pg <- read_html(html)
table <- pg %>% html_nodes(xpath = "//table/td")
table <- pg %>% html_form()
system("TAS_data.js > scrape.html")



################################
#new way via https://www.rstudio.com/resources/videos/using-web-apis-from-r/
#and https://www.r-bloggers.com/accessing-apis-from-r-and-a-little-r-programming/
#and https://datahelpdesk.worldbank.org/knowledgebase/articles/902061-climate-data-api
#https://www.r-bloggers.com/accessing-apis-from-r-and-a-little-r-programming/
#https://www.programmableweb.com/news/how-to-access-any-restful-api-using-r-language/how-to/2017/07/21

library(httr)
#This package makes requesting data from just about any API easier by formatting your GET requests with the proper headers and authentications. Next, install jsonlite in your script:
library(jsonlite)
library(tidyverse)

#url <- "http://climatedataapi.worldbank.org/climateweb/rest/v1/country/mavg/tas/2020/2039/afg"
#path <- "eurlex/directory_code"


url <- "http://climatedataapi.worldbank.org"
path <- "climateweb/rest/v1/country/mavg/tas/2020/2039/afg"
####note: i dont think i need to sep URLL and PATH. i think can just do this
#url <- "http://climatedataapi.worldbank.org/climateweb/rest/v1/country/mavg/tas/2020/2039/afg
#and then
#raw.result <- GET(url = url)


#below is from rblogges
raw.result <- GET(url = url, path = path)
names(raw.result)
raw.result$status_code #200 = oit is workign
head(raw.result$content)
this.raw.content <- rawToChar(raw.result$content)
nchar(this.raw.content)
substr(this.raw.content, 1, 100)
this.content <- fromJSON(this.raw.content)
this.content
this.content[[1]] 

###helper function
content(raw.result, "text")

content(raw.result, "parse") #parses the data

###

#or
text_content <- content(raw.result, as = "text", encoding = "UTF-8")

# Parse with jsonlite
json_content <- text_content %>% fromJSON
json_content



######################

url <- "http://sdwebx.worldbank.org/climateportal/index.cfm?page=downscaled_data_download&menu=historical"

d1 <- GET(url = url)
d1
content(d1, "parse")

#
page <- read_html("http://sdwebx.worldbank.org/climateportal/index.cfm?page=downscaled_data_download&menu=historical")
p1 <- page %>% html_nodes("#country")
View(p1)
p1[[1]]
