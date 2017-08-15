#!/usr/bin/env sh
echo "Running puma"
cd /usr/src/app && \
bundle exec sequel -m db/migrate db/config.yaml -E -e $RACK_ENV && \
rake assets:recompile && \
rake server:run
