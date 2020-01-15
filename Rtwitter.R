library(rtweet)

# Mude consumer_key, consume_secret, access_token, e 
# access_secret baseado nas suas propias chaves
token <- create_token(
  app = "Hi",
  consumer_key = consumer_key,
  consumer_secret = consumer_secret,
  access_token = access_token,
  access_secret = access_secret)



h=get_timeline("Alessandroptsn",n=500)

names(h)


####################################################################################################################
#criando o gráfico de pizza

source_table=h$source[h$source!="SumAll"]
source_table=source_table[source_table!="Twitter Web Client" ]
source_table=table(source_table)


#tendo uma vista previa do grafico
pie(source_table)

library(dplyr)
#arrumando a tabela 

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
source_table_2

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
  scale_fill_brewer(palette = "Blues") +
  #scale_fill_manual(values = c("#1F65CC","#3686D3")) +
  theme_void()


####################################################################################################################
#criando o gráfico de linha

library(chron)
library(stringr)
names(h)
h$created_at
h$created_at=str_sub(h$created_at, end = 10)
h$created_at=as.Date(h$created_at)

ggplot(h, aes(x = created_at, y = favorite_count))+geom_line(size = 2,colour = "red")+
  xlab("Tempo")+
  ylab("Quantidade de Likes")+
  ggtitle("Quantidade de Likes a medida do tempo, em média 2.26 Likes")


mean(h$favorite_count)

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




H=unlist(h$text)

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
#Gráfico de barras mostrando os Retweets

isretweet=table(h$is_retweet)

#arrumando a tabela 

retweet <- 
  dplyr::tibble(
    Fonte = names(isretweet),
    size = isretweet
  ) %>%
  dplyr::arrange(desc(size)) %>%
  dplyr::slice(1:10)

#melhorando a tabela
retweet$percent =  round((retweet$size)/sum(retweet$size),2)


#mostrando a tabela
retweet

#fazendo o Gráfico
ggplot(data=retweet, aes(x=Fonte,y=percent,fill=factor(size))) +
  geom_bar(position="dodge",stat="identity")+
  scale_fill_manual(values = c("dodgerblue4","red3"))+
  xlab("")+
  ylab("Porcentagem")+
  ggtitle("Meus Retwittes")

####################################################################################################################
