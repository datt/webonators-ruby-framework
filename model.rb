require_relative "generating_model.rb"
class Model
  def self.generating_model
   GeneratingModel.get_model_parameter ARGV
  end
end

Model.generating_model