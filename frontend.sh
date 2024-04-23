#!/bin/bash

echo "please enter db password"
read -s Mysql_root_password

  dnf install nginx -y &>>$LOGFILE
  VALIDATE $? "installing nginx"

  systemctl enable nginx &>>$LOGFILE
  VALIDATE $? "enabling nginx"

  systemctl start nginx &>>$LOGFILE
  VALIDATE $? "starting nginx"

  rm -rf /usr/share/nginx/html/* &>>$LOGFILE
  VALIDATE $? "removing existing content"

  curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
  VALIDATE $? "Downloading frontend code"

  cd /usr/share/nginx/html 
  unzip /tmp/frontend.zip &>>$LOGFILE
  VALIDATE $? "Extracting frontend code"


  #check your repo and path
  cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
  VALIDATE $? "Copy expense path"

  systemctl restart nginx &>>$LOGFILE
  VALIDATE $? "restaring nginx"

