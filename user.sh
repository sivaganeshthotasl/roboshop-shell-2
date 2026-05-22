#!/bin/bash
################################################
# Author: Siva Ganesh Thota SL
# Project: Roboshop Automation
# Component: User Set UP
# Description: Automated User Installation & Configuration
# Verstion: 1.0
# Date: 19/05/26
################################################

source ./common.sh
app_name="user"

# Application Configuration
app_setup

# NodeJS setup
nodejs_setup

# Systemd Set Up
systemd_setup

# Print Time
# Print time
print_time


