# Run update_submit to fetch the application and start it for the first time
/home/submit/bin/update_submit

# Prepare the application's database
su submit -c 'source /home/submit/venv/bin/activate; echo "from submit import models; models.create_schema()" | pshell /home/submit/files/submit.ini'
su submit -c 'source /home/submit/venv/bin/activate; cat /tmp-submit/create_admin_user.py | pshell /home/submit/files/submit.ini'
