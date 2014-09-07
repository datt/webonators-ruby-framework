#require "mysql2"
require ::File.expand_path("../connection.rb", __FILE__)
require ::File.expand_path("../mysql_adapter.rb", __FILE__)
class WebitModel
  @@model_parameters = {}

  def initialize(hash={})
    count = self.class.fetch_last_row
    instance_variable_set("@id",count+1)
    hash.each do |key, value|
      if @@model_parameters.has_key?(key.to_sym)
        instance_variable_set("@"+key,value)
      end
    end
  end
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

  def self.belongs_to (attribute)
    relation = {}
    relation["#{self.get_table_name}"] = "#{attribute}"
    self.attr_access("#{relation.values.join(" ")}_id")
  end

  def self.has_many (attribute)
    relation = {}
    relation["#{self.get_table_name}"] = "#{attribute}"
    unless relation.empty?
      client, klass = get_connection
      table_name = self.get_table_name
      select_all_query = klass.send("all", attribute)
      result = client.query(select_all_query)
      unless result.fields.include?("#{table_name}_id")
        add_column_query = klass.send("add_column",relation)
        query = add_column_query.join(" ")
        client.query(query)
      end
      add_foreign_key = klass.send("add_foreign_key",relation)
      s = add_foreign_key
      client.query(s)
    end
    self.attr_access(relation.values.join(" "))
    self.referring_table(relation)
  end

  def self.fetch_last_row
    client, klass = self.get_connection
    table_name = self.get_table_name
    fetch_count= klass.send("fetch_last_row_count", table_name)
    result = client.query(fetch_count)
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
      find_query = klass.send("fetch", table_name,table, id)
      result = client.query(find_query)
      result.entries
    end
  end

  def self.find_by args
    client, klass = self.get_connection
    table_name = self.get_table_name
    find_by_query = klass.send("find_by", table_name,args)
    resultset = client.query(find_by_query)
    client.close
    resultset.entries
  end

  def self.get_table_name
    table_name =self.name.downcase
    str_len = table_name.length
    table_name = table_name.insert(str_len, "s")
    table_name
  end

  protected
  def self.get_connection
    connection = Connection.new
    client,adapter = connection.establish_connection
    class_name = "#{adapter.capitalize}Adapter"
    klass = Object.const_get class_name
    return client, klass
  end

  def self.create_table model_class_name,data_type,column_name
    table_name = model_class_name
    model_class_name = model_class_name.capitalize
    model_class = Class.new WebitModel
    table_name = "#{table_name}s"
    client, klass = model_class.get_connection
    model_parameters = Hash[column_name.zip data_type]
    create_table_object = klass.send("create_table", table_name,model_parameters)
    client.query(create_table_object)
    client.close
  end

  def self.all
    client, klass = self.get_connection
    table_name = self.get_table_name
    select_all_query = klass.send("all", table_name)
    result = client.query(select_all_query)
    client.close
    @count = result.count
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

  def self.save args
    client, klass = self.get_connection
    table_name = self.get_table_name
    save_query = klass.send("save", table_name,args)
    client.query(save_query)
  end

  def self.update args
    client, klass = self.get_connection
    table_name = self.get_table_name
    update_query = klass.send("update", table_name,args)
    client.query(update_query)
  end

end


