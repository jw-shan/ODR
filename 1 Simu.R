rm(list=ls())

library(glmnet)
library(parallel)

source("1.1 DataGen.R")
source("1.2 MyFun.R")


# configure parallel environment
ncores = detectCores()
if (ncores<32) {
  cl = makeCluster(ncores)
}else{
  cl = makeCluster(32)
}
clusterExport(cl,c("cv.glmnet"))


# generate data
SEED = 2021
N = 100
p = 1000

data = datagen(SEED,N,p)

A=data$A
x=data$x
Y=data$Y
M=data$M


# run lasso 
cv.lamb = cv.glmnet(x,Y)
beta.lasso = as.vector(coef(cv.lamb)[-1])


# run debiased lasso
Theta.hat = t(parSapply(cl,1:p,nodewise,x))
beta.hat = beta.lasso + as.vector(Theta.hat%*%t(x)%*%(Y-x%*%beta.lasso)/N)


# Group for test
G = 1

# estimates of covariance
phi.i = as.vector( t(t(Theta.hat)[,G]) %*% t(x) %*% (Y-x%*%beta.hat) ) 
Sigma.E.hat = outer(phi.i,phi.i)/N

H0.value = sqrt(N)*beta.hat[G]/sqrt(Sigma.E.hat)
p.value = min(pnorm(H0.value), 1-pnorm(H0.value))





stopCluster(cl)





