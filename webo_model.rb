#!/usr/bin/ruby
require "mysql2"
require_relative "establish_connection.rb"
require_relative "mysql_adapter.rb"

class WeboModel
  @@model_parameters = {}

  def self.attr_access(*attribute)
    @@model_parameters[attribute[0]] = attribute[1]
    puts @@model_parameters
    field_name = @@model_parameters.keys
    field_name.each_index do |i|
      field_name[i] = field_name[i].to_s
    end
    self.class_eval do
      attr_accessor attribute[0]
    end
  end

  def initialize (hash)
    hash.each do |key, value|
      puts @@model_parameters.keys
      if @@model_parameters.has_key?(key.to_sym)
          instance_variable_set("@"+key,value)
      else
        puts "#{key} is not in field name"
      end
    end
  end

  def self.get_table_name
    table_name =self.name.downcase
    str_len = table_name.length
    table_name = table_name.insert(str_len, "s")
    table_name
  end

  def self.get_connection
    connection = Connection.new
    client = connection.establish_connection
    class_name = client.class.name.split("::")[0]
    class_name = "#{class_name}Adapter"
    klass = Object.const_get class_name
    return client, klass

  end

  def self.create_table
    client, klass = self.get_connection
    table_name = self.get_table_name
    create_table_object = klass.send("create_table", table_name,@@model_parameters)
    client.query(create_table_object)
    client.close

  end

  def self.all
    client, klass = self.get_connection
    table_name = self.get_table_name
    select_all_query = klass.send("all", table_name)
    puts select_all_query
    result = client.query(select_all_query)
    client.close
    result.entries

  end

  def self.show args
    client, klass = self.get_connection
    table_name = self.get_table_name
    find_query = klass.send("show", table_name, args)
    result = client.query(find_query)
    client.close
    result.entries
  end

  def self.destroy args
    client, klass = self.get_connection
    table_name = self.get_table_name
    destroy_query =  klass.send("destroy", table_name, args)
    client.query(destroy_query)
    client.close
  end

  def save
    client, klass = WeboModel.get_connection
    table_name = self.class.get_table_name
    arr = []
    @@model_parameters.keys.each do |key|
      arr.push(self.instance_variable_get("@#{key}"))
    end
    destroy_query =  klass.send("save", table_name, @@model_parameters,arr)
    client.query(destroy_query)
  end

  def update *args
    client, klass = WeboModel.get_connection
    table_name = WeboModel.get_table_name
  end

end


