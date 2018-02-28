#!/usr/bin/env sh

ssh-keygen -f id_rsa -t rsa -N ''
mv id_rsa submit_id_rsa
mv id_rsa.pub submit_id_rsa.pub
