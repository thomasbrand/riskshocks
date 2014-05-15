library(shiny)
library(rCharts)

shinyUI(fluidPage(
  
  fluidRow(
    column(
      width=8,offset=2,
      h1("Risk Shocks and Divergence between the Euro Area and the US",align="center",style="padding-top:15px;font-size:28px")
      ),
    column(
      width=2,offset=0,
      a(img(src="http://www.cepii.fr/CEPII/css/img/header/logo_header_en.png",align="right",style="padding-top:15px"),href="http://www.cepii.fr",target="_blank")
      )
    ),
  
  fluidRow(
    column(
      width=12,
      h3(a("Thomas Brand",href="http://www.cepii.fr/CEPII/fr/page_perso/page_perso.asp?nom_complet=Thomas%20Brand",target="_blank"),"and",
         a("Fabien Tripier",href="http://www.cepii.fr/CEPII/fr/page_perso/page_perso.asp?nom_complet=Fabien%20Tripier",target="_blank"),
         align="center",style="font-size:20px;line-height:10px")
    )
  ),
  
  fluidRow(
    h5(a("Download working paper (preliminary draft)",href="https://github.com/thomasbrand/riskshocks/blob/master/RiskDivergence.pdf?raw=true",target="_blank"),align="center",style="line-height:11px")),
  
  #br(),

  fluidRow(
    
    navlistPanel(
      
      well=F,
      widths=c(3,9),
      id="tsp",
      
      tabPanel(
        "Motivation",
        value="motiv",
        wellPanel(
          p("Christiano, Motto and Rostagno (2014,", a("AER)",href="https://www.aeaweb.org/articles.php?doi=10.1257/aer.104.1.27",target="_blank"),
            "show that risk shocks are essential to explain fluctuations of GDP in the US, especially during the Great Recession.",
            helpPopup('Definition of risk','In a model à la Bernanke, Gertler and Gilchrist (1999), entrepreneurs combine their own resources with loans to acquire raw capital. They then convert raw capital into effective capital in a process characterized by idiosyncratic uncertainty. CMR (2014) refer to the magnitude of this uncertainty as risk.')),
          p("Based on their model, we address three more questions: "),
          p("* Is the decline of risk shocks essential to explain recovery ?"),
          p("* Is it the same phenomenon in the EA ?"),
          p("* What are the specific role of EA structures and policies in explaining those results ?"),
          p("We update the CMR database, compile EA database and estimate the model for both countries.")
        ),
        h4("Index of",textOutput("captionMotiv1"),align="center"),
        showOutput("graphMotiv1","nvd3"),
        h4(textOutput("captionMotiv2"),align="center"),
        showOutput('graphMotiv2','nvd3')
      ),
      
      tabPanel(
        "Results",
        value="result",
        wellPanel(
          p("There are three main results: "),
          p('* The reversal of risk shocks drives the US recovery and is the key determinant of recent economic growth.'),
          p('* Risk shocks contributed less to the contraction in the EA than in the US, but they are at the origin of the double dip pattern of the crisis.'),
          p('* Differences in fiscal and conventional monetary policies explain a part of the divergence during the contraction, but play a minor role in the recent divergence.')
        ),
        h4("Index of",textOutput("captionResult"),align="center"),
        showOutput("graphResult","nvd3")
      ),
      
      tabPanel(
        "Role of Shocks",
        value="role",
        wellPanel(
          p('We compare raw data to simulated data, obtained when we feed only the selected shock to the model.')
        ),               
        h4("The Role of the Selected Shock in Observed Variables",align="center"),
        div(plotOutput("graphRole",height="700px",width="760px"),align="center")
      ),
      
      tabPanel(
        "Shock Decomposition",
        value="decompo",
#         wellPanel(
#           p("Now you can have a look at the decomposition and the role of the 12 shocks in the variation of the 12 observed variables for the Euro Area and the United States.")
#         ),
        h4("The Decomposition of Shocks in",textOutput("captionDecompo1"),align="center"),
        showOutput("graphDecompo1","nvd3"),
        h4("The Role of Shocks in",textOutput("captionDecompo2"),align="center"),
        showOutput("graphDecompo2","nvd3")
      ),

      tabPanel(
        "Variance Decomposition",
        value="vardecompo",
#         wellPanel(
#           p("Prior mean and standard deviation are the same in both countries.")
#         ),
        h4("Variance decomposition at business cycle frequency (Percent)",align="center"),
        dataTableOutput("tabVarDecompo")
      ),
      
      tabPanel(
        "Bayesian IRF",
        value="birf",
        h4("Bayesian Impulse Response Function after a Shock of",textOutput("captionBirf"),align="center"),
        div(plotOutput("graphBirf",height="700px",width="760px"),align="center")
      ),
      
      tabPanel(
        "Counterfactual",
        value="counterfact",
#         wellPanel(
#           p("Assessing the role of shocks, policies and structures.")
#         ),
        h4(textOutput("captionCounterfact"),align="center"),
        div(plotOutput("graphCounterfact",height="700px",width="760px"),align="center")
      ),     
      
      tabPanel(
        "Forecast",
        value="forecast",
        h4("The Forecast of Observed Variables",align="center"),
        div(plotOutput("graphForecast",height="700px",width="760px"),align="center")
      ),
      
      tabPanel(
        "Prior and Posterior",
        value="posterior",
        wellPanel(
          p("Prior mean and standard deviation are the same in both countries.")
        ),
        dataTableOutput("tabPosterior")
      ),
      
      tabPanel(
        "Data",
        value="source",
        wellPanel(
          p("We use quarterly observations on 12 variables covering the period 1987Q1-2013Q4. These include 8 variables that are standard in bayesian estimation of DSGE models: GDP, consumption, investment, inflation, wage, price of investment, hours worked and short-term risk-free rate."),
          p("For Euro case, we use the Area-wide Model (AWM) database, up to 2010Q4. We then link, where it is feasible, the data contained in the orginal AWM database to the official euro area data.",
            helpPopup("AWM Database","The original version of the databas is the ECB working paper No. 42: ‘An Area-wide Model (AWM) for the euro area’ by Gabriel Fagan, Jérôme Henry and Ricardo Mestre (January 2001). Here we use the 11th update of the AWM database. It has been constructed using both euro area data reported in the ECB Monthly Bulletin and other ECB and Eurostat data where available.")),
          p("As CMR, we also use four financial variables: credit, slope of the term structure of interest rates, entrepreneurial networth and credit spread."),
          p("Population series are used to normalize quantity variables.")
        ),
        h4('Sources for the 12 variables used in estimation (and the population)',align='center'),
        uiOutput("txtSource")
      )   
      
  ),

  
  absolutePanel(
    
    left="20px",
    width="22.5%",
    top="440px",
    fixed=TRUE,
    draggable=TRUE,
    
    conditionalPanel(
      condition="input.tsp=='motiv'",
      wellPanel(
        dateRangeInput('TimeMotiv','Date range (from 1988Q1 to 2013Q4):',start="2007-12-01",end="2013-12-01",min="1988-03-01",max="2013-12-01"),
        selectInput('ObsMotiv1','Index of selected variable:',levels(motiv1$variable)),
        selectInput('ObsMotiv2','Variable used in estimation (in real terms, except interest rate, and per capita for quantities):',levels(motiv2$variable)),
        checkboxInput('withoutmean','Demeaned variable (actually used in estimation)',FALSE),
        conditionalPanel(
          condition="input.withoutmean==true",
          p("Maybe you want to compare to CMR rawdata (also annualized)?",style="font-size:12px"),
          checkboxInput("rawdataCMR","Yes, it would be wonderful!",FALSE)
        )
      ),
      downloadButton('downloadDataMotiv','Download Data as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='result'",
      wellPanel(
        dateRangeInput('TimeResult','Date range:',start="2007-12-01",end="2013-12-01",min="1988-03-01",max="2013-12-01"),
        selectInput('ObsResult','Observed variable: ',levels(motiv1$variable)),
        selectInput('ShockResult','Shock: ',levels(decompo$shock)[-1],selected='risk')
      ),
      downloadButton('downloadDataResult','Download Data as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='role'",
      wellPanel(
        selectInput('CountryRole',"Country: ",c("Euro Area",'United States')),
        selectInput('ShockRole','Shock: ',levels(decompo$shock)[-1],selected='risk')
      ),
      downloadButton("downloadGraphRole", "Download Graphic as pdf")
    ),
    
    conditionalPanel(
      condition="input.tsp=='decompo'",
      wellPanel(
        selectInput('CountryDecompo','Country: ',c("Euro Area",'United States')),
        selectInput('ObsDecompo','Observed Variable: ',levels(decompo$variable))
      ),
      downloadButton('downloadDataDecompo', 'Download Data as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='vardecompo'",
      wellPanel(
        selectInput('CountryVarDecompo','Country',c('Euro Area','United States')),
        checkboxInput('longtable','You want to see the details of the variance decomposition ?',FALSE)
        ),
      downloadButton('downloadDataVarDecompo', 'Download Data as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='birf'",
      wellPanel(
        selectInput('CountryBirf',"Country: ",c("Euro Area",'United States')),
        selectInput('ShockBirf','Shock: ',levels(birf$shock),selected="risk")
      ),
      downloadButton("downloadGraphBirf", "Download Graphic as pdf"),
      br(),br(),
      downloadButton('downloadDataBirf', 'Download Data as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='counterfact'",
      wellPanel(
        radioButtons("VarCounterfact","You want to see:",
                     list("one country economic structure hit by all shocks from different countries"="struc",
                          "all shocks from one country hitting different country economic structures"="shock"),
                     "struc"),
        conditionalPanel(
          condition="input.VarCounterfact=='struc'",
          radioButtons("Country_model","Which economic structure do you want to consider:",
                       c("Euro Area","United States")
          )
        ),
        conditionalPanel(
          condition="input.VarCounterfact=='shock'",
          radioButtons("Country_shock",
                       "From which country are the shocks you want to consider:",
                       c("Euro Area","United States")
          )
        )
      ),
      downloadButton("downloadGraphCounterfact", "Download Graphic as pdf"),
      br(),br(),
      downloadButton('downloadDataCounterfact', 'Download Data as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='forecast'",
      wellPanel(
        selectInput('CountryForecast',"Country: ",c("Euro Area",'United States'))
      ),
      downloadButton("downloadGraphForecast", "Download Graphic as pdf"),
      br(),br(),
      downloadButton('downloadDataForecast', 'Download Data as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='posterior'",
      wellPanel(
        checkboxGroupInput("VarPosterior",
                           "Choose information about prior/posterior: ",
                           names(posterior)[-1],
                           selected=c("Prior mean","Post. mode EA","Post. mode US"))
      ),
      downloadButton('downloadDataPosterior', 'Download Data as csv')
    ),
    
    conditionalPanel(
      condition="input.tsp=='source'",
      p("")
    ),
    
    br(),
    p("Source code available at",a("GitHub",href="https://github.com/thomasbrand/riskshocks",target="_blank"),
      style="font-size:12px"
    )
    
  )
  #textOutput("pageviews"),
  ),
  
  tagList(
    tags$head(
      tags$link(rel="stylesheet", type="text/css",href="style.css"),
      tags$script(type="text/javascript", src = "busy.js"),
      tags$title('Risk Shocks and Divergence between the Euro Area and the US - Thomas Brand and Fabien Tripier - CEPII')
    )
  ),
  
  div(class = "busy",
      p("Calculation in progress.."),
      img(src="Preloader_7.gif")
  )
  
))