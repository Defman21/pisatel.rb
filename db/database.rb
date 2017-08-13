module DB
  Connection = Sequel.sqlite('./db/database.db')
  Connection.sql_log_level = :debug
  Connection.logger = ::Logging::Logger
end
