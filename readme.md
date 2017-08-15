# Pisatel

Pisatel is a blog engine written in Ruby.

## Installation

### docker-compose

1. Clone the repo.
2. `docker-compose up`

> By default, the application runs in the production mode.
You can edit the `docker-compose.yaml` and change the `RACK_ENV` variable
to `development` or `production`.

### Manual installation

1. Clone the repo.
2. `bundle install`
3. `bundle exec sequel db/config.yaml -m db/migrate -e development -E`
4. `RACK_ENV=development rake server:run`

### Application modes

**Development** mode enables the following features:

* Restart the server when you change the `.rb` files in the `./app` directory
* Compile assets on-the-fly and serve them with Sprockets
* Verbose Sequel logging
* Verbose Rack logging

**Production** mode enables the following features:

* Precompiled assets
* Faster assets serving by Sinatra
* No verbose logging

## Configuration

### Database

Install the adapter gem for your database and create the `db/config.yaml` file.
For the reference, see `db/config.examlpe.yaml`.

### Site

Copy `app/config.example.yaml` to `app/config.yaml`. You can edit it in an
editor or in the admin panel.

### HTTPS

You should set up a reverse proxy for that. There are lots of articles on the
Internet about that. By default, the docker container binds itself to
`localhost:8080` on the host, but because the puma server binds itself to
`0.0.0.0:8080`, you can proxy the queries directly to the container.


## License

[MIT License](/license.md).