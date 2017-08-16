#!/usr/bin/env sh
echo "Running puma"
cd /usr/src/app
if [ ! -f config/app.yaml ]; then
    cp ./config/app.example.yaml ./config/app.yaml
    echo "Admin panel login: login, password: password"
fi
bundle exec rake assets:recompile && \
bundle exec rake server:run
