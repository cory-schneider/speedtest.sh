#! /bin/bash

# A script used to run speedtest-cli and log the results along with date and time
# Ask user what to name the file.
# Todo: Create another version later that can be run as a cron job.
# Todo: If file exists, ask if user wants to append or replace. Request confirmation.
# Use ISO 8601 date format
# Todo: Display the speedtest-cli output while it's running
# Log only the relevant info: IP, test server, ping, down speed, up speed.
# Todo: Complete the process by returning in terminal the last four entries on the log using tail.


echo "What filename should we use?" 
echo "(Provide full path)"
# Can a multi-line echo be made by calling the command only once?
# Maybe use \n somehow?

read filename

# Later: create an if statement that checks for speedtest-cli. If it's not there, prompt user to install it.

echo "Speed Test Running. Please Wait..."

speedtest-cli > /tmp/spdtsttemp
# Writes the speedtest-cli command to a temporary file from which we'll pull the results
# Is it necessary to use this method? Come up with another solution and see which is faster/less resource intensive

echo "Log Date:" $(date -Iseconds) >> $filename
# Want to use 24hr time. Need to study this function further.

echo "ISP:" $(grep "Testing from" /tmp/spdtsttemp | cut -c14- | awk -F'[()]' '{print $1}') >> $filename

echo "IP:" $(grep "Testing from" /tmp/spdtsttemp | awk -F'[()]' '{print $2}') >> $filename
# Returns only the text on the line which is surrounded by parentheses. Need to study awk command further.

echo "Ping:" $(grep "Hosted by" /tmp/spdtsttemp | cut -d ":" -f 2) >> $filename
# This works, but is evidently not optimal for cases in where there are multiple ':'. Need to look into this.

grep "Download:" /tmp/spdtsttemp >> $filename

grep "Upload:" /tmp/spdtsttemp >> $filename 

echo "------------------------------------" >> $filename

tail -n 24 $filename
 
rm /tmp/spdtsttemp