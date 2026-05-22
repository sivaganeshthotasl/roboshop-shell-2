#!/bin/bash
##########################################################################
# Author: Siva Ganesh Thota SL
# Project: Roboshop Automation
# Component: Mongodb Setup
# Description: Automated Mongodb installation and configuration Script
# Version: 1.0
# Date: 17-05-26
###########################################################################

source ./common.sh
APP_NAME="MongoDB"

# Root User Validation
check_root


## MongoDB Repository Configuration
# 1. Create mongodb.repo locally inside project/repo
# 2. Add repository content > Refer Mongodb doc
# 3. Copy file to /etc/yum.repos.d/
cp mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOG_FILE
VALIDATE $? "Copying MongoDB repo"


# MongoDB Package Installation 
echo -e " $Y Installing MongoDB package $N " | tee -a $LOG_FILE
dnf install mongodb-org -y &>>$LOG_FILE 
VALIDATE $? "Installing MongoDB Instance"

# Enable and Start MongoDB
echo -e "$Y Enabling MongoDB $N" | tee -a $LOG_FILE
systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "Enable MongoDB"

echo -e "$Y Starting MongoDB Instance $N" | tee -a $LOG_FILE
systemctl start mongod &>>$LOG_FILE 
VALIDATE $? "Starting MongoDB"

# Update MongoDB Listen Address bindIp: 127.0.0.1 > bindIp: 0.0.0.0
echo -e "$Y Updating MongoDB configuration $N" | tee -a $LOG_FILE
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOG_FILE
VALIDATE $? "Updating MongoDB Remote Connection"

# Restart Mongodb Service
echo -e " $Y Restarting MongoDB Service $N"  | tee -a $LOG_FILE
systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "Restarting MongoDB"

# Print The Time
print_time

