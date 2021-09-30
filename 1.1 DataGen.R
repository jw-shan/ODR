
datagen <- function(SEED,n,p,s=4){
  set.seed(SEED)
  
  A = rbinom(n,1,0.5)
  x = matrix(rnorm(n*p),n,p)
  # x = cbind(rep(1,n),x)
  
  # beta  = c(runif(s,0.5,2)*sign(rnorm(s)), rep(0,p-s))
  # gamma = c(runif(s,0.5,2)*sign(rnorm(s)), rep(0,p-s))
  
  beta  = c(2,1,-1,2, rep(0,p-s))
  gamma = c(1,2,-2,-1, rep(0,p-s))
  
  Y1 = x[1]*x[2] + x%*%beta  + rnorm(n,sd=0.5)
  Y0 = x[1]*x[2] + rnorm(n,sd=0.5)
  Y  = A*(Y1) + (1-A)*Y0
  
  M1 = x[5]*x[6] + x%*%gamma + rnorm(n,sd=0.5)
  M0 = x[5]*x[6] + rnorm(n,sd=0.5)
  M  = A*(M1) + (1-A)*M0
  
  return(list(A=A,x=x,Y=Y,M=M,beta=beta,gamma=gamma))
  
  
}