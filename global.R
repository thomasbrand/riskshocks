library(rCharts)
library(shiny)
library(markdown)

#obsnames_nocumul<-c('hours','interestrate','premium','spread','deficit')
#obsnames_cumul<-subset(obsnames,!(obsnames %in% obsnames_nocumul))

load("data.RData")

#setwd("C:/Users/brand/Dropbox/github/riskshocks")
#Sys.setlocale("LC_TIME", "English_United States.1252")
#library(shinyapps)
#deployApp()
#library(devtools)
#install_github('rstudio/shinyapps')
#shinyapps::setAccountInfo(name="thomasbrand", token="A5423C2D9F81113EC9CC5584376AE53C", secret="MWceSmPODbrxiAXADNTAqEn+R8PCCFZFHFL9fzZP")
#devtools::install_github('rstudio/rscrypt')
