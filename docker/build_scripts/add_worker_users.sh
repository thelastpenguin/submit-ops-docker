#!/bin/bash -eux

# Generate SSH key
ssh-keygen -f ssh_rsa -N ""

# The submit user must own the key in order to use it
chown submit:submit ssh_rsa

for worker in worker1 worker2; do
    # Create user
    adduser $worker

    # Create .ssh/authorized_keys file
    -iu $worker mkdir .ssh
    -iu $worker chmod 700 .ssh
    cat ssh_rsa.pub | -iu $worker tee -a .ssh/authorized_keys
    -iu $worker chmod 600 .ssh/authorized_keys
done

# Remove the public key as it's no longer needed
rm ssh_rsa.pub
