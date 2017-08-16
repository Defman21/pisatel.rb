class ApplicationController < Sinatra::Base
  set :root, File.expand_path('../../../', __FILE__)
  set :app_root, File.join(root, 'app')
  
  set :version, "0.2.1".freeze
  
  set :sprockets, Sprockets::Environment.new(root)
  set :assets_prefix, '/assets'
  set :assets_path, File.join(root, '/public', assets_prefix)
  
  configure do
    sprockets.append_path File.join(app_root, 'assets', 'stylesheets')
    sprockets.append_path File.join(app_root, 'assets', 'javascripts')
    
    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix      = assets_prefix  
      config.debug       = true if development?
      
      if production?
        unless File.directory? assets_path
          Logging::Logger.warn 'Assets are not compiled! Run rake assets:precompile and restart the application'
        end
        config.digest = true
        config.manifest = Sprockets::Manifest.new(sprockets, File.join(assets_path, 'manifest.json'))
        
        # Let Sinatra handle /assets (./public/assets)
        set :public_folder, File.join(root, 'public')
      end
    end
  end
  
  configure :development do
    sprockets.cache = Sprockets::Cache::FileStore.new('./tmp')
    use Logging::RackLogger, Logging::Logger
    
    get "/assets/*" do
      env["PATH_INFO"].sub!("/assets", "")
      settings.sprockets.call(env)
    end
  end

  helpers do
    include Sprockets::Helpers
    include Sinatra::ContentFor
  end

  set :haml, format: :html5
  set :views, File.expand_path('../../views', __FILE__)
  set :site, Preferences.new(File.join(app_root, 'config.yaml'))

  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :expire_after => 2592000,
                             :secret => "keep_your_secrets"
end
