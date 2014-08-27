require_relative "generating_model.rb"
class Model
  def self.generating_model
   argv = ["new","post","String:name"]
   GeneratingModel.get_model_parameter argv
   #model_class_name = argv[1].capitalize
   #model_class_name.capitalize
   #data_type, column_name = GeneratingModel.get_model_attribute argv
   #GeneratingModel.create_class model_class_name,column_name
  end
end
Model.generating_model