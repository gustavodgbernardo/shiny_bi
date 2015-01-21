library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Neoway - RDashboard"),

  sidebarLayout(
    sidebarPanel(
           h3("Importar tabelas"),
           radioButtons("importa_tabela", 
                              label = h5("selecione uma opção"), 
                              choices = list("Importar local" = 1, 
                              "importar servidor" = 2, "importar banco" = 3),
           selected = 1), 
           conditionalPanel(
             condition = "input.importa_tabela == 1",
             fileInput("file", label = h5("Importar local"),accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
             checkboxInput('header', 'Header', TRUE),
             radioButtons('sep', 'Separator',
                          c(Comma=',',
                            Semicolon=';',
                            Tab='\t'),
                          ';'),
             radioButtons('quote', 'Quote',
                          c(None='',
                            'Double Quote'='"',
                            'Single Quote'="'"),
                          '"')
           ),
           conditionalPanel(
             condition = "input.importa_tabela == 2",
             textInput("text", label = h5("Importar servidor"),value = ""),
             checkboxInput('header', 'Header', TRUE),
             radioButtons('sep', 'Separator',
                          c(Comma=',',
                            Semicolon=';',
                            Tab='\t'),
                          ';'),
             radioButtons('quote', 'Quote',
                          c(None='',
                            'Double Quote'='"',
                            'Single Quote'="'"),
                          '"')
           ),
           conditionalPanel(
             condition = "input.importa_tabela == 3",
             h5("Importar SQL"),
             textInput("usuario", label = h5("usuario"),value = ""),
             textInput("senha", label = h5("senha"),value = ""),
             textInput("query", label = h5("query"),value = "")
           ),
           actionButton("proximo", label = "Próximo")),
    mainPanel(uiOutput("out_eixox"),
              uiOutput("out_eixoy"),
              uiOutput("out_filtro"),
              uiOutput("aplica_filtros"),
              actionButton("grafico", label = "Gráfico")
            )
    )
          
))