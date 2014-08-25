#!/usr/bin/env ruby
require 'yaml'
def create_config_file
  information = {"development" => {"adapter" => "mysql2", "hostname" => "localhost", "username" => "root", "password" => ""}}
  file = File.new("database.yml","w")
  top_string = "# MySQL version 5.x
# 	gem install mysql2
#
#	This file contains database configuration for mysql2 gem
#	To change the credentials or hostname, change it in here...
#	This field is meant only for database\n"
  
  bottom_string = "# You can add another yaml document below with a header and
# then list of keys and values

# Database:
#  adapter: sqlite3
#  database: db/development.sqlite3\n"
  
  file.write(top_string + information.to_yaml + bottom_string)
  file.close
end

def read_config_file
  remove_comments = Array.new()
  file = YAML.load_file("database.yml")
end

def extract_configuration
  lines = read_config_file
  puts lines["development"]
end

create_config_file
extract_configuration