    #!/usr/bin/ruby
require "mysql2"
#require_relative "establish_connection.rb"

class Mysql2Adapter


  def self.datatype_mapping parameter
    datatype_map = {
                    "string"  => "varchar(255)",
                    "text"    => "varchar(512)",
                    "integer"     => "int",
                    "float"   => "float",
                    "date"    => "date"
                  }
    parameter.each do |key,value|
      parameter[key] = datatype_map[value]
    end
    parameter
  end

  def self.create_table(table_name,table_parameter)
     if table_parameter.empty?
      create_table_query = "CREATE TABLE IF NOT EXISTS #{table_name}
                    (id INT PRIMARY KEY AUTO_INCREMENT NOT NULL )"
    else
      table_parameter = datatype_mapping table_parameter
      query_arr = []
      table_parameter.each do |field_name ,data_type|
        query = "#{field_name}"+" "+ "#{data_type}"
        query_arr.push(query)
      end
      query = query_arr.join(",")
      create_table_query = "CREATE TABLE IF NOT EXISTS #{table_name}
                      (id INT PRIMARY KEY AUTO_INCREMENT NOT NULL, #{query} )"
    end
  end

  def self.add_column relation
    query_relation_arr = []
    relation.each do |key,value|
      query = "alter table #{value}
            add #{key}_id int"
      query_relation_arr.push(query)
    end
    query_relation_arr
  end

  def self.add_foreign_key relation
    relation.each do |key,value|
    query = "alter table #{value}
            add FOREIGN KEY (#{key}_id)
            REFERENCES #{key}(id)
             ON DELETE CASCADE"
    return query
    end
  end

  def self.show(table_name,id)
    resultset = "SELECT * FROM #{table_name} WHERE id = #{id} "
  end

  def self.fetch table_name, related_table,id
    resultset = "SELECT * FROM #{related_table} WHERE #{table_name}_id = #{id} "
  end
  def self.all table_name
    select_all_query = "SELECT * FROM #{table_name} ORDER BY id DESC"
  end

  def self.destroy(table_name,id)
    query = "DELETE FROM #{table_name} WHERE id = #{id}"

  end

  def self.save(table_name,parameter)
    fields = []
    values =[]
    parameter_arr = parameter.values.collect do |element|
      if element.is_a?(String)
        "'#{element}'"
      else
        element
      end
    end
    puts parameter_arr
    puts values
    values = parameter_arr.join(",")
    fields = parameter.keys.join(",")
    query = "INSERT INTO #{table_name} (#{fields}) VALUES (#{values}) "

  end

  def self.find_by(table_name,parameter)
    if parameter.values.join.is_a? Fixnum
      query = "SELECT * from #{table_name} where #{parameter.keys.join} = #{parameter.values.join} "
    else
      query = "SELECT * from #{table_name} where #{parameter.keys.join} = '#{parameter.values.join()}' "
    end
  end

  def self.search(table_name,referred_table,args)
    query = "select * from #{table_name} where #{referred_table}_id in
            (select id from #{referred_table} where #{args.keys.join} = '#{args.values.join}');"
  end


  def self.update(table_name,update_info)
    puts update_info
    update_info
    update_column = "#{update_info.keys[0]} ='#{update_info.values[0]}',
                    #{update_info.keys[1]}= '#{update_info.values[1]}'"
    query = "UPDATE #{table_name} SET #{update_column}
                        WHERE id = #{update_info.values.last}"
  end

  def self.fetch_count(table_name)
    query = "SELECT * FROM #{table_name} ORDER BY id DESC LIMIT 1"
  end
end
