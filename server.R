library(readxl)
library(shiny)

shinyServer(function(input, output) {
  data_team <- read_excel(path = "DATA/data.xlsx", col_names = TRUE, sheet = "CLUB")
  data_country <- read_excel(path = "DATA/data.xlsx", col_names = TRUE, sheet = "COUNTRY")
  data_player <- read_excel(path = "DATA/data.xlsx", col_names = TRUE, sheet = "PLAYER")
  data_perform <- read_excel(path = "DATA/data.xlsx", col_names = TRUE, sheet = "PERFORM")
  
  data <- merge(x = data_player, y = data_country, by.x = "NATION", by.y = "ABV_COUNTRY", all.x = TRUE)
  data <- merge(x = data, y = data_perform, by.x = "ID_PLAYER", by.y = "ID_PLAYER", all.x = TRUE)
  data <- merge(x = data_team, y = data, by.x = "ID_CLUB", by.y = "ID_CLUB", all.x = TRUE)
  
  data <- data[,c(-1,-3,-4,-9)]
  
  output$title <- renderText({
    paste("<div id='header' >
          <br/>
          <i>HABDI Souleimane, VIENNE Soleymane, NICOLAS Romain & ROUVEURE Kylian</i>
          <br/><br/>
          <center><strong style='text-decoration: underline;font-weight: lighter;font-size:2em;' >
            Projet R : Ligue 1 Uber Eats
          </strong></center>
          </div>")
  })
  
  output$table_data <- renderTable({
    data_2 <- data[(data[,11]>0), ]
    data_good <- data_2[order(data_2[,11],decreasing=F), ]
  })
})