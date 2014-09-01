#!/usr/bin/env ruby
require 'yaml'
require ::File.expand_path("../initializers.rb", __FILE__)

module GenerateConfigurationFile
  def self.create
    file = File.new("database.yml","w")
    file.write(Constants::TOP_STRING + (Constants::INFORMATION).to_yaml + Constants::BOTTOM_STRING)
    file.close
  end

  def self.create_routes_file
    file = File.new("routes.rb", "w")
    file.write(Constants::ROUTES_STRING)
    file.close
  end
end