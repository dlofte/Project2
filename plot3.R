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

#plot3
NEI5 <- mutate(filter(NEI2, fips == "24510"), type = as.factor(type), year = as.factor(year))
str(NEI5)
NEI5group <- summarize(group_by(NEI2, type, year), Emissions = sum(Emissions))

png(file = "plot3.png")
qplot(year, Emissions, data= NEI5group, facets = .~type, ylab = 'Total Emissions', xlab = "Year")
dev.off()