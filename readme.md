# Pisatel

Pisatel is a blog engine written in Ruby.

## Installation

### docker-compose

1. Clone the repo.
2. `docker-compose up`

> By default, the application runs in the production mode.
You can edit the `docker-compose.yaml` file and change the `RACK_ENV` variable
to `development` or `production`.

### Manual installation

1. Clone the repo.
2. `bundle install`
3. `bundle exec sequel db/config.yaml -m db/migrate -e development -E`
4. `cp app/config.example.yaml app/config.yaml`
5. `RACK_ENV=production rake server:run`

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

Install the adapter gem for your database and run the application. You'll setup
everything needed within the site. (host, port, database name, etc.)

Adapters:

* `sqlite://` - `gem "sqlite3"`
* `mysql://` - `gem "mysql2"`
* `mysql2://` - `gem "mysql2"`
* `postgres://` - `gem "pg"`

### Site

You can edit your site settings in the admin panel. To enter it, use the
following credentials:

* Login: `login`
* Password: `password`

Change them **immediately** on the Settings page!

### HTTPS

You should set up a reverse proxy for that. There are lots of articles on the
Internet about that. By default, the docker container binds itself to
`localhost:8080` on the host, but because the puma server binds itself to
`0.0.0.0:8080`, you can proxy the queries directly to the container.


## License

[MIT License](/license.md).