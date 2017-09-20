#!/bin/bash

## Easter Egg.
## Edit this bash script to your liking locally and
## never have to remember all the volumee mounts you like :)
docker run -d -it \
    -v ~/repos/ansible:/etc/ansible \ 
    -v ~/.ansible_vault_pass.txt:/root/.ansible_vault_pass.txt \ 
    -v ~/.ssh:/root/.ssh \			   
    -v ~/.aws/credentials:/root/.aws/credentials \
    -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    -h localhost \
    --name ansible nelsonenzo/d-ansible 
