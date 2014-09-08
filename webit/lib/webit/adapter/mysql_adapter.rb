require ::File.expand_path("../../adapter.rb", __FILE__)
module Adapter
  class Mysql2Adapter < Base

    def self.create_table(table_name,table_parameter)
       if table_parameter.empty?
        create_table_query = "CREATE TABLE IF NOT EXISTS #{table_name}
                      (id INT PRIMARY KEY AUTO_INCREMENT NOT NULL )"
      else
        table_parameter = datatype_mapping(table_parameter)
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

    def add_column relation
      query_relation_arr = []
        query = "alter table #{realtion.values.join}
              add #{realtion.keys.join}_id int"
        query_relation_arr.push(query)
      query_relation_arr
    end

    def add_foreign_key relation
      query = "alter table #{relation.values.join}
              add FOREIGN KEY (#{relation.keys.join}_id)
              REFERENCES #{relation.keys.join}(id)
               ON DELETE CASCADE"
    end

    def find(table_name,id)
      resultset = "SELECT * FROM #{table_name} WHERE id = #{id} "
    end

    def all table_name
      select_all_query = "SELECT * FROM #{table_name} ORDER BY id DESC"
    end

    def destroy(table_name,id)
      query = "DELETE FROM #{table_name} WHERE id = #{id}"
    end

    def save(table_name,parameter)
      parameter_arr = parameter.values.collect do |element|
        if element.is_a?(String)
          "'#{element}'"
        else
          element
        end
      end
      query = "INSERT INTO #{table_name} (#{parameter.keys.join(",")})
                                  VALUES (#{parameter_arr.join(",")}) "
    end

    def find_by(table_name,parameter)
      if parameter.values.join.is_a? Fixnum
        query = "SELECT * from #{table_name} where #{parameter.keys.join} = #{parameter.values.join} "
      else
        query = "SELECT * from #{table_name} where #{parameter.keys.join} = '#{parameter.values.join()}' "
      end
    end

    def update(table_name,update_info)
      update_arr =[]
      update_info.each do |key,value|
        unless key == "id"
          update_arr << "#{key} = '#{value}'"
        end
      end
      query = "UPDATE #{table_name} SET #{update_arr.join(",")}
                          WHERE id = #{update_info.values.last}"
     end

    private
    def datatype_mapping parameter
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
  end
end