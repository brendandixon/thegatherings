# The Gatherings

[![Stories in Ready](https://badge.waffle.io/brendandixon/thegatherings.svg?label=ready&title=Ready)](http://waffle.io/brendandixon/thegatherings)

Making groups
- Easy to Find
- Easy to Connect
- Easy to Manage

## The Struggle of Managing Groups

*theGatherings* is an open-source project intended to address a common problem common in
churches: Managing their community of groups.

Churches often community groups of varying kinds: Weekly nights in homes, Sunday classes, weekend
outing groups, and more. All of these and each of these are useful in promoting and impacting
community. But managing these groups is work. And the problem gets worse as a church does better.
With each new group the net of relationships widens and thickens. It is difficult to know which
groups are healthy and which are struggling. It is hard to know how well they cover the church's
geographic area. Even leaders of the groups have challenges. They can lose sight of who's been
regular and who's been irregular.

Connecting people also requires constant time and attention. Groups have lifespans and membership
often changes. Finding groups, either for those new to the church or those switching for one reason
or another, is difficult. Maintaining the list of active groups often requires updates to the
church's main website.

Some solutions exist, but they come as part of a full-church office suite. By focusing on
everything, they lose the focus on the one thing. Choosing a solution impacts, not just managing
groups, but all aspects of church life. And, as churches grow, the full-suite can get expensive.

## The Goals of this Project

*theGatherings* will address all of these and more. *theGatherings* will exist in two forms: A
free-to-use hosted form and as an open-source platform sophisticated Churches may download and
deploy. *theGatherings* will have a "zero-height" bar to adoption. Churches will only have to
choose *if* they want to use *theGatherings.*

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

### Run the development server

This commands launches the application in the foreground, much like running [Rails](http://rubyonrails.org) locally.
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

```
    docker-compose run --rm -p 3000:3000 server
```

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
