#!/bin/bash
#####################################################
# Author: Siva Ganesh Thota SL
# Project: Roboshop Automation
# Component: Mysqldb Setup
# Description: Mysqldb automated script
# Version: 1.0
# Date: 19/05/26
#####################################################

source ./common.sh
app_name="mysql"

# Root User Validation
check_root

# Enter Mysql Root Password to setup
echo -e "$Y Please Enter MySQL Root Password: $N"
read -s MYSQL_ROOT_PASSWORD
echo

##MysqlDB configuration##
# Install Mysql server
dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing mysql-server"

# Enable and Start Mysql Service
systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabling mysqld"
systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Starting mysqld"

#change the default root password in order to start using the database service. Use password RoboShop@1
#mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD &>>$LOG_FILE
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "show databases;" &>>$LOG_FILE

if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${MYSQL_ROOT_PASSWORD} &>>$LOG_FILE
    VALIDATE $? "Setting Root Password"
else
    echo "MySQL Root password already configured"
fi


END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))
echo -e "$G The Script executed Successfully. Time Taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE


# Print Time
print_time

