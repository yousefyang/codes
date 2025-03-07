library(networkreporting)
surname<-c("zhu","wu","liu","sun","yang","zhou","zheng")   #these are estimates for known populations, labels have to be same as in dataset. In this study, these known populations are people with different Chinese surnames.
totpu<-c(66,88,232,64,94,79,39)  ##total size of the above surnames in the population, which is the sampled University.
knownpop<-data.frame(surname, totpu)
kp.vec <- df.to.kpvec(knownpop, kp.var = "surname", kp.value = "totpu")  #this converts the data frame to a vector of known populations
dat<-read.csv("xxxxxx")  ##read the dataset

#the codes below calculate network degrees
d.hat<-kp.degree.estimator(survey.data = dat,known.popns = kp.vec, total.popn.size = 4117,missing="ignore")  ##total.popn.size is the size of your target population, which in this case is the total size of the Chinese population at the sampled University.
d.hat[which(d.hat[]==0)]<-5  #manually recode to require that none has zero acquaintance. Everybody should have at least 5 acquaintance (realistically speaking)
dat$degree<-d.hat   #attach the calculated network degree back to the full dataset for subsequent analysis
library(ggplot2)
qplot(d.hat,binwidth=15,xlab="network degree")
validcheck<-nsum.internal.validation(survey.data = dat, known.popns = kp.vec, total.popn.size = 4117,
                                     missing="complete.obs",kp.method=T,killworth.se = T, return.plot=T)
validcheck$results
validcheck$plot   #liu is an inaccurate estimate. This reproduces the first graph in figure 1

#if exclude liu:
surname<-c("zhu","wu","sun","yang","zhou","zheng")
totpu<-c(66,88,64,94,79,39)
knownpop<-data.frame(surname, totpu)
kp.vec <- df.to.kpvec(knownpop, kp.var = "surname", kp.value = "totpu")
d.hat<-kp.degree.estimator(survey.data = dat,known.popns = kp.vec, total.popn.size = 4117,missing="ignore")
d.hat[which(d.hat[]==0)]<-5  #none has zero alter, at least 5
dat$degree<-d.hat
validcheck<-nsum.internal.validation(survey.data = dat, known.popns = kp.vec, total.popn.size = 4117,
                                     missing="complete.obs",kp.method=T,killworth.se = T, return.plot=T)
validcheck$plot    #this reproduces the second graph of figure 1

#calculate the classic network scale-up method estimates. This reproduces the classic estimates in table 3.
xsize<-nsum.estimator(survey.data=dat, d.hat.vals=d.hat, y.vals="christians", total.popn.size = 4117,
                      missing="complete.obs")
busize<-nsum.estimator(survey.data=dat, d.hat.vals=d.hat, y.vals="buddhists", total.popn.size = 4117,
                       missing="complete.obs")

##estimate the variance with bootstrap resampling. Specify your own weights.
library(surveybootstrap)
xboot<-bootstrap.estimates(survey.design =~1, num.reps=300, estimator.fn="nsum.estimator",
                           bootstrap.fn="rescaled.bootstrap.sample", weights="totwt",
                           d.hat.vals="degree", total.popn.size=4117,y.vals="christians",survey.data=dat,missing="complete.obs")
buboot<-bootstrap.estimates(survey.design =~1, num.reps=300, estimator.fn="nsum.estimator",
                            bootstrap.fn="rescaled.bootstrap.sample", weights="burhowt", tx.rate=.33,
                            d.hat.vals=d.hat, total.popn.size=4117,y.vals="buddhists",survey.data=dat,missing="complete.obs")