#!/usr/bin/ruby
require "mysql2"
require 'yaml'

class Connection
  #method for establishing connection
  def establish_connection
    configuration = extract_configuration
    adapter = configuration["adapter"]
    case adapter
      when "mysql2"
        hostname = configuration["hostname"]
        password = configuration["password"]
        username = configuration["username"]
        database = configuration["database"]
        @connection = Mysql2::Client.new(:host => "#{hostname}", :username => "#{username}",
                                        :password => "#{password}", :database =>"#{database}")
    end
    return  @connection,adapter
  end

  private
    #read database.yml for database configuration
    def read_config_file
      path = "#{ROOT}/config/database.yml"
      file = YAML.load_file("#{path}")
    end

    #extracting configuration, default is development
    def extract_configuration(env = "development")
      configuration = read_config_file
      configuration["#{env}"]
    end
end