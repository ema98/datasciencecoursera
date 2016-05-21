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
with(df, plot(DateTime, Global_active_power, ylab = "Global Active Power (kilowatts)", type = "l"))
dev.copy(png, "plot2.png")
dev.off()
