library(shiny)
library(rCharts)
library(ggplot2)

shinyServer(function(input, output,session) {
  
  dataL <- reactive({
    subdata <- subset(dataLevel,variable == input$ObsMotiv1  & time>=input$TimeMotiv[1] & time<=input$TimeMotiv[2])
    subdataIndex <- ddply(subdata,.(country,variable),transform,index=value/value[1]*100)
    })
  dataR <- reactive({
    if (input$withoutmean){
      if (input$rawdataCMR){
        data <- rbind(subset(dataRaw,variable == input$ObsMotiv2 & shock %in% c('rawdata (without mean)','rawdataCMR') & time>=input$TimeMotiv[1] & time<=input$TimeMotiv[2]))
      } else{
        data <- rbind(subset(dataRaw,variable == input$ObsMotiv2 & shock == 'rawdata (without mean)' & time>=input$TimeMotiv[1] & time<=input$TimeMotiv[2]))
      }
    } else{
      data <- subset(dataRaw,variable == input$ObsMotiv2 & shock == 'rawdata (with mean)' & time>=input$TimeMotiv[1] & time<=input$TimeMotiv[2])
    }
  })
  
  dataSL <- reactive({
    subdata <- subset(dataSimLev,variable == input$ObsRes & shock %in% c(input$ShockRes,'sum of shocks') & time>=input$TimeRes[1] & time<=input$TimeRes[2])
    subdataIndex <- ddply(subdata,.(country,variable,shock),transform,index=value/value[1]*100)
    })
  
  dataF <- reactive({
    rbind(subset(dataDecompo,shock == input$ShockFacet & country == input$CountryFacet),
          subset(dataRaw, country == input$CountryFacet & shock == 'rawdata (without mean)')
    )
  })
  
  dataFore <- reactive({subset(dataForecast,country == input$CountryForecast)})
  
  dataB <- reactive({subset(dataBirf,shock == input$ShockB & country == input$CountryB)})
  
  dataD <- reactive({subset(dataDecompo,variable == input$ObsDecompo & country == input$CountryDecompo)})
  dataS <- reactive({subset(dataSum, variable == input$ObsDecompo & country == input$CountryDecompo)})
  dataDS <- reactive({rbind(dataD(),
                            dataS(),
                            subset(dataRaw,variable == input$ObsDecompo & country == input$CountryDecompo & shock == 'rawdata (without mean)'))})
  
  dataC <- reactive({
    if (input$VarCount=="struc"){
      data <- subset(dataCount,country_model==input$Country_model)
    } else{
      data <- subset(dataCount,country_shock==input$Country_shock)
    }
  })
    
  specialtickM<-reactive({
    if (input$ObsMotiv2 == "Hours worked (log)"){
      tick<-"#!function (d) {return d3.format('.2f')(d);}!#"
    } else{
      tick<-"#!function (d) {return d3.format(',.1%')(d);}!#"
    }
  })
  
  specialtickD<-reactive({
    if (input$ObsDecompo == "Hours worked (log)"){
      tick<-"#!function (d) {return d3.format('.2f')(d);}!#"
    } else{
      tick<-"#!function (d) {return d3.format(',.1%')(d);}!#"
    }
  })
  
  output$captionMotiv1<-renderText({
    input$ObsMotiv1
  })
  output$captionMotiv2<-renderText({
    input$ObsMotiv2
  })
  output$captionRes<-renderText({
    input$ObsRes
  })
  output$captionF<-renderText({
    input$ShockFacet
  })
  output$captionB<-renderText({
    input$ShockB
  })
  output$captionD1<-renderText({
    input$ObsDecompo
  })
  output$captionD2<-renderText({
    input$ObsDecompo
  })

  output$captionC <- renderText({
    if (input$VarCount=="struc"){
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
  
  output$indexLineMotiv <- renderChart({
    n <- nPlot(index ~ time, data=dataL(), type = "lineChart",group="country")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=FALSE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format('.1f')(d);}!#",showMaxMin = FALSE)
    n$chart(useInteractiveGuideline=TRUE)
    n$set(dom = 'indexLineMotiv', width = 700,height=380)
    n
  })
  
  output$simpleLineMotiv <- renderChart({
    n <- nPlot(value ~ time, data=dataR(),type = "lineChart",group="country")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=FALSE)
    n$yAxis(tickFormat = specialtickM(),showMaxMin = TRUE)
    n$chart(useInteractiveGuideline=TRUE)
    n$set(dom = 'simpleLineMotiv', width = 700,height=380)
    n
  })
  
  output$indexLineRes <- renderChart({
    n <- nPlot(index ~ time, data=dataSL(), type = "lineChart",group="new")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=FALSE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format('.1f')(d);}!#",showMaxMin = FALSE)
    n$chart(useInteractiveGuideline=TRUE)
    n$set(dom = 'indexLineRes', width = 700,height=380)
    n
  })
  
  doPlotR <- function(text_size=10){
    p <- ggplot(data=dataF(),aes(x=time,y=value,group=shock,color=shock))+
      geom_line(size=0.8)+geom_point(aes(shape=shock),size=2)+
      scale_color_manual(values=c('#1F77B4','#B6CCEA'))+
      scale_shape_manual(values=c(4,NA)) +
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
  
  output$facetLineR <- renderPlot({
    doPlotR()  
  })
  
  doPlotB <- function(text_size=10){
    p <- ggplot(data=dataB(),aes(x=time,y=mean,group=shock))+
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
  
  output$facetLineB <- renderPlot({
    doPlotB()  
  })
  
  doPlotF <- function(text_size=10){
    p <- ggplot(data=dataFore(),aes(x=time,y=mean))+
      geom_line(size=0.8,colour="#1F77B4")+ 
      geom_ribbon(aes(ymin=inf,ymax=sup),alpha=0.6,fill="#D6E3F3") +
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
  
  output$facetLineF <- renderPlot({
    doPlotF()  
  })
  
  doPlotC <- function(text_size=10){
    if (input$VarCount=="struc"){
      p<-ggplot(data=dataC(),aes(x=time,y=value,color=country_shock,group=country_shock))+
        geom_line(size=0.8)+facet_wrap(~variable,nrow=4,scales="free_y")+scale_color_manual(values=c('#1F77B4','#B6CCEA'))
    } else{
      p<-ggplot(data=dataC(),aes(x=time,y=value,color=country_model,group=country_model))+
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
  
  output$facetLineC <- renderPlot({
    doPlotC()  
  })
  
  output$multibar <- renderChart({
    n <- nPlot(value ~ time, data = dataD(), type = "multiBarChart",group="shock")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$yAxis(tickFormat = specialtickD(),showMaxMin = TRUE)
    n$chart(showControls=FALSE,stacked=TRUE)
    n$set(dom = 'multibar', width = 700,height=400)
    n
  })
  
  output$focusLine <- renderChart({
    n <- nPlot(value ~ time, data = dataDS(), type = "lineWithFocusChart",group="shock")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$yAxis(tickFormat = specialtickD(),showMaxMin = FALSE)
    #n$y2Axis(tickFormat ="#!function (d) {return d3.format(',.1%')(d);}!#",showMaxMin = FALSE)
    n$x2Axis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$set(dom = 'focusLine', width = 700,height=400)
    n
  })
  
  output$table <- renderDataTable({
    dataTable[,-c(1,2)]<-round(dataTable[,-c(1,2)],8)
    subset(dataTable,select=c("names",input$varTable))
  },options=list(bPaginate=FALSE,bLengthChange=FALSE))

  #iDisplayLength=20
  #,aLengthMenu=list(c(10,20,50),c(10,20,"All"))
  
  dataLevel["shock"]<-"index"
  output$downloadDataRaw <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(rbind(dataRaw,dataLevel), file)})
  output$downloadDataRes <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(dataSimLev, file)})
  output$downloadDataDecompo <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(rbind(dataDecompo,dataSum), file)})
  output$downloadDataTable <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(dataTable, file)})
  
  output$downloadGraphForecast <- downloadHandler(filename = 'plot.pdf',
                                             content = function(file){
                                               pdf(file = file)
                                               doPlotF(text_size=7)
                                               dev.off()
                                             })
  
  output$downloadGraphRes <- downloadHandler(filename = 'plot.pdf',
                                                content = function(file){
                                                  pdf(file = file)
                                                  doPlotR(text_size=7)
                                                  dev.off()
                                                })

  output$downloadGraphB <- downloadHandler(filename = 'plot.pdf',
                                             content = function(file){
                                               pdf(file = file)
                                               doPlotB(text_size=7)
                                               dev.off()
                                             })
  
  output$downloadGraphC <- downloadHandler(filename = 'plot.pdf',
                                             content = function(file){
                                               pdf(file = file)
                                               doPlotC(text_size=7)
                                               dev.off()
                                             })
  
  output$pageviews <-  renderText({
    if (!file.exists("pageviews.Rdata")) pageviews <- 0 else load(file="pageviews.Rdata")
    pageviews <- pageviews + 1
    save(pageviews,file="pageviews.Rdata")
    paste("Visits:",pageviews)
  })
  
  output$activeTab <- reactive({
    return(input$tsp)
  })
  outputOptions(output, 'activeTab', suspendWhenHidden=F)
  
  output$datadesc<-renderUI({includeRmd('essai.Rmd')})

})

