#!/usr/bin/env ruby
require 'yaml'
require ::File.expand_path("../initializers.rb", __FILE__)

module GenerateConfigurationFile
  def self.create_database_file
    path_database_yml = File.expand_path("../database.yml", __FILE__)
    file = File.new("#{path_database_yml}","w")
    file.write(Constants::DATABASE_TOP_STRING + (Constants::DATABASE_INFORMATION).to_yaml + Constants::DATABASE_BOTTOM_STRING)
    file.close
  end
  def self.create_config_file app_name
    write_config = File.new("#{app_name}/config.ru","w")
    CONFIG_FILE_STRING = "#!/usr/bin/env ruby
require ::File.expand_path('../application.rb', __FILE__)
Rack::Server.start app: #{app_name}::Application, Port: 3000"
    write_config.write CONFIG_FILE_STRING
    write_config.close
  end
  def self.create_application_file app_name
    write_config = File.new("#{app_name}/config/application.rb","w+")
    APPLICATION_FILE_STRING = "require ::File.expand_path('../config/routes.rb', __FILE__)
Dir[\"#{app_name}/app/controllers/*.rb\"].each {|file| require file }
module #{app_name}
\s\sclass Application < Request
\s\send
end"
    write_config.write APPLICATION_FILE_STRING
    write_config.close
  end
  def self.create_gem_file app_name
    write_gem = File.new("#{app_name}/Gemfile", "w")
    write_gem.write Constants::GEM_FILE_STRING
    write_gem.close
  end
end