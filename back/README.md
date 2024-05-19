# Tutlayt Backend

## Prerequisites

To be able to run this backend project, please ensure you have these requirements satisfied:

- Have docker installed and configured. Make sure that this command does not return an error:

```PowerShell
> docker ps
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
```

- Have node and npm installed
- `(Optional but recommended)` Install prisma globally using `npm install -g prisma`. Then add `npm get prefix -g` result to path.
  If you chose not installing prisma please please replace `prisma %COMMAND%` with `npx prisma %COMMAND%`, or with with an equivalent alternative.

- `(Optional but recommended)` Install Prettier ESLint (`rvest.vs-code-prettier-eslint`) if you are willing to contribute some code to the project.

- `(Optional)` Have [Altair](https://altairgraphql.dev/) installed to execute GraphQL queries.
Add the following to headers to Authenticate :

```json
{
  "Authorization": "Bearer YOUR_TOKEN_HERE",
  "Apollo-Require-Preflight": "true"
}
```

Token example:

```JWT
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImR5dmhQTVREYzhMRnIwVTlKR0NkMSIsInVzZXJuYW1lIjoiYWRtaW41NTUiLCJlbWFpbCI6Im1vc2Npc2tpLm1la2hpQG1hZ2dpby5jby51ayIsInBob25lIjpudWxsLCJwaWN0dXJlIjoiaHR0cDovL2xvY2FsaG9zdDozNTAwL3N0b3JhZ2UvdGFtYXpnaGEucG5nIiwidXBkYXRlRGF0ZSI6IjIwMjQtMDUtMThUMjI6MzY6NTguMjg3WiIsImNyZWF0aW9uRGF0ZSI6IjIwMjQtMDUtMThUMjI6MzY6NTguMjg3WiIsImlhdCI6MTA3MTYxNDM3NDgsImV4cCI6MTA3NDc2Nzk3NDh9.uC9inuL98imyEQEN-q-T1rw7dELbsLwkItdpYy4K_n4
```

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
