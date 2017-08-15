require 'yaml'

class Preferences
  attr_accessor :preferences, :file
  def initialize(file_path)
    @file_path = file_path
    File.open @file_path, "r" do |f|
      Logging::Logger.debug "Opened #{@file_path} in read mode"
      @preferences = YAML.load f.read
      Logging::Logger.debug 'Loaded preferences'
    end
  end
  
  def [](key)
    @preferences[key]
  end
  
  def save
    File.open @file_path, "w" do |f|
      Logging::Logger.debug "Opened #{@file_path} in write mode"
      f.write YAML.dump(@preferences, indentation: 4)
    end
  end
end