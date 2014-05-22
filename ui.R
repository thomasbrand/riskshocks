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
  
  fluidRow(
    
    navlistPanel(
      
      well=F,
      widths=c(3,9),
      id="tsp",
      
      tabPanel(
        "Motivation",
        value="motiv",
        wellPanel(
          p("Highly synchronized during the 2008-2009 recession, Euro area and US economies have diverged since the former entered a double-dip recession, in the middle of 2011, while the latter pursued its weak recovery path. "),
          p("At the end of 2013, US economy has overtaken the pre-crisis level of output per capita whereas it is still below its pre-crisis level in the Euro area."),
          p("Why the Euro area and the US have diverged since 2011 while they were highly synchronized during the recession of 2008-2009?")
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
          p("We explain the divergence between Euro area and US economies by different paths of idiosyncratic uncertainty in the financial sector, also known as risk shocks as defined by ", a("Christiano, Motto and Rostagno (2014)",href="https://www.aeaweb.org/articles.php?doi=10.1257/aer.104.1.27",target="_blank"),
            helpPopup('What are risk shocks?',"Risk shocks have been defined by CMR as exogenous disturbances that modify the idiosyncratic uncertainty in the financial sector. They assume each entrepreneur should combine personal wealth and loan provided by the financial intermediary to transform raw capital into effective capital. The technology through this process is specific to each entrepreneur, approximated by an idiosyncratic shock applied to raw capital. Entrepreneurs who draws a low value of this idiosyncratic shock experience failure and lenders have to pay to check the state of the firm. The volatility of idiosyncratic uncertainty is defined as the time-varying standard deviation of these idiosyncratic shocks. An increase in risk means a higher dispersion of idiosyncratic shocks and therefore a higher risk of default in the economy.")),
          p("What's new since CMR already demonstrated the importance of risk shocks in the US business cycles, especially during the recession of 2008-2009?"),
          p('* We highlight a reversal of risk shocks in the US economy in the middle of 2009 that drives the US recovery afterwards.'),
          p('* We highlight a deterioration of the idiosyncratic uncertainty that is a the origin of the double-dip recession in the Euro area.'),
          p('* We conclude that the divergence would have been even stronger if only risk shocks have occurred.'),
          p("How do we proceed? We use the CMR methodology based on the estimation of a Dynamic Stochastic General Equilibrium (DSGE) model with nominal, real and financial frictions using macroeconomic and financial data up to 2013Q4. We update the CMR database for the US, compile a similar database for the Euro area, and estimate the DSGE model for both.")
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
        h4("The Decomposition of Shocks in",textOutput("captionDecompo1"),align="center"),
        showOutput("graphDecompo1","nvd3"),
        h4("The Role of Shocks in",textOutput("captionDecompo2"),align="center"),
        showOutput("graphDecompo2","nvd3")
      ),

      tabPanel(
        "Variance Decomposition",
        value="vardecompo",
        h4("Variance decomposition at business cycle frequency (percent)",align="center"),
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
        selectInput('ShockResult','Shock to feed the model and simulate the corresponding variable: ',levels(decompo$shock)[-1],selected='risk')
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
        selectInput('CountryVarDecompo','Country:',c('Euro Area','United States')),
        checkboxInput('longtable','Check if you want to see the details of the variance decomposition',FALSE)
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
    #textOutput("pageviews")
    
  )
  
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