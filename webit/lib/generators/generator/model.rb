require ::File.expand_path("../../../webit/webit_model.rb", __FILE__)
require ::File.expand_path("../../generator.rb", __FILE__)
require 'fileutils'

class Model

  DATA_TYPE = ["integer","float","boolean","string","text"]
  MIN_ARGUMENT_LENGTH = 3
  def call_for_model_operations argv
    model_name = argv[2]
    file_name = get_file_name argv
    if file_name.nil?
      abort "File can't be created"
    else
      create_model_file file_name
      model_name = singularize model_name
      model_class_name = model_name.capitalize
      validate_flag = validate argv
      write_in_model_file model_name,model_class_name
      if validate_flag
        data_type,column_name = get_model_attribute argv
        set_column data_type,column_name,model_class_name,file_name
        WebitModel.create_table argv[2],data_type,column_name
      else
        puts error_msg("error.model_error.perror")
        puts error_msg("error.model_error.usage")
      end
    end
  end

  private

    def error_msg(keys)
      path_error_yml = File.expand_path("../../../webit/error.yml", __FILE__)
      config_error = YAML.load_file("#{path_error_yml}")
      keys.split(".").inject(config_error) { |config_error, key| config_error[key] }
    end

    def singularize model_name
      if model_name[model_name.length-1].eql?'s'
        model_name[model_name.length-1] = ''
      end
      model_name
    end

    def write_in_model_file model_name,model_class_name
      write_model = File.open("app/models/#{model_name}.rb","a")
      write_model.write "class #{model_class_name} < WebitModel\n"
      write_model.close
    end

    def create_model_file file_name
      File.exists?("app/models/#{file_name}.rb")
      create_file = File.new("app/models/#{file_name}.rb","w")
      create_file.close
    end

    def get_model_attribute argv
      arguement_counter = 0
      data_type = []
      column_name = []
      if argv.length > MIN_ARGUMENT_LENGTH
        data_type_column_name_array = argv.drop(3)
        data_type_column_name_array.each do |element|
          column = element.split(':')
          data_type << column[0]
          column_name << column[1]
        end
      end
      return data_type, column_name
    end

    def validate argv
      validate_flag = true
      argument_datatype = []
      if argv.length > MIN_ARGUMENT_LENGTH
        data_type_column_name_array = argv.drop(3)
        argument_data_type = split_argument data_type_column_name_array
        unless DATA_TYPE.any?{ |x| argument_data_type.include?(x)}
          validate_flag = false
        end
      end
      validate_flag
    end

    def split_argument data_type_column_name_array
      argument_data_type = data_type_column_name_array.collect{ |element| element.split(":")[0]}
      argument_data_type
    end

    def set_column data_type, column_name, model_class_name,file_name
      loop_counter = 0
      write_file = File.open("app/models/#{file_name}.rb","a+")
      write_file.each_line do |line|
        if line.scan"class #{model_class_name}"
          while(loop_counter <= data_type.size-1)
            write_file.write"\s\sattr_access :#{column_name[loop_counter]} , :#{data_type[loop_counter]}\n"
            loop_counter += 1
          end
          write_file.write"\n"
        end
      end
      write_file.write("end")
      write_file.close
    end

    def get_file_name argv
      create_model_flag = 0
      if argv.first.eql?"g"
        if argv[2].nil?
          puts error_msg("error.model_error.perror")
        elsif argv[2].downcase.eql?"model"
          puts error_msg("error.model_error.same")
        else
          file_name = argv[2].downcase
        end
      end
      if create_model_flag.eql? 0
        file_name
      end
    end
end