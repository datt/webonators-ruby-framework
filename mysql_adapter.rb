#!/usr/bin/ruby
require "mysql2"
#require_relative "establish_connection.rb"

class Mysql2Adapter


  def self.datatype_mapping parameter
    datatype_map = {
                    :string  => "varchar(255)",
                    :text    => "varchar(512)",
                    :int => "int",
                    :float   => "float",
                    :date    => "date"
                  }
    parameter.each do |key,value|
      parameter[key] = datatype_map[value]
    end
    parameter
  end

  def self.create_table *args
    table_parameter = args[1]
    table_parameter = datatype_mapping table_parameter
    query_arr = []
    table_parameter.each do |field_name ,data_type|
      query = "#{field_name}"+" "+ "#{data_type}"
      query_arr.push(query)
    end
    query = query_arr.join(",")
    create_table_query = "CREATE TABLE IF NOT EXISTS #{args[0]}
                    (id INT PRIMARY KEY AUTO_INCREMENT NOT NULL ,
                    #{query})"
  end

  def self.add_column args
    relation = args
    query_relation_arr = []
    relation.each do |key,value|
      query = "alter table #{value}
            add #{key}_id int"
      query_relation_arr.push(query)
    end
    query_relation_arr
   end

  def self.add_foreign_key args
    relation = args
    puts args
    relation.each do |key,value|
    query = "alter table #{value}
     add FOREIGN KEY (#{key}_id)
     REFERENCES #{key}(id)
    "
    return query
    end
  end

  def self.show *args
    table_name = args[0]
    id = args[1]
    resultset = "SELECT * FROM #{table_name} WHERE id = #{id} "
  end

  def self.fetch table_name, related_table,id
    resultset = "SELECT * FROM #{related_table} WHERE #{table_name}_id = #{id} "
  end
  def self.all args
    table_name = args
    select_all_query = "SELECT * FROM #{table_name}"
  end

  def self.destroy *args
    query = "DELETE FROM #{args[0]} WHERE id = #{args[1]}"

  end

  def self.save table_name,parameter,values
    fields = []
    p values
    value_arr = values.collect do |element|
      if element.is_a?(String)
        "'element'"
      else
        element
      end
    end
    values = value_arr.join(",")
    parameter.keys.each do |key|
      fields.push(key.to_s)
    end
    fields = fields.join(",")
    query = "INSERT INTO #{table_name} (#{fields}) VALUES (#{values}) "

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

  def self.fetch_count(table_name)
    query = "SELECT * FROM #{table_name} ORDER BY id DESC LIMIT 1"
  end
end