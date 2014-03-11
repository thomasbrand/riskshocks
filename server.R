library(shiny)
library(rCharts)
library(ggplot2)

shinyServer(function(input, output) {
  
  dataL <- reactive({subset(dataLevel,variable == input$Obsvar)})
  dataR <- reactive({
    if (input$withoutmean){
      if (input$rawdataCMR){
        data <- rbind(subset(dataRaw,variable == input$Obsvar1 & shock %in% c('rawdata (without mean)','rawdataCMR')))
      } else{
        data <- rbind(subset(dataRaw,variable == input$Obsvar1 & shock == 'rawdata (without mean)'))
      }
    } else{
      data <- subset(dataRaw,variable == input$Obsvar1 & shock == 'rawdata (with mean)')
    }
  })
  
  dataD <- reactive({subset(dataDecompo,variable == input$Obsvar2 & country == input$Country)})
  dataS <- reactive({subset(dataSum, variable == input$Obsvar2 & country == input$Country)})
  dataDS <- reactive({rbind(dataD(),
                            dataS(),
                            subset(dataRaw,variable == input$Obsvar2 & country == input$Country & shock == 'rawdata (without mean)'))})
  
  dataF <- reactive({
    rbind(subset(dataDecompo,shock == input$Shock & country == input$Country2),
                           subset(dataRaw, country == input$Country2 & shock == 'rawdata (without mean)')
                )
  })
  
  specialtickM<-reactive({
    if (input$Obsvar1 == "Hours worked per capita (log)"){
      tick<-"#!function (d) {return d3.format('.2f')(d);}!#"
    } else{
      tick<-"#!function (d) {return d3.format(',.1%')(d);}!#"
    }
  })
  
  specialtickD<-reactive({
    if (input$Obsvar2 == "Hours worked per capita (log)"){
      tick<-"#!function (d) {return d3.format('.2f')(d);}!#"
    } else{
      tick<-"#!function (d) {return d3.format(',.1%')(d);}!#"
    }
  })
  
  output$captionM<-renderText({
    input$Obsvar
  })
  output$captionM1<-renderText({
    input$Obsvar1
  })
  output$captionF<-renderText({
    input$Shock
  })
  output$captionD1<-renderText({
    input$Obsvar2
  })
  output$captionD2<-renderText({
    input$Obsvar2
  })

  output$cumuLine <- renderChart({
    n <- nPlot(value ~ time, data=dataL(), type = "cumulativeLineChart",group="country")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=FALSE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format('.2f')(d);}!#",showMaxMin = FALSE)
    n$chart(showControls=TRUE,useInteractiveGuideline=TRUE)
    n$set(dom = 'cumuLine', width = 700,height=380)
    n
  })
  
  output$simpleLine <- renderChart({
    n <- nPlot(value ~ time, data=dataR(),type = "lineChart",group="country")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=FALSE)
    n$yAxis(tickFormat = specialtickM(),showMaxMin = TRUE)
    n$chart(useInteractiveGuideline=TRUE)
    n$set(dom = 'simpleLine', width = 700,height=380)
    n
  })
  
  output$facetLine <- renderPlot({
    p <- ggplot(data=dataF(),aes(x=time,y=value,color=shock,group=shock))+
      geom_line(size=0.8)+scale_color_manual(values=c('#1F77B4','#B6CCEA'))+
      facet_wrap(~variable,nrow=5,scales="free_y")+
      xlab(NULL) + ylab(NULL)+theme_bw()+
      theme(strip.background=element_blank(),
            strip.text.x=element_text(size=11),
            legend.key=element_rect(colour="white"),
            legend.position=c(0.5,0.1),
            legend.title=element_blank(),
            legend.text=element_text(size=11))
    facetAdjust(p)
    #print(p)
#     data$time<-as.character(data$time)
#     r <- rPlot(value ~ time, color = 'shock', data = data, type = 'line',group='shock')
#     r$facet(var = 'variable', type = 'wrap', cols = 2)
#     r$guides(
#       x=list(title=""),
#       y=list(title="",min=0,max=0.05))
#     )
#     r$set(dom = 'facetLine', width = 700,height=800,legendPosition="bottom")
#     r
    
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
    dataTable[,-1]<-round(dataTable[,-1],4)
    dataTable
  },options=list(iDisplayLength=20,aLengthMenu=list(c(10,20,50),c(10,20,"All"))))

  dataLevel["shock"]<-"index"
  output$downloadDataRaw <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(rbind(dataRaw,dataLevel), file)})
  output$downloadDataDecompo <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(rbind(dataDecompo,dataSum), file)})
  output$downloadDataTable <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(dataTable, file)})
  
  output$pageviews <-  renderText({
    if (!file.exists("pageviews.Rdata")) pageviews <- 0 else load(file="pageviews.Rdata")
    pageviews <- pageviews + 1
    save(pageviews,file="pageviews.Rdata")
    paste("Visits:",pageviews)
  })

})

