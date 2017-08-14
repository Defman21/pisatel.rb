module DB
  Connection = Sequel.connect YAML.load(File.read './db/config.yaml')[ENV['RACK_ENV']]
  Connection.sql_log_level = :debug
  Connection.logger = ::Logging::Logger
end
