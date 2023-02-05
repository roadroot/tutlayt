## Prerequisites

To be able to run this backend project, please ensure you have these requirements satisfied:

- Have docker installed and configured. Make sure that this command does not return an error:

```PowerShell
> docker ps
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
```

- Have node and npm installed
- `(Optional but recommended)` Install prisma globally using `npm install -g prisma`.
  If you chose not installing prisma please please replace `prisma %COMMAND%` with `npx prisma %COMMAND%`, or with with an equivalent alternative.

- `(Optional but recommended)` Install Prettier ESLint (`rvest.vs-code-prettier-eslint`) if you are willing to contribute some code to the project.

## Setup

Please read and follow the instructions on the readme located at [`../README.md`](../README.md) before this one.

### Env file
Create a `.env` file respecting the template in `.env.template`. You can run this command to make a copy of template to the `.env` file: 
```bash
cp .env.template .env
```

### Docker compose

To launch the backend, you need to have the database launched. To do that please open a terminal relative to this readme file and launch the following command:

```PowerShell
docker compose -f ../docker-compose.yaml up
```

> **_NOTE:_** You can run this command to delete the existing containers: **docker rm $(docker ps -aq)**

### Prisma

Please run `prisma db push` to update the database schema. This command will update the database schema against the one described in the relative path `./prisma/schema.prisma`.

Each time you modify the schema, run `prisma generate` to generate the prisma client, or `prisma db push` to generate the prisma client and update the database schema.

### npm

Run `npm install` to install npm dependencies.

## Troubleshoot
