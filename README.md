# Tutlayt

This is a cultrual project about the [*Amaziɣ* (*ⴰⵎⴰⵣⵉⵖ*)](https://en.wiktionary.org/wiki/Amazigh) people and language.

## Prerequisites

- Have docker installed and configured. Make sure that this command does not return an error:

```PowerShell
> docker ps
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
```

## Setup

### Env file
Create a `.env` file respecting the template in `.env.template`. You can run this command to make a copy of template to the `.env` file: 
```bash
cp .env.template .env
```

### Docker compose

Launch the required services for this project by launching them using the docker compose command. To do that please open a terminal relative to this readme file and launch the following command:

```PowerShell
docker compose -f docker-compose.yaml up
```

> **_NOTE:_** You can run this command to delete the existing containers: **docker rm $(docker ps -aq)**

## Back End
The back end is a [NestJS](https://nestjs.com/) project that can be found in [`./back/`](./back/) directory. Please read the instructions described in the README file located in [`./back/README.md`](./back/README.md)

## Front End
The front end is a flutter project that can be found in [`./front/`](./front/) directory. Please read the instructions described in the README file located in [`./front/README.md`](./front/README.md)

