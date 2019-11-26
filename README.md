# Medea

## Intention

This is a simple Location API microservice, allowing for querying a set of coordinates against known locations.

## Endpoints

### [GET /location_queries]
IN: [].
OUT: List of known locations, in GEO Json format.

### [GET /location_queries/inside]
IN: q - GEO Json-encoded Point.
OUT: Boolean value - whether given point is inside any of known locations.

[GET /location_queries]: https://location-api-medea.herokuapp.com/location_queries
[GET /location_queries/inside]: https://location-api-medea.herokuapp.com/location_queries/inside?q=%7B%22type%22%3A%22Point%22%2C%22coordinates%22%3A%5B8.3%2C50.66%5D%7D

## Development

Wanna contribute? There's a couple of thing you'll need.

### Ruby
Obviously. I use [`direnv`](https://github.com/direnv/direnv/wiki/Ruby) to manage and isolate Ruby projects. Template of `.envrc` is included in `.envrc.template`.

### System dependencies
* Postgres - client libraries. Required to connect to database. On macOS: `brew install pg`. On Arch: `pacman -Syu postgresql-client`.
* Geos - headers and binaries. Required for geometry helpers to work. On macOS: `brew install geos`. On Arch: `pacman -Syu geos`.

### Databases
* [Postgres](https://www.postgresql.org) with [Postgis](https://postgis.net). Lots of option there - simplest ones are either Docker, or direct installation on your OS. Create databases by running `rake db:create`.

### Running tests
Simply run `rspec`. If database connection fails, double check it's up and running and named databases are created.

### Running linters
There's couple of them: `rubocop` and `brakeman`. I recommend using `lefthook` for running them on pre-push Git hook. This way you can commit dirty code, but it won't get anywhere anyone can see it. Simply install them with `lefthook install`.

### Configuration
None should be required. Postgres connects on local socket, so no password is required. If you require changes, Rails guides like [the one from DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-set-up-ruby-on-rails-with-postgres) might be helpful.

### Deployment instructions
Heroku is hooked up to this Github account, so simply open a PR and it'll be deployed on merge. This is more or less default Heroku setup (Heroku Postgres supports Postgis by default), with only apt buildpack added to install dependencies. Steps are described on [RGeo wiki](https://github.com/rgeo/rgeo/wiki/Enable-GEOS-and-Proj4-on-Heroku#option-1-use-heroku-buildpack-apt).

### CI
Github Actions are used for linting PRs. In short they run [Danger](https://danger.systems/ruby/) and RSpec.

Danger checks for:
- Changelog convention - https://keepachangelog.com/en/1.0.0/,
- Commit messages - http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html,
- Rubocop - almost default configuration - with only Documentation disabled and LineLength extended.
