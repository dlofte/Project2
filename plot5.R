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

#plot 5
#I choose to use the data type Onroad/ON-ROAD as the most efficient way to find the rows containing motor vehicle data.
baltMotor <- mutate(filter(NEI2, fips == "24510", type == "ON-ROAD"), type = as.factor(type))

baltMotorSum <- summarize(group_by(baltMotor, year), Emissions =sum(Emissions)) 

png(file = "plot5.png")
plot(baltMotorSum$year, baltMotorSum$Emissions, type = "l", main = "Motor Emissions in Baltimore", xlab= "Year",ylab = "Emissions")
dev.off()