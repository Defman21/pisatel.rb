#!/usr/bin/env sh
echo "Running puma"
cd /usr/src/app
if [ ! -f app/config.yaml ]; then
    cp ./app/config.example.yaml ./app/config.yaml
    echo "Admin panel login: login, password: password"
fi
rake assets:recompile && \
rake server:run
