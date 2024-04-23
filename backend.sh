#!/bin/bash

source ./common.sh

check_root

echo "please enter db password"
read -s Mysql_root_password

  dnf module disable nodejs -y &>>$LOGFILE
  

  dnf module enable nodejs:20 -y &>>$LOGFILE
  
  dnf install nodejs -y &>>$LOGFILE
  

  id expense &>>$LOGFILE
  if [$? -ne 0]
  then 
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating expense user"
  else
    echo  -e "User already exists.. $Y SKIPPING $N"
  fi  

  mkdir -p /app &>>$LOGFILE
  

  curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
  

  cd /app
  rm -rf /app/*
  unzip /tmp/backend.zip
  
  npm install &>>$LOGFILE
  

  cp /home/ec2-user/expense-shell-sample/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
  

  systemctl daemon-reload &>>$LOGFILE
  

  systemctl start backend &>>$LOGFILE
  
  systemctl enable backend &>>$LOGFILE
  
  dnf install mysql -y &>>$LOGFILE
  

  #below code used for idompotent in nature
  mysql -h db-shellscript.sdevops.store -uroot -p${Mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
  
  systemctl restart backend &>>$LOGFILE
  











