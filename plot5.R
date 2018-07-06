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


#Plot 5:
SCC$SCC.Level.Two<-as.character(as.factor(SCC$SCC.Level.Two))
subSCC<-subset(SCC,grepl("Vehicles",SCC.Level.Two))
motorSCC<-as.vector(subSCC$SCC)
motorSub<-NEI[motorSCC %in% NEI$SCC,]
motorBalt<-subset(motorSub,fips=="24510")
plot5<-with(motorBalt,tapply(Emissions,list(year), FUN = sum))
png("plot5.png")
plot(plot5, type="o",pch=19,ylab="Total PM2.5 Emissions (tons)",xlab="Year",main = "Total PM2.5 Emissions for Baltimore City, MD \nMotor Vehicle Sources",xaxt="n")
axis(1,at=c(1,2,3,4),labels = c("1999","2002","2005","2008"))
dev.off()
