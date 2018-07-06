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


#Plot 3:
#Subset data for Baltimore City, MD
Balt<-subset(NEI,fips=="24510")
#Use tapply to sum the PM2.5 values by type and year using Baltimore data subset
plot3<-data.frame(with(Balt,tapply(Emissions,list(type,year), FUN = sum)))
#Rename columns
colnames(plot3)<-c("1999","2002","2005","2008")
#Add a column for emission type
plot3$Type<-c("Non-Road","Non-Point","On-Road","Point")
#Melt the dataset to separate out the variables and values
library(reshape2)
plot3m<-melt(plot3,id.vars="Type",
     variable.name="Year",
     value.name = "TotalPM")
library(ggplot2)
#Plot data and color code by emissions type
ggplot(data=plot3m, aes(x=Year,y=TotalPM, col=Type,group=Type))+
    geom_line()+
    geom_point(size=3)+
    labs(title="PM25 by Source Type in Baltimore City, MD",y="Total PM25 (tons)")+
    theme(plot.title=element_text(hjust=0.5,size = 20))
#Write the png file
dev.copy(png,"plot3.png")
dev.off()
