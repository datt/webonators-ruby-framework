#!/usr/bin/ruby
require 'fileutils'
require ::File.expand_path("../../support/generate_configuration.rb", __FILE__)
# Create directory structure when user creates new project in framework
class GenerateAppDirectory

  def self.make_directory(app_name)
    directory_array = [
      ["#{app_name}","app", "controllers"],
      ["#{app_name}","app", "models"],
      ["#{app_name}","app", "views"],
      ["#{app_name}","db","migration"],
      ["#{app_name}","log"],
      ["#{app_name}","config"]
    ]
    if File.exists?("#{app_name}")
      puts "#{app_name} is already up to date"
      user_choice = $stdin.gets.chomp
    else
      path_array= []
      directory_array.each do |element|
        path = element.join("/")
        path_array.push(path)
        if File.exists?path
          puts "#{path} file is present "
        else
          FileUtils.mkdir_p(path) unless File.exists?(path)
        end
      end
      path_array
    end
  end

  def self.generate_routes_file(app_name)
    file=File.new("#{app_name}/config/routes.rb","w")
    file.write("class Routes < WeboRoutes\n\n")
    file.close
  end

  def self.generate_default_files(app_name)
    File.new("#{app_name}/log/error.log","w")
    File.new("#{app_name}/log/application.log","w")
  end

  def self.generate_database_yml
    GenerateConfigurationFile.create
  end

  def self.write_config_file(app_name)
    write_config = File.new("#{app_name}/config.ru","w")
    write_config.write "#!/usr/bin/env ruby\n"
    write_config.write "require ::File.expand_path('../application.rb', __FILE__)\n"
    write_config.write "Rack::Server.start app: #{app_name}::Application, Port: 3000\n"
    write_config.close
  end

  def self.write_application_file(app_name)
    write_config = File.new("#{app_name}/config/application.rb","w+")
    write_config.write "require ::File.expand_path('../config/routes.rb', __FILE__)\n"
    write_config.write " Dir[\"#{app_name}/controllers/*.rb\"].each {|file| require file }\n"
    write_config.write "module SampleApp\n"
    write_config.write "\s\sclass Application < WeboController\n"
    write_config.write "\s\send\n"
    write_config.write "end\n"
    write_config.close
  end
end