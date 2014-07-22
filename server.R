library(shiny)
library(rCharts)
library(ggplot2)

shinyServer(function(input, output,session) {
  
  #Data
  dataMotiv1 <- reactive({
    subdata <- subset(motiv1,variable == input$ObsMotiv1  & time>=input$TimeMotiv[1] & time<=input$TimeMotiv[2])
    if (input$ObsMotiv1 %in% list("Short-term risk-free interest rate (APR)","Credit spread (APP)","Term premium (APP)")){
      subdataIndex <- ddply(subdata,.(country,variable),transform,index=value-value[1])
    }
    else{
      subdataIndex <- ddply(subdata,.(country,variable),transform,index=value/value[1]*100)
    }
  })
  
  dataMotiv2 <- reactive({
    if (input$withoutmean){
      if (input$rawdataCMR){
        rbind(subset(motiv2,variable == input$ObsMotiv2 & shock %in% c('raw data (without mean)','rawdataCMR') & time>=input$TimeMotiv[1] & time<=input$TimeMotiv[2]))
      } else{
        rbind(subset(motiv2,variable == input$ObsMotiv2 & shock == 'raw data (without mean)' & time>=input$TimeMotiv[1] & time<=input$TimeMotiv[2]))
      }
    } else{
      subset(motiv2,variable == input$ObsMotiv2 & shock == 'raw data (with mean)' & time>=input$TimeMotiv[1] & time<=input$TimeMotiv[2])
    }
  })
  
  dataResult <- reactive({
    subdata <- subset(result,variable == input$ObsResult & shock %in% c(input$ShockResult,'raw data') & time>=input$TimeResult[1] & time<=input$TimeResult[2])
    if (input$ObsResult %in% list("Short-term risk-free interest rate (APR)","Credit spread (APP)","Term premium (APP)")){
     subdataIndex <- ddply(subdata,.(country,variable,shock),transform,index=value-value[1])
    }
    else{
      subdataIndex <- ddply(subdata,.(country,variable,shock),transform,index=value/value[1]*100)
    }  
  })
  
  dataRoleVar <- reactive({
    rbind(subset(decompo,shock == input$ShockRole & country == input$CountryRole),
          subset(motiv2, shock == 'raw data (without mean)' & country == input$CountryRole)
    )
  })
  
  dataRoleShock <- reactive({
    rbind(subset(decompo,variable == input$ObsRole & country == input$CountryRole),
          subset(motiv2, variable == input$ObsRole & country == input$CountryRole & shock == 'raw data (without mean)'),
          subset(sum, variable == input$ObsRole & country == input$CountryRole)
      )
  })
  
  dataDecompo <- reactive({subset(decompo,variable == input$ObsDecompo & country == input$CountryDecompo)})
  
  dataVarDecompo <- reactive({
    if (input$longtable){
      subset(vardecompo,country==input$CountryVarDecompo)
    } else{
      names(vardecompoShort)[2]<-""
      subset(vardecompoShort, country==input$CountryVarDecompo)
    }
  })
  
  dataBirf <- reactive({subset(birf,shock == input$ShockBirf & country == input$CountryBirf)})
  
  dataCounterfact <- reactive({
    if (input$VarCounterfact=="struc"){
      subset(counterfact,country_model==input$Country_model)
    } else{
      subset(counterfact,country_shock==input$Country_shock)
    }
  })
  
  dataForecast <- reactive({subset(forecast,country == input$CountryForecast)})
  
  posterior[,-c(1,2)]<-round(posterior[,-c(1,2)],8)
  dataPosterior <- reactive({subset(posterior,select=c("names",input$VarPosterior))})
  
  #Caption/Ticks
  specialtickMotiv2<-reactive({
    if (input$ObsMotiv2 == "Hours worked (log)"){
      tick<-"#!function (d) {return d3.format('.2f')(d);}!#"
    } else{
      tick<-"#!function (d) {return d3.format(',.1%')(d);}!#"
    }
  })
  
  specialtickDecompo<-reactive({
    if (input$ObsDecompo == "Hours worked (log)"){
      tick<-"#!function (d) {return d3.format('.2f')(d);}!#"
    } else{
      tick<-"#!function (d) {return d3.format(',.1%')(d);}!#"
    }
  })
  
  
  output$captionMotiv1First<-renderText({
    if (input$ObsMotiv1 %in% list("Short-term risk-free interest rate (APR)","Credit spread (APP)","Term premium (APP)")){
      "Deviation of"
    } else "Index of"
  })
  output$captionMotiv1<-renderText({
    input$ObsMotiv1
  })
  output$captionMotiv2<-renderText({
    input$ObsMotiv2
  })
  output$captionResultFirst<-renderText({
    if (input$ObsResult %in% list("Short-term risk-free interest rate (APR)","Credit spread (APP)","Term premium (APP)")){
      "Deviation of"
    } else "Index of"
  })
  output$captionResult<-renderText({
    input$ObsResult
  })
  output$captionRoleShock<-renderText({
    input$ObsRole
  })
#   output$captionRoleVar<-renderText({
#     input$ShockRole
#   })
  output$captionDecompo<-renderText({
    input$ObsDecompo
  })
  output$captionBirf<-renderText({
    input$ShockBirf
  })
  output$captionCounterfact <- renderText({
    if (input$VarCounterfact=="struc"){
      if (input$Country_model=="Euro Area"){
        "EA specific economic structure hit by all shocks from the EA and from the US"
      } else{
        "US specific economic structure hit by all shocks from the EA and from the US"
      }
    } else{
    if (input$Country_shock=="Euro Area"){
        "All EA shocks hitting EA and US specific economic structure"
      } else{
        "All US shocks hitting EA and US specific economic structure"
      }
    }
  })
  
  #Graph
  output$graphMotiv1 <- renderChart({
    n <- nPlot(index ~ time, data=dataMotiv1(), type = "lineChart",group="country")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=FALSE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format('.1f')(d);}!#",showMaxMin = FALSE)
    n$chart(useInteractiveGuideline=TRUE)
    n$set(dom = 'graphMotiv1', width = 700,height=380)
    n
  })
  
  output$graphMotiv2 <- renderChart({
    n <- nPlot(value ~ time, data=dataMotiv2(),type = "lineChart",group="country")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=FALSE)
    n$yAxis(tickFormat = specialtickMotiv2(),showMaxMin = TRUE)
    n$chart(useInteractiveGuideline=TRUE)
    n$set(dom = 'graphMotiv2', width = 700,height=380)
    n
  })
  
  output$graphResult <- renderChart({
    n <- nPlot(index ~ time, data=dataResult(), type = "lineChart",group="new")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=FALSE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format('.1f')(d);}!#",showMaxMin = FALSE)
    n$chart(useInteractiveGuideline=TRUE)
    n$set(dom = 'graphResult', width = 700,height=380)
    n
  })
  
  doPlotRoleVar <- function(text_size=10){
    p <- ggplot(data=dataRoleVar(),aes(x=time,y=value,group=shock,color=shock))+
      geom_line(size=0.8)+geom_point(aes(shape=shock),size=2)+
      scale_color_manual(values=c('#1F77B4','#B6CCEA'))+
      scale_shape_manual(values=c(4,NA)) +
      scale_x_date(expand=c(0.01,0.01))+
      facet_wrap(~variable,nrow=4,scales="free_y")+
      xlab(NULL) + ylab(NULL)+theme_bw()+
      guides(col=guide_legend(reverse=T),shape=guide_legend(reverse=T))+
      theme(strip.background=element_blank(),
            strip.text=element_text(size=text_size),
            legend.key=element_rect(colour="white"),
            legend.position="bottom",
            legend.title=element_blank(),
            legend.text=element_text(size=text_size),
            axis.text=element_text(size=text_size))
    print(p)
  }
  
  output$graphRoleVar <- renderPlot({
    doPlotRoleVar()  
  })
  
  output$graphRoleShock <- renderChart({
    n <- nPlot(value ~ time, data = dataRoleShock(), type = "lineWithFocusChart",group="shock")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$yAxis(tickFormat = specialtickDecompo(),showMaxMin = FALSE)
    n$y2Axis(tickFormat ="#!function (d) {return d3.format(',.1%')(d);}!#",showMaxMin = FALSE)
    n$x2Axis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$set(dom = 'graphRoleShock', width = 700,height=400)
    n
  })
  
  output$graphDecompo <- renderChart({
    n <- nPlot(value ~ time, data = dataDecompo(), type = "multiBarChart",group="shock")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$yAxis(tickFormat = specialtickDecompo(),showMaxMin = TRUE)
    n$chart(showControls=FALSE,stacked=TRUE)
    n$set(dom = 'graphDecompo', width = 700,height=400)
    n
  })
  
  output$tabVarDecompo <- renderDataTable({dataVarDecompo()[,-1]},options=list(bPaginate=FALSE,bLengthChange=FALSE,bFilter=FALSE,bSort=0,bInfo=0))
  
  doPlotBirf <- function(text_size=10){
    p <- ggplot(data=dataBirf(),aes(x=time,y=mean,group=shock))+
      geom_line(size=0.8,colour="#1F77B4")+
      geom_ribbon(aes(ymin=inf,ymax=sup),alpha=0.6,fill="#D6E3F3")+
      facet_wrap(~variable,nrow=4,scales="free_y")+
      scale_x_discrete(breaks=c(10,20,30,40),expand=c(0.01,0.01))+
      xlab(NULL) + ylab(NULL)+theme_bw()+
      theme(strip.background=element_blank(),
            strip.text=element_text(size=text_size),
            legend.key=element_rect(colour="white"),
            legend.position="bottom",
            legend.title=element_blank(),
            legend.text=element_text(size=text_size),
            axis.text=element_text(size=text_size))
    print(p)
  }
  
  output$graphBirf <- renderPlot({
    doPlotBirf()  
  })
  
  doPlotCounterfact <- function(text_size=10){
    if (input$VarCounterfact=="struc"){
      p<-ggplot(data=dataCounterfact(),aes(x=time,y=value,color=country_shock,group=country_shock))+
        geom_line(size=0.8)+facet_wrap(~variable,nrow=4,scales="free_y")+scale_color_manual(values=c('#1F77B4','#B6CCEA'))
    } else{
      p<-ggplot(data=dataCounterfact(),aes(x=time,y=value,color=country_model,group=country_model))+
        geom_line(size=0.8)+facet_wrap(~variable,nrow=4,scales="free_y")+scale_color_manual(values=c('#1F77B4','#B6CCEA'))
    }
    p <- p + xlab(NULL) + ylab(NULL)+theme_bw()+
      scale_x_date(expand=c(0.01,0.01))+
      theme(strip.background=element_blank(),
            strip.text=element_text(size=text_size),
            legend.key=element_rect(colour="white"),
            legend.position="bottom",
            legend.title=element_blank(),
            legend.text=element_text(size=text_size),
            axis.text=element_text(size=text_size))
    print(p)
  }
  
  output$graphCounterfact <- renderPlot({
    doPlotCounterfact()  
  })
  
  doPlotForecast <- function(text_size=10){
    p <- ggplot(data=dataForecast(),aes(x=time,y=int50))+
      geom_ribbon(aes(ymin=int20,ymax=int80),alpha=0.3,fill="#D6E3F3") +
      geom_ribbon(aes(ymin=int30,ymax=int70),alpha=0.6,fill="#D6E3F3") +
      geom_ribbon(aes(ymin=int40,ymax=int60),alpha=0.9,fill="#D6E3F3") +
      geom_line(data=subset(dataForecast(),time>="2013-12-01"),size=0.73,linetype="dashed",colour="#1F77B4")+
      geom_line(data=subset(dataForecast(),time<="2013-12-01"),size=0.8,colour="#1F77B4")+ 
      scale_x_date(expand=c(0.01,0.01))+
      facet_wrap(~obs,nrow=4,scales="free_y")+
      xlab(NULL) + ylab(NULL)+theme_bw()+
      theme(strip.background=element_blank(),
            strip.text=element_text(size=text_size),
            legend.key=element_rect(colour="white"),
            legend.position="bottom",
            legend.title=element_blank(),
            legend.text=element_text(size=text_size),
            axis.text=element_text(size=text_size))
    print(p)
  }
  
  output$graphForecast <- renderPlot({
    doPlotForecast()  
  })
  
  output$tabPosterior <- renderDataTable({dataPosterior()},options=list(bPaginate=FALSE,bLengthChange=FALSE,bFilter=FALSE,bSort=0,bInfo=0))

  output$txtSource<-renderUI({includeRmd('essai.Rmd')})
  
  #Download
  #motiv1["shock"]<-"index"
  output$downloadDataMotiv <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(rbind(motiv1,motiv2), file)})
  
  output$downloadDataResult <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(result, file)})
  
#   output$downloadGraphRole <- downloadHandler(filename = 'plot.pdf',
#                                                 content = function(file){
#                                                   pdf(file = file)
#                                                   doPlotRole(text_size=7)
#                                                   dev.off()
#                                                 })
  output$downloadDataRoleShock <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(rbind(decompo,sum), file)})
  
  output$downloadDataDecompo <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(decompo, file)})
  
  output$downloadDataVarDecompo <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(vardecompo, file)})
  
  output$downloadGraphBirf <- downloadHandler(filename = 'plot.pdf',
                                               content = function(file){
                                                 pdf(file = file)
                                                 doPlotBirf(text_size=7)
                                                 dev.off()
                                               }
                                             )
  
  output$downloadDataBirf <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(rbind(birf,sum), file)})
  output$downloadDataCounterfact <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(rbind(counterfact,sum), file)})
  output$downloadDataForecast <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(rbind(forecast,sum), file)})
  
  output$downloadGraphCounterfact <- downloadHandler(filename = 'plot.pdf',
                                             content = function(file){
                                               pdf(file = file)
                                               doPlotCounterfact(text_size=7)
                                               dev.off()
                                             })
  
  output$downloadGraphForecast <- downloadHandler(filename = 'plot.pdf',
                                                  content = function(file){
                                                    pdf(file = file)
                                                    doPlotForecast(text_size=7)
                                                    dev.off()
                                                  })
  
  output$downloadDataPosterior <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(posterior, file)})
  
  #Options
  output$pageviews <-  renderText({
    if (!file.exists("pageviews.Rdata")) pageviews <- 0 else load(file="pageviews.Rdata")
    pageviews <- pageviews + 1
    save(pageviews,file="pageviews.Rdata")
    paste("Visits:",pageviews)
  })
  
  output$activeTab <- reactive({
    return(input$tsp)
  })
  outputOptions(output, 'activeTab', suspendWhenHidden=FALSE)
  
})

