This directory contains information for getting an instance of submit.cs working in a Docker container.

# Recent Updates 

## Recommended Development Workflow

### Environment Setup

 1. Fork and clone the source code to submit-cs as well as the source code for this repo into a directory
```sh
git clone git@github.com:ucsb-cs/submit.git
git clone git@github.com:ucsb-cs/submit-ops-docker.git
```
 2. cd into submit-ops-docker and generate the ssh keys (note that yes, you must actually be in the keys directory to make sure the files are output to the correct location)
```sh
sh generate-keys.sh
```
 3. build the docker container 
```sh
docker-compose build 
```
 4. Chmod the scripts directory to be executable
```sh
chmod -R +x ./scripts
```

__for your convenience all of those commands in one place__
```sh
#! /bin/bash
git clone git@github.com:ucsb-cs/submit.git
git clone git@github.com:ucsb-cs/submit-ops-docker.git
cd submit-ops-docker
sh generate-keys.sh
chmod -R +x ./scripts
docker-compose build 
```

### Launching the Production Environment

This is as simple as 
```
docker-compose up
```
It will use the production version of submit.cs which is published on pip, **NOT THE VERSION YOU CLONED ON YOUR HARD DRIVE**

_the application will be running on localhost at http://localhost:8080_

### Launching the Development Environment

This is as as simple as
```
./scripts/up
```

This script simply wraps
```
SRC=../submit:/submit_src docker-compose up
```
The src environment variable specifies a volume that gets mounted into the submit_cs docker container

_the application will be running on localhost at http://localhost:8080_

### Viewing the logs
The logs can be found in data/submit/logs on the host filesystem in the submit-ops-docker repo. They are mounted here as a volume by the docker-compose file.

## Using the scripts to manage your containers
 - ``sh ./scripts/down`` shuts down the docker containers
 - ``sh ./scripts/up`` starts up the docker containers
 - ``sh ./scripts/clear`` __clears out the database state__

### Shelling into the containers for more advanced debugging

#### Restarting submit_cs without recreating the container

```
docker exec -it bash # this will shell you into the container running submit_cs 
/home/submit/bin/update_submit /submit_src 
```

This restarts the submit\_cs web server, and reinstalls it from the source code located at /submit_src (which is a volume we mount into docker corresponding to docker/submit on your host machine)

#### Viewing any logs / errors directly in the container

Within the container the logs can be found in 
```
/home/submit/logs
```
but they are also conveniently mounted at ./submit_logs in this directory so you can more easily access them (hopefully without going through the pain of directly shelling into the container)

### Useful commands for working with docker
```
docker volume prune # prune out old database, don't run this if you want to keep the data 
docker-compose build # build the lastest changes to the docker configuration 
docker-compose rm # remove old containers
docker-compose up # start up the submit_cs instance
docker exec -it submit_cs # takes you into the container
```

The submit_cs process itself will be listening on port 8080 in your browser
```
http://localhost:8080
```
Is how you would typically access this.


# Old Documentation

## Just getting things up and running (useful commands)

Two important files are:
* Dockerfile
* docker-compose.yml


| Type this | to do this |
|------------|-----------|
| `docker-compose up | To bring up the whole composition of containers |
| `docker-compose down | To bring up the whole composition of containers |
| `docker-compose build | Rebuild the images (according to what is in the Dockerfile ) |
| `docker exec -it submit_cs bash` | root shell on submit_cs |
| `docker exec -it pg bash` | root shell on postgres machine |
| `docker exec -it mq bash` | root shell on postgres machine |
| `docker ps` | list all running containers |
| `docker ps -a` | list all containers that have exited and are running |


# What's in `docker-compose.yml`

Under services, each key represents a different container.

Each of those will be like its own virtual host.

The `container_name` entries will be put in the local DNS so that the
network nodes can refer to each other.

Docker's networking model for docker compose is that you can create
different virtual networks. By default it just creates one network.

`image` let's you know which image the containers is based on:
* for postgres and rabbitmq, we used stock images
* for submit_cs we used a different image
* TODO: Create submit_worker image (in meantime use "localhost")

`volumes`:

e.g.

```
- db-data:/var/lib/postgresql/data
```

At bottom we have:

```
volumes:
  db-data:
```

We can also do this to mount local files inside the container

```
 volumes:
      - ./build_scripts:/build_scripts
      - ./files:/docker/files
```

This is an abstraction of having disk space somewhere in your file system.


# Step 1:  Create a docker container with CentOS

We used the file docker/Dockerfile from this repo

In the docker directory, we typed:

```
docker build -t pconrad/submit.cs.try1 .
```

The last three lines of output were:

```
...
Removing intermediate container fef12b84544a
Successfully built 0617d29324f1
Successfully tagged pconrad/submit.cs.try1:latest
```

That checked that the `COPY` and `RUN` steps in the `Dockerfile` worked, but
it did not check whether any of the `CMD` steps worked.  Those don't get
executed when you do `docker build`.  Those get executed when you run the container.

We can see that the build worked through the command `docker images`:

```
Phills-MacBook-Pro:docker pconrad$ docker images
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
pconrad/submit.cs.try1   latest              0617d29324f1        2 minutes ago       877MB
...
Phills-MacBook-Pro:docker pconrad$
```

# Step 2: To run one container, you can do this.

BUT... typically we are going to run the whole docker compose,
so skip over this unless you only want to run one for some reason.


Now: we use this to run the container:

```
docker run -it pconrad/submit.cs.try1
```

OR:

```
docker run -it jeasterman/submit_cs
```

For example:

```
Phills-MacBook-Pro:docker pconrad$ docker run -it pconrad/submit.cs.try1
[root@5cd2b78e2641 /]# 
```

The command `docker ps` shows the running containers:

```
Phills-MacBook-Pro:docker pconrad$ docker ps
CONTAINER ID        IMAGE                    COMMAND             CREATED             STATUS              PORTS               NAMES
5cd2b78e2641        pconrad/submit.cs.try1   "/bin/bash"         2 minutes ago       Up 2 minutes                            jolly_borg
Phills-MacBook-Pro:docker pconrad$ 
```

The command `docker ps -a` also shows the ones that are stopped.

# Step 3: Run the whole system of containers via docker compose...

```
docker-compose up
```

Then, if it is working, to login and do stuff:

```
docker exec -it submit_cs bash
```

To take them all down:

```
docker-compose down
```
