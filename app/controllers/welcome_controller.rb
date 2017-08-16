class WelcomeController < ApplicationController
  get '/' do
    @site = settings.site
    @javascripts = %w(welcome)
    @stylesheets = %w(welcome)
    haml :'welcome/index', layout: :application
  end
  
  post '/setup' do
    begin
      data = Oj.load params['json']
      File.open(File.join(settings.root, 'config/db.yaml'), "w+") do |file|
        if data['adapter'] == 'sqlite'
          yaml = <<YAML
---
production: &production
    adapter: #{data['adapter']}
    database: #{data['db_file']}

development:
    <<: *production
    database: #{data['db_file']}.dev
YAML
        else
          yaml = <<YAML
production: &production
    adapter: #{data['adapter']}
    host: #{data['host']}
    port: #{data['port']}
    database: #{data['database']}_production
    username: #{data['username']}
    password: #{data['password']}

development:
    <<: *production
    database: #{data['database']}_development
YAML
        end
        file.write yaml
        Sequel.connect(YAML.load(yaml)[ENV['RACK_ENV']])
      end
      IO.popen("bundle exec sequel config/db.yaml -m db/migrate -e #{ENV['RACK_ENV']} -E 2>&1") do |lines|
        json({
          result: 'ok',
          output: lines.read
        })
      end
    rescue
      require 'fileutils'
      FileUtils.rm_rf(File.join(settings.root, 'config/db.yaml'))
      json({
        error: $!
      })
    end
  end
end