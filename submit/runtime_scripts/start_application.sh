# Run update_submit to fetch the application and start it for the first time
if [ -d "/submit_src" ]; then
  echo "Detected that /submit_src is present. Mounting source from host file system."
  /home/submit/bin/update_submit /submit_src 
else 
  echo "No /submit_src detected. Will be deploying the production version of submit.cs"
  /home/submit/bin/update_submit
fi

# # Prepare the application's database
if [ ! -f /home/submit/submit-files/dbready.txt ]; then
  echo "Getting the application's database ready"
  su submit -c 'source /home/submit/venv/bin/activate; echo "from submit import models; models.create_schema()" | pshell /home/submit/files/submit.ini'
  su submit -c 'source /home/submit/venv/bin/activate; cat /tmp-submit/create_admin_user.py | pshell /home/submit/files/submit.ini'
  touch /home/submit/submit-files/dbready.txt 
else
  echo "Found /home/submit/submit-files/dbready.txt indicating the database is already set up, skipping database ready as it may be redundant and dangerous. If you have made changes to the database please clear out the file system and the database"
fi