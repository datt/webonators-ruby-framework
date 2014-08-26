#!/usr/bin/ruby
require "mysql"
require_relative "model.rb"

=begin
contains raw queries for creating , selecting , updataing database
=end

class SqlQuery
  #method for connecting to database
  #include 'Model'
  include Week
  def get_connection
    con = Mysql.new 'localhost', 'root', 'webonise6186' , 'trial'

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
    puts Week.weeks_in_year
    c = get_connection
    puts c
    model_name = "Person".downcase
    create_table = "CREATE TABLE IF NOT EXISTS #{model_name}(id INT PRIMARY KEY AUTO_INCREMENT, #{query})"
    c.query(create_table)

  end
end
s = SqlQuery.new
s.create_table

#SqlQuery.get_connection
#SqlQuery.get_datatypes
