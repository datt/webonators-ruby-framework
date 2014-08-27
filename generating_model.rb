require_relative "webomodel.rb"
module GeneratingModel

 def self.get_model_parameter argv
    #@arg = argv

     # write_model = File.new("#{@file_name}.rb","a")
      puts argv[1]
      if argv[1].eql?"model"
        puts "i m model"
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
          write_model.write "class #{model_class_name} < WeboModel\n"
          write_model.close
          if validate_flag.eql?1
            data_type,column_name = get_model_attribute argv
            set_column data_type,column_name,model_class_name
          elsif validate_flag.eql?0
           puts "Bad command..!!Try again"
          end
        end
      elsif argv[1].eql?"controller"
        puts "here in controller"
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
        command_length=argv.length
      end
    end
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
    data_type = ["Integer","Float","Boolean","String"]
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
        while(loop_counter<=data_type.size-1)
          write_file.write"\s\s#{column_name[loop_counter]}:#{data_type[loop_counter]}"
          write_file.write"\n"
          loop_counter += 1
        end
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

  def self.create_class model_class_name,column_name
    klass = Class.new WeboModel
    klass.class_eval do
      attr_accessor *column_name
    end
    Object.const_set "#{model_class_name}",klass
  end
end