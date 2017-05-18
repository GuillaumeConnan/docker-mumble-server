# docker-mumble-server

A Docker container for Mumble Server configured with environment variables.

## Installation

```sh
docker pull silenthunter44/docker-mumble-server:latest
```

## Run

Run the default configuration with the following:

```sh
docker run --detach --name mumble-server --publish 64738/tcp --publish 64738/udp silenthunter44/docker-mumble-server:latest
```

Alternatively, you can use an external volume for database and configuration, and/or environment variables:

```sh
docker run --detach --name mumble-server  \
  --volume /local-path-to-mumble:/mumble-server \
  --publish 64738/tcp --publish 64738/udp \
  --env MS_SUPW=SuperUserPassword \
  --env MS_SERVERPASSWORD=ServerPassword \
  silenthunter44/docker-mumble-server:latest
```

## Ports

- `64738`: Mumble Server listening TCP and UDP port

## Volumes

- `/mumble-server`: database, configuration and logfile

## Credentials

Default password for SuperUser can be found in `/mumble-server/mumble-server.log` after first launch if no `MS_SUPW` variable passed

## Configuration

This Mumble Server container can be configured with the following environment variables:

- `MS_SUPW`: set or replace SuperUser password
- `MS_SERVERPASSWORD`: set or replace server password
- `MS_CONFIGFILE`: defines a custom configuration file path (default to `/mumble-server/mumble-server.ini`)
- `MS_LOGFILE`: defines a custom logfile path (default to `/mumble-server/mumble-server.log`)
- `MS_DATABASE`: defines a custom database path (default to `/mumble-server/mumble-server.sqlite`)
