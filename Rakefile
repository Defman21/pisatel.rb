require 'rake/tasklib'
require 'rake/sprocketstask'

require 'logger'

$logger = Logger.new $stdout

$logger.datetime_format = '%Y-%d-%m %H:%M:%S'
$logger.formatter = -> (severity, datetime, progname, msg) {
  unless progname.nil?
    progname = "(#{progname})"
  end
  "[#{datetime}] -- #{severity}: #{msg} #{progname}\n"
}

namespace :assets do
  task :precompile do
    require 'sass'
    require 'uglifier'
    root = Dir.pwd
    assets_path = File.join root, 'app', 'assets'
    public_path = File.join root, 'public', 'assets'
    
    env = Sprockets::Environment.new root
    env.append_path File.join assets_path, 'javascripts'
    env.append_path File.join assets_path, 'stylesheets'
    
    env.js_compressor  = :uglify
    env.css_compressor = :sass
    
    manifest = Sprockets::Manifest.new env, File.join(public_path, 'manifest.json')
    
    manifest.compile %w(app.coffee admin.coffee app.sass admin.sass)
    $logger.info "Compiled #{assets_path} to #{public_path}."
  end
  
  task :clear do
    require 'fileutils'
    public_path = File.join Dir.pwd, '/public/assets'
    FileUtils.rm_rf public_path
    $logger.info "Removed #{public_path}."
  end
  
  task recompile: ['assets:clear', 'assets:precompile'] do
    $logger.info 'Recompiled assets.'
  end
end

namespace :server do
  task :run do
    if ENV['RACK_ENV'] == 'development'
      exec %q(bundle exec rerun \
      -d app/controllers \
      -d app/services \
      -d db/ \
      -d ./ \
      -p "**/*.{rb,ru}" \
      -- \
      puma -p 8080 config.ru
      )
    else
      exec %q(bundle exec puma -C ./puma.rb)
    end
  end
end