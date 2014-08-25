module Model < WeboModel

  def self.get_model_parameter
    @file_name = method_name
    if @file_name.eql? "empty"
      puts "File can't be created"
    else
      write_model = File.new("#{@file_name}.rb","a")
      model_name = ARGV[1]
      model_name = model_name.downcase
      model_class_name = model_name.capitalize
      validate_flag = validate
      write_model.write "class #{model_class_name}\n\n"
      write_model.close
      if validate_flag.eql?1
          data_type,column_name = get_model_attribute
          set_column data_type,column_name,model_class_name
      else
        puts "Bad command..!!Try again"
      end
      write_model = File.new("#{@file_name}.rb","a")
      write_model.write "  def create_#{model_name}\t #auto generated\n"
      write_model.write "  end\n"
      write_model.write "end"
      write_model.close
    end
  end

  def self.get_model_attribute
    arguement_counter = 0
    data_type = []
    column_name = []
    ARGV.each do |arguement|
      if arguement_counter>=2
        column = arguement.split(':')
        data_type << column[0]
        column_name << column[1]
      end
      arguement_counter += 1
    end
    return data_type,column_name
  end

  def self.validate
    arguement_counter = 0
    validate_flag = 0
    arguement_datatype = []
    data_type = ["int","tinyint","smallint","mediumint","begint","float","double","decimal","date","datetime","timestamp","time","year","char","varchar","blob","tinyblob","mediumblob","longblob","enum"]
    ARGV.each do |arguement|
      if arguement_counter>=2
      arguement_datatype = arguement.split(':')
        if data_type.include?(arguement_datatype[0])
          validate_flag = 1
        else
          validate_flag = 0
          return validate_flag
        end
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
          write_file.write"  #{data_type[loop_counter]}:#{column_name[loop_counter]}"
          write_file.write"\n"
          loop_counter += 1
        end
      end
    end
    write_file.close
  end

  def self.method_name
    create_model_flag = false
    @file_name = "empty"
    if ARGV[0].eql?("new")
      unless ARGV[1].eql?("")
        @file_name = ARGV[1].downcase
        #file_name = "#{Time.now.strftime('%Y%m%d%H%M%S%L')}#{file_name}.rb"
        create_file = File.new("#{@file_name}.rb","w")
        create_file.close
      end
      create_model_flag = true
      return @file_name
    end
    if create_model_flag.eql? 0
      puts "Sorry new keyword is missing"
      return @file_name
    end
  end
end
Model.get_model_parameter