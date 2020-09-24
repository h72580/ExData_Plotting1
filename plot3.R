# The assignment states: "Your code file should include code for reading the
# data so that the plot can be fully reproduced."
# I get that I can consider the data already downloaded, unzipped in the "data"
# folder and that the assignment asks for the code to read the part of the data
# set that is of interest for the plottings.
# I put anyway the code used to download the zipped file, unzip it and move the
# file in the data folder which I used to prepare everything.

zipfileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfilename <- "./download/exdata_data_household_power_consumption.zip"
downloaddir <- "./download"
datadir <- "./data"
datasetfilename <- "./data/household_power_consumption.txt"
# if(!file.exists(datasetfilename)){
#   # check if directory exists and optionally create it
#   if(!file.exists(downloaddir)) dir.create(downloaddir)
#   # download the file writing in binary mode if not already there
#   if(!file.exists(zipfilename)) download.file(zipfileurl, zipfilename,
#                                               mode = "wb")
#   # unzip the file. Unzip automatically creates destination dir if needed
#   unzip(zipfilename, exdir=datadir)
#   # cleanup: remove the download folder
#   unlink(downloaddir, recursive=T)
# }

# end of the code to download and prepare the data file

# now... the assignment ask to try to check the memory needed to load the file
# and suggests to try to read only the rows of real interests.
# Being on Windows 10 I use findstr to search the file for the rows beginning
# with 1/2/2007 and 2/2/2007 with a regex and read them into a dataframe
# first we get the absolute path
absolutefilepath <- normalizePath(datasetfilename)
# I use read.csv2 since the separator in the file is ';'. we identify the
# missing values that the assignment tells us are encoded as question marks '?'
dataset <- read.csv2(pipe(paste("findstr /b \"[12]/2/2007\" \"", 
                                absolutefilepath, "\"", sep="")),
                                na.strings = "?", header = F)
# set the correct variable names
colnames(dataset) <- colnames(read.csv2(datasetfilename, header = T, nrows = 1))

# now... the first graph is an histogram showing the frequency of Global Active
# Power. I use "hist" and set the details as in the example given.
# but first open the png device and set width and height as asked
png("./plot3.png", width = 480, height = 480, units = "px")
# my system speaks Italian... to match the assignment labels I force English
Sys.setlocale("LC_ALL","English")
# I have to work with dates, I will leverage the lubridate package. I will
# "hope" that it is installed
library("lubridate")
# I add a new variable with the timestamp obtained parsing the Date and Time
# variables together
dataset <- cbind(dmy_hms(paste(dataset$Date, dataset$Time)), dataset)
# I set the correct variable name for the calculated column
colnames(dataset)[1] <- "timestamp"
# setup the plot
# I have to be sure that plot will select the right range for x and y scales,
# I just pretend to be interested in plotting the data from all sub_metering
# pasted together.
submeterings <- with(dataset, rbind(Sub_metering_1, Sub_metering_2, Sub_metering_3))
# I need to match the lenght also for the X axe so I replicate the timestamp
# column three times
with(dataset, plot(rep.int(timestamp, 3) , submeterings, type="n", 
                   ylab = "Energy sub metering", xlab = ""))

# plot the graphic
with(dataset, lines(timestamp, Sub_metering_1, col="black"))
with(dataset, lines(timestamp, Sub_metering_2, col="red"))
with(dataset, lines(timestamp, Sub_metering_3, col="blue"))

# set the legend
legend("topright", legend = c("sub_metering_1", "sub_metering_2",
                              "sub_metering_3"), col=c("black", "red", "blue"),
                              lty=1)
dev.off()

# DONE!