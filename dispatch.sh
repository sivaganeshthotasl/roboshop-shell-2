#!/bin/bash

#########################################
# Author: Siva Ganesh Thota SL
# Project: Roboshop Automation
# Component: Dispatch
# Discription: Dispatch script automated
# Version: 1.0
# Date: 20/5/26
#########################################

source ./common.sh
app_name="dispatch"

# Root User Validation
check_root

# Application Configuration
app_setup

# Golang Setup
golang_setup

# Systemd setup
systemd_setup

# Print Time
print_time






