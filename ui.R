library(shiny)
library(rCharts)

shinyUI(fluidPage(
  
  fluidRow(
    column(
      width=2,
      absolutePanel(
        left="20px",
        width="17%",
        top="20px",
        fixed=TRUE,
        wellPanel(
        div(strong("Interactive website:",style="font-size:12px"), p("Select data samples in the draggable grey left panel and by click on the legend",style="font-size:12px")),style="padding-top:3px;padding-bottom:3px"
      ))),
    column(
      width=8,#offset=2,
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
    h5(a("Download working paper",href="http://www.cepii.fr/CEPII/en/publications/wp/abstract.asp?NoDoc=7057",target="_blank"),align="center",style="line-height:11px")),
  
  fluidRow(
    
    navlistPanel(
      
      well=F,
      widths=c(3,9),
      id="tsp",
      
      tabPanel(
        "Motivation",
        value="motiv",
        wellPanel(
          p("Highly synchronized during the 2008-2009 recession, Euro area and US economies have diverged since the former entered a double-dip recession, in the middle of 2011, while the latter pursued its slow recovery path. "),
          p("The divergence is not limited to series of GDP or investment, but the financing conditions also differed."),
          p("Based on such evidence, we investigate the role of the volatility of idiosyncratic uncertainty in the financial sector, defined as risk shocks by", a("Christiano, Motto and Rostagno (2014)",href="https://www.aeaweb.org/articles.php?doi=10.1257/aer.104.1.27",target="_blank"),
            helpPopup('What are risk shocks?',"Risk shocks have been defined by CMR as exogenous disturbances that modify the idiosyncratic uncertainty in the financial sector. They assume each entrepreneur should combine personal wealth and loan provided by the financial intermediary to transform raw capital into effective capital. The technology through this process is specific to each entrepreneur, approximated by an idiosyncratic shock applied to raw capital. Entrepreneurs who draws a low value of this idiosyncratic shock experience failure and lenders have to pay to check the state of the firm. The volatility of idiosyncratic uncertainty is defined as the time-varying standard deviation of these idiosyncratic shocks. An increase in risk means a higher dispersion of idiosyncratic shocks and therefore a higher risk of default in the economy.",trigger='click'),", in the divergence between the two economies.")
        ),
        h4(textOutput("captionMotiv1First"),textOutput("captionMotiv1"),align="center"),
        showOutput("graphMotiv1","nvd3"),
        h4(textOutput("captionMotiv2"),align="center"),
        showOutput('graphMotiv2','nvd3')
      ),
      
      tabPanel(
        "Results",
        value="result",
        wellPanel(
          p("We estimate a Dynamic and Stochastic General Equilibrium Model with nominal, real and financial frictions for US and Euro area economies over the period 1987Q1-2013Q4, using eight standard macroeconomic series and four financial series"),
          p("We show that an important part of the business cycle variance in output is accounted for by risk shocks in both economies and risk shocks dominate all the other shocks to explain the recent divergence between the two economies."),
          p("Counterfactual experiment highlights the importance of those structural differences in the divergence between Euro area and US economies")
        ),
        h4(textOutput("captionResultFirst"),textOutput("captionResult"),align="center"),
        showOutput("graphResult","nvd3")
      ),
      
      tabPanel(
        "Historical Decomposition (lines)",
        value="role",
        wellPanel(
          p("We show the historical decomposition of the twelve observed variables used in the estimation over the sample period."),
          p("The lines represent the historical contribution of each of the twelve shocks to the observed variables, that is the counterfactual values predicted by the model when all other shocks are set to zero. The risk lines sum the contributions of unanticipated and anticipated risk shocks."),
          p("Raw data lines correspond to the demeaned historical series and sum of shocks lines to the series simulated by the model when all shocks are activated (the two lines coincide for each variable except because of measurement errors and numerical approximation). ")
        ),
        h4("The Role of Shocks in",textOutput("captionRoleShock"),align="center"),
        showOutput("graphRoleShock","nvd3")
      ),
      
      tabPanel(
        "Historical Decomposition (bars)",
        value="decompo",
        wellPanel(
          p("We show the historical decomposition of the twelve observed variables used in the estimation over the sample period."),
          p("The bars represent the historical contribution of each of the twelve shocks to the observed variables, that is the counterfactual values predicted by the model when all other shocks are set to zero. The risk bars sum the contributions of unanticipated and anticipated risk shocks.")
        ),
        h4("The Decomposition of Shocks in",textOutput("captionDecompo"),align="center"),
        showOutput("graphDecompo","nvd3")
      ),
      
      tabPanel(
        "Variance Decomposition",
        value="vardecompo",
        wellPanel(
          p("For each observed variable in row, risk column is the sum of the variance explained by anticipated and unanticipated components of the risk shocks, investment column is the sum of the variance explained by investment price and investment efficiency shocks and technology column is the sum of the variance explained by temporary technology and persistent technology growth shocks. We omit the contributions of inflation target and term structure shocks."),
          p("Numbers in each row may not add up to 100 as we ignore the correlation between the shocks when we add explained variances. Business cycle frequency is measured with HP filter (lambda = 1600).")
        ),
        h4("Variance decomposition at business cycle frequency (percent)",align="center"),
        dataTableOutput("tabVarDecompo")
      ),
      
      tabPanel(
        "Bayesian IRF",
        value="birf",
        wellPanel(
          p("The solid line is the mean of the Bayesian impulse response functions, i.e. the mean of the distribution of the Impulse Response Functions generated when parameters are drawn from the posterior distribution. Shaded areas are between the lower and the upper bound of a 80% highest posterior density interval. Variables are in deviation from their steady-state values.")
        ),
        h4("Bayesian Impulse Response Function (in percent) after a Shock of",textOutput("captionBirf"),align="center"),
        div(plotOutput("graphBirf",height="700px",width="760px"),align="center")
      ),
      
      tabPanel(
        "Counterfactual",
        value="counterfact",
        wellPanel(
          p("We perform counterfactual analysis that imposes in the US economic structure the estimated shocks of the Euro area economy and, reciprocally, in the Euro area economic structure the estimated shocks of the US economy.")
        ),
        h4(textOutput("captionCounterfact"),align="center"),
        div(plotOutput("graphCounterfact",height="700px",width="760px"),align="center")
      ),
      
      tabPanel(
        "Forecast",
        value="forecast",
        wellPanel(
          p("We show the forecasts of the twelve observed variables used in the estimation for the next ten years (2014Q1-2023Q4)."),
          p("The distribution of forecasts takes into account the uncertainty about both parameters and shocks. Shaded areas mark the uncertainty associated with our forecast as 20, 40, 60, and 80 percent probability intervals.")
        ),
        h4("The Forecast of Observed Variables",align="center"),
        div(plotOutput("graphForecast",height="700px",width="760px"),align="center")
      ),
      
      tabPanel(
        "Prior and Posterior",
        value="posterior",
        wellPanel(
          p("The table shows the prior and posterior distributions of estimated economic parameters and shocks."),
          p("Prior distributions are the same for both countries.")
        ),
        dataTableOutput("tabPosterior")
      ),
      
      tabPanel(
        "Data",
        value="source",
        wellPanel(
          p("We provide the sources for the observed variables used in estimation."),
          p("For the Euro area, we use the Area-wide Model (AWM) database, up to 2010Q4. We then link, where it is feasible, the data contained in the orginal AWM database to the official euro area data.",
            helpPopup("AWM Database","The original version of the databas is the ECB working paper No. 42: ‘An Area-wide Model (AWM) for the euro area’ by Gabriel Fagan, Jérôme Henry and Ricardo Mestre (January 2001). Here we use the 11th update of the AWM database. It has been constructed using both euro area data reported in the ECB Monthly Bulletin and other ECB and Eurostat data where available.",trigger='click')),
          p("Population series are used to normalize quantity variables.")
        ),
        #h4('Sources for the 12 variables used in estimation (and the population)',align='center'),
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
          selectInput('ObsMotiv1','Deviation of observed variable (in real terms, except interest rate, and per capita for quantities):',levels(motiv1$variable)),
          selectInput('ObsMotiv2','Observed variable, as used in estimation:',levels(motiv2$variable)),
          checkboxInput('withoutmean','Demeaned variable',FALSE),
          conditionalPanel(
            condition="input.withoutmean==true",
            p("Maybe you want to compare to CMR raw data (also annualized)?",style="font-size:12px"),
            checkboxInput("rawdataCMR","Yes, it would be wonderful!",FALSE)
          )
        ),
        downloadButton('downloadDataMotiv','Download Data as csv')
      ),
      
      conditionalPanel(
        condition="input.tsp=='result'",
        wellPanel(
          dateRangeInput('TimeResult','Date range:',start="2007-12-01",end="2013-12-01",min="1988-03-01",max="2013-12-01"),
          selectInput('ObsResult','Deviation of observed and simulated variables: ',levels(motiv1$variable)),
          selectInput('ShockResult','Shock to feed the model and simulate the corresponding variable: ',levels(decompo$shock)[-1],selected='risk')
        ),
        downloadButton('downloadDataResult','Download Data as csv')
      ),
      
      conditionalPanel(
        condition="input.tsp=='role'",
        wellPanel(
          selectInput('CountryRole',"Country: ",c("Euro Area",'United States')),
          selectInput('ObsRole','Observed variable: ',levels(decompo$variable))
          #selectInput('ShockRole','Shock: ',levels(decompo$shock)[-1],selected='risk')
        ),
        #downloadButton("downloadGraphRole", "Download Graphic as pdf")
        downloadButton('downloadDataRoleShock','Download Data as csv')
      ),
      
      conditionalPanel(
        condition="input.tsp=='decompo'",
        wellPanel(
          selectInput('CountryDecompo','Country: ',c("Euro Area",'United States')),
          selectInput('ObsDecompo','Observed variable: ',levels(decompo$variable))
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
          selectInput('ShockBirf','Shock: ',levels(birf$shock),selected="risk news (anticipated t-4)")
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