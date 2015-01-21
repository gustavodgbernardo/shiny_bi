library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output){
  dados <- reactive({
    if (input$proximo > 0){
      if (input$importa_tabela == 1){
        inFile <- input$file
        if (is.null(inFile))
          return(NULL)
        read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
      }
    }  
  })
  output$out_eixox <- renderUI({
    if (input$proximo > 0){
      selectInput("eixox", "Eixo x", c("",names(dados())))
    }
  })
  output$out_eixoy <- renderUI({
    if (input$proximo > 0){
      selectInput("eixoy", "Eixo y", c("",names(dados())))
    }
  })
  output$out_filtro <- renderUI({
    if (input$proximo > 0){
      selectInput("filtro", "Filtro", c("",names(dados())))
    }
  })
  output$aplica_filtros <- renderUI({
    if (length(input$filtro) > 0) {
      if (input$filtro != ""){
        seleciona <- unique(as.character(dados()[,input$filtro]))  
        checkboxGroupInput("selecao", "Selecionar filtro",seleciona)
      }
    }
  })
})