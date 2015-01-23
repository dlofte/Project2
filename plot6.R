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

#plot 6 
LAMotor <- mutate(filter(NEI2, fips == "06037", type == "ON-ROAD"), type = as.factor(type))

motor <- rbind(baltMotor, LAMotor)
motor[motor$fips == "24510",1] <-"Baltimore"
motor[motor$fips == "06037",1] <- "LA"
motorg <- summarize(group_by(motor, year, fips), Emissions = sum(Emissions) )
png(file = "plot6.png")
qplot(year, Emissions, data = motorg, facets = .~fips, ylab = "Motor Vehicle Emissions", xlab = "Year")
dev.off()

# Basically the same plot using the lattice library
# xyplot(Emissions ~ year | fips, type = "l", motorg)