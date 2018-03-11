if [ ! -S /home/submit/uwsgi.sock ]; then
  echo "/home/submit/uwsgi.sock did not launch -- I suspect the application server is not running"
  exit -1
fi

su -p submit -c 'rm -f /home/submit/.ssh/known_hosts'
su submit -c "ssh -4 -oStrictHostKeyChecking=no -i /home/submit/submit_key worker1@submit_worker exit"