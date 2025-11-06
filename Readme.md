# Personal Base Container

This is my personal base container for Docker. It provides a basic Ubuntu 22.04
(aka "Jammy") or 24.04 (aka "Nobel") image. Maybe you'll find it helpful too...

[![GitHub issues](https://img.shields.io/github/issues-raw/minchinweb/docker-base.svg?style=popout)](https://github.com/MinchinWeb/docker-base/issues)
<!--
[![Docker Pulls](https://img.shields.io/docker/pulls/minchinweb/base.svg?style=popout)](https://hub.docker.com/r/minchinweb/base)
![Docker Image Version](https://img.shields.io/docker/v/minchinweb/base?sort=date)
![Size & Layers](https://img.shields.io/docker/image-size/minchinweb/base?sort=semver)
-->

## How to Use This

The container will probably not be used directly, but rather as a for building
other (Docker) containers on. To do that, specify this as your base image (in
your `Dockerfile`):

    FROM ghcr.io/minchinweb/base:noble

    # ... and the rest

You also probably want to set the UID and GID (*User ID* number and *Group ID*
number). This can be done through the environmental variables `PUID` and `GUID`
(either the `-e` option at the command line, or the `environment` key in your
*docker-compose.yaml* file).

There is also a folders at `/app`, `/config`, `/defaults` that are owned by the
user. The idea is to have your application use this `/config` volume for all
its persist-able data, and do this by mounting this as a volume outside of your
container (either the `-v` option at the command line, or the `volumes` key in
your *docker-compose.yaml* file).

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

## Personal Additions and Notes

- add various tags as per [label-schema.org](http://label-schema.org/rc1/)
- added Canadian English locale, and sets the language to this
- init script is found at `/s6-init`. Turns out naming the process `init`
  [causes weird Docker
  bugs](https://github.com/just-containers/s6-overlay/issues/158)
- when built <del>on Docker Hub</del> via GitHub Actions and published to the
  GitHub Container Registry, is tagged with "latest", the Ubuntu codename (e.g.
  "noble"), and the Git commit ID (a random-ish string of numbers and letters)

## Prior Art

This is based on LinuxServer.io's [base
container](https://github.com/linuxserver/docker-baseimage-ubuntu). This is
where I first became aware of the user id problem and this solution, and also
the idea of a constant `/config` volume for all containers. However,
LinuxServer.io only has a certain selection of containers that they maintain,
and I wanted to apply this set up to other containers. By the time I'd figured
out how the system working, I'd basically rebuilt their base container.

- what LinuxServer.io says about [PUID and
  GUID](https://www.linuxserver.io/docs/puid-pgid)
- what LinuxServer.io says about [container
  volumes](https://www.linuxserver.io/docs/persisting-data)

Alpine Linux is often used as a base for container, owing to its small size
(quoted at ~5MB). However, I figure the trade off of being able to use Ubuntu
under the hood, and not being required to learn yet another variant of Linux,
is worth slightly larger size (this image comes in at ~44MB).

[s6-overlay](https://github.com/just-containers/s6-overlay/) is a project used
by LinuxServer.io, and so used here too, to deal with containers that launch
multiple processes. The s6 system is used to run the scripts that fix the user
id problem.

## Known Issues

- For whatever reason, I couldn't get this image to build locally and work.
  However, it works when built on Docker Cloud/Docker Hub.
- `/init` still exists, but don't use it. Use `/s6-init` instead (see
  [here](https://github.com/just-containers/s6-overlay/issues/158))
- I've had some issues getting services under the init system to work. I
  haven't gotten it solved yet, so I'm not sure whether the issue is something
  with it, or something with my code...
- this image doesn't automatically rebuild when the upstream image changes, but
  I have set up GitHub Actions to rebuild this image every week to approximate
  that automation.
- if you use this as a base image, you may need to set `ENV S6_KEEP_ENV=1` in
  your `Dockerfile` if you want your default script to have access to your
  environmental variables.
