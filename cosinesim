install.packages("lsa")
library(lsa)
data <- read.csv(file = 'tocharvec.csv')
data1 <- read.csv(file = 'tocharvecc.csv')
data1 <- data1$tokens_

matA <- data.matrix(data)
v <- c(split(matA, rep(1:ncol(matA), each = nrow(matA))))

matB <- matrix(, nrow = length(v), ncol = length(v))
for (i in seq(1, length(v), 1)){
  for (j in seq(1, length(v), 1)){
    matB[i,j] <- cosine(v[[i]], v[[j]])
  }
}

for (i in seq(1, length(v), 1)){
  for (j in seq(1, length(v), 1)){
    if (matB[i,j] > 0.9){
      data1[i] <- data1[j]
    } 
  }
}

data1 <- unique(data1)
