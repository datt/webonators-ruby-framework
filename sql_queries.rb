#!/usr/bin/ruby
require "mysql"
require_relative "generate_configuration.rb"

#contains raw queries for creating , selecting , updataing database
class SqlQuery
  #method for connecting to database
  include GenerateConfigurationFile
  def get_connection
    configuration = GenerateConfigurationFile.extract_configuration
    puts configuration
    hostname = configuration["hostname"]
    password = configuration["password"]
    username = configuration["username"]
    database = configuration["database"]
    Mysql.new("#{hostname}", "#{username}", "#{password}" , "#{database}")
  end

  #method for getting data types
  def get_datatypes
    datatype = ['varchar', 'integer']
  end

  #method for getting column names
  def get_columnname
    column_name = ['name', 'number']
  end

  def create_query
    datatype = get_datatypes
    column_name = get_columnname
    datatype_arr = []
    datatype.each do |data|
      if data == 'varchar'
        datatype_arr.push(data.upcase+"(255)")
      else
        datatype_arr.push(data)
      end
    end
    query_arr = []                              # tempory array for holding column name and datatype
    for i in 0...column_name.size
      query ="#{column_name[i]} #{datatype_arr[i]}"
      query_arr.push(query)
    end
    query = query_arr.join(",")
  end

  #method for creating table
  def create_table
    query = create_query
    puts query
    connection = get_connection
    model_name = "Simple2".downcase
    create_table = "CREATE TABLE IF NOT EXISTS #{model_name}(id INT PRIMARY KEY AUTO_INCREMENT NOT NULL, #{query})"
    connection.query(create_table)

  end

  def insert_into_table
    connection = get_connection
    fields = get_columnname
     column_fileds = fields.join(",")
     table_name = "simple1"
     query = "INSERT INTO #{table_name} (#{column_fileds}) VALUES ('minakshi',12)"
     puts query
     connection.query(query)
  end

end
sql_query = SqlQuery.new
sql_query.get_connection
sql_query.create_table

#SqlQuery.get_connection
#SqlQuery.get_datatypes
