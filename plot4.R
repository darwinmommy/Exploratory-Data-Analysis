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


SCC$Short.Name<-as.character(as.factor(SCC$Short.Name))
subSCC<-subset(SCC,grepl("[Cc]oal",Short.Name))
coalSCC<-as.vector(subSCC$SCC)
coalSub<-NEI[coalSCC %in% NEI$SCC,]
plot4<-with(coalSub,tapply(Emissions,list(year),FUN=sum))
plot(plot4, type="o",pch=19,ylab="Total PM2.5 Emissions (tons)",xlab="Year",main = "Total US PM2.5 Emissions by Year for Coal Sources",xaxt="n")
axis(1,at=c(1,2,3,4),labels = c("1999","2002","2005","2008"))
dev.copy(png,"plot4.png")
dev.off()
