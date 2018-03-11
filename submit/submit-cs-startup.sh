#!/usr/bin/env bash

echo "Starting ssh and nginx"
service sshd start
service nginx start

echo "Running submit cs update"
sh /docker/runtime_scripts/start_application.sh

echo "Aobut to do tail -f /dev/null"
tail -f /dev/null 