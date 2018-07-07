#Download and unzip
filename<-"PM Data.zip"
if(!file.exists(filename)){
    URL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(URL,filename)
}

if(!file.exists("PM Data")){
    unzip(filename, exdir="PM Data")
}

#Read the data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#Plot 6:
#Convert SCC.Level.Two from factor to charcter
SCC$SCC.Level.Two<-as.character(as.factor(SCC$SCC.Level.Two))
#Subset SCC with only entries that include the text string "Vehicles" in the SCC.Factor.Two column
subSCC<-subset(SCC,grepl("Vehicles",SCC.Level.Two))
#Create a vector of SCC codes resulting from the above subset
motorSCC<-as.vector(subSCC$SCC)
#Create a subset of PM25 data that includes only SCC codes from the vector created above
motorSub<-NEI[motorSCC %in% NEI$SCC,]
#Subset the data set above to include only Baltimore and LA based on fips codes
motorBaltLA<-subset(motorSub,fips=="24510" | fips=="06037")
#Create a data frame and use tapply to sum the PM25 vales by year and city
plot6<-data.frame(with(motorBaltLA,tapply(Emissions,list(year,fips), FUN = sum)))
#Change column names 
colnames(plot6)<-c("Los Angeles","Baltimore")
#Add a column that identifies the year as a variable
plot6$Year<-c("1999","2002","2005","2008")
library(reshape2)
#Use melt to deconstruct the data subset
plot6m<-melt(plot6,id.vars = "Year",
             variable.name="City",
             value.name = "TotalPM")
library(ggplot2)
#Begin writing the png file
png("plot6.png")
#Use ggplot to create a line graph, color-coded based on city (Los Angeles or Baltimore)
ggplot(data=plot6m, aes(x=Year,y=TotalPM, col=City,group=City))+
    geom_line()+
    geom_point(size=3)+
    labs(title="Total PM2.5 Emitted by Motor Vehicles \nin Baltimore City, MD and Los Angeles, CA",y="Total PM25 (tons)")+
    theme(plot.title=element_text(hjust=0.5,size = 20))
#Finish writing and save png file
dev.off()
