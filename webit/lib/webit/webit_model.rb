#require "mysql2"
require ::File.expand_path("../connection.rb", __FILE__)
require ::File.expand_path("../adapter/mysql_adapter.rb", __FILE__)
class WebitModel
  @@model_parameters = {}

  def initialize(hash={})
  hash.each do |key, value|
    if @@model_parameters.has_key?(key.to_sym)
      instance_variable_set("@"+key,value)
    end
  end
  get_connection
  get_table_name
  end

  def self.attr_access(*attribute)
    @@model_parameters[attribute[0]] = attribute[1]
    self.class_eval do
      attr_accessor attribute[0],:id
    end
  end

  def get_connection
    connection = Connection.new
    client,adapter = connection.establish_connection
    class_name = "#{adapter.capitalize}Adapter"
    @klass = Object.const_get("Adapter").const_get class_name
    @client = client
   return @client,@klass
  end

  def get_table_name
    table_name =self.class.name.downcase
    str_len = table_name.length
    table_name = table_name.insert(str_len, "s")
    @table_name = table_name
  end

  def self.belongs_to (attribute)
    relation = {}
    relation["#{self.new.get_table_name}"] = "#{attribute}"
    self.attr_access("#{relation.values.join(" ")}_id")
  end

  def self.has_many (attribute)
    relation = {}
    relation["#{self.new.get_table_name}"] = "#{attribute}"
    unless relation.empty?
      client, klass = self.new.get_connection
      select_all_query = klass.new.send("all", attribute)
      table_name = self.new.get_table_name
      result = client.query(select_all_query)
      unless result.fields.include?("#{table_name}_id")
        add_column_query = klass.new.send("add_column",relation)
        query = add_column_query.join(" ")
        client.query(query)
      end
      add_foreign_key = klass.new.send("add_foreign_key",relation)
      s = add_foreign_key
      client.query(s)
    end
    self.attr_access(relation.values.join(" "))
  end

  def create_table model_class_name,data_type,column_name
    table_name = model_class_name
    model_class_name = model_class_name.capitalize
    model_class = Class.new WebitModel
    table_name = "#{table_name}s"
    puts table_name
    client, klass = get_connection
    puts @client
    model_parameters = Hash[column_name.zip data_type]
    create_table_object = klass.send("create_table", table_name,model_parameters)
    client.query(create_table_object)
    client.close
  end

  def self.all
    client, klass = self.new.get_connection
    table_name = self.new.get_table_name
    select_all_query = klass.new.send("all", table_name)
    result = client.query(select_all_query)
    client.close
    result.entries
  end

  def self.find args
    client, klass = self.new.get_connection
    table_name = self.new.get_table_name
    find_query = klass.new.send("find",table_name, args)
    result = client.query(find_query)
    client.close
    result.entries
  end

  def destroy args
    destroy_query =@klass.new.send("destroy",@table_name, args)
    @client.query(destroy_query)
    @client.close
  end

  def save args
    save_query = @klass.new.send("save", @table_name,args)
    @client.query(save_query)
    @client.close
  end

  def update args
    update_query = @klass.new.send("update", @table_name,args)
    @client.query(update_query)
    @client.close
  end

   def find_by args
    find_by_query = @klass.new.send("find_by",@table_name,args)
    resultset = @client.query(find_by_query)
    @client.close
    resultset.entries
  end
end


