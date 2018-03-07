# The Gatherings

[![Stories in Ready](https://badge.waffle.io/brendandixon/thegatherings.svg?label=ready&title=Ready)](http://waffle.io/brendandixon/thegatherings)

Making groups
- Easy to Find
- Easy to Connect
- Easy to Manage

## Development and Testing

While you may install and run *theGatherings* locally, it is easiest to use [Docker](https://www.docker.com) for development and testing. The project includes a [Dockerfile](https://docs.docker.com/engine/reference/builder/) for the application and a [Docker Compose](https://docs.docker.com/compose/compose-file/) file for running the application with the required [MySQL](https://www.mysql.com) database.

The [Docker Compose](https://docs.docker.com/compose/compose-file/) configures [MySQL](https://www.mysql.com) to save data locally
in a [Docker Volume](https://docs.docker.com/storage/volumes/).

### Prepare the Environment

```
    docker-compose build
    docker-compose run --rm dev bundle exec rails dev:prime
    docker-compose run --rm test bundle exec rails db:environment:set
```

> Note: The `dev:prime` and related Rake tasks (as is common with Rake tasks) do not retry if the database
> is unavailable. Occasionally, the download and start of MySQL is not "fast enough" causing the task to fail.
> If the task fails, normally, re-running it succeeds.

### Run Migrations

```
    docker-componse run --rm dev bundle exec rails db:migrate
```

### Run a development console

```
    docker-compose run --rm dev
```

This launches a Bash terminal within which you can run all Rails and Gem commands.

### Run the development server

```
    docker-compose run --rm -p 3000:3000 server
```

This command launches the application in the foreground, much like running [Rails](http://rubyonrails.org) locally.
The application will be available at http://localhost:3000/.

The faux data created via the `rails dev:prime` Rake task adds several user accounts including (with `pa$$w0rd` as the password):

#### Leaders
* `a.admin@nomail.com` -- A full administrative account
* `a.leader@nomail.com` -- A Gathering Leader (aka Host) account
* `an.assistant@nomail.com` -- A Gathering Co-Leader account
* `a.coach@nomail.com` -- An administrator over a set of Gatherings

#### Members

* `mike<#>.member@nomail.com` where `<#>` is an integer
* `mary<#>.member@nomail.com` where `<#>` is an integer

Members numbered 72 or less (e.g., `mike72.member@nomail.com`) have affiliations with one or more Gatherings.
Members numbered 73 or greater are unaffiliated. Women get assigned the odd integers (e.g., `mary1.member@nomail.com`,
`mary3.member@nomail.com`) and men the even integers (e.g., `mike2.member@nomail.com`, `mike4.member@nomail.com`).

### Run Tests

```
    docker-compose run --rm test bundle exec rspec
```

### Stop all Docker Containers

```
    docker-compose down
```

## Running in Production 

*TBD*
