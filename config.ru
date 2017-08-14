require 'sinatra/base'
require 'sinatra/json'

require 'sprockets'
require 'sprockets-helpers'

require 'logger'

require 'sequel'

require 'redcarpet'
require 'oj'
require 'haml'
require 'sass'
require 'uglifier'
require 'coffee-script'
require 'execjs'
require 'yaml'

require 'graphql'
require 'graphql/batch'


module Logging  
  Logger = ::Logger.new $stdout
  Logger.datetime_format = '%Y-%d-%m %H:%M:%S'
  Logger.formatter = -> (severity, datetime, progname, msg) {
    unless progname.nil?
      progname = "(#{progname})"
    end
    "[#{datetime}] -- #{severity}: #{msg} #{progname}\n"
  }
  
  class RackLogger
    FORMAT = %{(%0.8ss) %s - %s %s%s %s %s | %s bytes}
    
    def initialize(app, logger)
      @app, @logger = app, logger
    end
    
    def call(env)
      began_at = Time.now
      status, header, body = @app.call env
      header = Rack::Utils::HeaderHash.new header
      log env, status, header, began_at
      [status, header, body]
    end
    
    private
    def log(env, status, header, began_at)
      length = extract_content_length header
      
      logger = @logger
      logger.debug FORMAT % [
        Time.now - began_at,
        env['HTTP_X_REAL_IP'] || \
        env['HTTP_X_FORWARDED_FOR'] || \
        env['REMOTE_ADDR'] || '-',
        env['REQUEST_METHOD'],
        env['PATH_INFO'],
        env['QUERY_STRING'].empty? ? '' : "?#{env['QUERY_STRING']}",
        env['HTTP_VERSION'],
        status.to_s[0..3],
        length
      ]
    end
    
    def extract_content_length(headers)
      value = headers['Content-Length'] or return '-'
      value.to_s == '0' ? '-' : value
    end
  end
end

module MD
  Render = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: true, prettify: true),
                                   fenced_code_blocks: true,
                                   smartypants: true,
                                   no_intra_emphasis: true,
                                   disable_indented_code_blocks: true)
  def self.render(text)
    Render.render text
  end
end

require './db/database'

Dir.glob('./db/models/*.rb').each do |model|
  require model
end

Dir.glob('./app/services/*.rb').each do |service|
  require service
end

Dir.glob('./app/controllers/*.rb').sort.each do |controller|
  require controller
end

map('/') { run IndexController }
map('/admin') { run AdminController }
map('/assets') { run IndexController.sprockets }