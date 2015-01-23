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

#plot2
NEI4 <- summarise(group_by(filter(NEI2, fips == "24510"), year), Emissions = sum(Emissions))

png(file="plot2.png")
plot(NEI4$year, NEI4$Emissions, type = "l", main="Total PM2.5 emissions in Baltimore City", xlab = "Year", ylab = "Total Yearly Emissions")
dev.off()

#plot3
NEI5 <- mutate(filter(NEI2, fips == "24510"), type = as.factor(type), year = as.factor(year))
str(NEI5)
NEI5group <- summarize(group_by(NEI2, type, year), Emissions = sum(Emissions))

png(file = "plot3.png")
qplot(year, Emissions, data= NEI5group, facets = .~type, ylab = 'Total Emissions', xlab = "Year")
dev.off()

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


#plot 5
#I choose to use the data type Onroad/ON-ROAD as the most efficient way to find the rows containing motor vehicle data.
baltMotor <- mutate(filter(NEI2, fips == "24510", type == "ON-ROAD"), type = as.factor(type))

baltMotorSum <- summarize(group_by(baltMotor, year), Emissions =sum(Emissions)) 

png(file = "plot5.png")
plot(baltMotorSum$year, baltMotorSum$Emissions, type = "l", main = "Motor Emissions in Baltimore", xlab= "Year",ylab = "Emissions")
dev.off()

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
     
