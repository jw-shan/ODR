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
p  = 300
N1 = 100
N2 = 100
N  = N1 + N2


## primary data
data1 = datagen(SEED,N1,p)

A1=data1$A
x1=data1$x
Y1=data1$Y
M1=data1$M
Y1.tilde = 2*(2*A1-1)*Y1
M1.tilde = 2*(2*A1-1)*M1

# Auxiliary data
data2 = datagen(SEED+100,N2,p)

A2=data2$A
x2=data2$x
M2=data2$M
M2.tilde = 2*(2*A2-1)*M2



# run lasso 
cv.lasso = cv.glmnet(x1,Y1.tilde)
beta.lasso = as.vector(coef(cv.lasso)[-1])


# run debiased lasso
Theta.hat = t(parSapply(cl,1:p,nodewise,rbind(x1,x2)))  # we use all data to estimate Theta
beta.hat = beta.lasso + as.vector(Theta.hat%*%t(x1)%*%(Y1.tilde-x1%*%beta.lasso)/N1)


# Group for test
G = 1

# estimates of covariance
Sigma.E.hat =  t(t(Theta.hat)[,G]) %*% t(x1) %*% diag(as.vector(Y1.tilde-x1%*%beta.hat)) %*% diag(as.vector(Y1.tilde-x1%*%beta.hat)) %*% x1 %*% t(Theta.hat)[,G] / N1


H0.value = sqrt(N1)*beta.hat[G]/sqrt(Sigma.E.hat)
p.value = min(pnorm(H0.value), 1-pnorm(H0.value))
p.value



# ----------------------------------------------
#  Use secondary outcome to reduce variance
# ----------------------------------------------

# combine two sources of data
x = rbind(x1,x2)
M = rbind(M1.tilde,M2.tilde)


# firstly use all data to fit gamma
cv.lasso = cv.glmnet(x,M)
gamma.lasso = as.vector(coef(cv.lasso)[-1])
gamma.hat = gamma.lasso + as.vector(Theta.hat%*%t(x)%*%(M-x%*%gamma.lasso)/N)

# secondly use primary data to fit gamma.E
cv.lasso = cv.glmnet(x1,M1.tilde)
gamma.E.lasso = as.vector(coef(cv.lasso)[-1])
gamma.E.hat = gamma.E.lasso + as.vector(Theta.hat%*%t(x1)%*%(M1.tilde-x1%*%gamma.E.lasso)/N1)


# estimates of variance and covariance matrix
Sigma.M.hat   = (1-N1/N) * t(t(Theta.hat)[,G]) %*% t(x) %*% diag(as.vector(M-x%*%gamma.hat)) %*% diag(as.vector(M-x%*%gamma.hat)) %*% x %*%  t(Theta.hat)[,G] / N
Sigma.rho.hat = (1-N1/N) * t(t(Theta.hat)[,G]) %*% t(x1) %*% diag(as.vector(M1.tilde-x1%*%gamma.E.hat)) %*% diag(as.vector(Y1.tilde-x1%*%beta.hat)) %*% x1 %*%  t(Theta.hat)[,G] / N1


# construct projection
beta.tilde = beta.hat[G] - as.vector(t(Sigma.rho.hat) %*% solve(Sigma.M.hat, gamma.hat[G]-gamma.E.hat[G]))

H0.value = sqrt(N1)*beta.tilde/sqrt(Sigma.E.hat - Sigma.rho.hat*solve(Sigma.M.hat,Sigma.rho.hat))
p.value = min(pnorm(H0.value), 1-pnorm(H0.value))
p.value





stopCluster(cl)





