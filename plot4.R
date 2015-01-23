#Exploratory Data Analysis Project 2
library(ggplot2)
library(dplyr)
library(lattice)
setwd("~/R/exploratoryDA/project2")

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, "particulateData.zip")
unzip("particulateData.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

NEI2 <-tbl_df(NEI) 
SCC <- tbl_df(SCC)

#plot4
#Merge the SCC and NEI data sets
SCCNEI <- merge(NEI2, SCC, by.x = "SCC", by.y = "SCC", all.x = T)

# Me using grep to find rows with "coal" and "combustion" I know this is not optimal but it worked (I think? :/)
allThingsCoalindex <-  grep(" [Cc]oal ", SCCNEI$Short.Name)
allThingsCoal<- SCCNEI[allThingsCoalindex,]
coalCombustionIndex <- grep(" [Cc]omb ", allThingsCoal$Short.Name)
coalCombustion <- SCCNEI[coalCombustionIndex,]
CC <- select(tbl_df(coalCombustion), SCC, Short.Name, Emissions, year)

# I change some variables into factor variables, then sum the coal combustion emissions by year
CCplot <- mutate(CC, SCC = as.factor(SCC), Short.Name = as.factor(Short.Name))
CCsum <- summarize(group_by(CCplot, year), Emissions = sum(Emissions))

png(file = "plot4.png")
plot(CCsum$year, CCsum$Emissions, type = 'l',  main = "Coal Combustion Related Emissions", xlab= "Year", ylab = "Emissions")
dev.off()