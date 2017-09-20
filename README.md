## Run Ansible locally in a docker container.

## Usage
Using simple Docker volume mounts, you can get a lot of the functiaonilty your used to with the command line on OSX, but without hacky OSX install patterns that mess with your dev environment.


```sh
## The short and sweet version with all the mounts I like to use.
## Adjust as needed.
## 1) Run it:
docker run -d -it \
    -v ~/repos/ansible:/etc/ansible \ 
    -v ~/.ansible_vault_pass.txt:/root/.ansible_vault_pass.txt \ 
    -v ~/.ssh:/root/.ssh \         
    -v ~/.aws/credentials:/root/.aws/credentials \
    -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    -h localhost \
    --name ansible nelsonenzo/d-ansible   

## 2) exec into the container
docker exec -it ansible /bin/bash

## 3) check the version you are running, it should be close to edge.
ansible --version

## Explained
docker run -d -it \
    -v ~/repos/ansible:/etc/ansible \    
      ## THE MOST IMPORTANT ONE TO CHANGE ##
      ## ~/repos/ansible should be the directory where your ansible code is.
        ## your code will be in /etc/ansible on the container, 
        ## which is conveniently in Ansibles search path by design

    -v ~/.ansible_vault_pass.txt:/root/.ansible_vault_pass.txt \
      ## SECOND MOST IMPORTANT TO CHANGE ##
      ## ~/.ansible_vault_pass.txt  is the file with your ansible-vault token

    -v ~/.ssh:/root/.ssh \
      ## ssh keys are usefull for all sorts of things, like running playbooks remotely
      ## don't forget to "ssh-add ~/.ssh/id_rsa" once your on the container.
      ## may also need eval `ssh-agent start`

    -v ~/.aws/credentials:/root/.aws/credentials \
      ## as are aws credentials.

    -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
      ## REQUIRED for ansible to ssh properly from within Docker.

    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
      ## REQUIRED for ansible to ssh properly from within Docker.

    -h localhost \
      ## you can use [localhost] in your playbooks to run against the base Ubuntu 14.04 this is running in.
      ## works pretty good for testing most code.

    --name ansible nelsonenzo/d-ansible   
      ## giving it a name makes it easy to start/stop with docker

```


### Rebuilding it locally
```sh
## build it
docker build . -t localhost/d-ansible:latest

## run it (add volume mounts as desired)
docker run -it -d --name local-d-ansible localhost/d-ansible:latest 

## use it
docker exec -it local-d-ansible /bin/bash
  root@c3c535435427:/etc/ansible# 

ansible --version
  ansible 2.5.0 (devel d395166ae0) last updated 2017/09/20 07:12:22 (GMT +000)
    config file = None
    configured module search path = [u'/opt/ansible/ansible/library']
    ansible python module location = /opt/ansible/ansible/lib/ansible
    executable location = /opt/ansible/ansible/bin/ansible
    python version = 2.7.6 (default, Oct 26 2016, 20:30:19) [GCC 4.8.4]

```