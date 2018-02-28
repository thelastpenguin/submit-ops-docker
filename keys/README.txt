You should run the script

./generate_keys

in this directory, to create the keys

  submit_id_rsa  submit_id_rsa.pub

Those files are .gitignored in the repo.

The Dockerfile for submit_cs and the worker-Dockerfile both copy
the keys from this directory into a /docker/keys directory in the root of the
respective containers.

