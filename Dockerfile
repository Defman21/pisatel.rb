FROM ruby:alpine

RUN apk add --update git g++ make sqlite-dev nodejs

ARG deployment=true

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN if [ "$deployment" = "true" ]; then bundle install --deployment; else bundle install; fi

COPY . ./
RUN mkdir -p ./tmp/pid

ENTRYPOINT '/usr/src/app/docker-entrypoint.sh'