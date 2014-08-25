require 'yaml'
def create_config_file
  information = {"Development" => {"adapter" => "mysql2", "hostname" => "localhost", "username" => "root", "password" => ""}}
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
  file = File.open("database.yml", "r")
  lines = file.readlines
  file.close
  lines.each do |line|
  	if line.start_with? "#"
      remove_comments.push(line)
    end
  end
  lines -= remove_comments
end

def extract_configuration
  lines = read_config_file
  key, value = [], []
  lines.each do |line|
  	if line.include? ":"
  	  unless line.split(":")[1].strip.empty?
  	  	key.push(line.split(":")[0].strip)
  	  	value.push(line.split(":")[1].strip)
  	  end
  	end
  end
  configurations = Hash[key.zip value]
  puts configurations
end
