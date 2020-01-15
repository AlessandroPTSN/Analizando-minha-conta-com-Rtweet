# Analizando-minha-conta-com-Rtweet
Fazendo uma análise descritiva dos meus twittes mais recentes usando o "get_timeline" do Rtweet

```R
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
```
![Rtwitter0](https://user-images.githubusercontent.com/50224653/72466816-67034880-37b8-11ea-9496-5ecd54e26399.png)

## Gráfico de pizza
```R
ggplot( source_table_2, aes(x = "", y = size, fill = Fonte)) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  ggtitle("          Por onde eu mais faço tweets")+
  coord_polar("y", start = 0)+
  geom_text(aes(y = position, label = percent), color = "Black")+
  scale_fill_brewer(palette = "Blues") +
  #scale_fill_manual(values = c("#1F65CC","#3686D3")) +
  theme_void()
```
![Rtwitter1](https://user-images.githubusercontent.com/50224653/72466817-67034880-37b8-11ea-99a5-6c3c58949455.png)

## Gráfico de linha
```R
ggplot(h, aes(x = created_at, y = favorite_count))+geom_line(size = 2,colour = "red")+
  xlab("Tempo")+
  ylab("Quantidade de Likes")+
  ggtitle("Quantidade de Likes a medida do tempo, em média 2.26 Likes")
```
![Rtwitter2](https://user-images.githubusercontent.com/50224653/72466813-666ab200-37b8-11ea-96b4-bacb3f6165b8.png)

## Gráfico de palavras
```R
wordcloud2(palavras, size = 0.7, color = "#1F65CC",backgroundColor = "grey")
#obs: recomendo dar uma olhada no código, isso foi o mais trabalhoso de ser feito
```
![Rtwitter3](https://user-images.githubusercontent.com/50224653/72466812-666ab200-37b8-11ea-924f-4a55e8089b2a.png)

## Gráfico de barras
```R
ggplot(data=retweet, aes(x=Fonte,y=percent,fill=factor(size))) +
  geom_bar(position="dodge",stat="identity")+
  scale_fill_manual(values = c("dodgerblue4","red3"))+
  xlab("")+
  ylab("Porcentagem")+
  ggtitle("Meus Retwittes")
```
![Rtwitter4](https://user-images.githubusercontent.com/50224653/72466814-67034880-37b8-11ea-8d7d-aa4fa3ea8128.png)
