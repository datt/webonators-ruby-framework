#!/usr/bin/ruby
require 'fileutils'
module ModelFileRead
  def self.read_model_file
    attribute_arr = []
    @model_file = "models/post.rb"
    File.open(@model_file, "r") do |file_pointer|
      file_pointer.each_line do |line|
        if line.include? "attribures"
           attribute_arr = line
        end
      end
    end
    attribute_arr
  end

  def self.getattributes


  end

  def self.getmodel
    models = Dir["models/**/*.rb"]
    puts models
    models
  end

  def self.get_classname
    class_name = "post"
    class_name
  end
end

