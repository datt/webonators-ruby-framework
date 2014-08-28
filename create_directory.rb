#!/usr/bin/ruby
require 'fileutils'
=begin
  class create directory structure when user creates new project in framework
=end
class CreateDirectory

  def self.make_directory(app_name)
    directory_array = [["#{app_name}","app", "controllers"], ["#{app_name}","app", "models"], ["#{app_name}","app", "views"],
                        ["#{app_name}", "db","migration"],["#{app_name}","log"],["#{app_name}","config"]]
    path_array= []
    for i in 0...directory_array.size
      path = directory_array[i].join("/")
      path_array.push(path)
      FileUtils.mkdir_p(path) unless File.exists?(path)
    end
    path_array
  end

  def self.generate_default_files(app_name)
    File.new("#{app_name}/log/error.log","w")
    File.new("#{app_name}/log/application.log","w")
  end

end
app_name =  ARGV[0]
CreateDirectory.make_directory(app_name)
CreateDirectory.generate_default_files(app_name)