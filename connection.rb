#!/usr/bin/ruby
require "mysql2"
require 'yaml'
require_relative "generate_configuration.rb"

class Connection

  def self.read_config_file
    remove_comments = Array.new()
    file = YAML.load_file("database.yml")
  end

  def self.extract_configuration
    configuration = read_config_file
    configuration["development"]
  end

  def establish_connection
    configuration = Connection.extract_configuration
    adapter = configuration["adapter"]
    case adapter
      when "mysql2"
        hostname = configuration["hostname"]
        password = configuration["password"]
        username = configuration["username"]
        database = configuration["database"]
        @connection = Mysql2::Client.new(:host => "#{hostname}", :username => "#{username}",
                                        :password => "#{password}", :database =>"#{database}")

      when "sqlite3"
        ##---------------------------------------------##
        ##----connection string for connecting to sqlite3
        ##---------------------------------------------##
      when "mongod"
        ##---------------------------------------------##
        ##----connection string for connecting to sqlite3
        ##---------------------------------------------##
    end
    @connection
  end

  def destroy_connection
    puts "some"
    @connection.close
  end

end