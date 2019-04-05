# Personal Base Container

This is my personal base container for Docker. Maybe you'll find it helpful
too...

## How to Use This

The container will probably not be used directly, but rather as a for building
other (Docker) containers on. To do that, specify this as your base image:

    FROM minchinweb/base

    # ... and the rest

You also probably want to set the UID and GID (*User ID* number and *Group ID*
number). This can be done through the environmental variables `PUID` and `GUID`
(either the `-e` option at the command line, or the `environment` key in your
*docker-compose.yaml* file).

There is also a volume at `/config` that is owned by the user. The idea is to
have your application use this for all its persist-able data, and do this by
mounting this as a volume outside of your container (either the `-v` option at
the command line, or the `volumes` key in your *docker-compose.yaml* file).

## Why I Created This

or, *What Problems is This Trying to Solve?*

Docker works it's magic by isolating processes, rather than spinning up a whole
new virtual machine. This is great for hardware requirements (especially as you
add more and more containers), but one of the byproducts is that certain
aspects of the processes run within the containers filter out into the host
operating system, in particular the user (and group) that a process is run by
*inside* the container **is the same user** (and group) that is running the
process *outside* the container, on the host system. Further more, this user is
not identified by a name, but rather a number. The naïve approach is just to
run everything as `root` (user id 1) because the user id is constant across
systems; however it's strength (that `root` has access to (pretty much)
everything) is also a great weakness (that it can stomp all over your system,
including changing or deleting pretty much any file on your system). Running
your containers as `root` also is the antithesis to much of Linux security
model, which requires processes to run as users with only the permissions they
need, and no extras. Thus, a better model is to create `docker` user on your
host system (name it whatever you want) that can only edit the docker volumes
on your host system, and map that user id (and group id) to the user running
the process within your container, and give that user (within the container)
whatever permissions it may need. Within the container, this user is named
`abc` and belongs to the `abc` group.

As another bonus, Docker will cache layers (the parts a container is built up
of), and so by using a constant base image on in my Docker setup, it saves on
space.

## Prior Art

This is based on LinuxServer.io's [base
container](https://github.com/linuxserver/docker-baseimage-ubuntu). This is
where I first became aware of the user id problem and this solution, and also
the idea of a constant `/config` volume for all containers. However,
LinuxServer.io only has a certain selection of containers that they maintain,
and I wanted to apply this set up to other containers. By the time I'd figured
out how the system working, I'd basically rebuilt their base container.

[s6-overlay](https://github.com/just-containers/s6-overlay/) is a project used
by LinuxServer.io, and so used here too, to deal with container that launch
multiple processes. The s6 system is used to run the scripts that fix the user
id problem.

## Known Issues

- For whatever reason, I couldn't get this image to build locally and work.
  However, it works when built on Docker Cloud/Docker Hub.
- Currently, only the "latest" tag (for the Docker image) is supplied.
