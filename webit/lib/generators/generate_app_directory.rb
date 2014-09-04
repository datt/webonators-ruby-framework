#!/usr/bin/ruby
require 'fileutils'
require ::File.expand_path("../../webit/generate_configuration.rb", __FILE__)
# Create directory structure when user creates new project in framework
class GenerateAppDirectory

  def self.make_directory(app_name)
    directory_array = [
      ["#{app_name}","app", "controllers"],
      ["#{app_name}","app", "models"],
      ["#{app_name}","app", "views"],
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
    file.write("class Routes < WebitRoutes\n")
    file.close
  end

  def self.generate_default_files(app_name)
    File.new("#{app_name}/log/error.log","w")
    File.new("#{app_name}/log/application.log","w")
  end

  def self.generate app_name
    GenerateAppDirectory.make_directory app_name
    GenerateAppDirectory.generate_default_files app_name
    GenerateAppDirectory.generate_routes_file app_name
    GenerateConfiguration.create_database_file
    GenerateConfiguration.create_config_file app_name
    GenerateConfiguration.create_application_file app_name
    GenerateConfiguration.create_gem_file app_name
  end

end