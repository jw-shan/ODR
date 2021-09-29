


# nodewise lasso
## This function returns the estimation of Theta (the "ind"-th row of Theta)

nodewise <- function(ind,x){
  n = dim(x)[1]
  p = dim(x)[2]
  k = length(ind)
  C.hat = matrix(nrow = k, ncol = p)
  
  for (i in 1:k) {
    cv = cv.glmnet(x[,-ind[i]],x[,ind[i]])
    gamma.hat = coef(cv)[-1]
    C.hat[i,ind[i]] = 1
    C.hat[i,-ind[i]] = -gamma.hat
    tau.hat.square = sum((x[,ind[i]] - x[,-ind[i]]%*%gamma.hat)^2)/n + cv$lambda.1se*sum(abs(gamma.hat))
    C.hat[i,] = C.hat[i,]/tau.hat.square
  }
  
  return(C.hat)
  
}
