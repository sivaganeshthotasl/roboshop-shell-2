#!/bin/bash

###################################################
# Author: Siva Ganesh Thota SL
# Project: Roboshop Automation
# Component: Shipping
# Description: Shipping Automated Script
# Version: 1.0
# Date: 19/05/26
####################################################

source ./common.sh
app_name="shipping"

# Root User Validation
check_root

# Enter Mysql Root Password to setup
echo -e "$Y Please Enter the Root Password: $N"
read -s MYSQL_ROOT_PASSWORD

# Applicatino Configuration Set UP
app_setup

# Maven Setup
maven_setup

# Systed Setup
systemd_setup 

# For this application to work fully functional we need to load schema to the Database.
# We need to load the schema. To load schema we need to install mysql client.
dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "Install mysql client"

# Load the Schema, app-user and masterdata
## Check whether shipping schema already exists
DB_CHECK=$(mysql -h mysql.robossl.shop -uroot -p$MYSQL_ROOT_PASSWORD -se "show databases;" | grep cities)

if [ -z "$DB_CHECK" ]
then
     mysql -h mysql.robossl.shop -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/schema.sql &>>$LOG_FILE
     VALIDATE $? "Loading Schema into mysqldb"

     mysql -h mysql.robossl.shop -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/app-user.sql &>>$LOG_FILE
     VALIDATE $? "Loading application user data"

     mysql -h mysql.robossl.shop -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/master-data.sql &>>$LOG_FILE
     VALIDATE $? "Loading the Master data"
else
     echo -e "$B Shipping Schemas Already Exists... $Y Skipping $N" | tee -a $LOG_FILE
fi


# Restart the Shipping Service
systemctl restart shipping &>>$LOG_FILE
VALIDATE $? "Restaring Shipping Service"

# Print Time
print_time


