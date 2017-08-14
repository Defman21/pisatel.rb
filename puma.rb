#!/usr/bin/env puma

root = Dir.pwd

threads 1, 4
workers 3

bind "unix://#{File.join(root, 'tmp/sock/puma.sock')}"
pidfile File.join(root, 'tmp/pid/puma.pid')

environment ENV['RACK_ENV'] || 'production'

rackup File.join root, 'config.ru'

preload_app!