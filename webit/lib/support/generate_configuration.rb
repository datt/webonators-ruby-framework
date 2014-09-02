#!/usr/bin/env ruby
require 'yaml'
require ::File.expand_path("../initializers.rb", __FILE__)

module GenerateConfigurationFile
  def self.create
    path_database_yml = File.expand_path("../database.yml", __FILE__)
    file = File.new("#{path_database_yml}","w")
    file.write(Constants::TOP_STRING + (Constants::INFORMATION).to_yaml + Constants::BOTTOM_STRING)
    file.close
  end
end