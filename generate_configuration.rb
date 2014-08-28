#!/usr/bin/env ruby
require 'yaml'
require_relative 'initializers.rb'
module GenerateConfigurationFile
  def self.create_config_file
    file = File.new("database.yml","w")
    file.write(Constants::TOP_STRING + (Constants::INFORMATION).to_yaml + Constants::BOTTOM_STRING)
    file.close
  end

  def self.read_config_file
    remove_comments = Array.new()
    file = YAML.load_file("database.yml")
  end

  def self.extract_configuration
    configuration = read_config_file
    configuration["development"]
  end
end