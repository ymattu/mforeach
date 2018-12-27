---
title: "mforeach - Easy to parallel processing in R -fix ver-"
author: "Yuya MATSUMURA"
output:
  html_document:
    keep_md: yes
---



## Overview

There is a parallel processing code using the `foreach` package:


```r
library(doParallel)
cl <- makeCluster(detectCores())
registerDoParallel(cl)
foreach(i = 1:3, .combine=c) %dopar% {
  i**2
}
stopCluster(cl)
```


```
## [1] 1 4 9
```

It can be simplified using `pforeach()` instead of `foreach()`:


```r
library(pforeach)
pforeach(i = 1:3)({
  i**2
})
```

```
## [1] 1 4 9
```

## How to install


```r
install.packages("devtools") # if you have not installed "devtools" package
devtools::install_github("hoxo-m/pforeach")
```

## To simplify!

### With other packages

Using `foreach()`:


```r
library(doParallel)
library(dplyr) # With other package
cl <- makeCluster(detectCores())
registerDoParallel(cl)
# You must indicate .packages parameter.
foreach(i = 1:3, .combine=c, .packages="dplyr") %dopar% {
  iris[i, ] %>% select(-Species) %>% sum
}
stopCluster(cl)
```


```
## [1] 10.2  9.5  9.4
```

Using `pforeach()`:


```r
library(pforeach)
library(dplyr) # With other package
# You need not to mind that.
pforeach(i = 1:3)({
  iris[i, ] %>% select(-Species) %>% sum
})
```

```
## [1] 10.2  9.5  9.4
```

### With enclosed variables

Using `foreach()`:


```r
# You must indicate .export parameter. 
library(doParallel)
square <- function(x) x**2
execute <- function() {
  cl <- makeCluster(detectCores())
  registerDoParallel(cl)
  result <- foreach(i = 1:3, .combine=c, .export="square") %dopar% {
    square(i)
  }
  stopCluster(cl)
  result
}
execute()
```

```
## [1] 1 4 9
```

Using `pforeach()`:


```r
# Need not to mind!
library(pforeach)
square <- function(x) x**2
execute <- function() {
  pforeach(i = 1:3)({
    square(i)
  })
}
execute()
```

```
## [1] 1 4 9
```

### Rows and Columns

Iterations for data frame can simplify using `rows()` and `cols()` instead of `iterators::iter()`.

Using `iter()`:


```r
library(doParallel)
cl <- makeCluster(detectCores())
registerDoParallel(cl)
data <- iris[1:5, ]
foreach(row = iter(data, by="row"), .combine=c) %dopar% {
  sum(row[-5])
}
stopCluster(cl)
```


```
## [1] 10.2  9.5  9.4  9.4 10.2
```

Using `rows()`:


```r
library(pforeach)
data <- iris[1:5, ]
pforeach(row = rows(data))({
  sum(row[-5])
})
```

```
## [1] 10.2  9.5  9.4  9.4 10.2
```

Using `cols()`:


```r
library(pforeach)
data <- iris[, 1:4]
pforeach(col = cols(data))({
  mean(col)
})
```

```
## [1] 5.843333 3.057333 3.758000 1.199333
```

## Options

### Cores

You can indicate number of cores for parallel processing with `.cores` parameter.


```r
pforeach(i = 1:3, .cores = 2)({
  i**2
})
```

If you set minus value to `.cores` for example `.cores = -1`, it means `.cores = detectCores() - 1`.


```r
pforeach(i = 1:3, .cores = -1)({
  i**2
})
```

### Fix random seed

If you want to fix random seed, set `.seed` parameter:


```r
library(pforeach)
pforeach(i = 1:3, .seed = 12345)({
  rnorm(1)
})
```


```
## [1]  0.74543208 -0.06047583 -0.40346641
```

### Do not parallel

If you want to change a parallel code to the non-parallel code with `pforeach`, you just only add one character "n".


```r
library(pforeach)
npforeach(i = 1:3)({
  i**2
})
```

```
## [1] 1 4 9
```

## Application

Parallelized random forest code with `foreach` is below:


```r
library(doParallel)
library(randomForest)
library(kernlab)
data(spam)
cores <- detectCores()
cl <- makePSOCKcluster(cores)
registerDoParallel(cl)
fit.rf <- foreach(ntree=rep(250, cores), .combine=combine, 
                  .export="spam", .packages="randomForest") %dopar% {
  randomForest(type ~ ., data = spam, ntree = ntree)
}
stopCluster(cl)
```

Using `pforeach`:


```r
library(pforeach)
library(randomForest)
library(kernlab)
data(spam)
fit.rf <- pforeach(ntree=rep(250, .cores), .c=combine)({
  randomForest(type ~ ., data = spam, ntree = ntree)
})
```
