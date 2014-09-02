#!/usr/bin/ruby
require "mysql2"
require_relative "connection.rb"
require_relative "mysql_adapter.rb"

class WebitModel
  @@model_parameters = {}

  def self.attr_access(*attribute)
    @@model_parameters[attribute[0]] = attribute[1]
    field_name = @@model_parameters.keys
    field_name.each_index do |i|
      field_name[i] = field_name[i].to_s
    end
    self.class_eval do
      attr_accessor attribute[0],:id
    end
  end

  def self.has_many (attribute)
    @relation = {}
    @relation["#{self.get_table_name}"] = "#{attribute}"
    if @relation.empty?
      puts "no reltion present"
    else
      client, klass = self.get_connection
      table_name = self.get_table_name
      add_column_query = klass.send("add_column",@relation)
      query = add_column_query.join("")
      puts query
     # client.query(query)
      add_foreign_key = klass.send("add_foreign_key",@relation)
      s = add_foreign_key
      client.query(s)
    end
    self.attr_access(@relation.values.join(" "))
    self.referring_table(@relation)
  end

  def initialize (hash={})
    count = self.class.count_records
    instance_variable_set("@id",count+1)
    hash.each do |key, value|
      if @@model_parameters.has_key?(key.to_sym)
          instance_variable_set("@"+key,value)
      else
        puts "#{key} is not in field name"
      end
    end
    self.class.find_by
    #self.class.related_table
  end

  def self.belongs_to (attribute)
    @relation = {}
    @relation["#{self.get_table_name}"] = "#{attribute}"
    self.attr_access("#{@relation.values.join(" ")}_id")

    self.search
    attribute

  end

  def self.search
    referred_table = @relation.values.join(" ")
    define_method("search") do |*args|
      if args.length == 2
        search_field = args[0]
        search_value = args[1]
        client, klass = self.class.get_connection
        table_name = self.class.get_table_name
        select_query = klass.send("search",table_name, referred_table,search_field,search_value)
        puts select_query
        result = client.query(select_query)
        puts result.entries
        client.close
      else
        puts "wrong number or parameter.. expected search_field and search_value"
      end
    end
  end

  def self.count_records
    client, klass = self.get_connection
    table_name = self.get_table_name
    fetch_count= klass.send("fetch_count", table_name)
    result = client.query(fetch_count)
    puts result.count
    if result.count == 0
      return 0
    else
      result.entries.first.values[0]
    end
  end

  def self.referring_table(relation)
    table = relation.values.join(" ")
    define_method("#{table}") do |arg = nil|
      id = self.instance_variable_get("@id")
      table_name = self.class.get_table_name
      client, klass = self.class.get_connection
      table_name1 = "posts"
      find_query = klass.send("fetch", table_name,table, id)
      puts find_query
      result = client.query(find_query)
      puts result.entries
    end
  end

  def self.find_by
    @@model_parameters.keys.each do |action|
      define_method("find_by_#{action}") do |argument|
        client, klass = self.class.get_connection
        table_name = self.class.get_table_name
        find_by_query = klass.send("find_by", table_name,action,argument)
        resultset = client.query(find_by_query)
        client.close
        resultset.entries
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
    @count = result.count
    puts @count
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
    client, klass = self.class.get_connection
    table_name = self.class.get_table_name
    value_arr = []
    @@model_parameters.keys.each do |key|
      value_arr.push(self.instance_variable_get("@#{key}"))
    end
    save_query =  klass.send("save", table_name, @@model_parameters,value_arr)
    puts save_query
    client.query(save_query)
  end

  #def update *args
  #  client, klass = WeboModel.get_connection
  #  table_name = WeboModel.get_table_name
  #end

end


