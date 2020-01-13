library(twitteR)
library(XML)
library(twitteR) 
# Mude consumer_key, consume_secret, access_token, e 
# access_secret baseado nas suas propias chaves
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)



####################################################################################################################

#obentdo meus dados
cran_tweets <- userTimeline('Alessandroptsn')
cran_tweets
cran_tweets=twListToDF(cran_tweets)

cran_tweets$statusSource=gsub("</a>", "", cran_tweets$statusSource)
cran_tweets$statusSource=strsplit(cran_tweets$statusSource, ">")
cran_tweets$statusSource=sapply(cran_tweets$statusSource, function(x) ifelse(length(x) > 1, x[2], x[1]))
table(cran_tweets$statusSource)

source_table=table(cran_tweets$statusSource)


#tendo uma vista previa do grafico
pie(source_table)

#arrumando a tabela 
source_table = source_table
source_table_2 <- 
  dplyr::tibble(
    Fonte = names(source_table),
    size = source_table
  ) %>%
  dplyr::arrange(desc(size)) %>%
  dplyr::slice(1:10)

#melhorando a tabela
source_table_2
source_table_2$percent =  round((source_table_2$size)/sum(source_table_2$size),2)

library(ggplot2)

#adicionando a posição da %
source_table_2 <-  source_table_2%>%
  arrange(desc(Fonte)) %>%
  mutate(position = cumsum(size) - 0.5*size)
source_table_2

#gráfico de pizza
ggplot( source_table_2, aes(x = "", y = size, fill = Fonte)) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  ggtitle("          Por onde eu mais faço tweets")+
  coord_polar("y", start = 0)+
  geom_text(aes(y = position, label = percent), color = "Black")+
  #scale_fill_brewer(palette = "Blues") +
  scale_fill_manual(values = c("#1F65CC","#3686D3")) +
  theme_void()


####################################################################################################################
#criando o gráfico de linha

library(chron)
library(stringr)
cran_tweets$created=str_sub(cran_tweets$created, end = 10)
cran_tweets$created=as.Date(cran_tweets$created)

ggplot(cran_tweets, aes(x = created, y = favoriteCount))+geom_line(size = 2,colour = "red")+
  xlab("Tempo")+
  ylab("Quantidade de Likes")+
  ggtitle("Quantidade de Likes a medida do tempo, em média 3 Likes")


mean(cran_tweets$favoriteCount)

####################################################################################################################
#gráfico de palavras

library(readtext)
library(tm)
library(ggplot2)
library(reshape2)
# Manipulacao eficiente de dados
library(tidyverse)
# Manipulacao eficiente de texto
library(tidytext)
# Leitura de pdf para texto
library(textreadr)
# Pacote de mineracao de texto com stopwords 
library(tm)
# Grafico nuvem de palavras
library(wordcloud)
library("tidytext")
library("stopwords")

texto <- scan("stopwords.txt", what="char", sep="\n", encoding = "UTF-8")
stop <- tolower(texto)




H=unlist(cran_tweets$text)

stopwords_regex = paste(stop, collapse = '\\b|\\b')
stopwords_regex = paste0('\\b', stopwords_regex, '\\b')
documents = stringr::str_replace_all(H, stopwords_regex, '')
H=documents


NormalizaParaTextMining <- function(texto){
  # Normaliza texto
  texto %>% 
    chartr(
      old = "(),´`^~¨:.!?&$@#0123456789",
      new = "                          ",
      x = .) %>% # Elimina acentos e caracteres desnecessarios
    str_squish() %>% # Elimina espacos excedentes 
    tolower() %>% # Converte para minusculo
    return() # Retorno da funcao
}
H=NormalizaParaTextMining(H)
H


texto <- tolower(H)

lista_palavras <- strsplit(texto, "\\W+")
vetor_palavras <- unlist(lista_palavras)

frequencia_palavras <- table(vetor_palavras)
frequencia_ordenada_palavras <- sort(frequencia_palavras, decreasing=TRUE)

palavras <- paste(names(frequencia_ordenada_palavras), frequencia_ordenada_palavras, sep=";")

cat("Palavra;Frequencia", palavras, file="frequencias.csv", sep="\n") 

palavras = read.csv("frequencias.csv", sep=";")

# library
library(wordcloud2) 

# Nuvem de palavras
wordcloud2(palavras, size = 0.7, color = "#1F65CC",backgroundColor = "grey")



####################################################################################################################
#Gráfico de barras mostrando os tweets "truncados"

#melhorando a tabela
trunctable2 <- 
  dplyr::tibble(
    name = names(trunctable),
    size = trunctable
  ) %>%
  dplyr::arrange(desc(size)) %>%
  dplyr::slice(1:10)
trunctable2$percent =  round((trunctable2$size)/sum(trunctable2$size),2)
#mostrando a tabela
trunctable2

#fazendo o Gráfico
ggplot(data=trunctable2, aes(x=name,y=percent,fill=factor(size))) +
  geom_bar(position="dodge",stat="identity")+
  scale_fill_manual(values = c("dodgerblue4","red3"))+
  xlab("")+
  ylab("Porcentagem")+
  ggtitle("Twittes truncados (Respostas em Twittes)")

####################################################################################################################
