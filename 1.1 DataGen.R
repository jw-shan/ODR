
datagen <- function(SEED,n,p,s=4){
  set.seed(SEED)
  
  A = rbinom(n,1,0.5)
  x = matrix(rnorm(n*p),n,p)
  # x = cbind(rep(1,n),x)
  
  # beta  = c(runif(s,0.5,2)*sign(rnorm(s)), rep(0,p-s))
  # gamma = c(runif(s,0.5,2)*sign(rnorm(s)), rep(0,p-s))
  
  beta  = c(1,0.5,-0.5,1, rep(0,p-s))
  gamma = c(0.5,1,-1,-2, rep(0,p-s))
  
  Y = x%*%beta  + rnorm(n,sd=0.5)
  M = x%*%gamma + rnorm(n,sd=0.5)
  
  return(list(A=A,x=x,Y=Y,M=M,beta=beta,gamma=gamma))
  
  
}