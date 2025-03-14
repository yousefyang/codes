###phylogentic tree using "ape" package
library(ape)
datam<-read.csv("")  #the address is your raw data
datam<-subset(datam, select=1:ncol(datam) )   #assuming your first variable is names of the cases, else you starts with column 1
rownames(datam)<-datam$X   #apply to rownames by the first variable in dataset which is labels, or user created vector of labels.

dist_obj=dist(datam, method="euclidean")    #some methods do not allow non-integer
tree<-nj(dist_obj)
plot(tree)
