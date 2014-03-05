library(shiny)
library(rCharts)

shinyUI(pageWithSidebar(
  
  headerPanel("Great Divergence ?"),
  
  sidebarPanel(
    
    h3("An Analysis of Exit Strategies in Euro Area and the United States"),
    
    p("by",a("Thomas Brand",href="http://www.cepii.fr/CEPII/fr/page_perso/page_perso.asp?nom_complet=Thomas%20Brand"),
      "and",a("Fabien Tripier",href="http://www.cepii.fr/CEPII/fr/page_perso/page_perso.asp?nom_complet=Fabien%20Tripier")),
    
    tags$hr(),
    conditionalPanel(
      condition="input.tsp=='motiv'",
      p("CMR (2014) show that risk shocks are essential to explain fluctuations of GDP in the US, especially during the Great Recession. Based on their model, we address 3 more questions : "),
      p("* Is the decline of risk shocks essential to explain recovery ?"),
      p("* Is it the same phenomenon in EA ?"),
      p("* What would US policies have produced in EA ?"),
      p("We update the CMR database, compile EA database, add one observed variable (government deficit) and estimate the model for both countries."),
      tags$hr(),
      selectInput('Obsvar','Plot the index of selected variable and choose when times begin with the red y-axis (quantities are in real terms per capita) :',levels(dataLevel$variable)),
      selectInput('Obsvar1',
                  'Plot one of the variables used in estimation (rates, or growth rates for quantities, are annualized) : ',
                  obsnames),
      checkboxInput('withoutmean','Demeaned variable (actually used in estimation)',FALSE),
      conditionalPanel(
        condition="input.withoutmean==true",
        p("Maybe you want to compare to CMR rawdata (also annualized) ?"),
        checkboxInput("rawdataCMR","Yes, it would be wonderful !",FALSE)
      ),
      tags$hr(),
      downloadButton('downloadDataRaw', 'Download as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='cmr'",
      p("Fiscal policy plays potentially a big role in explaining exit strategies. How original CMR's model take it into account ? Not so good if we look at the public deficit implied by their model."),
      p("This is why we add government deficit as an observed variable (and a shock on the deficit in the model).")
    ),
    
    conditionalPanel(
      condition="input.tsp=='decompo'",
      p("Look at the decomposition and the role of the 13 shocks in the variation of the 13 observed variables for Euro Area and the United States."),
      selectInput('Country',
                  'Country : ',
                  c('EA','US')),
      selectInput('Obsvar2', 
                  'Observed Variable : ',
                  obsnames),
      tags$hr(),
      downloadButton('downloadDataDecompo', 'Download as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='table'",
      p("Prior mean and standard deviation are the same in both countries."),
      tags$hr(),
      downloadButton('downloadDataTable', 'Download as csv')
    ),

    conditionalPanel(
      condition="input.tsp=='counterfact'",
      p("Assessing the role of shocks, policies and structures"),
      p("(what would have happened if US fiscal and monetary policies were implemented in EA ?)")
    ),
    
    tags$hr(),
    p("Source code available at",a("GitHub",href="https://github.com/thomasbrand/riskshocks"),textOutput("pageviews")),
    a(img(src="http://www.cepii.fr/CEPII/css/img/header/logo_header_fr.png", width="180", height="64"),href="http://www.cepii.fr")
  ),
  
  
  mainPanel(
    tabsetPanel(
      tabPanel("Motivation",
               h4("Index of Selected Observed Variable"),
               showOutput("cumuLine","nvd3"),
               h4("Selected Observed Variable Used in Estimation"),
               showOutput('simpleLine','nvd3'),
               value="motiv"),
      tabPanel("CMR Results",
               showOutput("simpleLine2","nvd3"),
               value="cmr"),
      tabPanel("Our Shock Decomposition",
               h4("The Decomposition of Shocks in Selected Variable"),
               showOutput("multiBar","nvd3"),
               tags$hr(),
               h4("The Role of Shocks in Selected Variable"),
               showOutput("focusLine","nvd3"),
               value="decompo"),
      tabPanel("Priors & Posteriors",
               dataTableOutput("table"),
               value="table"),
      tabPanel("Counterfactual",
               value="counterfact"),
      tabPanel("About",
               h4("References"),
               p("Published version of Christiano, Motto and Rostagno (2014) is available in",a("AER website",href="https://www.aeaweb.org/articles.php?doi=10.1257/aer.104.1.27"),"with technical appendix and Dynare code."),
               h4("Thanks"),
               p("rCharts"),
               value="about"),
      id="tsp"
    )
  )
))