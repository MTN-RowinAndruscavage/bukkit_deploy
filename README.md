# Deploy .jar apps via JRE in Docker

This ansible playbook has been tested on Ubuntu 16.04 "Xenial" but should work
on other platforms supported by the
[geerlingguy.docker](https://github.com/geerlingguy/ansible-role-docker/blob/master/meta/main.yml)
ansible role

This playbook will:
 * Install the latest docker-engine community edition
 * Download one or more jar files from a url specified in the `app_jarfiles` list
 * Build a docker container for it with any desired version of openjdk/jre
   (defaults to the minimalist Java8 jre on Alpine Linux - 82MB)
 * Launches the container in docker with any provided arguments

By default, I've provided an example of the craftbukkit minecraft server on port
25565, and a Jenkins-CI LTS release on port 8080

See `roles/jre_docker/README.md` for instructions on how to override them with
your own .jar file.

## Usage

### Initial setup

Ansible is a module for python2. After initially cloning this repo, install it
using pipenv:

```bash
pip install pipenv
pipenv shell

# Download last working version of python modules and dependencies
pipenv install

# Download public ansible roles
ansible-galaxy install -r requirements.yml
```

### Running ansible

Add the IP or FQDN of the target host to the end of the `inventory/hosts` file.
Also add an `ansible_ssh_pass:` if passwordless ssh is not already setup. This
host will be referred to as "bukkit", but feel free to change the name or add
more target hosts. It is part of the group "automation" which is what we'll be
operating upon.

Ad-hoc module commands

    ansible automation -m shell -a "uname -a"

Running playbooks

    ansible-playbook -l automation playbook.yml

## Development and Testing

test-kitchen for ansible spins up a virtual machine in vagrant to perform
integration testing on playbooks

### Initial setup dependencies:

 * [Vagrant] (https://www.vagrantup.com/downloads.html) - VM provisioner
 * [VirtualBox] (https://www.virtualbox.org) - default driver for Vagrant
 * [rbenv] (https://github.com/rbenv/rbenv#installation)
 * [bundler] (http://bundler.io)

### Usage:

```bash
# Use ruby packages defined in Gemfile
bundle install

# Show what test suites are available
bundle exec kitchen list

# Execute a full test
bundle exec kitchen test -d never automation-ubuntu-xenial64
```

If everything converges and completes verification, you'll be able to connect to
the minecraft server at localhost:25565 , and point a browser at localhost:8080
to finish setting up Jenkins-CI

```bash
# How to log in and poke around your VM
bundle exec kitchen login automation-ubuntu-xenial64
sudo docker ps
sudo docker exec -it jenkins /bin/sh

# Destroy VMs when done
bundle exec kitchen destroy
```
