require_relative "generating_model.rb"
class Model
  def self.generating_model
    GeneratingModel.get_model_parameter ARGV
  end
  def self.get_paramenter
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
end
Model.generating_model