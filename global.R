library(shiny)

pkgs <- c("markdown","devtools","ggplot2")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")

library(markdown)
library(devtools)
library(ggplot2)

if(!("rCharts" %in% installed.packages()[,"Package"])) install_github("rCharts","ramnathv")
library(rCharts)

load("data.RData")
