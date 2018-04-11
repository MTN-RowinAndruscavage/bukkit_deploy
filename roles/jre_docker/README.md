jre_docker
============

Downloads and runs a java .jar app in docker


Requirements
---------------

Need docker installed and configured


Role Variables
-----------------

Define the app_jarfiles list with the docker container name, jar filename, and jar download url

```yaml
app_jarfiles:

  # Minimal example
  - name: helloworld
    jarfile: helloworld-v1.jar
    url: http://example.com/helloworld.jar

  # java app that needs options and settings
  - name: craftbukkit
    jarfile: craftbukkit-1.12.2.jar
    url: https://cdn.getbukkit.org/craftbukkit/craftbukkit-1.12.2.jar
    # Pick a java version from https://hub.docker.com/_/openjdk/
    java_docker_base_image: openjdk:8-jre-alpine
    java_pretasks: " echo eula=true > /app/eula.txt &&"
    java_args: " -Xmx1024M -Xms1024M"
    app_args: " nogui --noconsole"
    # Additional docker build steps for the container
    run: " apk update; apk upgrade"
    # Port to expose in docker container
    port: 25565
    # port to map from host:docker container
    published_ports: 25565:25565

```

Dependencies
---------------

geerlingguy.docker or any other role to give ansible access to a docker CLI and
the python docker-py module


Example Playbook
--------------------

```yaml
- hosts: servers
  roles:
     - role: jre_docker

```

Unit Testing
---------------

This ansible role uses molecule to perform linting and unit testing with:
 * yamllint
 * ansible-lint
 * flake8 (for any .py code that might have been hiding in here)
 * testinfra in docker


Run unit tests with:

    pipenv run molecule test


`molecule` and its dependencies should already be installed by the top-level
pipenv for this playbook.

However, it relies on a local docker to preform the final testinfra test. I
haven't really bothered to write any testinfra tests yet since the test-kitchen
serverspec covers it, and the default `app_jarfiles` list is empty anyways, so
don't bother trying to get the last test to run too much.

But it feels good to see the other linting and coding conventions tests pass via
automated checks for any changes made to this role!


License
---------

GPLv3


Author Information
----------------------

rowin@andruscavage.com
