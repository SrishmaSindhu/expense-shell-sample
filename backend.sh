#!/bin/bash

echo "please enter db password"
read -s Mysql_root_password

  dnf module disable nodejs -y &>>$LOGFILE
  VALIDATE $? "disabling nodejs"

  dnf module enable nodejs:20 -y &>>$LOGFILE
  VALIDATE $? "enabling nodejs:20"

  dnf install nodejs -y &>>$LOGFILE
  VALIDATE $? "installing nodejs"


  id expense &>>$LOGFILE
  if [$? -ne 0]
  then 
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating expense user"
  else
    echo  -e "User already exists.. $Y SKIPPING $N"
  fi  

  mkdir -p /app &>>$LOGFILE
  VALIDATE $? "Creating App directive"

  curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
  VALIDATE $? "Downloading backend code"

  cd /app
  rm -rf /app/*
  unzip /tmp/backend.zip
  VALIDATE $? "extracted backend code"

  npm install &>>$LOGFILE
  VALIDATE $? "installing node js dependencies"

  cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
  VALIDATE $? "copied backend service"

  systemctl daemon-reload &>>$LOGFILE
  VALIDATE $? "Demon reload"

  systemctl start backend &>>$LOGFILE
  VALIDATE $? "start backend"

  systemctl enable backend &>>$LOGFILE
  VALIDATE $? "enabling backend"

  dnf install mysql -y &>>$LOGFILE
  VALIDATE $? "installing mysql client"


  #below code used for idompotent in nature
  mysql -h db-shellscript.sdevops.store -uroot -p${Mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
  VALIDATE $? "Schema loading"

  systemctl restart backend &>>$LOGFILE
  VALIDATE $? "restarting backend"












