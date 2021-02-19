########################################## --
########################################## --
##           Projet radio               ##
########################################## --
########################################## --


## Packages généraux ------
library(dplyr)
library(ggplot2)
library(tidyr)


# "not in" function
'%!in%' <- function(x,y)!('%in%'(x,y))

## Import the data ------
setwd("/Users/julia/Documents/DESCAMPS 2022/temps_parole") # MAC R ouvre le dossier qu'on spéficie

DYEARS <- read.csv("years.csv")
DYEARS_INFO <- subset(DYEARS, DYEARS$channel_name %in% c("Canal+", "Euronews", "Europe1", "France 2", "France 3", "France 5", "France Bleu", "France Culture", "France Info", "France Inter", "France 0", "LCI", "LCP/Public Sénat", "M6", "RMC", "RTL", "TF1", "TV5 Monde"))
DHOURS <- read.csv("hours.csv")
## Select the data -----
# variable Men Expression rate ----
DHOURS$mer <- 100 - DHOURS$wer 

# channels and years of interest
DHOURS_INFO <- subset(DHOURS, DHOURS$year != 2000 & DHOURS$channel_name %in% c("Canal+", "Europe1", "France 2", "France 3", "France 5", "France Bleu", "France Culture", "France Info", "France Inter", "France 0", "LCI", "LCP/Public Sénat", "M6", "RMC", "RTL", "TF1", "ARTE", "BFM TV", "RFI", "I-Télé/CNews"))
# variables of interest
DHOURS_INFO <- subset(DHOURS_INFO, select = c(media_type, channel_name, year, hour, wer, mer))


## Complete data for missing values ----

## Create "no_data" variable
DHOURS_INFO$no_data <- 0


## Media type vectors and list
tot_radio <- unique(DHOURS_INFO[DHOURS_INFO$media_type == "radio",]$channel_name)
tot_tv <- unique(DHOURS_INFO[DHOURS_INFO$media_type == "tv",]$channel_name)
tot_media <- unique(DHOURS_INFO$channel_name)
tot_radio
tot_tv
tot_media

tot_media <- sort(tot_media)
channels <<- as.list(tot_media)



## Missing hours for radio
missing_radio <- data.frame()
for (k in tot_radio){
  for (i in 2001:2019){
    for (h in 5:23)
      if (h %!in% DHOURS_INFO[DHOURS_INFO$channel_name == k & DHOURS_INFO$year == i,]$hour){
        channel_name <- unique(DHOURS_INFO[DHOURS_INFO$channel_name == k & DHOURS_INFO$year == i,]$channel_name)
        year <- as.character(unique(DHOURS_INFO[DHOURS_INFO$channel_name == k & DHOURS_INFO$year == i,]$year))
        hour <- as.character(h)
        media_type <- "radio"
        no_data <- 100
        wer <- 0
        mer <- 0
        row <- data.frame(media_type, channel_name, year, hour, wer, mer, no_data)
        missing_radio <- rbind(missing_radio, row)
      }
    
  }
  
}



## Missing hours for tv
missing_tv <- data.frame()
for (k in tot_tv){
  for (i in 2010:2019){
    for (h in 5:23)
      if (h %!in% DHOURS_INFO[DHOURS_INFO$channel_name == k & DHOURS_INFO$year == i,]$hour){
        channel_name <- unique(DHOURS_INFO[DHOURS_INFO$channel_name == k & DHOURS_INFO$year == i,]$channel_name)
        year <- as.character(unique(DHOURS_INFO[DHOURS_INFO$channel_name == k & DHOURS_INFO$year == i,]$year))
        hour <- as.character(h)
        media_type <- "tv"
        no_data <- 100
        wer <- 0
        mer <- 0
        row <- data.frame(media_type, channel_name, year, hour, wer, mer, no_data)
        missing_tv <- rbind(missing_tv, row)
      }
    
  }
  
}


## Paste data and missing data

DHOURS_INFO <- rbind(DHOURS_INFO, missing_radio)
DHOURS_INFO <- rbind(DHOURS_INFO, missing_tv)

## Missing years for tv
missing_tv_y <- data.frame()
for (k in tot_tv){
  for (i in 2001:2019){
      if (i %!in% DHOURS_INFO[DHOURS_INFO$channel_name == k,]$year){
        for (h in 5:23){
        channel_name <- unique(DHOURS_INFO[DHOURS_INFO$channel_name == k,]$channel_name)
        year <- i
        hour <- as.character(h)
        media_type <- "tv"
        no_data <- 100
        wer <- 0
        mer <- 0
        row <- data.frame(media_type, channel_name, year, hour, wer, mer, no_data)
        missing_tv_y <- rbind(missing_tv_y, row)
        }
      }
    
  }
  
}


## Paste data and missing data years
DHOURS_INFO <- rbind(DHOURS_INFO, missing_tv_y)

## Stats descriptives -------
## * Variable Women Expression rate -----
DYEARS$wer <- round(DYEARS$women_expression_rate, 0)
table(DYEARS$year, DYEARS$wer, useNA = "ifany")

DHOURS$wer <- round(DHOURS$women_expression_rate, 0)
table(DHOURS$year, DHOURS$wer, useNA = "ifany")

DHOURS$count <- 100



DHOURS[DHOURS$media_type == "tv",]$hour


## * Coefficient de corrélation Pearson -------
cor.test(DYEARS$year, DYEARS$wer, method = c("pearson"))

table(DYEARS$channel_name)

cor.test(DYEARS_INFO$year, DYEARS_INFO$wer, method = c("pearson"))

cor.test(DHOURS$year, DHOURS$wer, method = c("pearson"))

table(DHOURS$channel_name)


cor.test(DHOURS_INFO$hour, DHOURS_INFO$wer, method = c("pearson"))



## * Variable annee presidentielle -------
DYEARS_INFO$election <- NA
DYEARS_INFO$election[DYEARS_INFO$year == 1995 | DYEARS_INFO$year == 2002 | DYEARS_INFO$year == 2007 | DYEARS_INFO$year == 2012 | DYEARS_INFO$year == 2017] <- "yes"
DYEARS_INFO$election[DYEARS_INFO$year != 1995 & DYEARS_INFO$year != 2002 & DYEARS_INFO$year != 2007 & DYEARS_INFO$year != 2012 & DYEARS_INFO$year != 2017] <- "no"
DYEARS_INFO$election <- as.factor(DYEARS_INFO$election)
table(DYEARS_INFO$election, useNA = "ifany")

DHOURS_INFO$election <- NA
DHOURS_INFO$election[DHOURS_INFO$year == 1995 | DHOURS_INFO$year == 2002 | DHOURS_INFO$year == 2007 | DHOURS_INFO$year == 2012 | DHOURS_INFO$year == 2017] <- "yes"
DHOURS_INFO$election[DHOURS_INFO$year != 1995 & DHOURS_INFO$year != 2002 & DHOURS_INFO$year != 2007 & DHOURS_INFO$year != 2012 & DHOURS_INFO$year != 2017] <- "no"
DHOURS_INFO$election <- as.factor(DHOURS_INFO$election)
table(DHOURS_INFO$election, useNA = "ifany")



  

## Hour_pie functions -----


## Draw_clock
require('grid')
require('gridBase')    


drawClock <- function(hour, minute) 
{
  t <- seq(0, 2*pi, length=13)[-13]
  x <- cos(t)
  y <- sin(t)
  
  vps <- baseViewports()
  pushViewport(vps$inner, vps$figure, vps$plot)
  # ticks
  
  grid.segments(x, y, x*.9, y*.9, default="native", gp=gpar(lex=1.5))
  # Hour hand
  hourAngle <- pi/2 - (hour + minute/60)/12*2*pi
  grid.segments(0, 0, 
                .6*cos(hourAngle), .6*sin(hourAngle), 
                default="native", gp=gpar(lex=5))
  grid.text(hour, .8*cos(hourAngle), .8*sin(hourAngle), default = "native")
  # Minute hand
  minuteAngle <- pi/2 - (minute)/60*2*pi
  grid.segments(0, 0, 
                .8*cos(minuteAngle), .8*sin(minuteAngle), 
                default="native", gp=gpar(lex=3))    
  popViewport(3)
  #par(mar = c(35,25,20,36))
}


## All_hour_pie
all_hour_pie <- function(channel, year){
  titre = paste("Répartition du temps de parole par heure sur", channel, "en", year, sep = " ")
ggplot(data = dat[dat$channel_name == channel & dat$year == year,]) + 
  geom_bar(mapping = aes(x = "", fill = parole), position = "fill") +
  facet_wrap(~hour) +
  coord_polar(theta = "y") +
  scale_fill_manual(values = c("#fdb462", "#8dd3c7"))+
  ggtitle(titre) +
  xlab("") +
  theme(
    axis.text.x = element_blank(),
    axis.ticks = element_blank(),
    plot.title = element_text(size=9))
}

all_hour_pie("France Inter", "2019")


## One_hour_pie 
one_hour_pie <- function(channel, year, hour){
title <- paste("Répartition du temps de parole à", hour, "h sur", channel, "en", year, sep = " ")
labelw <- paste(DHOURS_INFO[DHOURS_INFO$channel_name == channel & DHOURS_INFO$year == year & DHOURS_INFO$hour == hour,]$wer, "%", sep = " ")
labelm <- paste(DHOURS_INFO[DHOURS_INFO$channel_name == channel & DHOURS_INFO$year == year & DHOURS_INFO$hour == hour,]$mer, "%", sep = " ")
pie(c(DHOURS_INFO[DHOURS_INFO$channel_name == channel & DHOURS_INFO$year == year & DHOURS_INFO$hour == hour,]$wer, DHOURS_INFO[DHOURS_INFO$channel_name == channel & DHOURS_INFO$year == year & DHOURS_INFO$hour == hour,]$mer, DHOURS_INFO[DHOURS_INFO$channel_name == channel & DHOURS_INFO$year == year & DHOURS_INFO$hour == hour,]$no_data), 
    cex = 1,
    cex.main = 1,
    labels = c(labelw, labelm),   
    clockwise=TRUE,
    radius=1.0, 
    init.angle=90, 
    col=c('#fdb462', '#9ad9ce', '#b3b3b3'),
    border=NA, 
    main = title)
legend("bottomright",c("Femmes","Hommes", "Pas de données"), bty="n", 
       cex=0.9, fill =c('#fdb462', '#9ad9ce', '#b3b3b3') )
drawClock(as.numeric(hour), 00)
}



one_hour_pie("France 2", "2013", "6")
one_hour_pie("RMC", "2011", "19")


## Animation ------
library(animation)

for (k in tot_radio) {
  for (i in 2001:2019)
  {
    animation::saveGIF(
      expr = {
        one_hour_pie(k, i, "5")
        one_hour_pie(k, i, "6")
        one_hour_pie(k, i, "7")
        one_hour_pie(k, i, "8")
        one_hour_pie(k, i, "9")
        one_hour_pie(k, i, "10")
        one_hour_pie(k, i, "11")
        one_hour_pie(k, i, "12")
        one_hour_pie(k, i, "13")
        one_hour_pie(k, i, "14")
        one_hour_pie(k, i, "15")
        one_hour_pie(k, i, "16")
        one_hour_pie(k, i, "17")
        one_hour_pie(k, i, "18")
        one_hour_pie(k, i, "19")
        one_hour_pie(k, i, "20")
        one_hour_pie(k, i, "21")
        one_hour_pie(k, i, "22")
        one_hour_pie(k, i, "23")
      },
      movie.name = paste(k, "_", i, ".gif", sep = "")
    )
  }
}

    
tot_radio

animation::saveGIF(
  expr = {
    one_hour_pie("France 2", "2013", "10")
    one_hour_pie("France 2", "2013", "11")
    one_hour_pie("France 2", "2013", "12")
    one_hour_pie("France 2", "2013", "13")
    one_hour_pie("France 2", "2013", "14")
    one_hour_pie("France 2", "2013", "15")
    one_hour_pie("France 2", "2013", "16")
    one_hour_pie("France 2", "2013", "17")
    one_hour_pie("France 2", "2013", "18")
    one_hour_pie("France 2", "2013", "19")
    one_hour_pie("France 2", "2013", "20")
    one_hour_pie("France 2", "2013", "21")
    one_hour_pie("France 2", "2013", "22")
    one_hour_pie("France 2", "2013", "23")
  },
  movie.name = "France2_2013.gif"
)

animation::saveGIF(
  expr = {
    one_hour_pie("France Inter", "2019", "5")
    one_hour_pie("France Inter", "2019", "6")
    one_hour_pie("France Inter", "2019", "7")
    one_hour_pie("France Inter", "2019", "8")
    one_hour_pie("France Inter", "2019", "9")
    one_hour_pie("France Inter", "2019", "10")
    one_hour_pie("France Inter", "2019", "11")
    one_hour_pie("France Inter", "2019", "12")
    one_hour_pie("France Inter", "2019", "13")
    one_hour_pie("France Inter", "2019", "14")
    one_hour_pie("France Inter", "2019", "15")
    one_hour_pie("France Inter", "2019", "16")
    one_hour_pie("France Inter", "2019", "17")
    one_hour_pie("France Inter", "2019", "18")
    one_hour_pie("France Inter", "2019", "19")
    one_hour_pie("France Inter", "2019", "20")
    one_hour_pie("France Inter", "2019", "21")
    one_hour_pie("France Inter", "2019", "22")
    one_hour_pie("France Inter", "2019", "23")
  },
  movie.name = "FranceInter_2019.gif"
)

animation::saveGIF(
  expr = {
    one_hour_pie("RMC", "2010", "5")
    one_hour_pie("RMC", "2010", "6")
    one_hour_pie("RMC", "2010", "7")
    one_hour_pie("RMC", "2010", "8")
    one_hour_pie("RMC", "2010", "9")
    one_hour_pie("RMC", "2010", "10")
    one_hour_pie("RMC", "2010", "11")
    one_hour_pie("RMC", "2010", "12")
    one_hour_pie("RMC", "2010", "13")
    one_hour_pie("RMC", "2010", "14")
    one_hour_pie("RMC", "2010", "15")
    one_hour_pie("RMC", "2010", "16")
    one_hour_pie("RMC", "2010", "17")
    one_hour_pie("RMC", "2010", "18")
    one_hour_pie("RMC", "2010", "19")
    one_hour_pie("RMC", "2010", "20")
    one_hour_pie("RMC", "2010", "21")
    one_hour_pie("RMC", "2010", "22")
    one_hour_pie("RMC", "2010", "23")
  },
  movie.name = "RMC_2010.gif"
)



library(gganimate)
theme_set(theme_bw())


one_hour_pie <- function(channel, year, hour){
  titre = paste("Répartition du temps de parole à", hour, "h sur", channel, "en", year, sep = " ")
  ggplot(data = dat[dat$channel_name == channel & dat$year == year & dat$hour == hour,]) + 
    geom_bar(mapping = aes(x = "", fill = parole), position = "fill") +
    coord_polar(theta = "y") +
    scale_fill_manual(values = c("#fdb462", "#8dd3c7"))+
    ggtitle(titre) +
    xlab("") +
    theme(
      axis.text.x = element_blank(),
      axis.title.x = element_blank(),
      axis.ticks = element_blank(),
      plot.title = element_text(size=8),
      legend.position="bottom", 
      plot.margin = margin(35,25,20,36))
  # drawClock(hour = as.numeric(hour), minute = 00)
  
}

clock_on_plot <- function(channel, year, hour){
  pie <- one_hour_pie(channel, year, hour)
 # return(pie)
  drawClock(hour = as.numeric(hour), minute = 00)
  save(list = ls(all.names = TRUE), file = "image.RData", envir = 
         environment())
}

load("image.RData")

one_hour_pie("France Inter", "2019", "20")
drawClock(20, 00)


library(grid)
library(gridBase)
library(caroline)


?grid.segments

require(grid)
drawClock <- function(hour, minute) {
  t <- seq(0, 2*pi, length=13)[-13]
  x <- cos(t)
  y <- sin(t)
  
  grid.newpage()
  pushViewport(dataViewport(x, y, gp=gpar(lwd=4)))
  # Circle with ticks
  grid.circle(x=0, y=0, default="native", 
              r=unit(1, "native"))
  grid.segments(x, y, x*.9, y*.9, default="native")
  # Hour hand
  hourAngle <- pi/2 - (hour + minute/60)/12*2*pi
  grid.segments(0, 0, 
                .6*cos(hourAngle), .6*sin(hourAngle), 
                default="native", gp=gpar(lex=4))
  # Minute hand
  minuteAngle <- pi/2 - (minute)/60*2*pi
  grid.segments(0, 0, 
                .8*cos(minuteAngle), .8*sin(minuteAngle), 
                default="native", gp=gpar(lex=2))    
  grid.circle(0, 0, default="native", r=unit(1, "mm"),
              gp=gpar(fill="white"))
}

drawClock(hour = 2, minute = 30)

test2 <- drawClock(12,20)
test2

plot(test2)

png("mugraph.png")
drawClock(2,30)
dev.off()

require('grid')
require('gridBase')    

pie(c(1,2), 
    clockwise=TRUE,
    radius=1.0, 
    init.angle=90, 
    col=c('pink', 'lightblue'),
    border=NA)

drawClock <- function(hour, minute) 
{
  t <- seq(0, 2*pi, length=13)[-13]
  x <- cos(t)
  y <- sin(t)
  
  vps <- baseViewports()
  pushViewport(vps$inner, vps$figure, vps$plot)
  # ticks
  
  grid.segments(x, y, x*.9, y*.9, default="native")
  # Hour hand
  hourAngle <- pi/2 - (hour + minute/60)/12*2*pi
  grid.segments(0, 0, 
                .6*cos(hourAngle), .6*sin(hourAngle), 
                default="native", gp=gpar(lex=4))
  # Minute hand
  minuteAngle <- pi/2 - (minute)/60*2*pi
  grid.segments(0, 0, 
                .8*cos(minuteAngle), .8*sin(minuteAngle), 
                default="native", gp=gpar(lex=2))    
  popViewport(3)
}

drawClock(hour = 2, minute = 25)




pie(c(1,2), 
    clockwise=TRUE,
    radius=1.0, 
    init.angle=90, 
    col=c('pink', 'lightblue'),
    border=NA)


clock <- drawClock(hour = 4, minute = 00)
class(clock)
class(pie)

library(ggplot2)
library(gridExtra)
library(ggplotify)
clock2 <- as.grob(clock)

grid.arrange(clock, pie)
