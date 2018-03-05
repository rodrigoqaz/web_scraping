library(tidyverse)
library(httr)
library(xml2)
library(rvest)
source("fun_scrapers.R")

# Download da homepage
url <- "http://www.infomoney.com.br/mercados/ultimas-noticias"
path <- "infomoney_mercado/ultimas-noticias.html"
df_infomoney_mercado <- web_scraping_infomoney_mercado(url,path)

# Download das próximas páginas:
for (i in 2:14){
  print(paste0("Extraindo página ",i))
  url <- paste0("http://www.infomoney.com.br/mercados/ultimas-noticias/pagina/",i)
  temp <- web_scraping_infomoney_mercado(url,path)
  df_infomoney_mercado <- rbind(df_infomoney_mercado,temp)
  rm(temp)
}
