#!/usr/bin/ruby
require 'fileutils'
=begin
  class create directory structure when user creates new project in framework
=end
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

  def self.generate_default_files(app_name)
    File.new("#{app_name}/log/error.log","w")
    File.new("#{app_name}/log/application.log","w")
  end

end
app_name =  ARGV[0]
GenerateAppDirectory.make_directory(app_name)
GenerateAppDirectory.generate_default_files(app_name)