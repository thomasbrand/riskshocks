library(shiny)
library(rCharts)

shinyServer(function(input, output) {
  
  dataDecompo <- reactive({subset(dataD,variable == input$Obsvar2 & country == input$Country)})
  dataRaw <- reactive({subset(rawdatawitherror, variable == input$Obsvar2 & country == input$Country)})
  dataDecompoRaw <- reactive({rbind(dataDecompo(),dataRaw())})

  output$simpleLine <- renderChart({
    if (input$withoutmean) {
      dataObserv <- reactive({subset(rawdata4,variable == input$Obsvar1 & shock == 'rawdata4withoutmean')})
    } else {
      dataObserv <- reactive({subset(rawdata4,variable == input$Obsvar1 & shock == 'rawdata4withmean')})
    }
    n <- nPlot(value ~ time, data=dataObserv(),type = "lineChart",group="country")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format(',.1%')(d);}!#",showMaxMin = TRUE)
    n$set(dom = 'simpleLine', width = 700,height=400)
    n
  })
  
  #if
#   output$cumuLine <- renderChart({
#     n <- nPlot(value ~ time, data=dataObserv(), type = "cumulativeLineChart",group="country")
#     n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
#     n$yAxis(tickFormat ="#!function (d) {return d3.format(',.1%')(d);}!#",showMaxMin = TRUE)
#     n$chart(showControls=FALSE,useInteractiveGuideline=TRUE)
#     n$set(dom = 'cumuLine', width = 700,height=400)
#     n
#   })
  
  output$multiBar <- renderChart({
    n <- nPlot(value ~ time, data = dataDecompo(), type = "multiBarChart",group="shock")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format(',.1%')(d);}!#",showMaxMin = TRUE)
    n$chart(showControls=FALSE,stacked=TRUE)
    n$set(dom = 'multiBar', width = 700,height=400)
    n
  })
  
  output$focusLine <- renderChart({
    n <- nPlot(value ~ time, data = dataDecompoRaw(), type = "lineWithFocusChart",group="shock")
    n$xAxis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$yAxis(tickFormat ="#!function (d) {return d3.format(',.1%')(d);}!#",showMaxMin = FALSE)
    #n$y2Axis(tickFormat ="#!function (d) {return d3.format(',.1%')(d);}!#",showMaxMin = FALSE)
    n$x2Axis(tickFormat ="#!function (d) {return d3.time.format('%m/%Y')(new Date(d * 86400000 ));}!#",showMaxMin=TRUE)
    n$set(dom = 'focusLine', width = 700,height=400)
    n
  })
  
  output$table <- renderTable({
    dataTable
  })
  
  output$downloadRawdata <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(rawdata4, file)})
  output$downloadDataD <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(dataD, file)})
  output$downloadDataTable <- downloadHandler(filename = 'data.csv', content = function(file) {write.csv(dataTable, file)})
  
})