#Library R Shiny
library(shiny)

#Library liées à la connexion des données
library(readxl)
library("RMySQL")

#Library pour l'export excel
library(writexl)

#Library pour formater les chiffres
library(scales)

shinyServer(function(input, output) {
  ## Code pour la connection avec une BDD Localhost ##
  #bdd <- dbConnect(MySQL(), user = 'root', password = NULL, dbname = 'projet_r', host = '127.0.0.1', charset='utf8')
  
  #data_team <- fetch(dbSendQuery(bdd, "SELECT * FROM club"))
  #data_country <- fetch(dbSendQuery(bdd, "SELECT * FROM country"))
  #data_player <-  fetch(dbSendQuery(bdd, "SELECT name FROM player"))
  #data_perform <-  fetch(dbSendQuery(bdd, "SELECT name FROM perform"))
  
  
  ## Code pour la connection la base Excel ##
  #Recupération des différentes tables
  data_team <- read_excel(path = "DATA/data.xlsx", col_names = TRUE, sheet = "CLUB")
  data_country <- read_excel(path = "DATA/data.xlsx", col_names = TRUE, sheet = "COUNTRY")
  data_player <- read_excel(path = "DATA/data.xlsx", col_names = TRUE, sheet = "PLAYER")
  data_perform <- read_excel(path = "DATA/data.xlsx", col_names = TRUE, sheet = "PERFORM")
  
  #Jointure des différentes tables
  data <- merge(x = data_player, y = data_country, by.x = "NATION", by.y = "ABV_COUNTRY", all.x = TRUE)
  data <- merge(x = data, y = data_perform, by.x = "ID_PLAYER", by.y = "ID_PLAYER", all.x = TRUE)
  data <- merge(x = data_team, y = data, by.x = "ID_CLUB", by.y = "ID_CLUB", all.x = TRUE)
  
  #Table finale
  data <- data[,c(-1,-3,-4,-9)]
  
  
  #Header
  output$title <- renderText({
    paste("<div id='header' >
            <br/>
            <i>HADBI Souleimane, VIENNE Soleymane, DE NICOLA Romain & ROUVEURE Kylian</i>
            <br/><br/>
            <center><strong style='text-decoration: underline;font-weight: lighter;font-size:2em;' >
              Projet R : Ligue 1
            </strong></center>
          </div>")
  })
  
  #Fonctions du Content
  #Bouton de l'export des graphiques
  observeEvent(input$export_graph, {
    if(input$opt_player != "Tous") {
      player<-data[(data[2]==input$opt_player),]
    }
    else {
      if(input$opt_team != "Tous") {
        if(input$opt_pays != "Tous") {
          player<-data[(data[1]==input$opt_team),]
          player<-player[(player[6]==input$opt_pays),]
        }
        else {
          player<-data[(data[1]==input$opt_team),]
        }
      }
      else {
        if(input$opt_pays != "Tous") {
          player<-data[(data[6]==input$opt_pays),]
        }
        else {
          player<-data
        }
      }
    }
    
    jpeg("DOWNLOAD/GRAPH/graph.jpg")
    if(input$opt_var == 'AGE') {
      var <- player[3]
      boxplot(var, horizontal = TRUE, col = "lightgreen", main = "Partition de l'age des joueurs")
    }
    else if(input$opt_var == 'POSTE') {
      player <- player[-which(player[10]==0),]
      var1 <- player[,4]
      var2 <- player[,10]
      
      boxplot(var2~var1, main= "Partition de l'efficacité des joueurs par poste", color="blue",xlab="Poste",ylab="Efficacité",col="lightyellow")
    }
    else if(input$opt_var == 'VALEUR') {
      player <- player[-which(player[5]==0),]
      player <- player[,5]
      
      boxplot(player, ylim=c(1,170000000), main="Partition des joueurs par leurs valeurs en €", color="blue",col="lightyellow")
    }
    else if(input$opt_var == 'MINUTE') {
      player<-player[7]
      
      boxplot(player, main="Partition des joueurs par leurs minutes de jeu", color="lightgreen",col="lightgreen")
    }
    else if(input$opt_var == 'BUT') {
      player<-player[8]
      
      boxplot(player, main="Partition des joueurs par leurs buts", color="blue",col="lightyellow")
    }
    else if(input$opt_var == 'PASSE D') {
      player<-player[9]
      boxplot(player, main="Partition des joueurs par leurs buts", color="lightgreen",col="lightgreen")
    }
    else if(input$opt_var == 'EFFICACITE') {
      player<-player[10]
      
      boxplot(player, main="Partition des joueurs par leurs efficacitées", color="blue",col="lightyellow")
    }
    else if(input$opt_var == 'EFF/MIN') {
      player <- player[-which(player[11]==0),]
      player<-player[11]
      
      boxplot(player, main="Partition des joueurs par leurs efficacitées par minutes jouées", color="lightgreen",col="lightgreen")
    }
    else {
      if(input$opt_team != "Tous") {
        player<-table(player[6])
        player<-sort(player, decreasing = TRUE)
        barplot(player, main="Trie sur les pays par le nombre de joueurs", color="lightgreen",col="lightgreen", las = 2, cex.names = 1)
      }
      else {
        player<-table(player[1])
        player<-sort(player, decreasing = TRUE)
        barplot(player, main="Trie sur les equipes par le nombre de joueurs", color="lightgreen",col="lightgreen", las = 2, cex.names = 1)
      }
    }
    dev.off() 
  })
  
  #Sortie du graphique en fonction des filtres
  output$graph_data <- renderPlot({
    if(input$opt_player != "Tous") {
      player<-data[(data[2]==input$opt_player),]
    }
    else {
      if(input$opt_team != "Tous") {
        if(input$opt_pays != "Tous") {
          player<-data[(data[1]==input$opt_team),]
          player<-player[(player[6]==input$opt_pays),]
        }
        else {
          player<-data[(data[1]==input$opt_team),]
        }
      }
      else {
        if(input$opt_pays != "Tous") {
          player<-data[(data[6]==input$opt_pays),]
        }
        else {
          player<-data
        }
      }
    }
    
    if(input$opt_var == 'AGE') {
      var <- player[3]
      boxplot(var, horizontal = TRUE, col = "lightgreen", main = "Partition de l'age des joueurs")
    }
    else if(input$opt_var == 'POSTE') {
      player <- player[-which(player[10]==0),]
      var1 <- player[,4]
      var2 <- player[,10]
      
      boxplot(var2~var1, main= "Partition de l'efficacité des joueurs par poste", color="blue",xlab="Poste",ylab="Efficacité",col="lightyellow")
    }
    else if(input$opt_var == 'VALEUR') {
      player <- player[,5]
      
      boxplot(player, main="Partition des joueurs par leurs valeurs en €", color="blue",col="lightyellow")
    }
    else if(input$opt_var == 'MINUTE') {
      player<-player[7]
      
      boxplot(player, main="Partition des joueurs par leurs minutes de jeu", color="lightgreen",col="lightgreen")
    }
    else if(input$opt_var == 'BUT') {
      player<-player[8]
      
      boxplot(player, main="Partition des joueurs par leurs buts", color="blue",col="lightyellow")
    }
    else if(input$opt_var == 'PASSE D') {
      player<-player[9]
      boxplot(player, main="Partition des joueurs par leurs buts", color="lightgreen",col="lightgreen")
    }
    else if(input$opt_var == 'EFFICACITE') {
      player<-player[10]
      
      boxplot(player, main="Partition des joueurs par leurs efficacitées", color="blue",col="lightyellow")
    }
    else if(input$opt_var == 'EFF/MIN') {
      player <- player[-which(player[11]==0),]
      player<-player[11]
      
      boxplot(player, main="Partition des joueurs par leurs efficacitées par minutes jouées", color="lightgreen",col="lightgreen")
    }
    else {
      if(input$opt_team != "Tous") {
        player<-table(player[6])
        player<-sort(player, decreasing = TRUE)
        barplot(player, main="Trie sur les pays par le nombre de joueurs", color="lightgreen",col="lightgreen", las = 2, cex.names = 1)
      }
      else {
        player<-table(player[1])
        player<-sort(player, decreasing = TRUE)
        barplot(player, main="Trie sur les equipes par le nombre de joueurs", color="lightgreen",col="lightgreen", las = 2, cex.names = 1)
      }
    }
  })
  
  #Bouton de l'export des données
  observeEvent(input$export_data, {
    if(input$opt_player != "Tous") {
      player<-data[(data[2]==input$opt_player),]
    }
    else {
      if(input$opt_team != "Tous") {
        if(input$opt_pays != "Tous") {
          player<-data[(data[1]==input$opt_team),]
          player<-player[(player[6]==input$opt_pays),]
        }
        else {
          player<-data[(data[1]==input$opt_team),]
        }
      }
      else {
        if(input$opt_pays != "Tous") {
          player<-data[(data[6]==input$opt_pays),]
        }
        else {
          player<-data
        }
      }
    }
    
    write_xlsx(player, "DOWNLOAD/DATA/data.xlsx")
  })
  
  #Sortie des données finales
  output$table_data <- renderTable({
    if(input$opt_player != "Tous") {
      player<-data[(data[2]==input$opt_player),]
    }
    else {
      if(input$opt_team != "Tous") {
        if(input$opt_pays != "Tous") {
          player<-data[(data[1]==input$opt_team),]
          player<-player[(player[6]==input$opt_pays),]
        }
        else {
          player<-data[(data[1]==input$opt_team),]
        }
      }
      else {
        if(input$opt_pays != "Tous") {
          player<-data[(data[6]==input$opt_pays),]
        }
        else {
          player<-data
        }
      }
    }
    
    if(input$opt_var == 'AGE') {
      player<-player[c(1,2,3)]
    }
    else if(input$opt_var == 'POSTE') {
      player<-player[c(1,2,4)]
    }
    else if(input$opt_var == 'VALEUR') {
      player<-player[c(1,2,5)]
    }
    else if(input$opt_var == 'MINUTE') {
      player <- player[-which(player[7]==0),]
      player<-player[c(1,2,7)]
    }
    else if(input$opt_var == 'BUT') {
      player <- player[-which(player[8]==0),]
      player<-player[c(1,2,8)]
    }
    else if(input$opt_var == 'PASSE D') {
      player <- player[-which(player[9]==0),]
      player<-player[c(1,2,9)]
    }
    else if(input$opt_var == 'EFFICACITE') {
      player <- player[-which(player[10]==0),]
      player<-player[c(1,2,10)]
    }
    else if(input$opt_var == 'EFF/MIN') {
      player <- player[-which(player[11]==0),]
      player<-player[c(1,2,11)]
    }
    else {
      player<-player[1:11]
    }
    
    player
  })
  
  #Fonctions de la Nav
  #Image du logo de la ligue 1
  output$logoligue1 <- renderImage({
    list(src = "IMAGE/ligue1.png",
         contentType = 'image/png',
         width = "100%",
         alt = "This is alternate text")
  }, deleteFile = FALSE)
  
  #Ajustement data obligatoire
  team <- data_team[2]
  colnames(team)[1] <- "Club"
  
  #1er input sur le filtre par équipe
  output$opt_team <- renderUI({
    tagList(
      selectInput("opt_team", "Équipe", c("Tous",team))
    )
  })
  
  #2eme input sur le filtre par pays
  output$opt_pays <- renderUI({
    if(input$opt_team != "Tous") {
      pays<-data[(data[1]==input$opt_team),][6]
    }
    else {
      pays<-data_country[3]
    }
    tagList(
      selectInput("opt_pays", "Pays", c("Tous",pays))
    )
  })
  
  #3eme input sur le filtre par player
  output$opt_player <- renderUI({
    if(input$opt_team != "Tous") {
      if(input$opt_pays != "Tous") {
        player<-data[(data[1]==input$opt_team),]
        player<-player[(player[6]==input$opt_pays),][2]
      }
      else {
        player<-data[(data[1]==input$opt_team),][2]
      }
    }
    else {
      if(input$opt_pays != "Tous") {
        player<-data[(data[6]==input$opt_pays),][2]
      }
      else {
        player<-data_player[2]
      }
    }
    tagList(
      selectInput("opt_player", "Joueur", c("Tous",player))
    )
  })
  
  #resume en chiffre clé de la data en fonction des filtres choisis
  output$resume_panel <- renderText({
    if(input$opt_player != "Tous") {
      player<-data[(data[2]==input$opt_player),]
    }
    else {
      if(input$opt_team != "Tous") {
        team <- input$opt_team
        if(input$opt_pays != "Tous") {
          player<-data[(data[1]==team),]
          player<-player[(player[6]==input$opt_pays),]
        }
        else {
          player<-data[(data[1]==team),]
        }
      }
      else {
        if(input$opt_pays != "Tous") {
          player<-data[(data[6]==input$opt_pays),]
        }
        else {
          player<-data
        }
      }
    }
    
    if(input$opt_var == 'AGE') {
      player<-player[3]
      
      moy<-round(mean(player[,1], na.rm = T),1)
      max<-round(max(player[,1], na.rm = T),1)
      min<-round(min(player[,1], na.rm = T),1)
      sd<-round(sd(player[,1], na.rm = T),1)
      
      content<-paste("Nombre :", nrow(player), "joueur(s)<br/>",
                     "<hr style='border: 1px solid #aaa;' /><strong style='font-size:1.5em;' >Age</strong><br/> 
                     Moyenne:",moy,"ans <br/>
                     Ecart-type:",sd,"ans <br/><br/>
                     Max:",max,"ans <br/>
                     Min:",min,"ans")
    }
    else if(input$opt_var == 'POSTE') {
      player<-player[4]
      att<-length(player[(player[1]=="A"),])
      mil<-length(player[(player[1]=="M"),])
      def<-length(player[(player[1]=="D"),])
      goa<-length(player[(player[1]=="G"),])
      
      att_pc<-(att/nrow(player))*100
      mil_pc<-(mil/nrow(player))*100
      def_pc<-(def/nrow(player))*100
      goa_pc<-(goa/nrow(player))*100
      
      content<-paste("Nombre :", nrow(player), "Joueur(s)<br/>",
                     "<hr style='border: 1px solid #aaa;' /><strong style='font-size:1.5em;' >Poste</strong><br/> 
                     Att:",att,"joueur(s) - (",round(att_pc, 1),"% ) <br/>
                     Mil:",mil,"joueur(s) - (",round(mil_pc, 1),"% ) <br/>
                     Def:",def,"joueur(s) - (",round(def_pc, 1),"% ) <br/>
                     Gar:",goa,"joueur(s) - (",round(goa_pc, 1),"% ) <br/>")
    }
    else if(input$opt_var == 'VALEUR') {
      nothing <- player[-which(player[5]>0),]
      
      player <- player[5]
      
      nothing_pc <- (nrow(nothing)/nrow(player))*100
      
      moy<-label_number(accuracy = 1)(round(mean(player[,1], na.rm = T),1))
      max<-label_number(accuracy = 1)(round(max(player[,1], na.rm = T),1))
      min<-label_number(accuracy = 1)(round(min(player[,1], na.rm = T),1))
      sd<-label_number(accuracy = 1)(round(sd(player[,1], na.rm = T),1))
      somme<-label_number(accuracy = 1)(round(sum(player[,1], na.rm = T),1))
      
      content<-paste("Nombre :", nrow(player), "joueur(s)<br/>",
                     "<hr style='border: 1px solid #aaa;' /><strong style='font-size:1.5em;' >Valeur €</strong><br/> 
                     Nb joueur à 0€:",nrow(nothing),"joueur(s) - (",round(nothing_pc, 1),"% ) <br/><br/>
                     Moyenne:",moy,"€ <br/> 
                     Ecart-type:",sd,"€ <br/><br/>
                     Max:",max,"€ <br/>
                     Min:",min,"€ <br/><br/>
                     Somme:",somme,"€")
    }
    else if(input$opt_var == 'MINUTE') {
      player<-player[7]
      
      moy<-label_number(accuracy = 1)(round(mean(player[,1], na.rm = T),1))
      max<-label_number(accuracy = 1)(round(max(player[,1], na.rm = T),1))
      min<-label_number(accuracy = 1)(round(min(player[,1], na.rm = T),1))
      sd<-label_number(accuracy = 1)(round(sd(player[,1], na.rm = T),1))
      somme<-label_number(accuracy = 1)(round(sum(player[,1], na.rm = T),1))
      
      content<-paste("Nombre :", nrow(player), "joueur(s)<br/>",
                     "<hr style='border: 1px solid #aaa;' /><strong style='font-size:1.5em;' >Minute</strong><br/> 
                     Moyenne:",moy,"min <br/> 
                     Ecart-type:",sd,"min <br/><br/>
                     Max:",max,"min <br/>
                     Min:",min,"min <br/><br/>
                     Somme:",somme,"min")
    }
    else if(input$opt_var == 'BUT') {
      nothing <- player[-which(player[8]>0),]
      
      player<-player[8]
      
      nothing_pc <- (nrow(nothing)/nrow(player))*100
      
      moy<-(round(mean(player[,1], na.rm = T),1))
      max<-label_number(accuracy = 1)(round(max(player[,1], na.rm = T),1))
      min<-label_number(accuracy = 1)(round(min(player[,1], na.rm = T),1))
      sd<-(round(sd(player[,1], na.rm = T),1))
      somme<-label_number(accuracy = 1)(round(sum(player[,1], na.rm = T),1))
      
      content<-paste("Nombre :", nrow(player), "joueur(s)<br/>",
                     "<hr style='border: 1px solid #aaa;' /><strong style='font-size:1.5em;' >But</strong><br/> 
                     Nb joueur à 0But:",nrow(nothing),"joueur(s) - (",round(nothing_pc, 1),"% ) <br/><br/>
                     Moyenne:",moy,"but(s) <br/> 
                     Ecart-type:",sd,"but(s) <br/><br/>
                     Max:",max,"but(s) <br/>
                     Min:",min,"but(s) <br/><br/>
                     Somme:",somme,"but(s)")
    }
    else if(input$opt_var == 'PASSE D') {
      nothing <- player[-which(player[9]>0),]
      
      player<-player[9]
      
      nothing_pc <- (nrow(nothing)/nrow(player))*100
      
      moy<-(round(mean(player[,1], na.rm = T),1))
      max<-label_number(accuracy = 1)(round(max(player[,1], na.rm = T),1))
      min<-label_number(accuracy = 1)(round(min(player[,1], na.rm = T),1))
      sd<-(round(sd(player[,1], na.rm = T),1))
      somme<-label_number(accuracy = 1)(round(sum(player[,1], na.rm = T),1))
      
      content<-paste("Nombre :", nrow(player), "joueur(s)<br/>",
                     "<hr style='border: 1px solid #aaa;' /><strong style='font-size:1.5em;' >Passe Décisive</strong><br/> 
                     Nb joueur à 0Passe D:",nrow(nothing),"joueur(s) - (",round(nothing_pc, 1),"% ) <br/><br/>
                     Moyenne:",moy,"passe(s) <br/>
                     Ecart-type:",sd,"passe(s) <br/><br/>
                     Max:",max,"passe(s) <br/>
                     Min:",min,"passe(s) <br/><br/>
                     Somme:",somme,"passe(s)")
    }
    else if(input$opt_var == 'EFFICACITE') {
      nothing <- player[-which(player[10]>0),]
      
      player<-player[10]
      
      nothing_pc <- (nrow(nothing)/nrow(player))*100
      
      moy<-(round(mean(player[,1], na.rm = T),1))
      max<-label_number(accuracy = 1)(round(max(player[,1], na.rm = T),1))
      min<-label_number(accuracy = 1)(round(min(player[,1], na.rm = T),1))
      sd<-(round(sd(player[,1], na.rm = T),1))
      somme<-label_number(accuracy = 1)(round(sum(player[,1], na.rm = T),1))
      
      content<-paste("Nombre :", nrow(player), "joueur(s)<br/>",
                     "<hr style='border: 1px solid #aaa;' /><strong style='font-size:1.5em;' >But + Passe D (Efficacité)</strong><br/>  
                     Nb joueur à 0:",nrow(nothing),"joueur(s) - (",round(nothing_pc, 1),"% ) <br/><br/>
                     Moyenne:",moy,"B+D <br/> 
                     Ecart-type:",sd,"B+D <br/><br/>
                     Max:",max,"B+D <br/>
                     Min:",min,"B+D <br/><br/>
                     Somme:",somme,"B+D ")
    }
    else if(input$opt_var == 'EFF/MIN') {
      nothing <- player[-which(player[11]>0),]
      
      player<-player[11]
      
      nothing_pc <- (nrow(nothing)/nrow(player))*100
      
      moy<-(round(mean(player[,1], na.rm = T),1))
      max<-(round(max(player[,1], na.rm = T),1))
      min<-(round(min(player[,1], na.rm = T),1))
      sd<-(round(sd(player[,1], na.rm = T),1))
      somme<-label_number(accuracy = 1)(round(sum(player[,1], na.rm = T),1))
      
      content<-paste("Nombre :", nrow(player), "joueur(s)<br/>",
                     "<hr style='border: 1px solid #aaa;' /><strong style='font-size:1.5em;' >Efficacité/Min</strong><br/>  
                     Nb joueur à 0:",nrow(nothing),"joueur(s) - (",round(nothing_pc, 1),"% ) <br/><br/>
                     Moyenne:",moy,"min <br/> 
                     Ecart-type:",sd,"min <br/><br/>
                     Max:",max,"min <br/>
                     Min:",min,"min")
    }
    else {
      player[1:11]
      content<-paste("Nombre :", nrow(unique(player[2])), "Joueur(s)<br/>",
                     nrow(unique(player[1])), "Équipe(s)<br/>",
                     nrow(unique(player[5])), "Pays<br/>")
    }
    
    paste("<center><strong style='font-size:1.5em;' >Info Gen</strong><br/>", content)
  })
})