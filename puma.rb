#!/usr/bin/env puma

root = Dir.pwd

threads 1, 4
workers 3

if !ENV['USE_SOCKET'].nil? && ENV['USE_SOCKET'] == 1
  bind "unix://#{File.join(root, 'tmp/sock/puma.sock')}"
else
  bind "tcp://0.0.0.0:8080"
end
pidfile File.join(root, 'tmp/pid/puma.pid')

environment ENV['RACK_ENV'] || 'production'

rackup File.join root, 'config.ru'

preload_app!