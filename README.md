# Analizando-minha-conta-com-twitteR
Fazendo uma análise descritiva dos meus twittes mais recentes usando o "userTimeline" do twitteR

```R
library(twitteR)
library(XML)
library(twitteR) 
# Mude consumer_key, consume_secret, access_token, e
# access_secret baseado nas suas propias chaves
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

#obentdo meus dados
cran_tweets <- userTimeline('Alessandroptsn')
cran_tweets <- twListToDF(cran_tweets)
cran_tweets
```

## Gráfico de pizza
```R
ggplot( source_table_2, aes(x = "", y = size, fill = Fonte)) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  ggtitle("          Por onde eu mais faço tweets")+
  coord_polar("y", start = 0)+
  geom_text(aes(y = position, label = percent), color = "Black")+
  scale_fill_manual(values = c("#1F65CC","#3686D3")) +
  theme_void()
```
![Alessandro_Twitter1](https://user-images.githubusercontent.com/50224653/72296271-fdf4c700-3637-11ea-8186-434268235d51.png)

## Gráfico de linha
```R
ggplot(cran_tweets, aes(x = created, y = favoriteCount))+geom_line(size = 2,colour = "red")+
  xlab("Tempo")+
  ylab("Quantidade de Likes")+
  ggtitle("Quantidade de Likes a medida do tempo, em média 3 Likes")
```
![Alessandro_Twitter2](https://user-images.githubusercontent.com/50224653/72296272-fdf4c700-3637-11ea-85d8-d035fa2a8943.png)

## Gráfico de palavras
```R
wordcloud2(palavras, size = 0.7, color = "#1F65CC",backgroundColor = "grey")
#obs: recomendo dar uma olhada no código, isso foi o mais trabalhoso de ser feito
```
![Alessandro_Twitter3](https://user-images.githubusercontent.com/50224653/72296269-fdf4c700-3637-11ea-829b-45a75263fc69.png)

## Gráfico de barras
```R
ggplot(data=trunctable2, aes(x=name,y=percent,fill=factor(size))) +
  geom_bar(position="dodge",stat="identity")+
  scale_fill_manual(values = c("dodgerblue4","red3"))+
  xlab("")+
  ylab("Porcentagem")+
  ggtitle("Twittes truncados (Respostas em Twittes)")
```
![Alessandro_Twitter4](https://user-images.githubusercontent.com/50224653/72296270-fdf4c700-3637-11ea-9978-1a86a6113517.png)
