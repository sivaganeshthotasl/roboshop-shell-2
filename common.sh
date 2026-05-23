#!/bin/bash

#################################################
# Author: SIVA GANESH THOTA SL
# Project: Roboshop Automation
# Component: Application Component
# Description: Automated Roboshop Components Installation & Configuration
# Version: 1.0
# Date: 21/05/06
##################################################

# Variables #

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


# End Variables #


# Root User Validation
check_root(){
    USER_ID="$(id -u)"
    if [ $USER_ID -ne 0 ]
    then
         echo -e "$R ERROR:; Please Run This Script With Root User $N" | tee -a $LOG_FILE
         exit 1
    else
         echo -e "$G You Are Running With Root User $N" | tee -a $LOG_FILE
    fi

}

# Application set up
app_setup(){
    #Creating Roboshop Application User
    id roboshop  &>>$LOG_FILE
    if [ $? -ne 0 ]
    then
         useradd --system --home /app --shell /sbin/nologin --comment "Roboshop System User" roboshop &>>$LOG_FILE
         VALIDATE $? "Creating Roboshop Application User"
    else
         echo -e "$B Roboshop User Already Created.. $Y Skipping $N"  &>>$LOG_FILE
    fi
    
    #Creating Application Directory
    mkdir -p /app &>>$LOG_FILE
    VALIDATE $? "Creating Application Directory"
    
    #Download the $app_name Application Code into /tmp Directory
    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>>$LOG_FILE
    VALIDATE $? "Downloading $app_name.zip File into /tmp Directory"
    
    #Extract $app_name Application Files
    cd /app
    unzip -o /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "Extracting $app_name content files"

}

# NodeJs Set Up
nodejs_setup(){
    #Disable Default Nodejs Version
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "Disabling Default Nodejs"

    # Enable NodeJS 20 Version
    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "Enabling NodeJS 20 Version"

    #Install NodeJS
    dnf install nodejs -y  &>>$LOG_FILE
    VALIDATE $? "Installing NodeJS" 

    #Install NodeJS Dependencies
    cd /app
    VALIDATE $? "Changing to /app Directory"
    npm install --force &>>$LOG_FILE
    VALIDATE $? "Install NodeJS Dependencies"


}

maven_setup(){
    # Installing Maven or Java
    dnf install maven -y &>>$LOG_FILE
    VALIDATE $? "Installing Maven"
    # Install Dependencies & Build the application
    cd /app
    mvn clean package &>>$LOG_FILE
    VALIDATE $? "Clear the Old dependencies and Installing new dependencies"
    mv target/shipping-1.0.jar shipping.jar  &>>$LOG_FILE
    VALIDATE $? "rename the shipping.jar file and store in the /app"
}

python_setup(){
    # Install Python 3 and required build tools
    dnf install python3 gcc python3-devel -y &>>$LOG_FILE
    VALIDATE $? "Installing Python3 & Build Tools"

    # Install all required application dependencies
    cd /app
    pip3 install -r requirements.txt &>>$LOG_FILE
    VALIDATE $? "Install Requirement Dependencies"
}

systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOG_FILE
    VALIDATE $? "Copying shipping.service to systemd"

    # Reload SystemD Manager
    systemctl daemon-reload  &>>$LOG_FILE
    VALIDATE $? "Reloading SystemD Manager"

    # Enable & Start $app_name service
    systemctl enable $app_name  &>>$LOG_FILE
    VALIDATE $? "Enable $app_name service"
    systemctl start $app_name  &>>$LOG_FILE
    VALIDATE $? "Start $app_name service"
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

# Print Time Function
print_time(){
    END_TIME="$(date +%s)"
    TOTAL_TIME="$(( $END_TIME - START_TIME ))"
    echo -e "$Y The Script Execution is Completed Successfully. Time Taken: $TOTAL_TIME Seconds $N"
}
