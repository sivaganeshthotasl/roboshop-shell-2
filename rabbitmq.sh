#!/bin/bash

########################################
# Author: Siva Ganesh Thota SL
# Project: Roboshop Automation
# Component: Rabbitmq
# Discription: Rabbitmq script Automated
# Version: 1.0
# Date: 20/05/26
########################################

source ./common.sh
app_name="rabbitmq"

# Root User Validation
check_root

# RabbitMq password set up
echo -e "$Y Please Enter Rabbitmq Password: $N"
read -s RABBITMQ_PASSWORD

# Install RabbitMQ
dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "Installing Rabbitmq"

# Enable and Start RabbitMQ 
systemctl enable rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Enabling rabbitmq-server"
systemctl start rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Starting rabbitmq-server"

# RabbitMQ provides a default login but it cannot be used by the application
# Creating a new User for RabbitMQ
rabbitmqctl list_users | grep roboshop
if [ $? -ne 0 ]
then
     rabbitmqctl add_user roboshop $RABBITMQ_PASSWORD &>>$LOG_FILE # this will be used by your application to connect rabbitmq
     VALIDATE $? "Add roboshop user to rabitmq"
else
     echo -e "$Y roboshop user is already created....$B Skipping $N" | tee -a $LOG_FILE
fi

# Give full access permission to the user
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
VALIDATE $? "Giving Full Permission"

# Print Time
print_time


