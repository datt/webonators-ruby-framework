require_relative "execute_generator.rb"
class Generator
  def self.generating_model_controller
     argv = ["new","model","post","String:name"]
     ExecuteGenerator.get_model_parameter argv
     if argv[1].eql?"model"
      model_class_name = argv[2].capitalize
      model_class_name.capitalize
      data_type, column_name = ExecuteGenerator.get_model_attribute argv
      ExecuteGenerator.create_model_class model_class_name,column_name
    elsif argv[1].eql?"controller"
      controller_class_name = argv[2].capitalize
      controller_class_name = controller_class_name.capitalize
      controller_class_name = "#{controller_class_name}Controller"
      ExecuteGenerator.create_controller_class controller_class_name
    end
  end
end
Generator.generating_model_controller