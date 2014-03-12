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
      p("CMR (2014) show that risk shocks are essential to explain fluctuations of GDP in the US, especially during the Great Recession. Based on their model, we address 3 more questions: "),
      p("* Is the decline of risk shocks essential to explain recovery ?"),
      p("* Is it the same phenomenon in EA ?"),
      p("* What would US policies have produced in EA ?"),
      p("We update the CMR database, compile EA database, add one observed variable (government deficit) and estimate the model for both countries."),
      tags$hr(),
      selectInput('Obsvar',
                  'Plot the index of selected variable and choose when times begin with the red y-axis:',
                  levels(dataLevel$variable)),
      selectInput('Obsvar1',
                  'Plot one of the variables used in estimation (all, except interest rate, are in real terms and quantities are per capita): ',
                  levels(dataRaw$variable)),
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
      condition="input.tsp=='result'",
      p("The first results we present are the role of the selected shock in explaining fluctuations of the observed variables (annualized and without mean), for both countries."),
      selectInput('Country2',
                  "Country",
                  choices=levels(dataDecompo$country)),
      selectInput('Shock', 
                  'Shock: ',
                  choices=levels(dataDecompo$shock)[-1],
                  selected='risk'),
      downloadButton("downloadGraphResult", "Download Graphic")
    ),
    
    conditionalPanel(
      condition="input.tsp=='decompo'",
      p("With respect to CMR estimation, we add one observed variable (government deficit), make explicit public deficit (adding lump-sump transfers to households), add a measurment error on observed deficit."),
      p("Now you can have a look at the decomposition and the role of the 12 shocks in the variation of the 13 observed variables for Euro Area and the United States."),
      selectInput('Country',
                  'Country: ',
                  levels(dataDecompo$country)),
      selectInput('Obsvar2', 
                  'Observed Variable: ',
                  levels(dataDecompo$variable)),
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
      p("Assessing the role of shocks, policies and structures: what would have happened if US fiscal and monetary policies were implemented in EA ?")
    ),
    
    tags$hr(),
    p("Source code available at",a("GitHub",href="https://github.com/thomasbrand/riskshocks"),textOutput("pageviews")),
    a(img(src="http://www.cepii.fr/CEPII/css/img/header/logo_header_fr.png", width="180", height="64"),href="http://www.cepii.fr")
  ),
  
  
  mainPanel(
    tabsetPanel(
      tabPanel("Motivation",
               h4("Index of",textOutput("captionM"),align="center"),
               showOutput("cumuLine","nvd3"),
               tags$hr(),
               h4(textOutput("captionM1"),align="center"),
               showOutput('simpleLine','nvd3'),
               value="motiv"),
      tabPanel("First Results",
               h4("The Role of the Selected Shock in Observed Variables",align="center"),
               plotOutput("facetLine",height="700px",width="85%"),
               value="result"),
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
      tabPanel("About",
               h4("Data"),
               includeMarkdown("data_description.Rmd"),
               h4("References"),
               p("Published version of Christiano, Motto and Rostagno (2014) is available in",a("AER website",href="https://www.aeaweb.org/articles.php?doi=10.1257/aer.104.1.27"),"with technical appendix and Dynare code."),
               h4("Thanks"),
               p("rCharts"),
               value="about"),
      id="tsp"
    )
  )
))