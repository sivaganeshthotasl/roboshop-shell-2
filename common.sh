#!/bin/bash

#################################################
# Author: SIVA GANESH THOTA SL
# Project: Roboshop Automation
# Component: Application Component
# Description: Automated Roboshop Components Installation & Configuration
# Version: 1.0
# Date: 21/05/06
##################################################

# Start Time
START_TIME="$(date +%s)"
# Colour Variables
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

# Log Folder Configuration
LOG_FOLDER="/var/log/shellscript-log"

# Script Metadata Variables & Log File Setup
SCRIPT_NAME="$(echo $0 | cut -d "." -f1)"
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

# Create Log Folder and Set Time stamp
mkdir -p $LOG_FOLDER
echo -e "$Y The Script execution started at $START_TIME $N"

# Creating Script Directory for copying mongo.repo for installing mongodb client.
SCRIPT_DIR=$(pwd)

# Root User Validation
CHECK_ROOT(){
    USER_ID="$(id -u)"
    if [ $USER_ID -ne 0 ]
    then
         echo -e "$R ERROR:; Please Run This Script With Root User $N" | tee -a $LOG_FILE
         exit 1
    else
         echo -e "$G You Are Running With Root User $N" | tee -a $LOG_FILE
    fi

}


# Validate Function
VALIDATE(){
    if [ $1 -eq 0 ]
    then
         echo -e "$G $2 is.... SUCCESS $N" | tee -a $LOG_FILE
    else
         echo -e "$R $2 is.... FAILED $N" | tee -a $LOG_FILE
         exit 1
    fi
}


PRINT_TIME(){
    END_TIME="$(date +%s)"
    TOTAL_TIME="$(( $END_TIME - START_TIME ))"
    echo "$Y The Script Execution is Completed Successfully. Time Taken: $TOTAL_TIME Seconds $N"
}
