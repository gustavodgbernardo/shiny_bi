library(shiny)
library(Hmisc)


# teste

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("RDashboard"),

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
    mainPanel(
          column(3,
             conditionalPanel(
               condition = "input.proximo > 0",
               selectInput('tipo_grafico', 'Graficos',
                            list(
                              "Linhas" = 2,
                              "Barras" = 3,
                              "Pizza" = 4,
                              "Histograma" = 5,
                              "Box-plot" = 6,
                              "Area" = 7
                            ))
              ),
             actionButton("grafico", label = "Gráfico")
          ),  
          column(4,
              uiOutput("out_elemento_linha")

          ),
          column(4,
              uiOutput("out_eixox"),
              conditionalPanel(
                condition = "(input.tipo_grafico == 2) & (input.proximo > 0)",
                selectInput('tipo_op', 'Tipo Operacao',
                            c("",
                              "soma" ,
                              "media" ,
                              "contar" 
                            ))
              ),
              uiOutput("out_grupo"),
              uiOutput("out_filtro"),
              uiOutput("aplica_filtros")
          ),
          plotOutput("graf_linhas")
    )       
  )          
))