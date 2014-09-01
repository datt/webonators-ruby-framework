#!/usr/bin/env ruby
require 'yaml'
require_relative 'initializers.rb'

module GenerateConfigurationFile
  def self.create
    file = File.new("database.yml","w")
    file.write(Constants::TOP_STRING + (Constants::INFORMATION).to_yaml + Constants::BOTTOM_STRING)
    file.close
  end

  def self.read
    remove_comments = []
    file = YAML.load_file("database.yml")
  end

  def self.extract
    configuration = read_config_file
    configuration["development"]
  end

  def self.create_routes_file
    file = File.new("routes.rb", "w")
    file.write(Constants::ROUTES_STRING)
    file.close
  end

end