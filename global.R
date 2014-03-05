library(shiny)
pkgs <- c("rCharts")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(rCharts)

load("data.RData")
