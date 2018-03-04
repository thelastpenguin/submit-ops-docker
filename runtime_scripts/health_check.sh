if [ ! -S /home/submit/uwsgi.sock ]; then
  echo "/home/submit/uwsgi.sock did not launch -- I suspect the application server is not running"
  exit -1
fi

if [ ! -S /home/submit/submit_key ]; then 
  echo "/home/submit/submit_key not found. Keys were not generated or were not copied into the container properly"
  exit -2
fi

su -p submit -c 'rm -f $HOME/.ssh/known_hosts'
su submit -c "ssh -4 -oStrictHostKeyChecking=no -i $HOME/submit_key worker1@submit_worker exit"