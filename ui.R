library(shiny)
library(rCharts)

shinyUI(pageWithSidebar(
  
  headerPanel("Great Divergence ?"),
  
  sidebarPanel(
    tags$head(
      tags$style(type="text/css", "select { width: 350px; }")
    ),
    h3("An Analysis of Exit Strategies in Euro Area and the United States"),
    
    p("by",a("Thomas Brand",href="http://www.cepii.fr/CEPII/fr/page_perso/page_perso.asp?nom_complet=Thomas%20Brand"),
      "and",a("Fabien Tripier",href="http://www.cepii.fr/CEPII/fr/page_perso/page_perso.asp?nom_complet=Fabien%20Tripier")),
    
    tags$hr(),
    conditionalPanel(
      condition="input.tsp=='motiv'",
      p("CMR (2014) show that risk shocks are essential to explain fluctuations of GDP in the US, especially during the Great Recession. Based on their model, we address three more questions: "),
      p("* Is the decline of risk shocks essential to explain recovery ?"),
      p("* Is it the same phenomenon in EA ?"),
      p("* What would US policies have produced in EA ?"),
      p("We update the CMR database, compile EA database and estimate the model for both countries."),
      tags$hr(),
      selectInput('ObsMotiv1',
                  'Plot the index of selected variable and choose when times begin with the red y-axis:',
                  levels(dataLevel$variable)),
      #sliderInput('yrs','Year range:',1988,2013,c(2007,2013),step=1),
      selectInput('ObsMotiv2',
                  'Plot one of the variables used in estimation (all, except interest rate, are in real terms and quantities are per capita): ',
                  levels(dataRaw$variable)),
      checkboxInput('withoutmean','Demeaned variable (actually used in estimation)',FALSE),
      conditionalPanel(
        condition="input.withoutmean==true",
        p("Maybe you want to compare to CMR rawdata (also annualized) ?"),
        checkboxInput("rawdataCMR","Yes, it would be wonderful !",FALSE)
      ),
      tags$hr(),
      downloadButton('downloadDataRaw', 'Download Data as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='result'",
      p("There are three main results: "),
      p('* The reversal of risk shocks drives the US recovery and is the key determinant of recent economic growth.'),
      p('* Risk shocks contributed less to the contraction in EA than in the US, but they are at the origin of the double dip pattern of the crisis.'),
      p('* Differences in fiscal and conventional monetary policies explain a part of the divergence during the contraction, but play no role in the recent divergence.'),
      tags$hr(),
#       selectInput('CountryRes',
#                   'Country: ',
#                   c("Euro Area",'United States')),
      selectInput('ObsRes',
                  'Observed variable: ',
                  levels(dataLevel$variable)),
      selectInput('ShockRes', 
                  'Shock: ',
                  levels(dataDecompo$shock)[-1],
                  selected='risk')
#       ,
#       tags$hr(),
#       downloadButton('downloadDataRaw', 'Download Data as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='facet'",
      p('Here we present the role of the selected shock in explaining fluctuations of the observed variables (annualized and without mean), for both countries.'),
      selectInput('CountryFacet',
                  "Country: ",
                  c("Euro Area",'United States')),
      selectInput('ShockFacet', 
                  'Shock: ',
                  levels(dataDecompo$shock)[-1],
                  selected='risk'),
      tags$hr(),
      downloadButton("downloadGraphResult", "Download Graphic as pdf")
    ),
    
    conditionalPanel(
      condition="input.tsp=='decompo'",
      p("Now you can have a look at the decomposition and the role of the 12 shocks in the variation of the 12 observed variables for Euro Area and the United States."),
      selectInput('CountryDecompo',
                  'Country: ',
                  c("Euro Area",'United States')),
      selectInput('ObsDecompo', 
                  'Observed Variable: ',
                  levels(dataDecompo$variable)),
      tags$hr(),
      downloadButton('downloadDataDecompo', 'Download Data as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='table'",
      p("Prior mean and standard deviation are the same in both countries."),
      tags$hr(),
      checkboxGroupInput("varTable",
                         "Choose information about prior/posterior you want to display in the table: ",
                         names(dataTable)[-1],
                         selected=c("Prior density","Prior mean","Post. mode EA","Post. mode US")),
      tags$hr(),
      downloadButton('downloadDataTable', 'Download Data as csv')
    ),

    conditionalPanel(
      condition="input.tsp=='counterfact'",
      p("Assessing the role of shocks, policies and structures: what would have happened if US fiscal and monetary policies were implemented in EA ?")
    ),
    
    tags$hr(),
    p("Source code available at",a("GitHub",href="https://github.com/thomasbrand/riskshocks"),textOutput("pageviews")),
    a(img(src="http://www.cepii.fr/CEPII/css/img/header/logo_header_fr.png", width="180", height="64"),href="http://www.cepii.fr")
  ),
  
  
  mainPanel(
    tabsetPanel(
      tabPanel("Motivation",
               h4("Index of",textOutput("captionMotiv1"),align="center"),
               showOutput("cumuLineMotiv","nvd3"),
               tags$hr(),
               h4(textOutput("captionMotiv2"),align="center"),
               showOutput('simpleLineMotiv','nvd3'),
               value="motiv"),
      tabPanel("Results",
               h4("Index of",textOutput("captionRes"),align="center"),
               showOutput("cumuLineRes","nvd3"),
               value="result"),
      tabPanel("Role of Shocks",
               h4("The Role of the Selected Shock in Observed Variables",align="center"),
               div(plotOutput("facetLine",height="700px",width="760px"),align="center"),
               value="facet"),
      tabPanel("Shock Decomposition",
               h4("The Decomposition of Shocks in",textOutput("captionD1"),align="center"),
               showOutput("multibar","nvd3"),
               tags$hr(),
               h4("The Role of Shocks in",textOutput("captionD2"),align="center"),
               showOutput("focusLine","nvd3"),
               value="decompo"),
      tabPanel("Priors & Posteriors",
               dataTableOutput("table"),
               value="table"),
      tabPanel("Counterfactual",
               value="counterfact"),
      tabPanel("Data",
               includeMarkdown("data_description.Rmd"),
               value="data"),
      id="tsp"
    )
  )
))