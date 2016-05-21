library(dplyr)

## Download the data set.
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists("./data")) { dir.create("./data") }

if (!file.exists("./data/household_power_consumption.zip")) download.file(fileUrl, destfile = "./data/household_power_consumption.zip", mode = "wb")

if (!file.exists("./household_power_consumption.txt")) {
    unzip("./data/household_power_consumption.zip")
    
    dir(".", recursive=TRUE)
}

## Load data into table
df <- read.table("household_power_consumption.txt", header = TRUE, na.strings = "?", sep = ";", nrows = 5)
classes <- sapply(df, class)
df <- read.table("household_power_consumption.txt", header = TRUE, na.strings = "?", sep = ";", colClasses = classes)

## Use date from the dates 2007-02-01 and 2007-02-02
df <- filter(df, grepl("^1/2/2007$|^2/2/2007$", Date))
df$DateTime <- strptime(paste(df$Date, df$Time), "%d/%m/%Y %H:%M:%S")
df <- select(df, -Date, -Time)

## Plot
oldpar <- par()
par(mfrow = c(2, 2), pty = "s", mar = 0.1 + c(4, 4, 1, 1), oma = c(0, 0, 2, 0), cex.lab = 1.5, font.lab = 1.5, cex.axis = 1.3, las = 1, cex.main = 1.5)
with(df, plot(DateTime, Global_active_power, xlab="", ylab = "Global Active Power (kilowatts)", type = "l"))
with(df, plot(DateTime, Voltage, xlab = "datetime", ylab = "Voltage", type = "l"))
with(df, plot(DateTime, Sub_metering_1, xlab = "", ylab = "Energy sub metering", col = "black", type = "l"))
with(df, lines(DateTime, Sub_metering_2, col = "red", type = "l"))
with(df, lines(DateTime, Sub_metering_3, col = "blue", type = "l"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1, xjust = 1, yjust = 1)
with(df, plot(DateTime, Global_reactive_power, xlab = "datetime", type = "l"))
dev.copy(png, "plot4.png")
dev.off()

par(oldpar)

