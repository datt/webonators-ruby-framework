#!/usr/bin/env ruby
require 'yaml'

module GenerateConfigurationFile
  def self.create_config_file
    info = { "development" =>
{
"adapter" => "mysql2",
"database" => "test",
"hostname" => "localhost",
"username" => "root",
"password" => ""
}
}
    file = File.new("database.yml","w")
    top_string = "# MySQL version 5.x
#   gem install mysql2
#
# This file contains database configuration for mysql2 gem
# To change the credentials or hostname, change it in here...
# This field is meant only for database\n"

  	bottom_string = "# You can add another yaml document below with a header and
# then list of keys and values

# Database:
#  adapter: sqlite3
#  database: db/development.sqlite3\n"

    file.write(top_string + info.to_yaml + bottom_string)
    file.close
  end

  def self.read_config_file
    remove_comments = Array.new()
    file = YAML.load_file("database.yml")
  end

  def self.extract_configuration
    configuration = read_config_file
    configuration["development"]
  end
end

#create_config_file
#extract_configuration
