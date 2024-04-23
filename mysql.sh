#!/bin/bash

source ./common.sh

check_root

  echo "please enter db password"
  read Mysql_root_password

  dnf install mysql-server -y &>>$LOGFILE
  # VALIDATE $? "installing mysql sever"

  systemctl enable mysqld &>>LOGFILE
  # VALIDATE $? "enabling mysql"

  systemctl start mysqld &>>LOGFILE
  # VALIDATE $? "start mysql"

  # mysql_secure_installation --set-root-pass ExpenseApp@1
  # VALIDATE $? "setting up root password"

  #below code used for idompotent in nature
  mysql -h db-shellscript.sdevops.store -uroot -p${Mysql_root_password} -e 'show databases;' &>>$LOGFILE

  if [ $? -ne 0 ]
  then 
    mysql_secure_installation --set-root-pass ${Mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root password setup"
  else
    echo -e "MySQL Root password already setup.. $Y SKIPPING $N"
  fi








