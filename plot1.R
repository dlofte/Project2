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

#plot1
#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#Using the base plotting system, make a plot showing the total PM2.5 emission from all
#sources for each of the years 1999, 2002, 2005, and 2008.



NEI3 <- summarise(group_by(NEI2, year), Emissions = sum(Emissions) )
png(file="plot1.png")
plot(NEI3$year, NEI3$Emissions, type = "l", xlab = "Year", ylab = "Total Yearly Emissions")
dev.off()