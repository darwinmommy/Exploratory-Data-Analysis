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
SCC$SCC.Level.Two<-as.character(as.factor(SCC$SCC.Level.Two))
subSCC<-subset(SCC,grepl("Vehicles",SCC.Level.Two))
motorSCC<-as.vector(subSCC$SCC)
motorSub<-NEI[motorSCC %in% NEI$SCC,]
motorBaltLA<-subset(motorSub,fips=="24510" | fips=="06037")
plot6<-data.frame(with(motorBaltLA,tapply(Emissions,list(year,fips), FUN = sum)))
colnames(plot6)<-c("Los Angeles","Baltimore")
plot6$Year<-c("1999","2002","2005","2008")
library(reshape2)
plot6m<-melt(plot6,id.vars = "Year",
             variable.name="City",
             value.name = "TotalPM")
library(ggplot2)
png("plot6.png")
ggplot(data=plot6m, aes(x=Year,y=TotalPM, col=City,group=City))+
    geom_line()+
    geom_point(size=3)+
    labs(title="Total PM2.5 Emitted by Motor Vehicles \nin Baltimore City, MD and Los Angeles, CA",y="Total PM25 (tons)")+
    theme(plot.title=element_text(hjust=0.5,size = 20))
dev.off()
