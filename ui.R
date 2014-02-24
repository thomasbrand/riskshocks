library(shiny)
library(rCharts)

shinyUI(pageWithSidebar(
  
  headerPanel("Great Divergence ?"),
  
  sidebarPanel(
    
    h3("An Analysis of Exit Strategies in EA and the US"),
    
    p("by",a("Thomas Brand",href="http://www.cepii.fr/CEPII/fr/page_perso/page_perso.asp?nom_complet=Thomas%20Brand"),
      "and",a("Fabien Tripier",href="http://www.cepii.fr/CEPII/fr/page_perso/page_perso.asp?nom_complet=Fabien%20Tripier")),
    p("CMR (2014) show that risk shocks are essential to explain fluctuations of GDP in the US, especially during the Great Recession. Based on their model, we adress 2 more questions : "),
    p("* Is the decline of risk shocks essential to explain recovery ?"),
    p("* Is it the same phenomenon in Euro Area ?"),
    p("We update the CMR database, compile EA database, add one observed variable (government deficit) and re-estimate the model for both countries."),
    
    tags$hr(),
    conditionalPanel(
      condition="input.tsp=='motiv'",
      selectInput('Obsvar1',
                  'Plot one of the variables used in estimation : ',
                  obsnames),
      checkboxInput('withoutmean','Demeaned variable (actually used in estimation)',FALSE),
      conditionalPanel(
        condition="input.withoutmean==true",
        checkboxGroupInput("compareRawdata",
                     "Maybe you want to compare to :",
                     c("cmr_rawdata","explained_rawdata"))
        ),
      tags$hr(),
      downloadButton('downloadRawdata', 'Download as csv')      
    ),
    
    conditionalPanel(
      condition="input.tsp=='plot'",
      selectInput('Country',
                  'Country : ',
                  c('EA','US')),
      selectInput('Obsvar2', 
                  'Observed Variable : ',
                  obsnames),
      tags$hr(),
      downloadButton('downloadDataD', 'Download as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='table'",
      tags$hr(),
      downloadButton('downloadDataTable', 'Download as csv')
    ),
    
    tags$hr(),
    p("Source code is available",a("here",href="https://github.com/thomasbrand/riskshocks")),
    a(img(src="http://www.cepii.fr/CEPII/medias/mailing/logo_cepii.jpg", width="180", height="64"),href="http://www.cepii.fr")
  ),
  
  
  mainPanel(
    tabsetPanel(
      tabPanel("Motivation",
               h4("Selected Observed Variable"),
               showOutput('simpleLine','nvd3'),
               #h4("Cumulative Growth of Selected Observed Variable"),
               #showOutput("cumuLine","nvd3"),
               value="motiv"),
      tabPanel("Plots",
               h4("The Decomposition of Shocks in Selected Variable"),
               showOutput("multiBar","nvd3"),
               tags$hr(),
               h4("The Role of Shocks in Selected Variable"),
               showOutput("focusLine","nvd3"),
               #tags$hr(),
               #h4("Cumulative Growth of Selected Observed Variable"),
               #showOutput("cumuLine2","nvd3"),
               value="plot"),
      tabPanel("Priors & Posteriors",
               tableOutput("table"),
               value="table"),
      id="tsp"
    )
  )
))