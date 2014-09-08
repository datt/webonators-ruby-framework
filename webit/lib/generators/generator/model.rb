require ::File.expand_path("../../../webit/webit_model.rb", __FILE__)
require ::File.expand_path("../../generator.rb", __FILE__)
require 'fileutils'

class Model
  VALID = true
  INVALID = false

  def call_for_model_operations argv
    file_name = method_name argv
    if file_name.nil?
      abort "File can't be created"
    else
      write_model_file file_name
      model_name = argv[2]
      if model_name[model_name.length-1].eql?'s'
        model_name[model_name.length-1] = ''
      end
      model_name = model_name.downcase
      model_class_name = model_name.capitalize
      validate_flag = validate argv
      write_model = File.open("app/models/#{model_name}.rb","a")
      write_model.write "class #{model_class_name} < WebitModel\n"
      write_model.close
      if validate_flag
        data_type,column_name = get_model_attribute argv
        set_column data_type,column_name,model_class_name,argv
        WebitModel.create_table argv[2],data_type,column_name
      elsif validate_flag.eql? INVALID
        puts "Wrong Syntax..Command to generate model => webit g model mode_name data_type:column_name"
      end
    end
  end

  private

    def write_model_file file_name
      File.exists?("app/models/#{file_name}.rb")
      create_file = File.new("app/models/#{file_name}.rb","w")
      create_file.close
    end

    def get_model_attribute argv
      arguement_counter = 0
      data_type = []
      column_name = []
      argv.each do |arguement|
        if arguement_counter >= 3
          column = arguement.split(':')
          data_type << column[0]
          column_name << column[1]
        end
        arguement_counter += 1
      end
      return data_type, column_name
    end

    def validate argv
      validate_flag = false
      arguement_datatype = []
      min_arguement_length = 3
      data_type = ["integer","float","boolean","string","text"]
      argv.each_with_index do |arguement,index|
        if index >= min_arguement_length
          arguement_datatype = arguement.split(':')
          if data_type.include?(arguement_datatype[0])
            validate_flag = true
          else
            validate_flag = true
            return validate_flag
          end
        end
        if argv.length == min_arguement_length
          validate_flag = true
        end
      end
      validate_flag
    end

    def set_column data_type, column_name, model_class_name,argv
      loop_counter = 0
      file_name = method_name argv
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

    def method_name argv
      create_model_flag = 0
      if argv.first.eql?"g"
        if argv[2].nil?
          puts "Model Name is not defined"
        elsif argv[2].downcase.eql?"model"
          abort "Sorry..Keywork Model cant be used in place of model_name"
        else
          file_name = argv[2].downcase
        end
      end
      if create_model_flag.eql? 0
        file_name
      end
    end
end