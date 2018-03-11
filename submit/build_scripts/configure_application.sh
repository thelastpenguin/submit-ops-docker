#!/bin/bash -eux

# Home directory must be readable by other users
chmod 755 /home/submit

# Files directory must be owned by submit user
# cp /docker/files/* /docker/files
chown submit:submit /docker/files

# Create bin directory
mkdir -p /home/submit/bin

# Set secrets in submit.ini
auth_secret=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 64 ; echo '')
cookie_secret=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 64 ; echo '')
sed -i s/{{auth_secret}}/$auth_secret/ /docker/files/submit.ini
sed -i s/{{cookie_secret}}/$cookie_secret/ /docker/files/submit.ini

# Make update_submit executable and relocate to directory on path
chmod +x /docker/files/update_submit
mv /docker/files/update_submit /home/submit/bin/

# # Run update_submit to fetch the application and start it for the first time
# /home/submit/bin/update_submit

# # Prepare the application's database
# su submit -c 'source /home/submit/venv/bin/activate; echo "from submit import models; models.create_schema()" | pshell /docker/files/submit.ini'
# su submit -c 'source /home/submit/venv/bin/activate; cat /docker/files/create_admin_user.py | pshell /docker/files/submit.ini'

# Make submit_shell executable and relocate to directory on path
chmod +x /docker/files/submit_shell
mv /docker/files/submit_shell /home/submit/bin/

