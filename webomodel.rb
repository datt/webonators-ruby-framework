#!/usr/bin/ruby
require "mysql"
require_relative "generate_configuration.rb"
require_relative "fileread.rb"

#contains raw queries for creating , selecting , updataing database
class SQLlQuery
  #method for connecting to database
  include GenerateConfigurationFile
  include FileRead
  def get_connection
    configuration = GenerateConfigurationFile.extract_configuration
    hostname = configuration["hostname"]
    password = configuration["password"]
    username = configuration["username"]
    database = configuration["database"]
    Mysql.new("#{hostname}", "#{username}", "#{password}" , "#{database}")
  end


  def get_parameter
    parameter =FileRead.read_file
    @column_name = parameter.keys
    @datatype = parameter.values
  end

  #method for getting data types
  def get_datatypes
     @datatype
  end

  #method for getting column names
  def get_columnname
    @column_name
  end

  def create_query
    datatype = get_datatypes
    column_name = get_columnname
    datatype_arr = []
    datatype.each do |data|
      if data == 'String'
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

  ## this method will read model_name.rb and will get table name
  def get_table_name
    table_name = FileRead.get_classname
    table_name.downcase
  end

  #method for creating table
  def create_table
    query = create_query
    puts query
    connection = get_connection
    table_name = get_table_name
    create_table = "CREATE TABLE IF NOT EXISTS #{table_name}
                    (id INT PRIMARY KEY AUTO_INCREMENT NOT NULL ,
                    #{query})"
    puts create_table
    connection.query(create_table)

  end

  def insert_into_table
    connection = get_connection
    fields = get_columnname
    table_name = get_table_name
    puts table_name
     column_fileds = fields.join(",")
     query = "INSERT INTO #{table_name} (#{column_fileds}) VALUES ('minakshi',12)"
     puts query
     connection.query(query)
  end

  #method for selecting data from table
  def select_data
    connection = get_connection
    table_name = get_table_name
    puts table_name
    resultset = connection.query("SELECT * FROM #{table_name}")
    puts resultset.inspect
  end



end
sql_query = SQLlQuery.new
sql_query.get_table_name
sql_query.get_parameter
sql_query.create_table
#sql_query.get_connection
#sql_query.create_table

#SqlQuery.get_connection
#SqlQuery.get_datatypes
