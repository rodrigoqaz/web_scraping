web_scraping_infomoney_mercado <- function(url,path) {
  ## Copia e salva a página da internet:
  GET(url, httr::write_disk(path, overwrite = T))
  
  ## Seleciona apenas a div desejada:
  pagina_bruta <- "infomoney_mercado/ultimas-noticias.html" %>%
    read_html() %>%
    html_node(xpath = "/html/body/div[1]/div[1]/div[2]/div[3]/div[3]/div[1]/div[2]/div/div") %>%
    html_text()
  
  ## Converte em data frame:
  df_manchetes <-as.data.frame(str_split(gsub("\n", ";", pagina_bruta),";"))
  names(df_manchetes) <- "manchete"
  
  ## ajuste das datas e padronização:
  df_manchetes <- df_manchetes %>% 
    mutate(manchete = str_trim(manchete)) %>% 
    filter(manchete != "") %>% 
    mutate(data = as.POSIXct(paste(str_sub(manchete,1,12),gsub("h",":",str_sub(manchete,16,20)), sep = ' '), format="%d %b, %Y %H:%M"),
           data_aj = lead(data,1)) %>% 
    filter(is.na(data_aj) != T) %>% 
    select(data_aj, manchete)
  
  ## retorno o data frame:
  return(df_manchetes)
  
}
