
    

fluidPage(
    # Application title
    titlePanel("Horloge parlante"),
    sidebarLayout(
        # Sidebar with a slider and selection inputs
        sidebarPanel(
            selectInput("selection", "Choisir un média :",
                        choices = channels),
            #actionButton("update", "Change"),
            hr(),
            sliderInput("year",
                        "Année :",
                        min = 2001,  max = 2019, value = 2010, sep = ""),
            sliderInput("hour",
                        "Heure :",
                        min = 5,  max = 23,  value = 10)
        ),
        
        # Show Word Cloud
        mainPanel(
            p("À l’aide de données récoltées par l’INA (Doukhan & Carrive, 2018), cette horloge interactive propose une visualisation du taux d’expression masculine et féminine sur plusieurs chaînes d'information (radio et télévision), pour différentes années et différentes heures de la journée."),
            p("Le taux d’expression féminine (resp. masculine) est défini comme le pourcentage de temps de parole attribué aux femmes (resp. aux hommes)"),
            plotOutput("plot")
        )
    )
)