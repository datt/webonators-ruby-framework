require ::File.expand_path("../webit_model.rb", __FILE__)
require ::File.expand_path("../webit_controller.rb", __FILE__)
require 'fileutils'
module ExecuteGenerator

  VALID = true
  INVALID = false

  def self.get_generator_parameter argv
    if argv[1] == "model" || argv[1] == "Model"
      call_for_model_operations argv
    elsif argv[1] == "controller" || argv[1] == "Controller"
      call_for_controller_operations argv
    end
  end

  def self.call_for_model_operations argv
    file_name = method_name argv
    if file_name.eql? "empty"
      puts "File can't be created"
    else
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
      if validate_flag.eql? VALID
        data_type,column_name = get_model_attribute argv
        set_column data_type,column_name,model_class_name,argv
        WebitModel.create_table argv[2],data_type,column_name
      elsif validate_flag.eql? INVALID
        puts "Wrong Syntax..Command to generate model => webit generate model "
      end
    end
  end

  def self.call_for_controller_operations argv
    actions = []
    controller_name = argv[2]
    if argv[2].nil?
      puts "Controller Name is not defined"
    else
      if controller_name[controller_name.length-1]!='s'
        controller_name="#{controller_name}s"
      end
    controller_name = controller_name.downcase
    controller_class_name = controller_name.split('_').each {|word| word.capitalize!}
    controller_class_name = controller_class_name.join.concat("Controller")
    write_controller = File.new("app/controllers/#{controller_name}_controller.rb","w")
    write_controller.write "class #{controller_class_name} < WebitController\n"
    write_controller.close
    if argv.length > 3
      argv.each_with_index do |action, index|
        if index > 2
          action = action.downcase
          actions << action
          write_def_controller controller_name,action
          create_view_file action
          write_action_routes controller_name,action
          write_to_view controller_name,action
        end
      end
    end
   end
    write_controller = File.open("app/controllers/#{controller_name}_controller.rb","a")
    write_controller.write "\nend"
    write_controller.close
    write_routes = File.open("config/routes.rb","a")
    write_routes.write("\nend")
    write_routes.close
  end

  def self.write_def_controller controller_name,action
    write_controller = File.open("app/controllers/#{controller_name}_controller.rb","a+")
    write_controller.write("\n\s\sdef #{action}\n\s\send\n")
    write_controller.close
  end

  def self.write_action_routes controller_class_name,action
    file = File.open("config/routes.rb","a+")
    if file.readline("class Routes < WebitRoutes")
      file.write("\n\s\sget \'/#{controller_class_name}/#{action}\' do\n")
      file.write("\s\s\s\sgoto \'#{controller_class_name}\',\s\'#{action}\'\n")
      file.write("\s\send\n")
      file.close
    end
  end

  def self.create_view_file action
    File.new("app/views/#{action}.html.erb","w")
  end

  def self.write_to_view controller_name,action
    file = File.open("app/views/#{action}.html.erb","a")
    file.write("<html>\n\s\s<body>\n\s\s\s\s<h1>\n")
    file.write("\s\s<%= \"You are in #{controller_name} Controller\'s #{action} Action\" %>\n")
    file.write("\s\s\s\s</h1>\n")
    file.write("\s\s</body>\n</html>\n")
    file.close
  end

  def self.get_model_attribute argv
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

  def self.validate argv
    validate_flag = false
    arguement_datatype = []

    data_type = ["integer","float","boolean","string","text"]
    argv.each_with_index do |arguement,index|
      if index >= 3
        arguement_datatype = arguement.split(':')
        if data_type.include?(arguement_datatype[0])
          validate_flag = true
        else
          validate_flag = true
          return validate_flag
        end
      end
      if argv.length == 3
        validate_flag = true
      end
    end
    validate_flag
  end

  def self.set_column data_type, column_name, model_class_name,argv
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

  def self.method_name argv
    create_model_flag = 0
    file_name = "empty"
    p argv
    if argv[0].eql?("generate") || argv[0].eql?("g")
      if argv[2].nil?
        puts "Model Name is not defined"
      elsif argv[2].eql?"model" || "Model"
        abort "Sorry..Keywork Model cant be used in place of model_name"
      else
        file_name = argv[2].downcase
      end
      create_file = File.new("app/models/#{file_name}.rb","w")
      create_file.close
      return file_name
    end
    if create_model_flag.eql? 0
      return file_name
    end
  end
end