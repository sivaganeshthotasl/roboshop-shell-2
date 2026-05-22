#!/bin/bash

####################################################
# Author: Siva Ganesh Thota SL
# Project: Roboshop Autmation
# Component: Redis
# Description: Redis Service Set Up script
# Version: 1.0
# Date: 18/05/26
#####################################################

source ./common.sh
app_name="redis"

# Root User Validation
check_root



# Disable and Enable Redis 
dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disabling and Enabling Redis"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "Enabling Redis"

# Installing Redis
dnf install redis -y &>>$LOG_FILE
VALIDATE $? "Installing Redis"

# Update bind IP and Protect Mode as NO
sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Updating Redis Configuration"

# Enable and Start Redis Service
systemctl enable redis &>>$LOG_FILE
VALIDATE $? "Enabling Redis Service"
systemctl start redis &>>$LOG_FILE
VALIDATE $? "Starting Redis Service"

# Redis Service Validating
netstat -lntp | grep 6379 &>>$LOG_FILE
VALIDATE $? "Redis Port Validation"

# Print Time
print_time


