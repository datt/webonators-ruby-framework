#!/usr/bin/ruby
require 'fileutils'
require ::File.expand_path("../../webit/initializers.rb", __FILE__)
# Create directory structure when user creates new project in framework
class GenerateDirectoryFiles

  def generate app_name
    make_directory app_name
    generate_routes_file app_name
    create_database_file app_name
    create_config_file app_name
    create_application_file app_name
    create_gem_file app_name
  end

  private
    def make_directory(app_name)
      directory_array = [
        ["#{app_name}","app", "controllers"],
        ["#{app_name}","app", "models"],
        ["#{app_name}","app", "views"],
        ["#{app_name}","config"]
      ]
      unless File.exists?("#{app_name}")
        directory_array.each do |element|
          path = element.join("/")
          unless File.exists?path
            FileUtils.mkdir_p(path) unless File.exists?(path)
          else
            #some error message
          end
        end
      else
        #some error message like directory already presetn goes here
      end
    end

    def generate_routes_file(app_name)
      file=File.new("#{app_name}/config/routes.rb","w")
      file.write("class Routes < WebitRoutes\n")
      file.close
    end

    def create_database_file app_name
      # path_database_yml = File.expand_path("../database.yml", __FILE__)
      file = File.new("#{app_name}/config/database.yml","w")
      file.write(Constants::DATABASE_TOP_STRING + (Constants::DATABASE_INFORMATION).to_yaml + Constants::DATABASE_BOTTOM_STRING)
      file.close
    end

    def create_config_file app_name
      write_config = File.new("#{app_name}/config.ru","w")
      module_name = app_name.split("_").each {|word| word.capitalize!}
      module_name = module_name.join
      config_file_string = "#!/usr/bin/env ruby
                          require ::File.expand_path(\"../config/application.rb\", __FILE__)
                          Rack::Handler::WEBrick.run( #{module_name}::Application, :Port => 3000)"
      write_config.write config_file_string
      write_config.close
    end

    def create_application_file app_name
      write_config = File.new("#{app_name}/config/application.rb","w+")
      module_name = app_name.split("_").each {|word| word.capitalize!}
      module_name = module_name.join
      application_file_string = "require 'webit'
                                require ::File.expand_path('../routes.rb', __FILE__)
                                Dir[\"app/controllers/*.rb\"].each {|file| require_relative \"../\"+file}
                                Dir[\"app/models/*.rb\"].each {|file| require_relative \"../\"+file}
                                module #{module_name}
                                  class Application < Request
                                  end
                                end"
      write_config.write application_file_string
      write_config.close
    end

    def create_gem_file app_name
      write_gem = File.new("#{app_name}/Gemfile", "w")
      write_gem.write Constants::GEM_FILE_STRING
      write_gem.close
    end



end