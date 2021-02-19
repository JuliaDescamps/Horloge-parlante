
function(input, output, session) {
    # Define a reactive expression for the document term matrix
    terms <- reactive({
        # Change when the "update" button is pressed...
        input$update
        # ...but not for anything else
        isolate({
            withProgress({
                setProgress(message = "Processing...")
         #       getTermMatrix(input$selection)
         
            })
        })
    })




    output$plot <- renderPlot({
        one_hour_pie(channel = as.factor(input$selection), year = as.character(input$year), hour = as.character(input$hour))
    })
}