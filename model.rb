require_relative "generating_model.rb"
class Model
  def self.generating_model
   argv = ["new","controller","post"]
   GeneratingModel.get_model_parameter argv
   model_class_name = argv[2].capitalize
   model_class_name.capitalize
   data_type, column_name = GeneratingModel.get_model_attribute argv
   p column_name
   GeneratingModel.create_class model_class_name,column_name
  end
end
Model.generating_model