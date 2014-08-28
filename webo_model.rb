#!/usr/bin/ruby
require "mysql"
require_relative "generate_configuration.rb"
require_relative "fileread.rb"

#contains raw queries for creating , selecting , updataing database
class WeboModel
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
=begin
  def mapping_datatype
    get_parameter
    datatype = get_datatypes
    puts datatype
      mapping_datatypes = {
      "String"=>"VARCHAR(255)",
      "integer" =>"number",
      "float" => "double"
     }
     temp_arr= []
     datatype.each do |data|
      if mapping_datatypes.has_key?(data)
        mapped_data = hash[data]
        puts mapped_data
        temp_arr.push(mapped_data)
      end
      p temp_arr
    end
  end
=end
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
    connection.query(create_table)

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

  #method for selecting data from table
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

  # WHERE clause implementation
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
#sql_query = SQLQuery.new

#sql_query.get_table_name
#sql_query.get_parameter
#sql_query.create_query
#sql_query.create_table
#sql_query.get_datatypes
#sql_query.get_connection
#sql_query.create_table

#SqlQuery.get_connection
#SqlQuery.get_datatypes