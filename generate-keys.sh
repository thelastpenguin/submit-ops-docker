ssh-keygen -b 2048 -t rsa -f ./submit_key -q -N ""
mv ./submit_key ./submit/files
mv ./submit_key.pub ./worker/worker_files