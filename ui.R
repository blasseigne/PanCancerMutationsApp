library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  # Application title
  titlePanel(
    h1("TCGA PanCancer Somatic Mutations", align="center")),
  
  # Sidebar, information about where variants came from, etc.--should we specify this is fro the example dataset?
  sidebarLayout(
    sidebarPanel(
      h5("TCGA PanCancer Somatic Mutation Data"), 
      p("Variant data was accessed from:"), 
      a("Kandoth, et al. 2013", href="http://www.nature.com/nature/journal/v502/n7471/full/nature12634.html"), 
      br(),
      br(),
      p("These variants were annotated with the HudsonAlpha Institute for Biotechnology Variant Annotation pipeline and v1.3 CADD scores"), 
      br(), 
      h5("More information about CADD and c scores can be found here:"),
      a("Combined Annotation Dependent Depletion (CADD)", href="http://cadd.gs.washington.edu"), 
      br(),
      a("Kircher & Witten, et al. 2014", href="http://www.nature.com/ng/journal/v46/n3/full/ng.2892.html"),
      br(), 
      br(), 
      br(), 
      br(),
      p("Developed and Maintained by:"),
      a("Rick Myers' and", href="http://research.hudsonalpha.org/Myers/"),
      a("Sara Cooper's Labs", href="http://research.hudsonalpha.org/CooperS/"),
      p("Contacts:  Brittany Lasseigne (blasseigne@hudsonalpha.org) and Ryne Ramaker (rramaker@hudsonalpha.org)"),
      br(),
      a("HudsonAlpha Institute for Biotechnology", href="http://hudsonalpha.org"),
      img(src = "hudson-logo.png", height=50, width=200)
    ),
    
    # Set up tabs for the main panel
    mainPanel(
      tabsetPanel(
        tabPanel("Summary", 
                 br(), 
                 fluidRow(
                   column(12, align="center",
                          textOutput("variantCount"), 
                          textOutput("sampleCount"), 
                          textOutput("cancerCount"), 
                          br()
                   )
                 ),
                 fluidRow(
                   column(5,
                          h5("Variant Classification in Dataset"),
                          plotOutput("bp") 
                   ),
                   column(6, offset=1,
                          h5("Samples per Cancer in Dataset"),
                          plotOutput("pieCancer")
                   ))
        ),
        tabPanel("Cancer Summary", 
                 dataTableOutput("cancerSummary")),
        tabPanel("Variants per Sample by Cancer", 
                 plotOutput("bp4"),
                 br()),
                 #p("*Samples with 3000+ variants were removed for this analysis")), 
        tabPanel("CADD Summary", plotOutput("scaledCADD"),
                 br(),
                 fluidRow(
                   column(2, 
                          selectInput("distributionData",
                                      label="Please select variant classification:",
                                      choices=list("All", "Missense", "Nonsense", "Nonstop", "RNA", "Silent", "Splice Site"),
                                      selected="All")),
                   column(2, offset=0.5, 
                          sliderInput("bins", "# of bins:", min=1, max=100, value=50)),
                   column(7, offset=0.5,
                          h4("Distribution Summary:"),
                          verbatimTextOutput("summary")))),
        tabPanel("Genes", 
                 br(),
                 h5("The following table displays the number of variants annotated to each gene and sorted by frequency."),
                 br(),
                p("Note:  You can search for your favorite gene in the box labeled 'Gene' found below the table."),
                 dataTableOutput("geneSummary"))
      )
    ))
))