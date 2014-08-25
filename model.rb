require_relative "run_model.rb"
class Model
  def self.run_model
    RunModel.get_model_parameter ARGV
  end
end
Model.run_model