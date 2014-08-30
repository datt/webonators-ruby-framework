require_relative "execute_generator.rb"
class Generator
  def self.generating_model_controller
     #argv = ["new","Controller","post","coffee", "tea"]
     #argv = ["new","Model","post","string:name","integer:age"]
     ExecuteGenerator.get_model_parameter ARGV
     if ARGV[1] == "model" || ARGV[1] == "Model"
      model_class_name = ARGV[2].capitalize
      model_class_name.capitalize
      data_type, column_name = ExecuteGenerator.get_model_attribute ARGV
      ExecuteGenerator.create_model_class model_class_name,column_name
    end
  end
end
Generator.generating_model_controller