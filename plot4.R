#Downloading the file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "assignment.zip")
unzip("assignment.zip", exdir = ".")

#Using  data.table package
library(data.table)
DT_full <- fread("household_power_consumption.txt")
DT <- DT_full[Date == "1/2/2007" | Date == "2/2/2007",]

#Checking the classes of DT's columns
sapply(DT, class)

#Changing the classes of the columns 3 to 9, from Charcter to numeric
DT[,3:9]<-lapply(DT[,3:9], as.numeric)

#Changing the classes of Date & Time columns
DT$Date <- as.Date(DT$Date, "%d/%m/%Y")
DateTime <- strptime(paste(DT$Date, DT$Time), format = "%Y-%m-%d %H:%M:%S")
DateTime <- as.POSIXct(DateTime)
DT[,DateTime] <- DateTime
DT <- DT[,-(1:2)]

#Plot4
par(mfrow = c(2,2))

with(DT, plot(DateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power"))

with(DT, plot(DateTime, Voltage, type = "l", xlab = "datetime", ylab = "Voltage"))

with(DT, plot(DateTime, Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")) 
with(DT, points(DateTime, Sub_metering_1, type = "l", col = "black"))
with(DT, points(DateTime, Sub_metering_2, type = "l", col = "red"))
with(DT, points(DateTime, Sub_metering_3, type = "l", col = "blue"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = "solid",
       col = c("black", "red", "blue"))

with(DT, plot(DateTime, Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power"))

dev.copy(png, file = "plot4.png",width = 480, height = 480)
dev.off()
