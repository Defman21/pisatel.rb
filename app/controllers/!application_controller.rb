class ApplicationController < Sinatra::Base
  set :root, File.expand_path('../../', __FILE__)
  
  set :sprockets, Sprockets::Environment.new(root)
  set :assets_prefix, '/assets'
  set :assets_path, '/public'
  
  configure do
    sprockets.append_path File.join(root, 'assets', 'stylesheets')
    sprockets.append_path File.join(root, 'assets', 'javascripts')
  
    sprockets.js_compressor  = :uglify
    sprockets.css_compressor = :sass
    
    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix      = assets_prefix  
      config.debug       = true if development?
      
      if production?
        config.digest = true
        config.manifest = Sprockets::Manifest.new(sprockets, File.join(assets_path, 'manifest.json'))
      end
    end
  end
  
  configure :development do
    sprockets.cache = Sprockets::Cache::FileStore.new('./tmp')
    use Logging::RackLogger, Logging::Logger
  end
  
  Markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: true, prettify: true),
                                     fenced_code_blocks: true,
                                     smartypants: true,
                                     no_intra_emphasis: true,
                                     disable_indented_code_blocks: true)
  
  helpers do
    include Sprockets::Helpers
    
    def markdown(text)
      find_and_preserve Markdown.render text
    end
  end

  set :haml, format: :html5
  set :views, File.expand_path('../../views', __FILE__)
  set :site, YAML.load_file(File.join(root, 'config.yaml'))

  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :expire_after => 2592000,
                             :secret => "keep_your_secrets"
end
