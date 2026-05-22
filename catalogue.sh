#!/bin/bash
######################################################################
# Author: Siva Ganesh Thota SL
# Project: Roboshop Automation
# Component: Catalogue Setup
# Discription: Automated Catalogue installation & configuration script
# Version: 1.0
# Date: 17/05/26
#######################################################################


source ./common.sh
app_name="catalogue"

# Root Validation
check_root

# Application Configration
app_setup

# NodeJS Set Up
nodejs_setup

# Systemd Set Up
systemd_setup

## MongoDB Repository Configuration
# 1. Create mongodb.repo locally inside project/repo
# 2. Add repository content > Refer Mongodb doc
# 3. Copy file to /etc/yum.repos.d/

# Copy MongoDB Repo File
cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOG_FILE
VALIDATE $? "Copy MongoDB Repo File"

# Install MongoDB client
dnf install mongodb-mongosh -y  &>>$LOG_FILE
VALIDATE $? "Installing MongoDB client"

# Load catalogue schema into MongoDB
STATUS=$(mongosh --quiet --host mongodb.robossl.shop --eval 'db.getMongo().getDBNames().indexOf("catalogue")')  # This is an idempotency check.

if [ $STATUS -lt 0 ]
then
      mongosh --host mongodb.robossl.shop </app/db/master-data.js &>>$LOG_FILE
      VALIDATE $? "Load catalogue schema"
else
      echo -e "$Y Data is already loaded ... SKIPPING $N"
fi

# Print time
print_time

