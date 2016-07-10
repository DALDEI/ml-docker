# ml-docker

This repo contains a set of Docker containers for building and running
MarkLogic server.

## Images

There are three images

* `coreos` is the Fedora 23 base system
* `runner` is a minimal container for running MarkLogic Server
* `builder` is configured to allow you to build the server

### coreos

The `coreos` container installs Fedora 23 and sets up Java. It creates
one non-root user that you can use when `docker exec`ing into the
container.

There are three build arguments:

* `java` a path to a Java RPM to install, you must supply this
* `user` the name of the non-root user, defaults to `devuser`
* `uid` the UID of the non-root user, defaults to `1000`

By setting the `user` and `uid` arguments appropriately, you can allow
the user logged into the container to update volumes mounted on it.

### runner

The `runner` container installs and runs MarkLogic server. You must
supply a MarkLogic RPM to the `marklogic` build argument. You can
download them from http://developer.marklogic.com/

This container also installs the MarkLogic Python API.

There are two build arguments:

* `marklogic` a path to a MarkLogic RPM to install, you must supply this
* `user` the name of the non-root user, defaults to `devuser`
   and must be the same as the `user` passed to the `coreos` image

### builder

The `builder` container extends the `coreos` container with build
tools sufficient to compilee MarkLogic Server. (Assuming, of course,
that you have access to the sources.)

There’s a single build argument:

* `user` the name of the non-root user, defaults to `devuser`
   and must be the same as the `user` passed to the `coreos` image

## Ancillary scripts

Optional: two scripts exists to 'pull' these files during the build.
They are meant to be augmented and are only called if apprprate rpms
are not found. The `getjava.sh` script will pull a java 1.8_60 JDK from
oracle. The `getml.sh` script will simply remind you to obtain a
MarkLogic rpm

## Building the images

A build script is provided in `bin`.

Usage:

    ./build.sh [coreos|runner|builder] {--tag tag} {--user devuser} {--uid 1000}

This builds one of 3 variants. You must build `coreos` first. If you specify
a tag for the `coreos` image, then you’ll have to modify the `Dockerfiles` for
the other images.
