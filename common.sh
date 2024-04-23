#!/bin/bash
set -e

handle_error(){
    echo "error occured at line no:$1, error command: $2"
}


trap 'handle_error ${LINENO} "$BASH_COMMAND"' ERR

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%s)
SCRIPTNAME=$( echo $0 | cut -d "." -f1 )
LOGFILE=$TIMESTAMP-$SCRIPTNAME.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

check_root(){
if [ $USERID -ne 0 ]
then 
    echo "please run the script with root access"
    exit 1
else     
    echo  "your super user"
fi
}

VALIDATE() {
    if [ $1 -ne 0 ]
     then 
        echo -e "$2 ..$R FAILED $N"
     else 
           
       echo -e " $2... $G SUCCESS $N"
  fi  
}
