library(rCharts)
library(shiny)
#library(markdown)

#obsnames_nocumul<-c('hours','interestrate','premium','spread','deficit')
#obsnames_cumul<-subset(obsnames,!(obsnames %in% obsnames_nocumul))

# library(shiny)
# pkgs <- c("reshape2","raster","maps","maptools")
# pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
# if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
# load("qm.RData", envir=.GlobalEnv)
# library(reshape2); library(raster); library(maps); library(maptools)

load("data.RData")

#setwd("C:/Users/brand/Dropbox/github/riskshocks")

#Sys.setlocale("LC_TIME", "English_United States.1252")
#library(shinyapps)
#deployApp()
#library(devtools)
#install_github('rstudio/shinyapps')
#shinyapps::setAccountInfo(name="thomasbrand", token="A5423C2D9F81113EC9CC5584376AE53C", secret="MWceSmPODbrxiAXADNTAqEn+R8PCCFZFHFL9fzZP")
#devtools::install_github('rstudio/rscrypt')

# This figure shows la simulation du déficit public total lorsque cette variable n'est pas incluse parmi les observables dans le cas américain.
# Si la série simulée est différente de la série observée, il est préférable d'inclure cette variable parmi les observables pour identifier les mécanismes de la politique budgétaire.
# Ces mécanismes pourront être utilisés dans les simulations contrefactuelles.
# Si la série simulée est proche de la série observée, nous avons perdu beaucoup de temps.