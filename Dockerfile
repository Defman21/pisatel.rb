FROM ruby:alpine

RUN apk add --update git g++ make sqlite-dev nodejs

WORKDIR /tmp
COPY Gemfile* ./
RUN bundle install

COPY . /usr/src/app
WORKDIR /usr/src/app
RUN mkdir -p ./tmp/pid
RUN mkdir -p ./tmp/sock
RUN mkdir -p ./db/data

ENTRYPOINT '/usr/src/app/docker-entrypoint.sh'