library(shiny)

pkgs <- c("markdown","devtools","ggplot2","knitr")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")

library(knitr)
library(markdown)
library(devtools)
library(ggplot2)

if(!("rCharts" %in% installed.packages()[,"Package"])) install_github("rCharts","ramnathv")
library(rCharts)

load("data.RData")

helpPopup <- function(title, content,
                      placement=c('right', 'top', 'left', 'bottom'),
                      trigger=c('focus', 'hover', 'click', 'manual')) {
  tagList(
    singleton(
      tags$head(
        tags$script("$(function() { $(\"[data-toggle='popover']\").popover(); })")
      )
    ),
    tags$a(
      href = "#", `data-toggle` = "popover", #class = "btn btn-mini",
      title = title, `data-content` = content, `data-animation` = TRUE,
      `data-placement` = match.arg(placement, several.ok=TRUE)[1],
      `data-trigger` = match.arg(trigger, several.ok=TRUE)[1],
      
      tags$i(class="icon-question-sign")
    )
  )
}

includeRmd <- function(path){
  if (!require(knitr))
    stop("knitr package is not installed")
  if (!require(markdown))
    stop("Markdown package is not installed")
  shiny:::dependsOnFile(path)
  contents = paste(readLines(path, warn = FALSE), collapse = '\n')
  html <- knitr::knit2html(text = contents, fragment.only = TRUE)
  Encoding(html) <- 'UTF-8'
  return(HTML(html))
}