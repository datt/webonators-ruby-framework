#!/usr/bin/env ruby
require 'yaml'
require ::File.expand_path("../initializers.rb", __FILE__)

module GenerateConfiguration
  def self.create_database_file
    path_database_yml = File.expand_path("../database.yml", __FILE__)
    file = File.new("#{path_database_yml}","w")
    file.write(Constants::DATABASE_TOP_STRING + (Constants::DATABASE_INFORMATION).to_yaml + Constants::DATABASE_BOTTOM_STRING)
    file.close
  end

  def self.create_config_file app_name
    write_config = File.new("#{app_name}/config.ru","w")
    config_file_string = "#!/usr/bin/env ruby
require ::File.expand_path(\"../config/application.rb\", __FILE__)
Rack::Server.start app: #{app_name}::Application, Port: 3000"
    write_config.write config_file_string
    write_config.close
  end

  def self.create_application_file app_name
    write_config = File.new("#{app_name}/config/application.rb","w+")
    application_file_string = "require ::File.expand_path('../routes.rb', __FILE__)
Dir[\"#{app_name}/app/controllers/*.rb\"].each {|file| require file }
module #{app_name}
  class Application < Request
  end
end"
    write_config.write application_file_string
    write_config.close
  end

  def self.create_gem_file app_name
    write_gem = File.new("#{app_name}/Gemfile", "w")
    write_gem.write Constants::GEM_FILE_STRING
    write_gem.close
  end
end