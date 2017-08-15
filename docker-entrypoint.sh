#!/usr/bin/env sh
echo "Running puma"
cd /usr/src/app && \
bundle exec sequel -m db/migrate db/config.yaml -E -e $RACK_ENV && \
rake assets:recompile && \
if [ "$RACK_ENV" == "production" ]; then bundle exec puma -C ./puma.rb; else rake server:run; fi
