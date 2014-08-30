#!/usr/bin/ruby
require "mysql2"
require_relative "generate_configuration.rb"
require_relative "fileread.rb"

class WeboModel
  @@arr = {}
  @@relationship ={}
  include GenerateConfigurationFile
  include ModelFileRead
  def get_connection
    configuration = GenerateConfigurationFile.extract_configuration
    hostname = configuration["hostname"]
    password = configuration["password"]
    username = configuration["username"]
    database = configuration["database"]
    connection = Mysql2::Client.new(:host => "#{hostname}", :username => "#{username}",
                                    :password => "#{password}", :database =>"#{database}")
  end

  def self.attr_access(*attribute)
      @@arr[attribute[0]] = attribute[1]
  end

  def self.belongs_to(attribute)
    table_name = self.new.get_table_name
    @@relationship["#{table_name}"] = attribute
  end

  def self.relationship
    p @@relationship
  end

  def get_parameter
    parameter =FileRead.read_model_file
    @column_name = parameter.keys
    @datatype = parameter.values
  end

  def get_datatypes
    datatypes = @@arr.values
  end

  def get_columnname
    column_name = @@arr.keys
  end

  def create_query
    datatype = get_datatypes
    column_name = get_columnname
    datatype_arr = []
    puts datatype
    datatype.each do |data|
      if data == 'string'
        datatype_arr.push("VARCHAR"+"(255)")
      else
        datatype_arr.push(data.upcase)
      end
    end
    query_arr = []                              # tempory array for holding column name and datatype
    for i in 0...column_name.size
      query ="#{column_name[i]} #{datatype_arr[i]}"
      query_arr.push(query)
    end
    query = query_arr.join(",")
    query
  end

  def get_table_name
    table_name = ModelFileRead.get_classname
    table_name.downcase
  end

  def create_table
    p @@relationship
    query = create_query
    connection = get_connection
    table_name = get_table_name
    create_table = "CREATE TABLE IF NOT EXISTS #{table_name}
                    (id INT PRIMARY KEY AUTO_INCREMENT NOT NULL ,
                    #{query})"
    if @@relationship.empty?
      connection.query(create_table)
    else
      add_foreign_key
    end
  end

  def add_foreign_key

    puts @@relationship
    table_name1 = @@relationship.keys.join("")
    table_name2 = @@relationship.values.join("")
    alter = "ALTER TABLE #{table_name1}
            ADD FOREIGN KEY (#{table_name2}_id)
            REFERENCES #{table_name2}(id)"
    puts alter
    connection = get_connection
    connection.query(alter)
  end

  def save args
    get_parameter
    connection = get_connection
    fields = get_columnname
    table_name = get_table_name
    column_fileds = fields.join(",")
    query = "INSERT INTO #{table_name} (#{column_fileds}) VALUES ('user') "
    connection.query(query)
  end

  def all
    connection = get_connection
    table_name = get_table_name
    result_arr= []
    resultset = connection.query("SELECT * FROM #{table_name}")
    rows_num = 0...resultset.num_rows
    rows_num.each do |index|
      resultset_hash = resultset.fetch_hash
      result_arr.push(resultset_hash)
    end
    result_arr
  end

  def find args
    connection = get_connection
    table_name = get_table_name
    puts args
    resultset = connection.query("SELECT * FROM #{table_name} WHERE id = #{args} ")
    resultset.fetch_hash
  end

  def update_query
    value_arr = []
    get_parameter
    column_name = get_columnname
    column_name.each do |element|
      puts "enter updated value"
      value = gets.chomp
      value_arr.push(value)
    end
    query_arr = []
    column_name.each_index do |i|
       query ="#{column_name[i]} = #{value_arr[i]}"
       query_arr.push(query)
    end
    query = query_arr.join(",")
    query
  end

  def update
    get_parameter
    table_name = get_table_name
    connection = get_connection
    raw_query = update_query
    puts "enter which id you want to update"
    id = Integer(gets.chomp)
    query = "UPDATE #{table_name} SET #{raw_query}
                        WHERE id = #{id}"
    connection.query(query)
  end

  def destroy
    connection = get_connection
    table_name = get_table_name
    puts "enter which id you want to delete"
    id = Integer(gets.chomp)
    query = "DELETE FROM #{table_name} WHERE id = #{id}"
    connection.query(query)
  end
end

