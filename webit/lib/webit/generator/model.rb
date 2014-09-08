require ::File.expand_path("../../webit_model.rb", __FILE__)
require ::File.expand_path("../../generator.rb", __FILE__)
require 'fileutils'
module Generator
  class Model

    DATA_TYPE = ["integer","float","boolean","string","text"]
    MIN_ARGUMENT_LENGTH = 3
    
    # method to generate model
    def generate arguement_array
      model_name = arguement_array[MIN_ARGUMENT_LENGTH-1]
      file_name = get_file_name arguement_array
      if file_name.nil?
        abort "File can't be created"
      else
        generate_model arguement_array, file_name, model_name
      end
    end

    private

    # method to include user errors
    def error_msg(keys)
      path_error_yml = File.expand_path("../../../config/error.yml", __FILE__)
      config_error = YAML.load_file("#{path_error_yml}")
      keys.split(".").inject(config_error) { |config_error, key| config_error[key] }
    end

    # method to perform futher operations on model file( like create model file, write in model file, check validations)
    def generate_model arguement_array, file_name, model_name
      create_model_file file_name
      model_name = singularize model_name
      model_class_name = model_name.capitalize
      validate_flag = validate arguement_array
      write_in_model_file model_name,model_class_name
      if validate_flag
          data_type,column_name = get_model_attribute arguement_array
          set_column data_type,column_name,model_class_name,file_name
          WebitModel.create_table model_name,data_type,column_name
      else
        puts error_msg("error.controller_error.perror")
        puts error_msg("error.controller_error.usage")
      end
    end

    # method to singularize model name
    def singularize model_name
      last_element = -1
      if model_name[last_element].eql? 's'
        model_name[last_element] = ''
      end
      model_name
    end

    # method to write in model file
    def write_in_model_file model_name,model_class_name
      write_model = File.open("app/models/#{model_name}.rb","a")
      write_model.write "class #{model_class_name} < WebitModel\n"
      write_model.close
    end

    # method to create model file
    def create_model_file file_name
      File.exists?("app/models/#{file_name}.rb")
      create_file = File.new("app/models/#{file_name}.rb","w")
      create_file.close
    end

    # method to get model attribute
    def get_model_attribute arguement_array
      arguement_counter = 0
      data_type = []
      column_name = []
      if arguement_array.length > MIN_ARGUMENT_LENGTH
        data_type_column_name_array = arguement_array.drop(3)
        data_type_column_name_array.each do |element|
          column = element.split(':')
          data_type << column.first
          column_name << column.last
        end
      end
      return data_type, column_name
    end

    # method to check validations in command-line argument
    def validate arguement_array
      validate_flag = true
      argument_datatype = []
      if arguement_array.length > MIN_ARGUMENT_LENGTH
        data_type_column_name_array = arguement_array.drop(3)
        argument_data_type = split_argument data_type_column_name_array
        unless DATA_TYPE.any?{ |x| argument_data_type.include?(x)}
          validate_flag = false
        end
      end
      validate_flag
    end

    # method to split argument as data_type : column name (eg. string:name)
    def split_argument data_type_column_name_array
      argument_data_type = data_type_column_name_array.collect{ |element| element.split(":")[0]}
      argument_data_type
    end

    # method to set column and write attribute in model file
    def set_column data_type, column_name, model_class_name,file_name
      write_file = File.open("app/models/#{file_name}.rb","a+")
      write_file.each_line do |line|
        if line.scan"class #{model_class_name}"
          column_name.zip(data_type).each do |value|
            write_file.write"\s\sattr_access :#{value.first} , :#{value.last}\n"
          end
        end
      end
      write_file.write("end")
      write_file.close
    end

    # method to get model file name
    def get_file_name argument_array
      create_model_flag = 0
      model_name = argument_array[MIN_ARGUMENT_LENGTH-1]
      if argument_array.first.eql?"g"
        if model_name.nil?
          puts error_msg("error.model_error.perror")
        elsif model_name.downcase.eql?"model"
          puts error_msg("error.model_error.same")
          abort
        else
          file_name = model_name.downcase
        end
      end
      if create_model_flag.eql? 0
        file_name
      end
    end
  end
end
