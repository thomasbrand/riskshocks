library(shiny)
library(rCharts)

shinyUI(pageWithSidebar(
  
  div(h3("Risk shocks and divergence between the Euro Area and the US",align="center",
         a(img(src="http://www.cepii.fr/CEPII/css/img/header/logo_header_en.png", width="180", height="64",align="right"),href="http://www.cepii.fr")),
      h4(a("Thomas Brand",href="http://www.cepii.fr/CEPII/fr/page_perso/page_perso.asp?nom_complet=Thomas%20Brand"),
      "and",a("Fabien Tripier",href="http://www.cepii.fr/CEPII/fr/page_perso/page_perso.asp?nom_complet=Fabien%20Tripier"),align="center"),
      br()
      ),

  sidebarPanel(
    br(),
    
    conditionalPanel(
      condition="input.tsp=='motiv'",
      p("Christiano, Motto and Rostagno (2014,", a("AER)",href="https://www.aeaweb.org/articles.php?doi=10.1257/aer.104.1.27"),
        "show that risk shocks are essential to explain fluctuations of GDP in the US, especially during the Great Recession.",
        helpPopup('Definition of risk','In a model à la Bernanke, Gertler and Gilchrist (1999), entrepreneurs combine their own resources with loans to acquire raw capital. They then convert raw capital into effective capital in a process characterized by idiosyncratic uncertainty. CMR (2014) refer to the magnitude of this uncertainty as risk.')),
      p("Based on their model, we address three more questions: "),
      p("* Is the decline of risk shocks essential to explain recovery ?"),
      p("* Is it the same phenomenon in the EA ?"),
      p("* What are the specific role of EA structures and policies in explaining those results ?"),
      p("We update the CMR database, compile EA database and estimate the model for both countries."),
      tags$hr(),
      dateRangeInput('TimeMotiv','Date range:',start="2007-12-01",end="2013-12-01",min="1988-03-01",max="2013-12-01"),
      selectInput('ObsMotiv1',
                  'Plot the index of selected variable :',
                  levels(dataLevel$variable)),
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
      p('* Risk shocks contributed less to the contraction in the EA than in the US, but they are at the origin of the double dip pattern of the crisis.'),
      p('* Differences in fiscal and conventional monetary policies explain a part of the divergence during the contraction, but play no role in the recent divergence.'),
      tags$hr(),
      dateRangeInput('TimeRes','Date range:',start="2007-12-01",end="2013-06-01",min="1988-03-01",max="2013-12-01"),
      selectInput('ObsRes',
                  'Observed variable: ',
                  levels(dataLevel$variable)),
      selectInput('ShockRes', 
                  'Shock: ',
                  levels(dataDecompo$shock)[-1],
                  selected='risk'),
      tags$hr(),
      downloadButton('downloadDataRes', 'Download Data as csv')
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
      downloadButton("downloadGraphRes", "Download Graphic as pdf")
    ),

    conditionalPanel(
      condition="input.tsp=='forecast'",
      #p('blabla'),
      selectInput('CountryForecast',
                  "Country: ",
                  c("Euro Area",'United States')),
      tags$hr(),
      downloadButton("downloadGraphForecast", "Download Graphic as pdf")
    ),
    
    conditionalPanel(
      condition="input.tsp=='birf'",
      #p('blabla'),
      selectInput('CountryB',
                  "Country: ",
                  c("Euro Area",'United States')),
      selectInput('ShockB',
                  'Shock: ',
                  levels(dataBirf$shock),
                  selected="risk"),
      tags$hr(),
      downloadButton("downloadGraphB", "Download Graphic as pdf")
    ),
    
    conditionalPanel(
      condition="input.tsp=='decompo'",
      p("Now you can have a look at the decomposition and the role of the 12 shocks in the variation of the 12 observed variables for the Euro Area and the United States."),
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
                         selected=c("Prior mean","Post. mode EA","Post. mode US")),
      tags$hr(),
      downloadButton('downloadDataTable', 'Download Data as csv')
    ),

    conditionalPanel(
      condition="input.tsp=='counterfact'",
      p("Assessing the role of shocks, policies and structures."),
      radioButtons("VarCount",
                   "You want to see:",
                   list("one country economic structure hit by all shocks from different countries"="struc",
                        "all shocks from one country hitting different country economic structures"="shock"),
                   "struc"),
      conditionalPanel(
        condition="input.VarCount=='struc'",
        radioButtons("Country_model",
                     "Which economic structure you want to consider:",
                     c("Euro Area","United States")
                     )
        ),
      conditionalPanel(
        condition="input.VarCount=='shock'",
        radioButtons("Country_shock",
                     "From which country are the shocks you want to consider:",
                     c("Euro Area","United States")
        )
      ),
      tags$hr(),
      downloadButton("downloadGraphC", "Download Graphic as pdf")
    ),
    
    conditionalPanel(
      condition="input.tsp=='data'",
      p("We use quarterly observations on 12 variables covering the period 1987Q1-2013Q4. These include 8 variables that are standard in bayesian estimation of DSGE models: GDP, consumption, investment, inflation, wage, price of investment, hours worked and short-term risk-free rate."),
      p("For Euro case, we use the Area-wide Model (AWM) database, up to 2010Q4. We then link, where it is feasible, the data contained in the orginal AWM database to the official euro area data.",
        helpPopup("AWM Database","The original version of the databas is the ECB working paper No. 42: ‘An Area-wide Model (AWM) for the euro area’ by Gabriel Fagan, Jérôme Henry and Ricardo Mestre (January 2001). Here we use the 11th update of the AWM database. It has been constructed using both euro area data reported in the ECB Monthly Bulletin and other ECB and Eurostat data where available.")),
      p("As CMR, we also use four financial variables: credit, slope of the term structure of interest rates, entrepreneurial networth and credit spread."),
      p("Population series are used to normalize quantity variables.")
    ),
    
    tags$hr(),
    p("Source code available at",a("GitHub",href="https://github.com/thomasbrand/riskshocks"),textOutput("pageviews"))
    #a(img(src="http://www.cepii.fr/CEPII/css/img/header/logo_header_en.png", width="180", height="64"),href="http://www.cepii.fr")
  ),
  
  
  mainPanel(    
    tabsetPanel(      
      tabPanel("Motivation",
               h4("Index of",textOutput("captionMotiv1"),align="center"),
               showOutput("indexLineMotiv","nvd3"),
               tags$hr(),
               h4(textOutput("captionMotiv2"),align="center"),
               showOutput('simpleLineMotiv','nvd3'),
               value="motiv"),
      tabPanel("Results",
               h4("Index of",textOutput("captionRes"),align="center"),
               showOutput("indexLineRes","nvd3"),
               value="result"),
      tabPanel("Role of Shocks",
               h4("The Role of the Selected Shock in Observed Variables",align="center"),
               div(plotOutput("facetLineR",height="700px",width="760px"),align="center"),
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
      tabPanel("Bayesian IRF",
               h4("Bayesian Impulse Response Function after a Shock of",textOutput("captionB"),align="center"),
               div(plotOutput("facetLineB",height="700px",width="760px"),align="center"),
               value="birf"),
      tabPanel("Forecast",
               h4("The Forecast of Observed Variables",align="center"),
               div(plotOutput("facetLineF",height="700px",width="760px"),align="center"),
               value="forecast"),
      tabPanel("Counterfactual",
               h4(textOutput("captionC"),align="center"),
               div(plotOutput("facetLineC",height="700px",width="760px"),align="center"),
               value="counterfact"),
      tabPanel("Data",
               h4('Sources for the 12 variables used in estimation (and the population)',align='center'),
               uiOutput("datadesc"),
               value="data"),
      id="tsp",
      type='pills'
    ),
    tagList(
      tags$head(
        tags$link(rel="stylesheet", type="text/css",href="style.css"),
        tags$script(type="text/javascript", src = "busy.js")
      )
    ),      
    div(class = "busy",
        p("Calculation in progress.."),
        img(src="ajaxloaderq.gif")
    )    
  )
))