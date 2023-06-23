library(shiny)
library(DT)
library(ggplot2)
library(dplyr)
library(palmerpenguins)

ui <- fluidPage(
  titlePanel("펭귄 데이터 분석"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("species", label = '펭귄을 선택하세요',
                         choices = list('Adelie', 'Gentoo', 'Chinstrap'),
                         selected = 'Adelie'),
      selectInput("x","x 선택하세요", 
                  choices = list('bill_length_mm','body_mass_g','bill_depth_mm',
                                 "flipper_length_mm", "body_mass_g")),
      selectInput("y", "Y 선택하세요", 
                  choices = list('bill_length_mm','body_mass_g','bill_depth_mm',
                                 "flipper_length_mm", "body_mass_g")),
      
      sliderInput("slider1", 'size', min = 1, max = 10, value = 5)
    ),
    mainPanel(
      dataTableOutput('penguins_table'),
      plotOutput('penguins_plot')
    )
  )
)

server <- function(input, output, session) {
  sel <- reactive({
    penguins %>%
      select("species", "island", "bill_length_mm", 
             "bill_depth_mm", "flipper_length_mm", 
             "body_mass_g", "sex", "year") %>%
      filter(species %in% input$species)
  })
  
  output$penguins_table <- renderDataTable({
    sel() %>%
      datatable()
  })
  
  output$penguins_plot <- renderPlot({
    sel() %>%
      ggplot(aes(x = !!sym(input$x), y = !!sym(input$y), color = species, shape = sex)) +
      geom_point(size = input$slider1)
  })
}

shinyApp(ui, server)
