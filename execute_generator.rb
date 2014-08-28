require_relative "webo_model.rb"
require_relative "webo_controller.rb"
module ExecuteGenerator

  def self.get_model_parameter argv
    if argv[1] == "model" || argv[1] == "Model"
      call_for_model_operations argv
    elsif argv[1] == "controller" || argv[1] == "Controller"
      call_for_controller_operations argv
    end
  end

  def self.call_for_model_operations argv
    @file_name = method_name argv
    if @file_name.eql? "empty"
      puts "File can't be created"
    else
      model_name = argv[2]
      if model_name[model_name.length-1].eql?'s'
        model_name[model_name.length-1] = ''
      end
      model_name = model_name.downcase
      model_class_name = model_name.capitalize
      validate_flag = validate argv
      write_model = File.new("#{model_name}.rb","a")
      write_model.write "class #{model_class_name} < WeboModel\n"
      write_model.close
      if validate_flag.eql?1
        data_type,column_name = get_model_attribute argv
        set_column data_type,column_name,model_class_name
      elsif validate_flag.eql?0
       puts "Bad command..!!Try again"
      end
    end
  end

  def self.call_for_controller_operations argv
    actions = []
    controller_name = argv[2]
    if controller_name[controller_name.length-1]!='s'
      controller_name[controller_name.length]='s'
    end
    controller_name = controller_name.downcase
    p controller_name
    controller_class_name = controller_name.capitalize
    p controller_class_name
    write_controller = File.new("#{controller_name}_controller.rb","w")
    write_controller.write "class #{controller_class_name}Controller < WeboController\n"
    write_controller.close
    command_length = argv.length
    if command_length > 3
      for  loop_counter in 3...command_length
        action = argv[loop_counter].downcase
        actions << action
        write_def_controller controller_name,action
        create_view_file action
        write_action_routes controller_name,action
        write_to_view controller_name,action
      end
    elsif command_length ==3
    end
    create_controller_class_and_method controller_class_name,actions
    write_controller = File.open("#{controller_name}_controller.rb","a")
    write_controller.write "\nend"
    write_controller.close
  end

  def self.write_def_controller controller_name,action
    write_controller = File.open("#{controller_name}_controller.rb","a+")
    write_controller.write("\n\s\sdef #{action}\n\s\send\n")
    write_controller.close
  end

  def self.write_action_routes controller_name,action
    file = File.open("routes.rb","a")
    file.write("goto '/#{controller_name}/#{action}', on '#{controller_name}##{action}', via: 'get'\n")
    file.close
  end

  def self.create_view_file action
    File.new("#{action}.html.erb","w")
  end

  def self.write_to_view controller_name,action
    file = File.open("#{action}.html.erb","a")
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
      if arguement_counter>=3
        column = arguement.split(':')
        data_type << column[0]
        column_name << column[1]
      end
      arguement_counter += 1
    end
    return data_type,column_name
  end

  def self.validate argv
    arguement_counter = 0
    validate_flag = 0
    arguement_datatype = []
    data_type = ["integer","float","boolean","string"]
    argv.each do |arguement|
      if arguement_counter>=3
        arguement_datatype = arguement.split(':')
        if data_type.include?(arguement_datatype[0])
          validate_flag = 1
        else
          validate_flag = 0
          return validate_flag
        end
      end
      if argv.length == 3
        validate_flag = 1
      end
      arguement_counter += 1
    end
    return validate_flag
  end

  def self.set_column data_type,column_name,model_class_name
    loop_counter = 0
    write_file = File.open("#{@file_name}.rb","a+")
    write_file.each_line do |line|
      if line.scan"class #{model_class_name}"
        write_file.write "\s\s#Class Attribute should be added in hash\n"
        write_file.write"\s\shash = {"
        while(loop_counter <= data_type.size-1)
          write_file.write"\"#{data_type[loop_counter]}\" => \"#{column_name[loop_counter]}\""
          if loop_counter < (data_type.size-1)
            write_file.write","
          elsif loop_counter == (data_type.size-1)
            write_file.write""
          end
          loop_counter += 1
        end
        write_file.write"}\n"
      end
    end
    write_file.write("end")
    write_file.close
  end

  def self.method_name argv
    create_model_flag = 0
    @file_name = "empty"
    if argv[0].eql?("new")
      unless argv[2].eql?("")
        @file_name = argv[2].downcase
        create_file = File.new("#{@file_name}.rb","w")
        create_file.close
      end
      return @file_name
    end
    if create_model_flag.eql? 0
      puts "Sorry new keyword is missing"
      return @file_name
    end
  end

  def self.create_model_class model_class_name,column_name
    klass = Class.new WeboModel
    klass.class_eval do
      attr_accessor *column_name
    end
    Object.const_set "#{model_class_name}",klass
  end

  def self.create_controller_class_and_method controller_class_name,actions
    controller_class_name = "#{controller_class_name}Controller"
    klass = Class.new WeboController
    Object.const_set "#{controller_class_name}",klass
    klass.class_eval do
      actions.each do |action|
        define_method "#{action}" do
        end
      end
    end
  end
end