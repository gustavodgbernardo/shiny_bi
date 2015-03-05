library(shiny)
library(Hmisc)
library(ggplot2)
library(reshape2) 

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
  output$out_grupo <- renderUI({
    if (input$proximo > 0){
      if (input$tipo_grafico == 2){
        selectInput("grupo_linha", "Grupo", c("",names(dados())))
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
          sliderInput("selecao_slider", "Selecionar filtro",
                      min = min, max = max, value = c(min, max))
        }else{
          seleciona <- unique(as.character(dados()[,input$filtro]))  
          checkboxGroupInput("selecao_box", "Selecionar filtro",seleciona)  
        }
      }
    }
  })
  output$graf_linhas <- renderPlot({
      if (input$grafico > 0) {
        x <- input$eixox 
        linhas <- input$elemento_linha
        if (input$filtro != ""){
          if (length(input$selecao_box)>0){
            id <- which(dados()[,input$filtro] %in% input$selecao_box)
            tabela_grafico <- dados()[id,c(x,linhas)]
          }            
          if (length(input$selecao_slider)>0){
            id <- which( (dados()[,input$filtro] <= input$selecao_slider[2]) & (dados()[,input$filtro] >= input$selecao_slider[1]) )
            tabela_grafico <- dados()[id,c(x,linhas)]
          }
          if ( (length(input$selecao_slider)==0) & (length(input$selecao_box)==0) ){
            tabela_grafico <- dados()[,c(x,linhas)]
          }
          
        }else{
          tabela_grafico <- dados()[,c(x,linhas)]
        }
        
        mdf <- melt(tabela_grafico, id.vars=x)
        mdf[,x] <- factor(mdf[,x],unique(as.character(mdf[,x]))) 
        names(mdf)[1] <- 'eixox'
        ggplot(data=mdf, aes(x=eixox, y=value, group = variable , color = variable)) + geom_line() + geom_point()
      }
  })
})