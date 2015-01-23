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

#plot2
NEI4 <- summarise(group_by(filter(NEI2, fips == "24510"), year), Emissions = sum(Emissions))

png(file="plot2.png")
plot(NEI4$year, NEI4$Emissions, type = "l", main="Total PM2.5 emissions in Baltimore City", xlab = "Year", ylab = "Total Yearly Emissions")
dev.off()