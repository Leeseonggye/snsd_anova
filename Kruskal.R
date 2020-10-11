library(doBy)
library(dplyr)
library(lawstat)

snsd <- read.csv("D:/���� 17-2/�����ȹ��/����/SNSD.csv")
sper <- snsd[,c(13:21)]

#
percentage <- c()
song <- c()
member <- c()
for(i in 1:nrow(sper)){
  percentage <- c(percentage, sper[i,])
  song <- c(song, rep(i,ncol(sper)))
  member <- c(member, colnames(sper))
}

#����
data <- as.data.frame(cbind(percentage, song, member))
data$percentage <- as.numeric(as.character(data$percentage))
data$song <- as.character(data$song)
data$member <- unlist(data$member)

#���̸�
row.names(data) <- 1:nrow(data)

#����ī ������ ��/��
ss.without.jessica.idx <- c((which(is.na(data))[1]-8):nrow(data))

ss.without.jessica <- data[ss.without.jessica.idx,]
ss.without.jessica <- na.omit(ss.without.jessica)
ss.with.jessica <- data[-ss.without.jessica.idx,]

lm.out = lm(percentage~song+member+song:member, data = ss.with.jessica)
anova(lm.out)


##anova
ssmodel <- aov(percentage ~ member, data = ss.with.jessica)
summary(ssmodel)
TukeyHSD(ssmodel)
v1 <- TukeyHSD(ssmodel)$member
write.csv(v1, "D:/���� 17-2/�����ȹ��/����/����ī���������ĺм�.csv")


ssmodel <- aov(percentage ~ member, data = ss.without.jessica)
summary(ssmodel)
TukeyHSD(ssmodel)
v2 <- TukeyHSD(ssmodel)$member
write.csv(v2, "D:/���� 17-2/�����ȹ��/����/����ī���������ĺм�.csv")

#���Լ� ����
memberr <- unique(data$member)

#����ī ������ 
for(i in memberr){
  name <- i
  a <- ss.with.jessica %>% filter(member == i)
  print(name)
  print(shapiro.test(a$percentage))
}
#ȿ���� ���Լ� �ȵ���

#����ī ������
for(i in memberr[-length(memberr)]){
  name <- i
  a <- ss.without.jessica %>% filter(member == i)
  print(name)
  print(shapiro.test(a$percentage))
}

#��л꼺 ���� with mean
levene.test(ss.with.jessica$percentage, ss.with.jessica$member, location = "mean")
levene.test(ss.without.jessica$percentage, ss.without.jessica$member, location = "mean")

#��л꼺 ���� with median
levene.test(ss.with.jessica$percentage, ss.with.jessica$member, location = "median")
levene.test(ss.without.jessica$percentage, ss.without.jessica$member, location = "median")

#��������
kruskal.test(percentage~member,as.matrix.data.frame(ss.with.jessica))
kruskal.test(percentage~member,as.matrix.data.frame(ss.without.jessica))