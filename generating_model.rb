module GeneratingModel

 def self.get_model_parameter argv
    @arg = argv
    @file_name = method_name
    if @file_name.eql? "empty"
      puts "File can't be created"
    else
      write_model = File.new("#{@file_name}.rb","a")
      model_name = @arg[1]
      model_name = model_name.downcase
      model_class_name = model_name.capitalize
      validate_flag = validate
      write_model.write "class #{model_class_name} < WeboModel\nend"
      write_model.close
      if validate_flag.eql?1
        data_type,column_name = get_model_attribute
      elsif validate_flag.eql?0
        puts "Bad command..!!Try again"
      elsif validate_flag.eql?2
      end
      create_class model_class_name,column_name
    end
  end

  def self.get_model_attribute
    arguement_counter = 0
    data_type = []
    column_name = []
    @arg.each do |arguement|
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
    if @arg.size.eql?2
      validate_flag =2
      return validate_flag
    end
    @arg.each do |arguement|
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

  def self.method_name
    create_model_flag = 0
    @file_name = "empty"
    if @arg[0].eql?("new")
      unless @arg[1].eql?("")
        @file_name = @arg[1].downcase
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
    klass = Object.const_set "#{model_class_name}",Class.new
    eval("#{model_class_name}").class_eval do
      attr_accessor *column_name
    end
    Object.const_set "#{model_class_name}_object",eval("#{model_class_name}.new")
  end
end