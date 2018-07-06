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


#Plot 2:
Balt<-subset(NEI,fips=="24510")
plot2<-with(Balt,tapply(Emissions,list(year), FUN = sum))
plot(plot2, type="o",pch=19,ylab="Total PM2.5 Emissions (tons)",xlab="Year",main = "Total PM2.5 Emissions by Year for Baltimore City, MD",xaxt="n")
axis(1,at=c(1,2,3,4),labels = c("1999","2002","2005","2008"))
dev.copy(png,"plot2.png")
dev.off()
