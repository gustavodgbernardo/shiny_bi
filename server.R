library(shiny)
library(Hmisc)

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
  output$out_elemento_linha <- renderUI({
    if ( input$proximo > 0 ){
      if (input$tipo_grafico == 2){
        checkboxGroupInput("elemento_linha", "Linhas", c(names(dados())))
      }
    }
  })
  output$out_eixox <- renderUI({
    if (input$proximo > 0){
      if (input$tipo_grafico == 2){
      selectInput("eixox", "Eixo x", c("",names(dados())))
      }
    }
  })
  output$out_filtro <- renderUI({
    if (input$proximo > 0){
      if (input$tipo_grafico == 2){
      selectInput("filtro", "Filtro", c("",names(dados())))
      }
    }
  })
  output$aplica_filtros <- renderUI({
    if (length(input$filtro) > 0) {
      if (input$filtro != ""){
        classe <- all.is.numeric(dados()[,input$filtro],extras=c('.','NA','',NA))
        if ( (classe) & (length(unique(dados()[,input$filtro])))>20){
          max <- max(dados()[,input$filtro],na.rm=T)
          min <- min(dados()[,input$filtro],na.rm=T)
          sliderInput("slider_filtro", "Selecionar filtro",
                      min = min, max = max, value = c(min, max))
        }else{
          seleciona <- unique(as.character(dados()[,input$filtro]))  
          checkboxGroupInput("selecao", "Selecionar filtro",seleciona)  
        }
      }
    }
  })
})