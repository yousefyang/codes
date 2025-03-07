###phylogentic tree based on root cognates (Matisoff 2009)
library(ape)
datam<-read.csv("C:\\Users\\Lenovo\\OneDrive\\SYSU\\Research\\Book\\sino-tibetan\\ST cognates.csv")
datam<-subset(datam, select=2:ncol(datam) )
rownames(datam)<-c("????????"  ,  "????????",
                   "????",
                   "原始??????",
                   "原始??伽",
                   "原始????",
                   "原始??芒",
                   "原始????",
                   "????",
                   "?良?",
                   "????",
                   "?瞎藕???","??-羌??","农-????","????支")
dist_obj=dist(datam, method="euclidean")
tree<-nj(dist_obj)

plot(tree)


#phylo tree of cultural traits
library(ape)
datam<-read.csv("C:\\Users\\ii\\Desktop\\genderval.csv", encoding = "UTF-8")

datam2<-subset(datam, select=2:ncol(datam) )
rownames(datam2)<-datam$X.U.FEFF.sheng

dist_obj=dist(datam2, method="euclidean")
tree<-nj(dist_obj)
plot(tree)
