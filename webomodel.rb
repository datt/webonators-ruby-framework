#!/usr/bin/ruby
require "mysql"
require_relative "generate_configuration.rb"
require_relative "fileread.rb"

#contains raw queries for creating , selecting , updataing database
class SQLQuery
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
    get_parameter
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

  def save args
    get_parameter
    puts args
    connection = get_connection
    fields = get_columnname
    table_name = get_table_name
    puts table_name
     column_fileds = fields.join(",")
     query = "INSERT INTO #{table_name} (#{column_fileds}) VALUES (#{args.join(",")}) )"
     puts query
     connection.query(query)
  end

  #method for selecting data from table
  def all
    connection = get_connection
    table_name = get_table_name
    puts table_name
    resultset = connection.query("SELECT * FROM #{table_name}")
    puts resultset.inspect
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

  # method for updating data
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
sql_query = SQLQuery.new

#sql_query.get_table_name
#sql_query.get_parameter
#sql_query.create_query
sql_query.create_table
#sql_query.get_datatypes
#sql_query.get_connection
#sql_query.create_table

#SqlQuery.get_connection
#SqlQuery.get_datatypes
