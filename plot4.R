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


#Plot 4:
#Change Short.Name from factor to character
SCC$Short.Name<-as.character(as.factor(SCC$Short.Name))
#Subset only rows that include "coal" or "Coal" in the Short.Name column
subSCC<-subset(SCC,grepl("[Cc]oal",Short.Name))
#Create a vector of SCC codes based on the subsetted data
coalSCC<-as.vector(subSCC$SCC)
#Subset NEI PM2.5 data so that only the SCC codes from the vector above are included
coalSub<-NEI[coalSCC %in% NEI$SCC,]
#Use tapply to sum PM2.5 values by year
plot4<-with(coalSub,tapply(Emissions,list(year),FUN=sum))
plot(plot4, type="o",pch=19,ylab="Total PM2.5 Emissions (tons)",xlab="Year",main = "Total US PM2.5 Emissions by Year for Coal Sources",xaxt="n")
axis(1,at=c(1,2,3,4),labels = c("1999","2002","2005","2008"))
#Write the png file
dev.copy(png,"plot4.png")
dev.off()
