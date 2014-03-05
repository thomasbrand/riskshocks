library(shiny)
library(rCharts)

shinyServer(function(input, output) {
  
  dataL <- reactive({subset(dataLevel,variable == input$Obsvar)})
  dataR <- reactive({
    if (input$withoutmean){
      if (input$rawdataCMR){
        data <- rbind(subset(dataRaw,variable == input$Obsvar1 & shock %in% c('rawdata4withoutmean','rawdataCMR')))
      } else{
        data <- rbind(subset(dataRaw,variable == input$Obsvar1 & shock == 'rawdata4withoutmean'))
      }
    } else{
      data <- subset(dataRaw,variable == input$Obsvar1 & shock == 'rawdata4withmean')
    }
  })
  
  dataD <- reactive({subset(dataDecompo,variable == input$Obsvar2 & country == input$Country)})
  dataS <- reactive({subset(dataSum, variable == input$Obsvar2 & country == input$Country)})
  dataDS <- reactive({rbind(dataD(),
                            dataS(),
                            subset(dataRaw,variable == input$Obsvar2 & country == input$Country & shock == 'rawdata4withoutmean'))})

  output$cumuLine <- renderChart({
    n <- nPlot(value ~ time, data=dataL(), type = "cumulativeLineChart",group="country")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format('.2f')(d);}!#",showMaxMin = FALSE)
    n$chart(showControls=TRUE,useInteractiveGuideline=TRUE)
    n$set(dom = 'cumuLine', width = 700,height=400)
    n
  })
  
  output$simpleLine <- renderChart({
    n <- nPlot(value ~ time, data=dataR(),type = "lineChart",group="country")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format(',.1%')(d);}!#",showMaxMin = TRUE)
    n$chart(useInteractiveGuideline=TRUE)
    n$set(dom = 'simpleLine', width = 700,height=400)
    n
  })
  
  output$simpleLine2 <- renderChart({
    n <- nPlot(value ~ time, data=dataDefSim,type = "lineChart",group="variable")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format(',.1%')(d);}!#",showMaxMin = TRUE)
    n$chart(useInteractiveGuideline=TRUE)
    n$set(dom = 'simpleLine2', width = 700,height=400)
    n
  })
  
  output$multiBar <- renderChart({
    n <- nPlot(value ~ time, data = dataD(), type = "multiBarChart",group="shock")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format(',.1%')(d);}!#",showMaxMin = TRUE)
    n$chart(showControls=FALSE,stacked=TRUE)
    n$set(dom = 'multiBar', width = 700,height=400)
    n
  })
  
  output$focusLine <- renderChart({
    n <- nPlot(value ~ time, data = dataDS(), type = "lineWithFocusChart",group="shock")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format(',.1%')(d);}!#",showMaxMin = FALSE)
    #n$y2Axis(tickFormat ="#!function (d) {return d3.format(',.1%')(d);}!#",showMaxMin = FALSE)
    n$x2Axis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$set(dom = 'focusLine', width = 700,height=400)
    n
  })
  
  output$table <- renderDataTable({
    dataTable[,-1]<-round(dataTable[,-1],4)
    dataTable
  },options=list(iDisplayLength=20,aLengthMenu=list(c(10,20,50),c(10,20,"All"))))
  
  output$downloadDataRaw <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(dataRaw, file)})
  output$downloadDataDecompo <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(rbind(dataDecompo,dataSum), file)})
  output$downloadDataTable <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(dataTable, file)})
  
  output$pageviews <-  renderText({
    if (!file.exists("pageviews.Rdata")) pageviews <- 0 else load(file="pageviews.Rdata")
    pageviews <- pageviews + 1
    save(pageviews,file="pageviews.Rdata")
    paste("Visits :",pageviews)
  })

})





