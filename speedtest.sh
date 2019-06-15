#! /bin/bash

# A script used to run speedtest-cli and log the results along with date and time
# Ask user what to name the file.
# Todo: Create another version later that can be run as a cron job on my Raspberry Pi.
# Log only the relevant info: IP, test server, ping, down speed, up speed.
# Todo: Complete the process by returning in terminal the last four entries on the log using tail.


echo "What filename should we use?" 
echo "(Provide full path)"
# Can a multi-line echo be made by calling the command only once?
# Maybe use \n somehow?

read filename

# Later: create an if statement that checks for speedtest-cli. If it's not there, prompt user to install it.
 
echo "Speed Test Running. Please Wait..."
echo "-------------------------------------"

speedtest-cli >&1 | tee /tmp/spdtsttemp
# Is it necessary to use the temp file method? Come up with another solution and see which is faster/less resource intensive
# Need to study the tee command and understand the >&1 part 

echo "-------------------------------------"

echo "Log Date:" $(date -Iseconds) >> $filename
# Want to use 24hr time. Need to study this function further.

echo "ISP:" $(grep "Testing from" /tmp/spdtsttemp | cut -c14- | awk -F'[()]' '{print $1}') >> $filename

echo "IP:" $(grep "Testing from" /tmp/spdtsttemp | awk -F'[()]' '{print $2}') >> $filename
# Returns only the text on the line which is surrounded by parentheses. Need to study awk command further.

echo "Ping:" $(grep "Hosted by" /tmp/spdtsttemp | cut -d ":" -f 2) >> $filename
# This works, but is evidently not optimal for cases in where there are multiple ':'. Need to look into this.

grep "Download:" /tmp/spdtsttemp >> $filename

grep "Upload:" /tmp/spdtsttemp >> $filename 

echo "-------------------------------------" >> $filename

tail -n 28 $filename
 
rm /tmp/spdtsttemp

# Example Speed Test Output:
# Retrieving speedtest.net configuration...
# Testing from WideOpenWest (192.168.0.1)...
# Retrieving speedtest.net server list...
# Selecting best server based on ping...
# Hosted by CFH CABLE INC (Tampa, FL) [31.41 km]: 25.347 ms
# Testing download speed................................................................................
# Download: 224.79 Mbit/s
# Testing upload speed................................................................................................
# Upload: 10.65 Mbit/s
